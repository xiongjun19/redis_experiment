

ip=$1
port_start=$2
inst_num=$3

port_num=$(($inst_num * 2))
port_end=$(($port_start + $port_num - 1))
echo "${port_start} ${port_end}" > /data/code/redis_experiment/tmp_save

bash gen_cluster_conf_custom.sh $ip $port_start $port_num
bash gen_docker_yml.sh $port_start $inst_num
docker_yml_file="docker-compose_cluster_inst${inst_num}_port${port_start}.yml"
docker_yml_path="yml_files/${docker_yml_file}"
docker-compose -f $docker_yml_path up -d

docker exec -it redis-$port_start /bin/bash
pwd=1234
ip=172.31.60.65
cd /usr/local/bin/
start_end=$(head -1 /data/code/redis_experiment/tmp_save)
port_start=${start_end[0]}
port_end=${start_end[1]}
all_ports=""
for port in $(seq $port_start $port_end);
do
all_ports="${all_ports} $ip:$port"
done
./redis-cli -a $pwd --cluster create $all_ports --cluster-replicas 1 --cluster-yes
exit

