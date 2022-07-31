require 'rspec'
require 'rspec/its'
require 'stringio'

require './lib/document'
require './lib/report'
require './lib/track'
require './lib/indicator'
require './lib/error'

RSpec.describe Lib::Document do
  let(:t1_id) { 'T1' }
  let(:t2_id) { 'T2' }
  let(:t3_id) { 'T3' }
  let(:t4_id) { 'T4' }

  let(:r1_id) { 'R1' }
  let(:r2_id) { 'R2' }

  let(:i1) { Lib::Indicator.new id: 'I1', track_id: t1_id, score: 50 }
  let(:i2) { Lib::Indicator.new id: 'I2', track_id: t1_id, score: 75 }
  let(:i3) { Lib::Indicator.new id: 'I3', track_id: t1_id, score: 66 }
  let(:i4) { Lib::Indicator.new id: 'I4', track_id: t1_id, score: 23 }

  let(:i5) { Lib::Indicator.new(id: 'I5', track_id: t2_id, score: 33, weight: 5) }
  let(:i6) { Lib::Indicator.new(id: 'I6', track_id: t2_id, score: 57, weight: 2) }
  let(:i7) { Lib::Indicator.new(id: 'I7', track_id: t2_id, score: 90, weight: 3) }
  let(:i8) { Lib::Indicator.new(id: 'I8', track_id: t2_id, score: 48, weight: 4) }

  let(:i9) { Lib::Indicator.new(id: 'I9', track_id: t3_id, score: 82, weight: 5) }
  let(:i10) { Lib::Indicator.new(id: 'I10', track_id: t4_id, score: 13, weight: 1) }

  let(:t1) { Lib::Track.new id: t1_id, report_id: r1_id, name: 'Test Track 1' }
  let(:t2) { Lib::Track.new id: t2_id, report_id: r1_id, name: 'Test Track 2' }

  let(:t3) { Lib::Track.new id: t3_id, report_id: r2_id, name: 'Test Track 1' }
  let(:t4) { Lib::Track.new id: t4_id, report_id: r2_id, name: 'Test Track 2' }

  let(:r1) { Lib::Report.new id: r1_id }
  let(:r2) { Lib::Report.new id: r2_id }

  let(:document) { Lib::Document.new }

  it "Rejects Indicators that reference Tracks that have not yet been added" do
    expect { document << i1 }.to raise_error Lib::TrackNotDefined
  end

  it "Rejects Tracks that reference Reports that have not yet been added" do
    expect { document << t1 }.to raise_error Lib::ReportNotDefined
  end

  it "Accepts Reports" do
    expect { document << r1 << r2 }.to change { document.reports.length }.by(2)

    expect(document.reports).to include r1.id
    expect(document.reports).to include r2.id
  end

  it "Accepts valid Tracks" do
    expect do
      document << r1 << t1
    end.to change { r1.tracks.length || 0 }.by(1)
      .and change { document.tracks.length }.by(1)
  end

  it "Accepts valid Indicators" do
    expect do
      document << r1
      document << t1 << i1 << i2 << i3
      document << t2 << i5 << i6
    end.to change { document.indicators.length }.by(5)
      .and change { t1.indicators.length || 0 }.by(3)
      .and change { t2.indicators.length || 0 }.by(2)
  end

  describe "Generate a report" do
    let(:output) { StringIO.new }
    let(:report_text) { output.string.split("\n") }

    before :each do
      document << r1
      document << t1 << i1 << i2 << i3 << i4
      document << t2 << i5 << i6 << i7 << i8

      document << r2
      document << t3 << i9
      document << t4 << i10

      document.generate_report(output)
    end

    it "Includes a line for every Report in the input" do
      document.reports do |id, report|
        expect(report_text).to include(
          match(/^Report #{id} Overall Score: #{report.score}$/)
        ).once
      end
    end

    it "Includes a line for every Track in the input" do
      document.tracks.each do |id, track|
        expect(report_text).to include(
          match(/^Track #{id} Score: #{track.score}$/)
        ).once
      end
    end
  end
end
