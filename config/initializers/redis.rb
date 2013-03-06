require 'resque/failure/multiple'
#require 'resque/failure/airbrake'
require 'resque/failure/redis'

REDIS_CONFIG = YAML.load(File.open(Rails.root.join("config/redis.yml")))[Rails.env] #opened in application.rb

redis_base = Redis.new(REDIS_CONFIG.symbolize_keys!)

Resque.redis = redis_base
Resque.redis.namespace = "resque:pi"

#Resque::Failure::Airbrake.configure do |config|
#  config.api_key = '6755c72bfd6c153034b214a73c4f6176'
#end

#Resque::Failure::Multiple.classes = [Resque::Failure::Redis, Resque::Failure::Airbrake]
#Resque::Failure.backend = Resque::Failure::Multiple

unless defined?(RESQUE_LOGGER)
  f = File.open("#{Rails.root}/log/resque.log", 'a+')
  f.sync = true
  RESQUE_LOGGER = ActiveSupport::BufferedLogger.new f
end

#Resque.schedule = YAML.load_file(File.join(Rails.root, 'config/resque_schedule.yml'))

$redis = Redis::Namespace.new(REDIS_CONFIG[:namespace], :redis => redis_base)
$redis.flushdb if Rails.env.test?


Resque::Server.use Rack::Auth::Basic do |username, password|
  password == "queueitup"
end
