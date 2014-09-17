require 'fileutils'
require 'launchy'
require 'erb'

class WebSpeak
  def tohtml(a)
    puts "building " + a + " into a web page"
           
    f = File.open("Input/#{a}", "r")

    f.each_line do |line|
      if line.start_with?("Picture:")
        line.slice!(0..8)
        Page_content << "<img src='../Pictures/" + line + "'alt='some_text'></img><br />"
      elsif line.start_with?("Code:")
        Page_content << "<div id='code'>"
      elsif line.start_with?(":Code")
        Page_content << "</div>"
      elsif line.start_with?("Quote:")
        Page_content << "<div id='quote'>"
      elsif line.start_with?(":Quote")
        Page_content << "</div>"	
      elsif line.start_with?("Header:")
        line.slice!(0..7)
        Page_content << "<h1>" + line + "</h1>"
      elsif line == "\n"
        Page_content << "<br />"
      elsif line.start_with?(":tab:")
        Page_content << "&nbsp;" * line.scan(/:tab:/).length
        line.gsub!(":tab:", "")
        Page_content << line
        Page_content << "<br />"
      else
        Page_content << line
        Page_content << "<br />"
      end
    end

    erb = ERB.new(File.read('resources/views/standard_page.erb'))
    output_file = File.new("Website/Pages/" + a.chomp(".txt") + ".html", "w")
    output_file.puts erb.result()
    output_file.close
    
    Page_content.clear
  end
end

class IndexPage
  @@index_options
	@@index_length
	
  def make
    file = File.open("resources/Index_options.txt", "r")
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
Page_content = String.new

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

FileUtils.cp("resources/style.css", "Website/Style/style.css")

#for test only------------------------------------------------
puts " "
puts "------Files included in website:------"
puts InputFilesIndex
puts "-------------Pages made:--------------"
puts Pages

Launchy.open("Website/index.html")