require 'active_support/core_ext/module/delegation'

module Cal
  class Day

    def initialize(date, calendar)
      @date = date
      @calendar = calendar
    end

    attr_reader :calendar, :date

    delegate :today?, :to => :date

    def ==(other)
      other.is_a?(Day) && other.calendar == calendar && other.date == date
    end

    def number
      date.day
    end

  end
end