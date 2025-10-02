The python dependencies for Martinize are: 
1-Pandas
2-Matplotlib
3-mdtraj
4-Vermouth

STEPS:

<pre>  pdb2pqr --ff=CHARMM         --with-ph=7.4         --keep-chain         --titration-state-method=propka      --pdb-output=fold_fv_model_0_propka.pdb         fold_fv_model_0.pdb fold_fv_model_0_propka.pqr </pre>

<pre> martinize2 -f fold_fv_model_0_propka.pdb -x FV_CG.pdb -o FV_CG.top -ff martini3IDP -p backbone -dssp -elastic -el 0 -eu 0.85 -eunit 1:663,1546:2196 -id-regions 664:1545 -idr-tune </pre>

<pre> /data1/dveizaj/FV/.venv/bin/insane -f FV_CG.pdb -o FV_CG.gro -p FV_CG.top -pbc polyhexagonal -box 20,20,20 -salt 0.15 -sol W -d 0 </pre>

Adjust the .top file

<pre> gmx grompp -p FV_CG.top -c FV_CG.gro -f mdp_dg/00.martini_mini.mdp -o minimization.tpr -r FV_CG.gro -maxwarn 1 </pre>
