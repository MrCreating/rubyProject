# Puma configuration file

# Number of threads per worker
threads_count = ENV.fetch("RAILS_MAX_THREADS", 3)
threads threads_count, threads_count

# Specify the binding to allow Puma to listen on all interfaces
bind "http://0.0.0.0:3000"

# Allow puma to be restarted by `bin/rails restart` command.
plugin :tmp_restart

# Run the Solid Queue supervisor inside of Puma for single-server deployments
plugin :solid_queue if ENV["SOLID_QUEUE_IN_PUMA"]

# Specify the PID file. Defaults to tmp/pids/server.pid in development.
pidfile ENV["PIDFILE"] if ENV["PIDFILE"]