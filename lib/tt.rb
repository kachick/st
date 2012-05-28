# Copyright (C) 2012 Kenichi Kamiya


module TT

  VERSION = '0.0.1'.freeze

  TestFailed = Struct.new :target, :expected, :comparison, :caller do
    def to_s
      "`#{target.inspect}` not #{comparison} `#{expected.inspect}`.  # (#{caller})"
    end
  end

  RescueFailedMissMatch = Struct.new :occured, :expected, :caller do
    def to_s
      "Expected an error `#{expected}` or any suberror, but ocuured `#{occured.class}`.  # (#{caller})"
    end
  end

  RescueFailedNoError = Struct.new :expected, :caller do
    def to_s
      "Expected an error `#{expected}` or any suberror, but not occured any errors.  # (#{caller})"
    end
  end

  CatchFailedMissMatch = Struct.new :occured, :expected, :caller do
    def to_s
      "Expected just an error `#{expected}`, but ocuured `#{occured.class}`.  # (#{caller})"
    end
  end

  CatchFailedNoError = Struct.new :expected, :caller do
    def to_s
      "Expected just an error `#{expected}`, but not occured any errors.  # (#{caller})"
    end
  end

  @failers, @pass_counter = [], 0

  class << self
    
    def setup
      @failers, @pass_counter = [], 0
    end
    
    def teardown
      @failers, @pass_counter = [], 0
    end

    def pass
      @pass_counter += 1
    end
    
    def fail(detail)
      @failers << detail
    end

    def report(title)
      puts "# #{title}" if title

      @failers.each do |result|
        puts "Failer: #{result}"
      end

      puts "#{@pass_counter + @failers.length} tests: Pass: #{@pass_counter} - Fail: #{@failers.length}"
      puts '-' * 78
    end
    
  end

  module ObjectExtension
  
    def EQUAL?(other)
      (__id__ == other.__id__) && (_tt_bidirectical? :equal?, other)
    end

    def EQL?(other)
      (_tt_bidirectical? :eql?, other) && (hash == other.hash) &&
        ( {self => true}.has_key? other)
    end

    def IS?(other)
      _tt_bidirectical? :==, other
    end
    
    def NOT?(other)
      (_tt_bidirectical? :!=, other) && (!(self == other)) && (!(other == self))
    end
    
    def MATCH?(other)
      other === self
    end

    def KIND?(other)
      kind_of? other
    rescue TypeError
      false
    end

    def A?(other)
      instance_of? other
    rescue TypeError
      false
    end

    def LIKE?(other)
      (other.public_methods - public_methods).empty?
    end
    
    def RESPOND?(message)
      respond_to? message
    end

    instance_methods(false).grep(/\A(?<mname>[A-Z]+)\?\z/) do |predicate|
      define_method $~[:mname].to_sym do |other|
        (__send__ predicate, other) ? TT.pass : TT.fail(TestFailed.new self, other, __callee__, caller.first)
      end
    end
    
    private

    def _tt_bidirectical?(comparison, other)
      (__send__ comparison, other) && (other.__send__ comparison, self)
    end

  end
  
  module ExceptionExtension

    def RESCUE(&block)
      block.call
    rescue self
      TT.pass
    rescue Exception
      TT.fail RescueFailedMissMatch.new($!, self, caller[1])
    else
      TT.fail RescueFailedNoError.new(self, caller[1])
    end
    
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


def TT(title=nil)
  TT.setup
  yield
rescue Exception
  $stderr.puts 'Unkonw error occured', $!
else
  TT.report title
ensure
  TT.teardown
end


