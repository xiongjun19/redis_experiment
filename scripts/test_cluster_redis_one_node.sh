set -x

host=172.31.60.65
port=6379
pwd=1234

cmd="docker run --rm redislabs/memtier_benchmark:latest -s ${host}  -p ${port} -a $pwd --cluster-mode"


# $cmd -c 100 -R -d 100 -t 16 --ratio=1:1 -n 1000 

thread_arr=(10 20 40)
cli_arr=(20 40 80)
data_size_arr=(32 64 128)
num_request=2000
ratio=1:10

log_f='../logs/clus_test_da_persis'

for th in ${thread_arr[@]} 
do 
   for cli in ${cli_arr[@]} 
	do
	  for ds in ${data_size_arr[@]}
	  do
	     $cmd -c ${cli} -R -d ${ds} -t $th --ratio=${ratio} -n ${num_request}  > "${log_f}_cli${cli}_th${th}_d${ds}"
	  done
	done
done

echo "finished testing the cluster redis instance"

