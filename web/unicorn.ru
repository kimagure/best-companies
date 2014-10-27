worker_processes 4
timeout 30

@app_path = '/home/ec2-user/best-companies/web'
listen "/tmp/unicorn.sock", :backlog => 64
pid "#{@app_path}/tmp/pids/unicorn.pid"