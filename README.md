The python dependencies for Martinize are: 
1-Pandas
2-Matplotlib
3-mdtraj
4-Vermouth

STEPS:
pdb2pqr --ff=CHARMM         --with-ph=7.4         --keep-chain         --titration-state-method=propka      --pdb-output=fold_fv_model_0_propka.pdb         fold_fv_model_0.pdb fold_fv_model_0_propka.pqr
martinize2 -f fold_fv_model_0_propka.pdb -x FV_CG.pdb -o FV_CG.top -ff martini3IDP -p backbone -dssp -elastic -el 0 -eu 0.85 -eunit 1:691,1602:2196 -id-regions 692:1601 -idr-tune
/data1/dveizaj/FV/.venv/bin/insane -f FV_CG.pdb -o FV_CG.gro -p FV_CG.top -pbc cubic -box 35,35,35 -salt 0.15 -sol W -d 0
