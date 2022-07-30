module Lib
  class Indicator
    attr_accessor :score, :weight
    attr_reader :id, :track_id

    def initialize(id:, track_id:, score:, weight: 1)
      @id = id
      @track_id = track_id
      @score = score
      @weight = weight
    end

    def weighted_score
      @score * @weight
    end
  end
end
