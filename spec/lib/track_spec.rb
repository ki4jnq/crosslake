require 'rspec'
require 'rspec/its'

require './spec/spec_helper'

require './lib/track'
require './lib/indicator'

RSpec.describe Lib::Track do
  include_examples(:report_data)

  before(:each) do
    t1 << i1 << i2 << i3 << i4
  end

  describe "Attributes" do
    subject { t1 }

    its(:id) { is_expected.to eq t1_id }
    its(:name) { is_expected.to eq 'Test Track 1' }
    its(:report_id) { is_expected.to eq r1_id }
    its('indicators.length') { is_expected.to eq 4 }
  end

  it 'Rejects Indicator IDs that have already been added to the Track' do
    expect { t1 << i1 }.to raise_error Lib::IndicatorAlreadyAdded
  end

  it 'Calculates a score as the average of its indicators' do
    expect(t1.score).to eq(53)
  end

  it 'Considers indicator weights when calculating a score' do
    t1 << Lib::Indicator.new(id: 'I5', track_id: t1_id, score: 33, weight: 5)
    expect(t1.score).to eq(42)

    t1 << Lib::Indicator.new(id: 'I6', track_id: t1_id, score: 57, weight: 2)
    expect(t1.score).to eq(44)
  end
end
