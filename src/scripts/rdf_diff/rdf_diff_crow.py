# Script om twee versie van een TTL file te vergelijken en TSV en TTL output diffs te krijgen.
# Pas de file pairs aan welke je wilt vergelijken

from hashlib import sha256
import rdflib
from rdflib.compare import graph_diff, to_isomorphic
import os

# Define input and output folder paths
INPUT_FOLDER = "input"
OUTPUT_FOLDER = "output"

# Ensure the output folder exists
if not os.path.exists(OUTPUT_FOLDER):
    os.makedirs(OUTPUT_FOLDER)

# Define input file pairs (relative to the input folder)
FILE_PAIRS = [
    ("2022_imbor-aanvullend-metamodel.ttl", "2025_imbor-aanvullend-metamodel.ttl"),
    ("2022_imbor-kern.ttl", "2025_imbor-kern.ttl"),
    ("2022_imbor-domeinwaarden.ttl", "2025_imbor-domeinwaarden.ttl"),  # Add more pairs as needed
]

# Define functions
## Function to format a triple for TSV output
def format_triple(triple):
    return tuple(t.n3() for t in triple)

## Function to write triples to a TSV file
def write_to_tsv(triples, tsvfile, prefix):
    for triple in triples:
        tsvfile.write(f"{prefix} {triple[0]} {triple[1]} {triple[2]} .\n")

## Function to generate a subject URI for a change statement
def generate_change_subject(triple):
    hash_value = sha256(" ".join(triple).encode()).hexdigest()
    return rdflib.URIRef(f"https://data.crow.nl/change/imbor/id/{hash_value}")

## Function to write prefixes to a Turtle file
def write_prefixes(ttlfile):
    prefixes = f"""@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>.
@prefix as: <https://www.w3.org/ns/activitystreams#>.
@prefix crow_change: <https://data.crow.nl/change/imbor/id/>.

"""
    ttlfile.write(prefixes)

## Function to write triples to a Turtle file as change statements
def write_to_ttl(triples, ttlfile, change_type):
    for triple in triples:
        subj = generate_change_subject(format_triple(triple))
        formatted_triple = format_triple(triple)
        ttlfile.write(f"""{subj.n3()} a rdf:Statement , as:{change_type} ;
    rdf:subject {formatted_triple[0]} ;
    rdf:predicate {formatted_triple[1]} ;
    rdf:object {formatted_triple[2]} .

""")

# Process each pair of files
for ttl_file_1, ttl_file_2 in FILE_PAIRS:
    # Construct full paths for input files
    input_file_1 = os.path.join(INPUT_FOLDER, ttl_file_1)
    input_file_2 = os.path.join(INPUT_FOLDER, ttl_file_2)

    # Load graphs
    graph1 = rdflib.Graph().parse(input_file_1, format="turtle")
    graph2 = rdflib.Graph().parse(input_file_2, format="turtle")

    # Compute isomorphic graphs and diff
    iso_graph1 = to_isomorphic(graph1)
    iso_graph2 = to_isomorphic(graph2)
    _, removed_triples, added_triples = graph_diff(iso_graph1, iso_graph2)

    # Format triples
    formatted_added_triples = sorted([format_triple(t) for t in added_triples])
    formatted_removed_triples = sorted([format_triple(t) for t in removed_triples])

    # Construct output filenames based on input filenames
    base_name_1 = os.path.splitext(os.path.basename(ttl_file_1))[0]
    base_name_2 = os.path.splitext(os.path.basename(ttl_file_2))[0]
    changes_tsv = os.path.join(OUTPUT_FOLDER, f"diff_{base_name_1}_vs_{base_name_2}.tsv")
    changes_ttl = os.path.join(OUTPUT_FOLDER, f"diff_{base_name_1}_vs_{base_name_2}.ttl")

    # Write to TSV file
    with open(changes_tsv, "w", encoding="utf-8") as tsvfile:
        write_to_tsv(formatted_added_triples, tsvfile, "+")
        write_to_tsv(formatted_removed_triples, tsvfile, "-")

    # Write to TTL file
    with open(changes_ttl, "w", encoding="utf-8") as ttlfile:
        write_prefixes(ttlfile)
        write_to_ttl(added_triples, ttlfile, "Create")
        write_to_ttl(removed_triples, ttlfile, "Delete")

    # Notify completion for this pair
    print(f"Changes in TSV: {changes_tsv}")
    print(f"Changes in TTL: {changes_ttl}")