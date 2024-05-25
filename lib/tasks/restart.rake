namespace :server do
  desc "Restart the Rails server"
  task restart: :environment do
    pid = `cat tmp/pids/server.pid`.strip.to_i
    Process.kill("TERM", pid)
  end
end