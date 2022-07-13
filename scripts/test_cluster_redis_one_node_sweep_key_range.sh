set -x
  
host=172.31.60.65
port=6379
pwd=1234

cmd="docker run --rm redislabs/memtier_benchmark:latest -s ${host}  -p ${port} -a $pwd --cluster-mode"

cli_arr=(8 32)
thread_arr=(1 4 16 64)
data_size_arr=(128)
key_range_arr=(1000 10000 100000 1000000 10000000 100000000)
      --key-minimum=NUMBER       Key ID minimum value (default: 0)
      --key-maximum=NUMBER       Key ID maximum value (default: 10000000)

num_request=2000
ratio_arr=("1:10")
exp_run=$1


log_f="../logs/cluster_data_persis/${exp_run}"
sar_prefix="/data/redis_sar/${exp_run}"

mkdir -p ${sar_prefix}
mkdir -p ${log_f}
ssh -t $host "mkdir -p ${sar_prefix}"


for th in ${thread_arr[@]}
do
   for cli in ${cli_arr[@]}
        do
          for ds in ${data_size_arr[@]}
          do
           for ratio in ${ratio_arr[@]}
            do
              for key_range in ${key_range_arr[@]}
              do
               sar_path="${sar_prefix}/cluster_cli${cli}_th${th}_d${ds}_r${ratio}_kr${key_range}"
               ssh  $host "nohup sar -burqdp  -n DEV -P ALL  1 > ${sar_path} &"
               sleep 1
               $cmd -c ${cli} -R -d ${ds} -t $th --ratio=${ratio} -n ${num_request} --key_maximum=${key_range} > "${log_f}/cluster_cli${cli}_th${th}_d${ds}_r${ratio}_kr${key_range}"
                ssh $host 'ps aux |  grep sar | grep  DEV | awk '\''{print $2}'\'' | xargs kill -9'
                 sleep 1
              done 
            done
          done
        done
done

echo "finished testing the cluster redis instance"
