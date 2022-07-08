set -x

host=172.31.60.65
port=6379
pwd=1234

cmd="docker run --rm redislabs/memtier_benchmark:latest -s ${host}  -p ${port} -a $pwd --cluster-mode"


# $cmd -c 100 -R -d 100 -t 16 --ratio=1:1 -n 1000 

thread_arr=(40 100)
cli_arr=(40 100)
data_size_arr=(128 1280 12800)
num_request=2000

ratio_arr=("1:10" "1:1")
# ratio=1:10

log_f='../logs/clus_test_da_persis'
sar_prefix='/data/redis_sar'
mkdir -p ${sar_prefix}
ssh -t $host "mkdir -p ${sar_prefix}"


for th in ${thread_arr[@]} 
do 
   for cli in ${cli_arr[@]} 
	do
	  for ds in ${data_size_arr[@]}
	  do
           for ratio in ${ratio_arr[@]}
            do
             sar_path="${sar_prefix}/cluster_cli${cli}_th${th}_d${ds}_r${ratio}"
	     ssh  $host "nohup sar -burqdp  -n DEV -P ALL  1 > ${sar_path} &"
	     sleep 1
	     $cmd -c ${cli} -R -d ${ds} -t $th --ratio=${ratio} -n ${num_request}  > "${log_f}_cli${cli}_th${th}_d${ds}_r${ratio}"
              ssh $host 'ps aux |  grep sar | grep  DEV | awk '\''{print $2}'\'' | xargs kill -9'
	       sleep 1

	  done
          done
	done
done

echo "finished testing the cluster redis instance"

