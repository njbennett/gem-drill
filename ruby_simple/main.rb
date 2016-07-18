require 'sinatra'
require 'json'
require 'mysql2'

STDOUT.sync = true
STDERR.sync = true
mysql_credentials = JSON.parse(ENV["VCAP_SERVICES"])["p-mysql"][0]["credentials"]
@client = Mysql2::Client.new(
  :host => mysql_credentials["hostname"],
  :username => mysql_credentials["username"],
  :password => mysql_credentials["password"],
  :database => mysql_credentials["name"],
)

@client.query("CREATE TABLE IF NOT EXISTS simple (
  info TEXT
  )"
)

get '/' do
<<-RESPONSE
Healthy
It just needed to be restarted!
My application metadata: #{ENV['VCAP_APPLICATION']}
My port: #{ENV['PORT']}
My custom env variable: #{ENV['CUSTOM_VAR']}
Services: #{JSON.parse(ENV["VCAP_SERVICES"])}
RESPONSE
end

get '/log/:message' do
  message = params[:message]
  STDOUT.puts(message)
  "logged #{message} to STDOUT"
end

Thread.new do
  while true do
    @client.query("INSERT INTO simple VALUES ('text'))")
    sleep 1
  end
end
