class Oystercard

    attr_reader :balance
    # attr_accessor :state

    MAXIMUM_BALANCE = 90
    MINIMUM_BALANCE = 1

    def initialize
    @state = false
    @balance = 0
    end

    def top_up(amount)
        fail 'maximum balance #{MAXIMUM_BALANCE} exceeded' if @balance + amount > MAXIMUM_BALANCE
        @balance += amount
    end

    def deduct(amount)
        @balance -= amount
    end

    def touch_in
     raise 'minimum balance required' if @balance < MINIMUM_BALANCE
     @state = true
    end

    def touch_out
      @state = false
    end

    def in_journey?
      @state
    end

end
