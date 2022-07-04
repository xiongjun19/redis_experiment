
host=172.31.60.65
port=6379

thread_arr=(10 20 40)
cli_arr=(20 40 80)
data_size_arr=(32 64 128)
num_request=2000

for th in ${thread_arr[@]} 
do 
   for cli in ${cli_arr[@]} 
	do
	  for ds in ${data_size_arr[@]}
	  do
	     docker run --rm redislabs/memtier_benchmark:latest -s ${host}  -p ${port} -c ${cli} -R -d ${ds} -t $th -n ${num_request}
	  done
	done
done

echo "finished testing the single redis instance"


