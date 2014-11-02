require 'sinatra'
require 'launchy'

Launchy.open("http://localhost:4567/")


#open the init erb form
#load the presets from the local options file



#present options and build button
#take in the answers to options.txt file if changed
#close the page or put up a "website made, can be found in #{folder} folder

get '/' do
	  if !File.exist?("Index_options.txt")
			output_file = File.new("Index_options.txt", "w")
			output_file.puts ["Blog Name: My Blog", "Name Displayed in Title: Yes", "Links on each index page: 5"]
			output_file.close
		end
	
		file = File.open("Index_options.txt", "r")
		index_options = file.readlines[0..2]
		
		Title = index_options[0].split(': ')[1]
		
		A = "Hello, is it me your looking for?"
		
		erb :test
end

get '/about' do
	"Something about you here...."
end

get '/hello' do
	"Hello there :)"
end

get '/Start' do
	A = "Hello, is it me your looking for?"
	erb :test
end

get '/page_editor' do
	A = "Hello, is it me your looking for?"
	erb :page_editor
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

post '/form1' do
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
