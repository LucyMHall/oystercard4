
class Oystercard

    attr_reader :balance, :entry_station, :exit_station, :journey, :list_of_journeys

    MAXIMUM_BALANCE = 90
    MINIMUM_BALANCE = 1
    PENALTY_FARE = 6

    def initialize
      @balance = 0
      @list_of_journeys = []
    end

    def top_up(amount)
        fail 'maximum balance #{MAXIMUM_BALANCE} exceeded' if @balance + amount > MAXIMUM_BALANCE
        @balance += amount
    end

    def touch_in(entry_station, journey= Journey.new)
      raise 'minimum balance required' if @balance < MINIMUM_BALANCE
      @journey = journey
      @journey.reset_current_journey
      @journey.start_journey(entry_station)
    end

    def touch_out(exit_station)
      !@journey.journey_complete?  ? deduct(PENALTY_FARE) : deduct(MINIMUM_BALANCE)
      @journey.end_journey(exit_station)
    end

    def in_journey?
      !@journey.entry_station.nil?
    end

    def view_past_journeys
      @list_of_journeys << @journey.current_journey
      @list_of_journeys.each do |index|
       print "#{index["entry station"]} to #{index["exit station"]}"
      end
    end

    private

    def deduct(amount)
        @balance -= amount
    end

end
