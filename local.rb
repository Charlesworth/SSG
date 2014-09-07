require 'fileutils'

class WebSpeak
  def tohtml(a)
    puts "building " + a + " into HTML"
           
    f = File.open("Input/#{a}", "r")
    f.each_line do |line|
      if line.start_with?("Picture:")
        line.slice!(0..8)
        #move picture into Out/Pictures 
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

    out_HTML = File.new("Website/Pages/" + a.chomp(".txt") + ".html", "w")

    HTML.each do |x|
      out_HTML.puts x
    end

    out_HTML.close
    HTML.clear
  end
end

class IndexPage
  @@IndexOptions

  def make
    f = File.open("IndexOptions.txt", "r")
    @@IndexOptions = f.readlines[0..2]
    if @@IndexOptions[1].include?("Yes")
      strg = @@IndexOptions[0].split(': ')[1]
      HTML << "<h1 style='padding-left: 0.5em;'>" + strg + "</h1>"
    end

    for i in 0..2# (IndexOptions[2][26].to_i - 1) 
    #InputFilesIndex.each do |b|
      #b.chomp(".txt")
      HTML << "<a href='./Pages/#{InputFilesIndex[i].chomp(".txt")}.html'>#{InputFilesIndex[i].chomp(".txt")}</a>"
      #shitfuck = InputFilesIndex[i][0..-5]
      #puts shitfuck
      #HTML << "<a href='./Pages/#{InputFilesIndex[i][0..-5]}.html'>#{InputFilesIndex[i][0..-5]}</a>"	
    end 

    out_HTML = File.new("Website/index.html", "w")

    HTML.each do |x|
      out_HTML.puts x + "<br />"
    end

    out_HTML.close
    HTML.clear
    puts "index complete, website now finished!"
  end
end

InputFilesIndex = Dir.entries(Dir.pwd + "/Input").reject{|entry| entry == "." || entry == ".."}.sort
HTML = Array.new

OutputDirectories = ["Website", "Website/Pictures", "Website/Pages", "Website/Style"]
OutputDirectories.each {|x| if (Dir.exist?(x) == false) then Dir.mkdir(x) end}

InputFilesIndex.each do |a|
	if a.include? ".txt"
    WebSpeak.new.tohtml(a)
  elsif a.include? ".jpg" or a.include? ".png"
    FileUtils.cp("Input/#{a}", "Website/Pictures/#{a}")
	elsif a.include? ".md"
		# call redcarpet markdown
  else
    puts "file #{a} not recognised, please look at supported file types"
	end
end

puts "builds complete, making index"

IndexPage.new.make