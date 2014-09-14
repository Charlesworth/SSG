require 'fileutils'
require 'launchy'

class WebSpeak
  def tohtml(a)
    puts "building " + a + " into HTML"
           
    f = File.open("Input/#{a}", "r")
    f.each_line do |line|
      if line.start_with?("Picture:")
        line.slice!(0..8)
        HTML << "<br /><img src='../Pictures/" + line + "'alt='some_text'></img><br />"
      elsif line.start_with?("Code:")
        HTML << "<br /><div style='background: darkgray; padding-left: 1em; color: green; font-family: monospace;'>"
      elsif line.start_with?(":Code")
        HTML << "</div>"
      elsif line.start_with?("Quote:")
        HTML << "<br /><div style='font-style: italic; padding-left: 1em;'>"
      elsif line.start_with?(":Quote")
        HTML << "</div>"	
      elsif line.start_with?("Header:")
        line.slice!(0..7)
        HTML << "<h1 style='padding-left: 0.5em;'>" + line + "</h1>"
      elsif line == "\n"
        HTML << "<br />"
      else
        HTML << line
      end
    end
      
    #put next post and index hyperlinks here

    output_file = File.new("Website/Pages/" + a.chomp(".txt") + ".html", "w")

    HTML.each do |x|
      output_file.puts x
    end

    output_file.close
    HTML.clear
  end
end

class IndexPage
  @@index_options
	@@index_length
	
  def make
    file = File.open("Index_options.txt", "r")
    @@index_options = file.readlines[0..2]
    if @@index_options[1].include?("Yes") #If display title = yes
      title = @@index_options[0].split(': ')[1]
      HTML << "<h1 style='padding-left: 0.5em;'>" + title + "</h1>"
    end
		
		if (@@index_options[2][26].to_i > Pages.length)	
			@@index_length = Pages.length
		else
			@@index_length = @@index_options[2][26].to_i
		end
		
    for i in 0..(@@index_length - 1)
      HTML << "<a href='./Pages/#{Pages[i]}.html'>#{Pages[i]}</a>"
    end 

    output_file = File.new("Website/index.html", "w")

    HTML.each do |x|
      output_file.puts x + "<br />"
    end

    output_file.close
    HTML.clear
  end
end


InputFilesIndex = Dir.entries(Dir.pwd + "/Input").reject{|entry| entry == "." || entry == ".."}.sort
HTML = Array.new
Pages = Array.new

OutputDirectories = ["Website", "Website/Pictures", "Website/Pages", "Website/Style"]
OutputDirectories.each {|x| if (Dir.exist?(x) == false) then Dir.mkdir(x) end}

InputFilesIndex.each do |current_file|
	if current_file.include? ".txt"
    WebSpeak.new.tohtml(current_file)
		Pages << current_file.chomp(".txt")
  elsif current_file.include? ".jpg" or current_file.include? ".png"
    FileUtils.cp("Input/#{current_file}", "Website/Pictures/#{current_file}")
	elsif current_file.include? ".md"
		# call redcarpet markdown
  else
    puts "file #{current_file} not recognised, please look at supported file types"
	end
end

puts "builds complete, making index"
IndexPage.new.make
puts "index complete, website now finished!"
#system 'ruby server.rb'

#for test only------------------------------------------------
puts " "
puts "------Files included in website:------"
puts InputFilesIndex
puts "-------------Pages made:--------------"
puts Pages