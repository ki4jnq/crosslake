require 'rspec'
require './lib/indicator'

RSpec.describe Lib::Indicator do
  let(:unweighted) { Lib::Indicator.new id: 'I1', track_id: 'T1', score: 50 }
  let(:weighted) { Lib::Indicator.new id: 'I1', track_id: 'T1', score: 75, weight: 3 }

  it "is expected to calculate its weighted_score as score*weight" do
    expect(unweighted.weighted_score).to eq 50
    expect(weighted.weighted_score).to eq 225
  end
end
