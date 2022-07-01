set -x

host=10.200.3.33
port=6379
host_dir='/Users/junxiong/data/redis_test'

cmd="docker run -v ${host_dir}:/data --rm redislabs/memtier_benchmark:latest "

# 测试1 最简测试
$cmd -s $host -p $port  -c 100  -R -d 100 -t 16 -n 1000 --out-file=/data/result1.txt 

# 测试2 增加测试数目
$cmd -s $host -p $port  -c 100  -R -d 100 -t 16 -n 2000 --out-file=/data/result2.txt 

# $cmd -s $host -p $port  -c 100  -R -d 100 -t 16 -n 1000 --out-file=/data/result2.txt 

# 测试3 修个key的长度分布 
$cmd -s $host -p $port -R --data-size-range=4-204 --data-size-pattern=S   -c 100  -d 100 -t 16 -n 1000 --out-file=/data/result3.txt 

