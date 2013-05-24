require 'active_support/core_ext/module/delegation'
require 'active_support/time'

module Cal
  class Day
    include Comparable

    def initialize(date, calendar)
      @date = date
      @calendar = calendar
    end

    attr_reader :calendar, :date

    delegate :today?, :to => :date

    def ==(other)
      other.is_a?(Day) && calendar == other.calendar && date == other.date
    end

    def <=>(other)
      date <=> other.date
    end

    def succ
      self.class.new date.tomorrow, calendar
    end

    def number
      date.day
    end
  end
end