module Cal
  class Year

    def initialize(calendar)
      @calendar = calendar
    end

    attr_reader :calendar

    def ==(other)
      other.is_a?(Year) && other.calendar == calendar
    end

    def to_s
      calendar.date.strftime "%Y"
    end

  end
end