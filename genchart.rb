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

def write_header file, title=nil
  header = <<"EOS"
<!DOCTYPE HTML>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>Highcharts Example</title>

		<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
		<script type="text/javascript">
$(function () {
        $('#container').highcharts({
            chart: {
                zoomType: 'x',
                spacingRight: 20
            },
            title: {
                text: '#{title}'
            },
            subtitle: {
                text: document.ontouchstart === undefined ?
                    'Click and drag in the plot area to zoom in' :
                    'Drag your finger over the plot to zoom in'
            },
            xAxis: {
                type: 'datetime',
                maxZoom: 14 * 24 * 3600000, // fourteen days
                title: {
                    text: null
                }
            },
            yAxis: {
                title: {
                    text: 'Exchange rate'
                }
            },
            tooltip: {
                shared: true
            },
            legend: {
                enabled: false
            },
            plotOptions: {
                area: {
                    fillColor: {
                        linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1},
                        stops: [
                            [0, Highcharts.getOptions().colors[0]],
                            [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
                        ]
                    },
                    lineWidth: 1,
                    marker: {
                        enabled: false
                    },
                    shadow: false,
                    states: {
                        hover: {
                            lineWidth: 1
                        }
                    },
                    threshold: null
                }
            },
    
            series: [{
                type: 'area',
                name: 'USD to EUR',
                pointInterval: 24 * 3600 * 1000,
                pointStart: Date.UTC(2006, 0, 01),
                data: [
EOS
  file.write header
end

def write_data file, data
  last = data.length - 1
  data.each_with_index do |datum, i|
    file.write "#{datum}\n"
  end
end

def write_footer file
  footer = <<EOS
                ]
            }]
        });
    });
    

		</script>
	</head>
	<body>
<script src="highcharts.js"></script>
<script src="exporting.js"></script>

<div id="container" style="min-width: 400px; height: 400px; margin: 0 auto"></div>

	</body>
</html>
EOS
  file.write footer
end

#####

title = "Sample Graph"

filename = ARGV.shift
title = ARGV.shift

unless filename
  usage
  exit
end

title = "Sample Graph" unless title

data = []

File.open(filename) do |f|
  while line = f.gets
    datum = line.strip
    data << datum
  end
end

outputfile = generate_html_name filename

File.open(outputfile, "w") do |f|
  write_header f, title
  write_data f, data
  write_footer f
end

printf "Done output to #{outputfile}\n"

