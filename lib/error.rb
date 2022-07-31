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

  class BadID < Error
    def initialize(id, referencing_id)
      @id = id
      @referencing_id = referencing_id
    end
  end

  class ReportNotDefined < BadID
    def to_s
      "Report '#{@id}' Referenced by Track '#{@referencing_id}' has not yet been defined"
    end
  end

  class TrackNotDefined < BadID
    def to_s
      "Track '#{@id}' Referenced by Indicator '#{@referencing_id}' has not yet been defined"
    end
  end

  class TrackAlreadyAdded < BadID
    def to_s
      "Track '#{@id}' already added to Report '#{@referencing_id}'"
    end
  end

  class IndicatorAlreadyAdded < BadID
    def to_s
      "Indicator '#{@id}' already added to Track '#{@referencing_id}'"
    end
  end

end
