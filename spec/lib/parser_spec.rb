require 'rspec'
require 'stringio'

require './spec/spec_helper'
require './lib/parser'


RSpec.describe Lib::Parser do
  let(:input1) do
    StringIO.new(<<-EOS)
      REPORT R1
      Track T1 R1 Architecture
      Indicator I1 T1 99 1
      Indicator I2 T1 67 5
      Track T2 R1 SDLC
      Indicator I3 T2 57 1
      Indicator I4 T2 42 4
      Indicator I5 T2 78 2
      Indicator I6 T2 90 2
      Track T3 R1 Security
      Indicator I7 T3 81 1
      Indicator I8 T3 55 3
      Indicator I9 T3 88 1
    EOS
  end

  let(:input2) do
    StringIO.new(<<-EOS)
      REPORT R2
      Track T4 R2 Other_Track
      Indicator I10 T4 77 2
      Indicator I11 T4 70 1
      Indicator I12 T4 50 1
      Track T5 R2 Operations
      Indicator I13 T5 29 5
      Indicator I14 T5 92 3
    EOS
  end

  let(:parser) { Lib::Parser.new }
  let(:document) { parser.document }

  describe "Invalid Inputs" do
    let(:track_before_report) do
      StringIO.new(<<-EOS)
        Track T4 R2 Other_Track
        REPORT R2
      EOS
    end

    let(:track_before_indicator) do
      StringIO.new(<<-EOS)
        REPORT R2
        Indicator I12 T4 50 1
        Track T4 R2 Other_Track
      EOS
    end

    it "Rejects the input if a track comes before the report it references" do
      expect do
        parser.parse track_before_report
      end.to raise_error Lib::ReportNotDefined
    end

    it "Rejects the input if an indicator comes before the track it references" do
      expect do
        parser.parse track_before_indicator
      end.to raise_error Lib::TrackNotDefined
    end
  end

  describe "Valid Inputs" do
    before(:each) do
      parser.parse input1
      parser.parse input2
    end

    it "Adds all Reports to the Document" do
      expect(document.reports.length).to eq 2
      expect(document.reports).to include('R1')
    end

    it "Adds all Tracks to the Document" do
      expect(document.tracks.length).to eq 5

      %w{T1 T2 T3 T4 T5}.each do |track_id|
        expect(document.tracks).to include(track_id)
      end
    end

    it "Parses all Track attributes out of the input source" do
      document.tracks.symbolize_keys in { T1: t1, T2: t2, T3: t3 }

      expect(t1.id).to eq 'T1'
      expect(t1.report_id).to eq 'R1'
      expect(t1.name).to eq 'Architecture'

      expect(t2.id).to eq 'T2'
      expect(t2.report_id).to eq 'R1'
      expect(t2.name).to eq 'SDLC'

      expect(t3.id).to eq 'T3'
      expect(t3.report_id).to eq 'R1'
      expect(t3.name).to eq 'Security'
    end

    it "Adds all Indicators to the Document" do
      expect(document.indicators.length).to eq 14

      %w{I1 I2 I3 I4 I5 I6 I7 I8 I9 I10 I11 I12 I13 I14}.each do |indicator_id|
        expect(document.indicators).to include(indicator_id)
      end
    end

    it "Parses all Indicator attributes out of the input source" do
      document.indicators.symbolize_keys in { I1: i1, I5: i5, I8: i8 }

      expect(i1.id).to eq 'I1'
      expect(i1.track_id).to eq 'T1'
      expect(i1.score).to eq 99
      expect(i1.weight).to eq 1

      expect(i5.id).to eq 'I5'
      expect(i5.track_id).to eq 'T2'
      expect(i5.score).to eq 78
      expect(i5.weight).to eq 2

      expect(i8.id).to eq 'I8'
      expect(i8.track_id).to eq 'T3'
      expect(i8.score).to eq 55
      expect(i8.weight).to eq 3
    end
  end

end
