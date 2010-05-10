require 'dm-core'
require 'haml'
require 'hpricot'

load File.join(APP_ROOT,'db','migrations.rb')
(Dir.entries(File.join(APP_ROOT,'models')).delete_if {|i| i =~ /^\..*/ || i == "base.rb"}).each do |file|
  load File.join APP_ROOT, 'models', file
end
