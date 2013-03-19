require 'bundler/gem_tasks'
require 'less'

LESS_PATH = 'vendor/less'
CSS_PATH = 'vendor/assets/stylesheets'

def less_to_css(file)
  less_file = "#{LESS_PATH}/#{file}.less"
  rcss_file = "#{CSS_PATH}/#{file}.css"
  mcss_file = "#{CSS_PATH}/#{file}-min.css"
  rf = File.new(rcss_file, File::CREAT|File::TRUNC|File::RDWR, 0644)
  mf = File.new(mcss_file, File::CREAT|File::TRUNC|File::RDWR, 0644)
  parser = Less::Parser.new
  tree = parser.parse(File.new(less_file).read)
  rf.write tree.to_css; rf.flush
  mf.write tree.to_css(compress: true); mf.flush
end

task :less do
  less_to_css('forma')
end