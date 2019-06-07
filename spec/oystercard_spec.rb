require 'oystercard'

describe Oystercard do

  before(:each) do
    subject.top_up(Oystercard::MINIMUM_BALANCE)
    @entry_station = double("station")
    @exit_station = double("station")
  end

  describe '#initialize' do

    it "card has a balance" do
      oystercard = Oystercard.new
      expect(oystercard.balance).to eq(0)
    end

    it "has a empty list of journeys by default" do
      expect(subject.list_of_journeys).to eq([])
    end

  end

  describe '#top_up' do

    it 'can top up the balance' do
        expect{ subject.top_up(Oystercard::MINIMUM_BALANCE) }.to change{ subject.balance }.by (Oystercard::MINIMUM_BALANCE)
    end

    it "to raise an error if the maximum balance is exceeded" do
        oystercard = Oystercard.new
        maximum_balance = Oystercard::MAXIMUM_BALANCE
        oystercard.top_up(maximum_balance)
        expect{ oystercard.top_up 1 }.to raise_error 'maximum balance #{MAXIMUM_BALANCE} exceeded'
    end
  end

  describe '#touch_in' do

    it 'requires a minimum balance' do
      oystercard = Oystercard.new
      expect { oystercard.touch_in(@entry_station)}.to raise_error 'minimum balance required'
    end

    it 'records an entry station' do
      subject.touch_in(@entry_station)
      expect(subject.entry_station).to eq(@entry_station)
    end
  end

  describe '#touch_out' do
    it 'resets entry station to nil' do
      subject.touch_in(@entry_station)
      subject.touch_out(@exit_station)
      expect(subject.entry_station).to eq nil
    end

    it 'it deducts the minimum fare' do
      subject.touch_in(@entry_station)
      expect{subject.touch_out(@exit_station)}.to change {subject.balance}.by(-Oystercard::MINIMUM_BALANCE)
    end

    it "records an exit station" do
      subject.touch_out(@exit_station)
      expect(subject.exit_station).to eq(@exit_station)
    end

  end

  describe "#in_journey" do

    it "card touches in and we are in journey" do
        subject.touch_in(@entry_station)
        expect(subject.in_journey?).to be true
    end

    it "card touches out and we are in journey" do
        subject.touch_out(@exit_station)
        expect(subject.in_journey?).to be false
    end

  end

  describe '#journey_log' do

    it 'tells you your previous journeys' do
      subject.touch_in(@entry_station)
      subject.touch_out(@exit_station)
      expect{subject.journey_log}.to output("#{@entry_station} to #{@exit_station}").to_stdout
    end

    it "touching in and out creates one journey" do
      subject.touch_in(@entry_station)
      subject.touch_out(@exit_station)
      expect(subject.journey_log.length).to eq(1)
    end
  end


end
