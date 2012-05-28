# Copyright (C) 2012 Kenichi Kamiya


module TT

  module ObjectExtension
  
    # true if bidirectical passed #equal, and __id__ is same value
    def EQUAL?(other)
      (__id__ == other.__id__) && (_tt_bidirectical? :equal?, other)
    end

    # true if completed condition for hash key
    def EQL?(other)
      (_tt_bidirectical? :eql?, other) && (hash == other.hash) &&
        ( {self => true}.has_key? other)
    end

    # true if under "=="
    def IS?(other)
      _tt_bidirectical? :==, other
    end
    
    def NOT?(other)
      (_tt_bidirectical? :!=, other) && (!(self == other)) && (!(other == self))
    end
    
    def MATCH?(other)
      other === self
    end

    # true if under "kind_of?"
    def KIND?(other)
      kind_of? other
    rescue TypeError
      false
    end

    # true if under "instance_of?"
    def A?(other)
      instance_of? other
    rescue TypeError
      false
    end

    # true if completed other methods
    def FAMILY?(other)
      (other.public_methods - public_methods).empty?
    end

    # true if under "respond_to?"
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

end