The python dependencies for Martinize are: 
1-Pandas
2-Matplotlib
3-mdtraj
4-Vermouth

STEPS:
python propka-3.0/propka.py fold_fv_model_0.pdb --pH 7.4

pdb2pqr --ff=CHARMM         --with-ph=7.4         --keep-chain         --titration-state-method=propka      --pdb-output=fold_fv_model_0_propka.pdb         fold_fv_model_0.pdb fold_fv_model_0_propka.pqr

martinize2 -f fold_fv/fold_fv_model_0.pdb -o fv_model_0.top -x fv_model_0.pdb -dssp -id-regions 692:1601 -water-bias -water-bias-eps idr:0.5
