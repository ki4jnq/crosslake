require './lib/document'
require './lib/error'
require './lib/report'
require './lib/track'
require './lib/indicator'

module Lib
  class Parser
    attr_reader :document

    def initialize
      @document = Document.new
    end

    def parse(io)
      io.each do |line|
        parts = line.split(' ')
        parts[0].upcase!

        case parts
        in ["REPORT", id]
          self.document << Report.new(id: id)

        in ["TRACK", id, report_id, name]
          self.document << Track.new(
            id: id,
            report_id: report_id,
            name: name,
          )

        in ["INDICATOR", id, track_id, score, weight]
          self.document << Indicator.new(
            id: id,
            track_id: track_id,
            score: score.to_i,
            weight: weight.to_i,
          )
        else
          raise UnsupportedKeyword.new(parts[0])
        end
      end

      @document
    end

  end
end
