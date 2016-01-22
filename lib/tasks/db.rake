namespace :db do
  desc "Rebuild db"
  task rebuild: [:drop, :create, :migrate, :seed]  do
    p 'Done'
  end
end
