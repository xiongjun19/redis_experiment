set -x

bash test_single_redis_sweep_client.sh 1_run_sweep_client_local

bash test_single_redis_sweep_thread.sh 1_run_sweep_thread_local

bash test_single_redis_sweep_datasize.sh 1_run_sweep_datasize_local
