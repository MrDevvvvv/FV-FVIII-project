from Bio import PDB
import sys

input_cif = sys.argv[1]
output_pdb = sys.argv[2]

parser = PDB.MMCIFParser()
structure = parser.get_structure("id", input_cif)

io = PDB.PDBIO()
io.set_structure(structure)
io.save(output_pdb)

print(f"Converted {input_cif} → {output_pdb}")

