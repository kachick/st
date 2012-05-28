# Copyright (C) 2012 Kenichi Kamiya

class Object

  unless (instance_methods & TT::ObjectExtension.instance_methods(false)).empty?
    warn 'Already defined the TT methods' 
  end

  include TT::ObjectExtension
  
end

class Exception
  
  unless (methods & TT::ExceptionExtension.instance_methods(false)).empty?
    warn 'Already defined the TT methods' 
  end

  extend TT::ExceptionExtension

end
