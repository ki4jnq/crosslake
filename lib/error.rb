module Lib
  class Error < ::StandardError; end

  class UnsupportedKeyword < Error
    def initialize(word)
      @word = word
    end

    def to_s
      "Unsupported Keyword in Input file: '#{@word}'"
    end
  end

  class UndefinedID < Error
    def initialize(id, referencing_id)
      @id = id
      @referencing_id = referencing_id
    end
  end

  class ReportNotDefined < UndefinedID
    def to_s
      "Report #{id} Referenced by Track '#{referencing_id}' has not yet been defined"
    end
  end

  class TrackNotDefined < UndefinedID
    def to_s
      "Track #{id} Referenced by Indicator '#{referencing_id}' has not yet been defined"
    end
  end

end
