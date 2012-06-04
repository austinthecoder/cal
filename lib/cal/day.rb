require 'active_support/core_ext/module/delegation'

module Cal
  class Day

    def initialize(calendar, date)
      @calendar = calendar
      @date = date
    end

    attr_reader :calendar, :date

    delegate :today?, :to => :date

    def ==(other)
      other.is_a?(Day) && other.calendar == calendar && other.date == date
    end

    def current?
      date == calendar.current_day
    end

  end
end