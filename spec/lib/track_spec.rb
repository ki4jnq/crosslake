require 'rspec'
require 'rspec/its'

require './lib/track'
require './lib/indicator'

RSpec.describe Lib::Track do
  let(:tid) { 'T1' }
  let(:rid) { 'R1' }

  let(:i1) { Lib::Indicator.new id: 'I1', track_id: tid, score: 50 }
  let(:i2) { Lib::Indicator.new id: 'I2', track_id: tid, score: 75 }
  let(:i3) { Lib::Indicator.new id: 'I3', track_id: tid, score: 66 }
  let(:i4) { Lib::Indicator.new id: 'I4', track_id: tid, score: 23 }

  let(:track) do
    track = Lib::Track.new id: tid, report_id: rid, name: 'Test Track'
    track << i1 << i2 << i3 << i4
  end

  describe "Attributes" do
    subject { track }

    its(:id) { is_expected.to eq tid }
    its(:name) { is_expected.to eq 'Test Track' }
    its(:report_id) { is_expected.to eq rid }
    its('indicators.length') { is_expected.to eq 4 }
  end

  it 'Rejects Indicator IDs that have already been added to the Track' do
    expect { track << i1 }.to raise_error Lib::IndicatorAlreadyAdded
  end

  it 'Calculates a score as the average of its indicators' do
    expect(track.score).to eq(53)
  end

  it 'Considers indicator weights when calculating a score' do
    track << Lib::Indicator.new(id: 'I5', track_id: tid, score: 33, weight: 5)
    expect(track.score).to eq(42)

    track << Lib::Indicator.new(id: 'I6', track_id: tid, score: 57, weight: 2)
    expect(track.score).to eq(44)
  end
end
