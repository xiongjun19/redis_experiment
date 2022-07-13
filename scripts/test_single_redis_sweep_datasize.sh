set -x
  
host=172.31.60.65
port=6379

thread_arr=(8)
cli_arr=(1 2 4)
data_size_arr=(1 1280 12800 128000 1280000 12800000)
num_request=2000
ratio_arr=("1:10")
exp_run=$1


cmd="docker run --rm redislabs/memtier_benchmark:latest -s ${host}  -p ${port}"

log_f="../logs/single_persis/${exp_run}"
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
             sar_path="${sar_prefix}/single_cli${cli}_th${th}_d${ds}_r${ratio}"
             ssh  $host "nohup sar -burqdp  -n DEV -P ALL  1 > ${sar_path} &"
             sleep 1
             $cmd -c ${cli} -R -d ${ds} -t $th -n ${num_request} --ratio=${ratio}  > "${log_f}/single_cli${cli}_th${th}_d${ds}_r${ratio}"
             ssh $host 'ps aux |  grep sar | grep  DEV | awk '\''{print $2}'\'' | xargs kill -9'
             sleep 1
            done
          done
        done
done

echo "finished testing the single redis instance"
