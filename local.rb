require 'fileutils'
require 'launchy'
require 'erb'

IDate = Time.new

class WebSpeak
  @@date = Time.new
  def tohtml(a)
    puts "building " + a + " into a web page"
           
    f = File.open("Input/#{a}", "r")

    @@date = "No date given"
    
    f.each_line do |line|
      if line.start_with?("Picture:")
        line.slice!(0..8)
        Page_content << "<img src='../Pictures/" + line + "'alt='some_text'></img><br />"
      elsif line.start_with?("Code:")
        Page_content << "<code>"#"<div id='code'>"
      elsif line.start_with?(":Code")
        Page_content << "</code>"#"</div>"
      elsif line.start_with?("Quote:")
        Page_content << "<blockquote>"#"<div id='quote'>"
      elsif line.start_with?(":Quote")
        Page_content << "</blockquote>"#"</div>"	
      elsif line.start_with?("Header:")
        line.slice!(0..7)
        Page_content << "<h3>" + line + "</h3>"
      elsif line == "\n"
        Page_content << "<br />"
      elsif line.start_with?(":tab:")
        Page_content << "&nbsp;&nbsp;&nbsp;" * line.scan(/:tab:/).length
        line.gsub!(":tab:", "")
        Page_content << line
        Page_content << "<br />"
      elsif line.start_with?("Date:")
        line.slice!(0..5)
        line.slice!(8..9)
        puts "Incorect date format detected in file " + a + ", please use 'Date: DD/MM/YY'" if line.length != 8 
        @@date = line
      else
        Page_content << line
        Page_content << "<br />"
      end
    end

    Page_date[a.chomp(".txt")] = @@date
		
    erb = ERB.new(File.read('resources/views/page_template.erb'))
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
      #Blog_title << title
    end
		
		if (@@index_options[2][26].to_i > Pages.length)	
			@@index_length = Pages.length
		else
			@@index_length = @@index_options[2][26].to_i
		end
		
    for i in 0..(@@index_length - 1)
      Page_content << "<a href='./Pages/#{Pages[i]}.html'>#{Pages[i]} : #{Page_date[Pages[i]]}</a><br />"
    end 

		erb = ERB.new(File.read('resources/views/index_template.erb'))
    output_file = File.new("Website/index.html", "w")
    output_file.puts erb.result()
    output_file.close

    Page_content.clear
  end
end

InputFilesIndex = Dir.entries(Dir.pwd + "/Input").reject{|entry| entry == "." || entry == ".."}.sort
Pages = Array.new
Page_content = String.new
Page_date = Hash.new
#Blog_title = String.new

Output_directories = ["Website", "Website/Pictures", "Website/Pages", "Website/Style", "Website/Style/js", "Website/Style/css"]
Output_directories.each {|x| if (Dir.exist?(x) == false) then Dir.mkdir(x) end}
Style_import = ["css/bootstrap.min.css", "css/sticky-footer-navbar.css","js/bootstrap.min.js"]
Style_import.each {|y| FileUtils.cp("resources/Style/#{y}", "Website/Style/#{y}")}
#FileUtils.cp_r("resources/Style/js","Website/Style")

#------------------
file = File.open("resources/Index_options.txt", "r")
Blog_title = file.readlines[0].split(': ')[1]
puts Blog_title
#------------------

InputFilesIndex.each do |current_file|
	if current_file.include? ".txt"
    Pages << current_file.chomp(".txt")
    #WebSpeak.new.tohtml(current_file)
  elsif current_file.include? ".jpg" or current_file.include? ".png"
    FileUtils.cp("Input/#{current_file}", "Website/Pictures/#{current_file}")
	elsif current_file.include? ".md"
		# call redcarpet markdown
  else
    puts "file #{current_file} not recognised, please look at supported file types"
	end
end

Pages.each {|page| WebSpeak.new.tohtml(page + ".txt")}

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
puts Page_date.sort

Launchy.open("Website/index.html")