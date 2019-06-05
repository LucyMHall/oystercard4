require 'oystercard'

describe Oystercard do

  before(:each) do
    subject.top_up(Oystercard::MINIMUM_BALANCE)
    @station = "Euston"
  end

  describe '#initialize' do

    it "card has a balance" do
      oystercard = Oystercard.new
      expect(oystercard.balance).to eq(0)
    end

  end

  describe '#top_up' do

    # it { is_expected.to respond_to(:top_up).with(1).argument }

    it 'can top up the balance' do
        expect{ subject.top_up 1 }.to change{ subject.balance }.by 1
    end

    it "to raise an error if the maximum balance is exceeded" do
        oystercard = Oystercard.new
        maximum_balance = Oystercard::MAXIMUM_BALANCE
        oystercard.top_up(maximum_balance)
        expect{ oystercard.top_up 1 }.to raise_error 'maximum balance #{MAXIMUM_BALANCE} exceeded'
    end

  describe '#touch_in' do

    it 'requires a minimum balance' do
      oystercard = Oystercard.new
      expect { oystercard.touch_in(@station)}.to raise_error 'minimum balance required'
    end

    it 'records an entry station' do
        subject.touch_in(@station)
        expect(subject.entry_station).to eq(@station)
    end
  end

  describe '#touch_out' do
    it 'resets entry station to nil' do
      subject.touch_in(@station)
      subject.touch_out
      expect(subject.entry_station).to eq nil
    end

    #it { is_expected.to respond_to(:deduct).with(1).argument } ....now we cannot access it because the method became private

    # it "card touch out, card status not in use" do
      # subject.touch_out
      # expect(subject.state).to eq false
    # end

    it 'card touch out, fare deducted' do
      subject.touch_in(@station)
      expect{subject.touch_out}.to change {subject.balance}.by(-Oystercard::FARE)
    end

  end

  describe "#in_journey" do

    it "card touches in and we are in journey" do
        subject.touch_in(@station)
        expect(subject.in_journey?).to be true
    end

    it "card touches out and we are in journey" do
        subject.touch_out
        expect(subject.in_journey?).to be false
    end

  end



end
end
