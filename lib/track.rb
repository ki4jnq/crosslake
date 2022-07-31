module Lib
  class Track
    attr_accessor :indicators
    attr_reader :id, :report_id, :name

    def initialize(id:, report_id:, name:)
      @id = id
      @report_id = report_id
      @name = name
      @indicators = {}
    end

    def <<(indicator)
      raise IndicatorAlreadyAdded.new(indicator.id, id) if indicators.include? indicator.id

      @indicators[indicator.id] = indicator
      self
    end

    def score
      vals = indicators.values
      vals.map(&:weighted_score).reduce(&:+) / vals.map(&:weight).reduce(&:+)
    end
  end
end
