module Cal
  class Month

    def initialize(calendar)
      @calendar = calendar
    end

    attr_reader :calendar

    def ==(other)
      other.is_a?(Month) && other.calendar == calendar
    end

    def to_s
      calendar.date.strftime "%B"
    end

  end
end