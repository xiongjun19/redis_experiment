cd /data/code/redis_experiment/docker 

ip=172.31.60.65
port_start=6379

for inst_num in 2 8 16 32
do 
	bash start_environment.sh $ip $port_start $inst_num

	sleep 1

	bash run_experiment_and_clean_up.sh $ip $port_start $inst_num 

done


