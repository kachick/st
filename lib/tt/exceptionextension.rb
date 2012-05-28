# Copyright (C) 2012 Kenichi Kamiya


module TT

  module ExceptionExtension

    # pass if occured the error is a own/subclassis instance
    def RESCUE(&block)
      block.call
    rescue self
      TT.pass
    rescue Exception
      TT.fail RescueFailedMissMatch.new($!, self, caller[1])
    else
      TT.fail RescueFailedNoError.new(self, caller[1])
    end
    
    # pass if occured the error is just a own instance
    def CATCH(&block)
      block.call
    rescue Exception
      if $!.instance_of? self
        TT.pass
      else
        TT.fail CatchFailedMissMatch.new($!, self, caller[1])
      end
    else
      TT.fail CatchFailedNoError.new(self, caller[1])
    end

  end

end
