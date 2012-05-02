require 'bundler/capistrano'
require 'thinking_sphinx/deploy/capistrano'

set :application, "clouds"

set :scm, :git
set :repository, "git://github.com/keeganquinn/clouds.git"

set :domain, "nil.keegan.ws"
role :web, domain
role :app, domain
role :db, domain, primary: true

set :use_sudo, false
set :deploy_to, "/srv/rails/#{application}"
set :deploy_via, :remote_cache

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, roles: :app, except: { no_release: true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

before 'deploy:update_code', 'thinking_sphinx:stop'
after 'deploy:update_code', 'thinking_sphinx:start'

namespace :sphinx do
  desc "Symlink Sphinx indexes"
  task :symlink_indexes, roles: :app do
    run "ln -nfs #{shared_path}/db/sphinx #{release_path}/db/sphinx"
  end
end

after 'deploy:finalize_update', 'sphinx:symlink_indexes'
