require 'rspec'

require './spec/spec_helper'
require './lib/indicator'

RSpec.describe Lib::Indicator do
  include_examples(:report_data)

  let(:unweighted) { i1 }
  let(:weighted) { i5 }

  it "is expected to calculate its weighted_score as score*weight" do
    expect(unweighted.weighted_score).to eq 50
    expect(weighted.weighted_score).to eq 165
  end
end
