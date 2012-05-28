# Copyright (C) 2012 Kenichi Kamiya


module ST

  module ExceptionExtension

    # pass if occured the error is a own/subclassis instance
    def RESCUE(&block)
      block.call
    rescue self
      ST.pass
    rescue Exception
      ST.fail RescueFailedMissMatch.new($!, self, caller[1])
    else
      ST.fail RescueFailedNoError.new(self, caller[1])
    end
    
    # pass if occured the error is just a own instance
    def CATCH(&block)
      block.call
    rescue Exception
      if $!.instance_of? self
        ST.pass
      else
        ST.fail CatchFailedMissMatch.new($!, self, caller[1])
      end
    else
      ST.fail CatchFailedNoError.new(self, caller[1])
    end

  end

end
