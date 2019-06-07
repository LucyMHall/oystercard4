require 'oystercard'

describe Oystercard do

  before(:each) do
    subject.top_up(Oystercard::MINIMUM_BALANCE)
    @entry_station = double("station")
    @exit_station = double("station")
    @journey = double("journey", entry_station: @entry_station, exit_station: @exit_station)
  end

  describe '#initialize' do

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

  end

  describe '#touch_out' do
    it 'resets entry station to nil' do
      subject.touch_in(@entry_station)
      subject.touch_out(@exit_station)
      expect(subject.entry_station).to eq nil
    end

    it 'deducts the minimum fare' do
      subject.touch_in(@entry_station)
      subject.touch_out(@exit_station)
      expect{subject.touch_out(@exit_station)}.to change {subject.balance}.by(-Oystercard::MINIMUM_BALANCE)
    end

    it 'deducts 6 if the journey is incomplete' do
      subject.touch_in(@entry_station)
      expect{subject.touch_out(@exit_station)}.to change {subject.balance}.by(-Oystercard::PENALTY_FARE)
    end
  end

  describe "#in_journey" do

    it "card touches in and we are in journey" do
        subject.touch_in(@entry_station)
        expect(subject.in_journey?).to be true
    end

  end

  describe "#view_past_journeys" do

    it "returns your previoUs journeys" do
      subject.touch_in(@entry_station)
      subject.touch_out(@exit_station)
      expect{subject.view_past_journeys}.to output("#{@entry_station} to #{@exit_station}").to_stdout
    end
  end



end
