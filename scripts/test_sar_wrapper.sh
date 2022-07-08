set -x

host=172.31.60.65
port=6379

log_f='../logs/single_test_da_persis'
cmd="docker run --rm redislabs/memtier_benchmark:latest -s ${host}  -p ${port}" 
sar_prefix='/data/redis_sar'
mkdir -p ${sar_prefix}
ssh -t $host "mkdir -p ${sar_prefix}"

sar_path="${sar_prefix}/single_cli10_th10_d32_r1:10"
ssh $host "nohup sar -burqdp  -n DEV -P ALL  1 > ${sar_path} &"
sleep 5
ssh  $host 'ps aux |  grep sar | grep  DEV | awk '\''{print $2}'\'' | xargs kill -9'

echo "finished testing the sar"


