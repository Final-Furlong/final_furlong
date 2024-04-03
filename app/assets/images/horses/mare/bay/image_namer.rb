require 'optparse'

options = {}
OptionParser.new do |opt|
  opt.on('--file FILE') { |o| options[:file] = o }
end.parse!

puts options

File.rename("#{options[:file]}.ora", "#{options[:file]}.zip")
`/Applications/7zz e -y #{options[:file]}.zip`

# rename layers
File.rename('000.png', 'lf_ermine2.png')
File.rename('001.png', 'lf_ermine1.png')
File.rename('002.png', 'lf_coronet.png')
File.rename('003.png', 'lf_sock2.png')
File.rename('004.png', 'lf_sock1.png')
File.rename('005.png', 'lf_stocking1.png')
File.rename('006.png', 'lf_stocking1.png')
File.rename('007.png', 'rf_ermine2.png')
File.rename('008.png', 'rf_ermine1.png')
File.rename('009.png', 'rf_coronet.png')
File.rename('010.png', 'rf_sock2.png')
File.rename('011.png', 'rf_sock1.png')
File.rename('012.png', 'rf_stocking2.png')
File.rename('013.png', 'rf_stocking1.png')
File.rename('014.png', 'lh_ermine1.png')
File.rename('015.png', 'lh_ermine2.png')
File.rename('016.png', 'lh_coronet.png')
File.rename('017.png', 'lh_sock2.png')
File.rename('018.png', 'lh_sock1.png')
File.rename('019.png', 'lh_stocking2.png')
File.rename('020.png', 'lh_stocking1.png')
File.rename('021.png', 'rh_ermine1.png')
File.rename('022.png', 'rh_ermine2.png')
File.rename('023.png', 'rh_coronet.png')
File.rename('024.png', 'rh_sock2.png')
File.rename('025.png', 'rh_sock1.png')
File.rename('026.png', 'rh_stocking2.png')
File.rename('027.png', 'rh_stocking1.png')
File.rename('028.png', 'body.png')
