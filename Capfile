require 'dotenv'
Dotenv.load

require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rbenv'
require 'capistrano/rails'
require 'capistrano/sidekiq'
require 'capistrano/puma'

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
