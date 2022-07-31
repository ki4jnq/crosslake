module Lib
  class Report
    attr_accessor :tracks
    attr_reader :id

    def initialize(id:)
      @id = id
      @tracks = {}
    end

    def <<(track)
      raise TrackAlreadyAdded.new(track.id, id) if @tracks.include? track.id

      @tracks[track.id] = track
      self
    end

    def score
      vals = tracks.values
      vals.map(&:score).reduce(&:+) / vals.length
    end
  end
end
