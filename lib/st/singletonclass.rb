# Copyright (C) 2012 Kenichi Kamiya


module ST

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

    def report
      @failers.each do |result|
        puts "Failer: #{result}"
      end

      puts "#{@pass_counter + @failers.length} tests: Pass: #{@pass_counter} - Fail: #{@failers.length}"
      puts '-' * 78
    end
    
  end

end