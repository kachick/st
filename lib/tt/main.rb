# Copyright (C) 2012 Kenichi Kamiya

def TT(title=nil)
  puts "# #{title || caller.first}"
      
  TT.setup
  yield
rescue Exception
  $stderr.puts 'Unkonw error occured', $!
else
  TT.report
ensure
  TT.teardown
end
