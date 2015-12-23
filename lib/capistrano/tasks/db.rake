namespace :db do
  desc "Setup db from seeds"
  task :rebuild do
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: :production do
          execute :rake, "db:drop db:create db:migrate db:seed"
        end
      end
    end
  end

  before 'db:rebuild', 'puma:stop'
  before 'db:rebuild', 'sidekiq:stop'
  after 'db:rebuild', 'sidekiq:start'
  after 'db:rebuild', 'puma:start'
end
