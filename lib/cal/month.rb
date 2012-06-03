module Cal
  class Month

    def initialize(calendar)
      @calendar = calendar
    end

    attr_reader :calendar

    def name
      calendar.date.strftime "%B"
    end

    alias_method :to_s, :name

  end
end