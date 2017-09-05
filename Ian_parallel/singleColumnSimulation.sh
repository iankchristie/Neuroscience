

num=$(awk 'BEGIN{for(i=0;i<=1.05;i+=0.05)print i}')

for i in $num ; do
	echo $i
    	qsub -v MYWii=$i -N simulation_${i} runSingleColumnSimulation.job;
done;
~            
