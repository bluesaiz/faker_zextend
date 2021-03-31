require "faker_zextend/version"
require "faker"
Faker::Config.locale = 'zh-CN'
module FakerZextend
  class Error < StandardError; end
  # Your code goes here...
end
mydir = __dir__

Dir.glob(File.join(mydir, 'faker_zextend', 'extend', '/**/*.rb')).sort.each {|file| require file}