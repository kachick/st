# Copyright (C) 2012 Kenichi Kamiya

class Object

  unless (instance_methods & ST::ObjectExtension.instance_methods(false)).empty?
    warn 'Already defined the ST methods' 
  end

  include ST::ObjectExtension
  
end

class Exception
  
  unless (methods & ST::ExceptionExtension.instance_methods(false)).empty?
    warn 'Already defined the ST methods' 
  end

  extend ST::ExceptionExtension

end
