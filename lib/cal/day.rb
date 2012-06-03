module Cal
  class Day

    def initialize(calendar, date)
      @calendar = calendar
      @date = date
    end

    attr_reader :calendar, :date

    def ==(other)
      other.is_a?(Day) && other.calendar == calendar && other.date == date
    end

  end
end