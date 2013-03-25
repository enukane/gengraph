#!/usr/bin/env ruby

def usage
  printf "\n"
  printf "usage:  ruby genchart.rb <filename>\n"
  printf "\n"
  printf "    this will output <filename>-<date>.html which displays line chart on browser\n"
  printf "    <filename> must be a file with several data separated with newline\n"
  printf "\n"
  exit
end

def generate_html_name filename
  time = Time.now
  str = ""
  str += "#{filename}-"
  str += time.year.to_s
  str += sprintf("%02d", time.month)
  str += sprintf("%02d", time.day)
  str += sprintf("%02d", time.hour)
  str += sprintf("%02d", time.min)
  str += ".html"
  return str
end

def write_header file
  file.write "<html>\n"
  file.write "<head>\n"
  file.write "<script type=\"text/javascript\" src=\"dygraph-combined.js\"></script>\n"
  file.write "</head>\n"
  file.write "<body>\n"
  file.write "<div id=\"graphdiv\"></div>\n"
  file.write "<script type=\"text/javascript\">\n"
  file.write "g = new Dygraph(\n"
  file.write "document.getElementById(\"graphdiv\"), \"Date,Temperature\\n\" +\n"
end

def write_data file, data
  last = data.length - 1
  data.each_with_index do |datum, i|
    file.write "\"#{i},#{datum}\\n\""
    if last == i
      file.write ",\n"
    else
      file.write " +\n"
    end
  end
end

def write_footer file
  file.write "{ }\n"
  file.write ");\n"
  file.write "</script>\n"
  file.write "</body>\n"
  file.write "</html>\n"
end

#####

filename = ARGV.shift
usage unless filename

data = []

File.open(filename) do |f|
  while line = f.gets
    datum = line.strip
    data << datum
  end
end

outputfile = generate_html_name filename

File.open(outputfile, "w") do |f|
  write_header f
  write_data f, data
  write_footer f
end

printf "Done output to #{outputfile}\n"

