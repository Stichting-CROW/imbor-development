from __future__ import annotations

from pathlib import Path
import sys
import uuid
import pandas as pd


# -----------------------------
# Configuratie
# -----------------------------
BASE_DIR = Path(__file__).resolve().parent

OBJECTTYPEN_CSV = BASE_DIR / "URI+Naam-objecttypen.csv"
ATTRIBUTEN_CSV = BASE_DIR / "URI+Naam-attributen.csv"
MIN_DATASET_XLSX = BASE_DIR / "20251124­-MDS-IMBOR.xlsx"

OUT_CSV = BASE_DIR / "minimale_dataset_triples.csv"
OUT_TTL = BASE_DIR / "triples.ttl"
OUT_SHAPES = BASE_DIR / "shapes.ttl"

OBJECTTYPE_COL = "Objecttype"
ATTRIBUUT_COL = "Attribuut"
MIN_DATASET_COL = "MinimaleDataset"

PREFIXES = """@prefix dash: <http://datashapes.org/dash#> .
@prefix geo: <http://www.opengis.net/ont/geosparql#> .
@prefix gwsw: <http://data.gwsw.nl/1.6/totaal/> .
@prefix imbor: <https://data.crow.nl/imbor/def/> .
@prefix imbor-meta: <https://data.crow.nl/imbor/aanvullend-metamodel/> .
@prefix imbor-term: <https://data.crow.nl/imbor/term/> .
@prefix mds_imbor: <https://data.crow.nl/imbor/mds/> .
@prefix nen2660: <https://w3id.org/nen2660/def#> .
@prefix nen3610: <http://modellen.geostandaarden.nl/def/nen3610-2022#> .
@prefix net: <http://inspire.ec.europa.eu/ont/net#> .
@prefix owl: <http://www.w3.org/2002/07/owl#> .
@prefix quantitykind: <http://qudt.org/vocab/quantitykind/> .
@prefix qudt: <http://qudt.org/schema/qudt/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix sh: <http://www.w3.org/ns/shacl#> .
@prefix skos: <http://www.w3.org/2004/02/skos/core#> .
@prefix sml: <https://w3id.org/sml/def#> .
@prefix tooi-ont: <https://identifier.overheid.nl/tooi/def/ont/> .
@prefix unit: <http://qudt.org/vocab/unit/> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
"""


# -----------------------------
# Helpers
# -----------------------------
def norm(value) -> str:
    return str(value).strip().lower()


def read_inputs() -> tuple[pd.DataFrame, pd.DataFrame, pd.DataFrame]:
    if not OBJECTTYPEN_CSV.exists():
        raise FileNotFoundError(f"Niet gevonden: {OBJECTTYPEN_CSV}")
    if not ATTRIBUTEN_CSV.exists():
        raise FileNotFoundError(f"Niet gevonden: {ATTRIBUTEN_CSV}")
    if not MIN_DATASET_XLSX.exists():
        raise FileNotFoundError(f"Niet gevonden: {MIN_DATASET_XLSX}")

    objecttypen = pd.read_csv(OBJECTTYPEN_CSV)
    attributen = pd.read_csv(ATTRIBUTEN_CSV)
    min_dataset = pd.read_excel(MIN_DATASET_XLSX, header=1)

    return objecttypen, attributen, min_dataset


def validate_columns(df: pd.DataFrame, required: list[str], name: str) -> None:
    missing = [c for c in required if c not in df.columns]
    if missing:
        raise ValueError(f"Ontbrekende kolommen in {name}: {missing}")


def prepare_keys(objecttypen: pd.DataFrame, attributen: pd.DataFrame, min_dataset: pd.DataFrame) -> None:
    objecttypen["key_objecttype"] = objecttypen["objecttype_naam"].apply(norm)
    attributen["key_attribuut"] = attributen["attribuut_naam"].apply(norm)
    min_dataset["key_objecttype"] = min_dataset[OBJECTTYPE_COL].apply(norm)
    min_dataset["key_attribuut"] = min_dataset[ATTRIBUUT_COL].apply(norm)


def join_uris(objecttypen: pd.DataFrame, attributen: pd.DataFrame, min_dataset: pd.DataFrame) -> pd.DataFrame:
    df = min_dataset.merge(
        objecttypen[["key_objecttype", "objecttype_uri"]],
        on="key_objecttype",
        how="left"
    )

    df = df.merge(
        attributen[["key_attribuut", "attribuut_uri"]],
        on="key_attribuut",
        how="left"
    )

    # Toon volledige URI's in output
    pd.set_option("display.max_colwidth", None)

    # checks NA beide merges -- debug doeleinden
    miss_obj = df[df["objecttype_uri"].isna()][[OBJECTTYPE_COL]].drop_duplicates()
    miss_attr = df[df["attribuut_uri"].isna()][[ATTRIBUUT_COL]].drop_duplicates()

    print("❌ Objecttypen zonder URI:")
    print(miss_obj)

    print("❌ Attributen zonder URI:")
    print(miss_attr)

    print("Totaal rijen:", len(df))
    print("Objecttype URI ontbreekt:", df["objecttype_uri"].isna().sum())
    print("Attribuut URI ontbreekt:", df["attribuut_uri"].isna().sum())

    return df


def map_boolean(df: pd.DataFrame) -> None:
    df["minimale_dataset_bool"] = df[MIN_DATASET_COL].str.lower().map({
        "ja": "true",
        "nee": "false"
    })


def build_triples(df: pd.DataFrame) -> None:
    df["triple"] = (
        "<" + df["objecttype_uri"] + "> "
        "<https://data.crow.nl/imbor/def/heeftMinimaalAttribuut> "
        "<" + df["attribuut_uri"] + "> ."
    )

    df["triple_met_boolean"] = (
        "_:stmt" + df.index.astype(str) + " "
        "<https://data.crow.nl/imbor/def/objecttype> <" + df["objecttype_uri"] + "> ; "
        "<https://data.crow.nl/imbor/def/attribuut> <" + df["attribuut_uri"] + "> ; "
        "<https://data.crow.nl/imbor/def/minimaleDataset> \""
        + df["minimale_dataset_bool"]
        + "\"^^<http://www.w3.org/2001/XMLSchema#boolean> ."
    )


def export_outputs(df: pd.DataFrame) -> None:
    df[[
        OBJECTTYPE_COL,
        ATTRIBUUT_COL,
        MIN_DATASET_COL,
        "objecttype_uri",
        "attribuut_uri",
        "triple"
    ]].to_csv(OUT_CSV, index=False)

    df["triple"].to_csv(OUT_TTL, index=False, header=False)


def uri_to_prefixed_imbor(uri: str) -> str:
    """
    Zet IMBOR-def URIs om naar imbor:UUID, anders <URI>.
    """
    if isinstance(uri, str) and uri.startswith("https://data.crow.nl/imbor/def/"):
        return "imbor:" + uri.rsplit("/", 1)[-1]
    return f"<{uri}>"


def build_shapes(df: pd.DataFrame) -> str:
    """
    Bouwt SHACL shapes:
    - per objecttype een NodeShape met sh:targetClass
    - per minimaal attribuut een PropertyShape met sh:minCount 1 en sh:path
    - IDs zijn UUIDs onder mds_imbor:
    """
    lines: list[str] = []
    lines.append(PREFIXES.strip())
    lines.append("")

    # Alleen minimale dataset == Ja
    mdf = df[df[MIN_DATASET_COL].str.lower() == "ja"].copy()

    # Groepeer per objecttype_uri
    grouped = mdf.groupby("objecttype_uri", dropna=False)

    for objecttype_uri, group in grouped:
        if pd.isna(objecttype_uri) or objecttype_uri == "":
            # kan niet targetten zonder URI
            continue

        node_shape_id = f"mds_imbor:shape-{uuid.uuid4()}"
        target_class = uri_to_prefixed_imbor(objecttype_uri)

        # Verzamel property shapes voor dit objecttype
        prop_shapes: list[tuple[str, str]] = []
        for _, row in group.iterrows():
            attribuut_uri = row.get("attribuut_uri")
            if pd.isna(attribuut_uri) or attribuut_uri == "":
                continue
            prop_id = f"mds_imbor:prop-{uuid.uuid4()}"
            path = uri_to_prefixed_imbor(attribuut_uri)
            prop_shapes.append((prop_id, path))

        # --- NodeShape blok ---
        lines.append(f"{node_shape_id} a sh:NodeShape ;")
        lines.append(f"  sh:targetClass {target_class} ;")

        if prop_shapes:
            for prop_id, _ in prop_shapes[:-1]:
                lines.append(f"  sh:property {prop_id} ;")
            last_prop_id, _ = prop_shapes[-1]
            lines.append(f"  sh:property {last_prop_id} .")
        else:
            # Geen properties, sluit direct af
            lines[-1] = lines[-1][:-1] + "."
        lines.append("")

        # --- PropertyShape blokken ---
        for prop_id, path in prop_shapes:
            lines.append(f"{prop_id} a sh:PropertyShape ;")
            lines.append(f"  sh:minCount 1 ;")
            lines.append(f"  sh:path {path} .")
            lines.append("")

    return "\n".join(lines).strip() + "\n"


def export_shapes(shapes_ttl: str) -> None:
    OUT_SHAPES.write_text(shapes_ttl, encoding="utf-8")


def main() -> int:
    try:
        objecttypen, attributen, min_dataset = read_inputs()

        validate_columns(objecttypen, ["objecttype_naam", "objecttype_uri"], "objecttypen")
        validate_columns(attributen, ["attribuut_naam", "attribuut_uri"], "attributen")
        validate_columns(min_dataset, [OBJECTTYPE_COL, ATTRIBUUT_COL, MIN_DATASET_COL], "min_dataset")

        prepare_keys(objecttypen, attributen, min_dataset)

        # alias mapping voor attribuutnamen
        #ALIASES = {
        #            "identificatie": "resource identifier",
        #             "domein": "domeinwaarde",
        #                    }
        #min_dataset["key_attribuut"] = min_dataset["key_attribuut"].replace(ALIASES)

        # Na de alias replace
        print("Keys na alias-replace:")
        print(min_dataset["key_attribuut"].unique())

        df = join_uris(objecttypen, attributen, min_dataset)
        # Na join_uris
        print("Rijen met URI voor 'resource identifier' of 'domeinwaarde':")
        print(df[df["key_attribuut"].isin(["resource identifier", "domeinwaarde"])][[
        ATTRIBUUT_COL, "key_attribuut", "attribuut_uri", MIN_DATASET_COL
        ]])
        map_boolean(df)
        build_triples(df)
        export_outputs(df)

        shapes_ttl = build_shapes(df)
        export_shapes(shapes_ttl)

        print(f"✅ Klaar: {OUT_TTL.name}, {OUT_CSV.name} en {OUT_SHAPES.name} aangemaakt")
        return 0

    except Exception as exc:
        print(f"❌ Fout: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())