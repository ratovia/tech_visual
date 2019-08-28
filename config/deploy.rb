# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

# application name
set :application, "tech_visual"
set :repo_url, "git@github.com:ratovia/tech_visual.git"

# Branch Deploy
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
# set :branch, ENV['BRANCH'] || "master"

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push("config/master.key")
# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# config ruby
# set :rbenv_type, :user
# set :rbenv_ruby, '2.5.1'
# set :rbenv_custom_path, '/usr/local/rbenv'
# config ssh
set :ssh_options, auth_methods: ['publickey'],
                    keys: ['~/.ssh/ratovia_ssh_key.pem']

# config unicorn
set :unicorn_pid, -> { "#{shared_path}/tmp/pids/unicorn.pid" }
set :unicorn_config_path, -> { "#{current_path}/config/unicorn.rb" }
set :keep_releases, 5

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    # invoke 'unicorn:restart'
    invoke 'unicorn:stop'
    invoke 'unicorn:start'
  end
end

namespace :deploy do
  desc 'db_seed'
  task :db_seed do
    on roles(:db) do |host|
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:seed'
        end
      end
    end
  end
end