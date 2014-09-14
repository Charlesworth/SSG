require 'sinatra'
require 'launchy'

Launchy.open("http://localhost:4567/test")
#open the init erb form
#take in the answers to a txt file
#close the page or put up a "website made, can be found in #{folder} folder

get '/' do
	"Hello, World!"
end

get '/about' do
	"Something about you here...."
end

get '/hello' do
	"Hello there :)"
end

get '/test' do
	A = "Hello, is it me your looking for?"
	erb :test
end

get '/hello/:name' do
	# params[:name]
	# "Hello there #{params[:name]}"
	"Hello there #{params[:name].upcase}"
end

get '/hello/:name/:city' do
	"Hey there #{params[:name]} from #{params[:city]}!"
end

get '/more/*' do
	params[:splat].inspect
end

get '/form' do
	erb :form
end

post '/form' do
	# "you posted something"
	output =  params[:message] + " " + params[:fuck]
	"You said '#{params[:fuck]} #{params[:message]}', Well #{output}"
	#if params[:message].empty? "no mess no fuss!"
end

get '/secret' do
	erb :secret
end

post '/secret' do
	params[:secret].reverse
end

get '/decrypt/:secret' do
	params[:secret].reverse
end

# get '/*' do
	# status 404
	# 'not found'
# end

not_found do
	halt 404, 'page not found'
end
