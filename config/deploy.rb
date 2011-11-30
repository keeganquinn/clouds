require 'bundler/capistrano'

set :application, "clouds"

set :scm, :git
set :repository, "git://github.com/keeganquinn/clouds.git"

set :domain, "cloudscontrol.us"
role :web, domain
role :app, domain
role :db, domain, :primary => true

set :use_sudo, false
set :deploy_to, "/srv/rails/#{application}"
set :deploy_via, :copy

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
