
ip=$1
port_start=$2
inst_num=$3


docker_yml_file="docker-compose_cluster_inst${inst_num}_port${port_start}.yml"
docker_yml_path="yml_files/${docker_yml_file}"

mkdir -p ../logs 
sar 1 500 > "../logs/${inst_num}inst_baseline"
ssh sdw7 "cd /data/code/redis_experiment/scripts; bash sweep_wrapper_cluster_custom.sh ${inst_num} ${ip} ${port_start}"

cd /data/code/redis_experiment/docker 
docker-compose -f $docker_yml_path stop
docker-compose -f $docker_yml_path rm
