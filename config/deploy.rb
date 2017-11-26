# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'livefac'
set :repo_url, 'git@bitbucket.org:jeks/livefac.git'
set :rbenv_path, '/home/livefac/.rbenv'
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/livefac/www'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('.env')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'public/uploads')

set :rbenv_ruby, File.read('.ruby-version').strip

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log, "#{shared_path}/log/puma_access.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, [0, 1]
set :puma_workers, 1
set :puma_init_active_record, true
set :puma_preload_app, true

set :sidekiq_queue, ['default', 'mailers']
set :sidekiq_processes,  1
set :sidekiq_concurrency, 1

namespace :deploy do

  after :finishing, :nginx_reload do
    on roles(:app) do
      within release_path do
        execute "sudo service nginx reload"
      end
    end
  end

end
