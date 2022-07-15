start_port=$1
inst_num=$2
num_port=$(($inst_num * 2))
end_port=$(($start_port + $num_port - 1))
mkdir -p yml_files

echo "Start generating port ${start_port}...${end_port} for ${inst_num} instances.."

out_file="docker-compose_cluster_inst${inst_num}_port${start_port}.yml"
out_path="yml_files/${out_file}"

echo "File location is --> ${out_path}"

echo "version: \"3\"" > $out_path
echo "" >> $out_path

echo "services:" >> $out_path

for port in $(seq $start_port $end_port);
do
        echo "  redis-${port}:" >> $out_path
        echo "    image: redis" >> $out_path
        echo "    container_name: redis-${port}" >> $out_path
        echo "    network_mode: \"host\"" >> $out_path
        echo "    volumes:" >> $out_path
        echo "      - /data/code/redis_experiment/docker/cluster_conf/redis_${port}.conf:/usr/local/etc/redis/redis.conf" >> $out_path
        echo "      - /data:/data" >> $out_path
        echo "    command: redis-server /usr/local/etc/redis/redis.conf" >> $out_path
        echo "" >> $out_path
done

echo "Finish yml generation."
