require "station"

RSpec.describe Station do

  describe '#intialise' do
    it 'stores the station name it is passed' do
      station = Station.new("Euston", "zone 1")
      expect(station.name).to eq("Euston")
    end
    it 'stores the zone it is passed' do
      station = Station.new("Euston", "zone 1")
      expect(station.zone).to eq("zone 1")
    end
  end

end
