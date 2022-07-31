require './lib/error'
require './lib/report'
require './lib/track'
require './lib/indicator'

module Lib
  class Document
    attr_reader :reports, :tracks, :indicators

    def initialize
      @reports = {}
      @tracks = {}
      @indicators = {}
    end

    #def score_for(**args)
    #  case args
    #  in report_id: id
    #    @reports[id].score
    #  in track_id: id
    #    @tracks[id].score
    #  in indicator_id: id
    #    @indicators[id].weighted_score
    #  end
    #end

    def generate_report(out)
      @reports.each do |_, report|
        out.puts "Report #{report.id} Overall Score: #{report.score}"
        report.tracks.each do |_, track|
          out.puts "Track T1 Score: #{track.score}"
        end
      end
    end

    def <<(entry)
      add_report(entry) and return self if entry.is_a? Report
      add_track(entry) and return self if entry.is_a? Track
      add_indicator(entry) and return self if entry.is_a? Indicator
    end

    private

    def add_report(report)
      @reports[report.id] = report
    end

    def add_track(track)
      report = @reports[track.report_id]
      raise ReportNotDefined.new(track.report_id, track.id) unless report

      @tracks[track.id] = track
      report << track
    end

    def add_indicator(indicator)
      track = @tracks[indicator.track_id]
      raise TrackNotDefined.new(indicator.track_id, indicator.id) unless track

      @indicators[indicator.id] = indicator
      track << indicator
    end

  end
end
