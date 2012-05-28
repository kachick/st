# Copyright (C) 2012 Kenichi Kamiya

def ST(title=nil)
  puts "# #{title || caller.first}"
      
  ST.setup
  yield
rescue Exception
  $stderr.puts 'Unkonw error occured', $!
else
  ST.report
ensure
  ST.teardown
end
