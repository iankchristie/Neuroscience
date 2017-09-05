
for s in `seq 2 20` ; do 
     (( maxw=s-1 )); 
     for w in `seq 1 $maxw ` ; do 
          qsub -l mem_token=4G -l mem_free=4G -v MYS=$s,MYW=$w -N simulation_${s}_${w} runSimulation.job; 
     done;
done; 
