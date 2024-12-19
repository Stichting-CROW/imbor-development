from hashlib import sha256
import rdflib
from rdflib.compare import graph_diff, to_isomorphic

# Define input and output file paths
TTL_FILE_1 = "am-2022.ttl"
TTL_FILE_2 = "am-2025.ttl"
ADDED_TRIPLES_TSV = "added_triples.tsv"
REMOVED_TRIPLES_TSV = "removed_triples.tsv"
ADDED_TRIPLES_TTL = "added_triples.ttl"
REMOVED_TRIPLES_TTL = "removed_triples.ttl"

# Define functions 
## Function to format a triple for TSV output
def format_triple(triple):
    # Formats an RDF triple as a tuple of N3-encoded strings.
    return tuple(t.n3() for t in triple)

## Function to write triples to a TSV file
def write_to_tsv(triples, filename, prefix):
    # Writes triples to a TSV file with a specified prefix.
    with open(filename, "w", newline="\n", encoding="utf-8") as tsvfile:
        for triple in triples:
            tsvfile.write(f"{prefix} {triple[0]} {triple[1]} {triple[2]} .\n")

## Function to generate a subject URI for a change statement
def generate_change_subject(triple):
    # Generates a unique URI for a change statement based on the triple's hash.
    hash_value = sha256(" ".join(triple).encode()).hexdigest()
    return rdflib.URIRef(f"https://data.crow.nl/change/id/{hash_value}")

## Function to write prefixes to a Turtle file
def write_prefixes(filename):
    # Writes standard prefixes to a Turtle file.
    prefixes = f"""@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>.
@prefix as: <https://www.w3.org/ns/activitystreams#>.
@prefix crow_change: <https://data.crow.nl/change/id/>.

"""
    with open(filename, "w", encoding="utf-8") as f:
        f.write(prefixes)

## Function to write triples to a Turtle file as change statements
def write_to_ttl(triples, filename, change_type):
    # Writes triples to a Turtle file as ActivityStreams Create/Delete statements.
    write_prefixes(filename)
    with open(filename, "a", encoding="utf-8") as f:
        for triple in triples:
            subj = generate_change_subject(format_triple(triple))
            formatted_triple = format_triple(triple)
            f.write(f"""{subj.n3()} a rdf:Statement , as:{change_type} ;
    rdf:subject {formatted_triple[0]} ;
    rdf:predicate {formatted_triple[1]} ;
    rdf:object {formatted_triple[2]} .

""")
            
## Separate function for pretty printing
def pretty_print_turtle_file(input_filename, output_filename):
    # Serialize a turtle file with improved formatting
    g = rdflib.Graph()
    g.parse(input_filename, format="turtle")
    
    # Serialize with pretty formatting
    pretty_turtle = g.serialize(format="turtle", indent=4)
    
    # Write to a new file
    with open(output_filename, "w", encoding="utf-8") as f:
        f.write(pretty_turtle)

# Actions/steps
## Load graphs
graph1 = rdflib.Graph().parse(TTL_FILE_1, format="turtle")
graph2 = rdflib.Graph().parse(TTL_FILE_2, format="turtle")

## Compute isomorphic graphs and diff
iso_graph1 = to_isomorphic(graph1)
iso_graph2 = to_isomorphic(graph2)
_, removed_triples, added_triples = graph_diff(iso_graph1, iso_graph2)

## Format and write changes
formatted_added_triples = sorted([format_triple(t) for t in added_triples])
formatted_removed_triples = sorted([format_triple(t) for t in removed_triples])

write_to_tsv(formatted_added_triples, ADDED_TRIPLES_TSV, "+")
write_to_tsv(formatted_removed_triples, REMOVED_TRIPLES_TSV, "-")

write_to_ttl(added_triples, ADDED_TRIPLES_TTL, "Create")
write_to_ttl(removed_triples, REMOVED_TRIPLES_TTL, "Delete")

pretty_print_turtle_file(ADDED_TRIPLES_TTL, "pretty_" + ADDED_TRIPLES_TTL)
pretty_print_turtle_file(REMOVED_TRIPLES_TTL, "pretty_" + REMOVED_TRIPLES_TTL)

## Notify completion
print(f"Added triples (TSV): {ADDED_TRIPLES_TSV}")
print(f"Removed triples (TSV): {REMOVED_TRIPLES_TSV}")
print(f"Added triples (TTL): {ADDED_TRIPLES_TTL}")
print(f"Removed triples (TTL): {REMOVED_TRIPLES_TTL}")
print(f"Pretty Added triples (TTL): pretty_{ADDED_TRIPLES_TTL}")
print(f"Pretty Removed triples (TTL): pretty_{REMOVED_TRIPLES_TTL}")