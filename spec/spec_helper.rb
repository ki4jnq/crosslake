require 'rspec'

Dir['./spec/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
end

#RSpec.shared_examples :indicator_data do
#  let(:tid) { 'T1' }
#  let(:rid) { 'R1' }
#
#  let(:i1) { Lib::Indicator.new id: 'I1', track_id: tid, score: 50 }
#  let(:i2) { Lib::Indicator.new id: 'I2', track_id: tid, score: 75 }
#  let(:i3) { Lib::Indicator.new id: 'I3', track_id: tid, score: 66 }
#  let(:i4) { Lib::Indicator.new id: 'I4', track_id: tid, score: 23 }
#
#  let(:i5) { Lib::Indicator.new(id: 'I5', track_id: tid, score: 33, weight: 5)
#  let(:i6) { Lib::Indicator.new(id: 'I6', track_id: tid, score: 57, weight: 2)
#end
