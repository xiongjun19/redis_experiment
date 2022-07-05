# ip=172.31.49.168
ip=$1


mkdir -p cluster_conf
mkdir -p /data/log
mkdir -p /data/run
for port in $(seq 6379 6384); 
do 
	mkdir -p /data/redis_clus/${port}
	touch cluster_conf/redis_${port}.conf
	cat  << EOF > cluster_conf/redis_${port}.conf 
port ${port}
requirepass 1234
bind 0.0.0.0
protected-mode no
daemonize no
loglevel notice
pidfile /data/run/redis_${port}.pid
logfile /data/log/redis_${port}.log
dir /data/redis_clus/${port}
appendonly yes
cluster-enabled yes 
cluster-config-file nodes.conf
cluster-node-timeout 5000
cluster-announce-ip ${ip} 
cluster-announce-port ${port}
cluster-announce-bus-port 1${port}
EOF
done

