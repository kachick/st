$VERBOSE = true

require_relative 'lib/st'


ST 'Successful case' do

  s = 'Sample Strings'

  s.IS 'Sample Strings'
  s.NOT 'Critical Value'
  s.MATCH /\S+ \S+/
  s.EQUAL s
  s.EQL 'Sample Strings'
  s.KIND String
  s.A String

  Exception.RESCUE do
    s.fooooooooooobar!
  end

  NoMethodError.CATCH do
    s.fooooooooooobar!
  end

end

ST 'Failure case' do

  s = 'Sample Strings'

  s.IS ';)'
  s.NOT 'Sample Strings'
  s.MATCH /\d/
  s.EQUAL 'Sample Strings'
  s.EQL :'Sample Strings'
  s.KIND Symbol
  s.A Symbol

  Exception.CATCH do
    s.fooooooooooobar!
  end

  SyntaxError.RESCUE do
    s.fooooooooooobar!
  end

end
