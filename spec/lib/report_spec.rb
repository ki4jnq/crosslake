require 'rspec'
require 'rspec/its'

require './lib/report'
require './lib/track'
require './lib/indicator'
require './lib/error'

RSpec.describe Lib::Report do
  let(:t1_id) { 'T1' }
  let(:t2_id) { 'T2' }
  let(:rid) { 'R1' }

  let(:i1) { Lib::Indicator.new id: 'I1', track_id: t1_id, score: 50 }
  let(:i2) { Lib::Indicator.new id: 'I2', track_id: t1_id, score: 75 }
  let(:i3) { Lib::Indicator.new id: 'I3', track_id: t1_id, score: 66 }
  let(:i4) { Lib::Indicator.new id: 'I4', track_id: t1_id, score: 23 }

  let(:i5) { Lib::Indicator.new(id: 'I5', track_id: t2_id, score: 33, weight: 5) }
  let(:i6) { Lib::Indicator.new(id: 'I6', track_id: t2_id, score: 57, weight: 2) }
  let(:i7) { Lib::Indicator.new(id: 'I7', track_id: t2_id, score: 90, weight: 3) }
  let(:i8) { Lib::Indicator.new(id: 'I8', track_id: t2_id, score: 48, weight: 4) }

  let(:t1) do
    track = Lib::Track.new id: t1_id, report_id: rid, name: 'Test Track'
    track << i1 << i2 << i3 << i4
  end

  let(:t2) do
    track = Lib::Track.new id: t2_id, report_id: rid, name: 'Test Track'
    track << i5 << i6 << i7 << i8
  end

  let(:report) { Lib::Report.new id: rid }

  describe "Attributes" do
    subject { report << t1 << t2 }
    its(:id) { is_expected.to eq rid }
    its('tracks.length') { is_expected.to eq 2 }
  end

  it "Rejects Track IDs that have already been added to the Report" do
    expect { report << t1 << t1 }.to raise_error Lib::TrackAlreadyAdded
  end

  it "Calculates its overall score as an average of all Tracks" do
    report << t1
    expect(report.score).to eq 53
  end

  it "Considers Indicator weights in the overall score" do
    report << t1 << t2
    expect(report.score).to eq 52
  end
end
