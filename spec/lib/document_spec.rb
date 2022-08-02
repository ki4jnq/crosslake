require 'rspec'
require 'rspec/its'
require 'stringio'

require './spec/spec_helper'

require './lib/document'
require './lib/report'
require './lib/track'
require './lib/indicator'
require './lib/error'

RSpec.describe Lib::Document do
  include_examples(:report_data)

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
