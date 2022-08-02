require 'rspec'
require 'rspec/its'

require './spec/spec_helper'

require './lib/report'
require './lib/track'
require './lib/indicator'
require './lib/error'

RSpec.describe Lib::Report do
  include_examples(:report_data)

  before :each do
    t1 << i1 << i2 << i3 << i4
    t2 << i5 << i6 << i7 << i8
  end

  let(:report) { Lib::Report.new id: r1_id }

  describe "Attributes" do
    subject { report << t1 << t2 }
    its(:id) { is_expected.to eq r1_id }
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
