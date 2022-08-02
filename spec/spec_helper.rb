require 'rspec'

Dir['./spec/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
end

# There's probably a better place for this, but I got tired of copying these
RSpec.shared_examples :report_data do
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

  let(:t3) { Lib::Track.new id: t3_id, report_id: r2_id, name: 'Test Track 3' }
  let(:t4) { Lib::Track.new id: t4_id, report_id: r2_id, name: 'Test Track 4' }

  let(:r1) { Lib::Report.new id: r1_id }
  let(:r2) { Lib::Report.new id: r2_id }
end
