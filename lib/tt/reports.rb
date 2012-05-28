# Copyright (C) 2012 Kenichi Kamiya

module TT

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

end
