require 'active_support/core_ext/module/delegation'
require 'active_support/time'
require 'cal/month'

module Cal
  class Day
    include Comparable

    def initialize(date)
      @date = date
    end

    attr_reader :date

    delegate :today?, :to => :date

    def ==(other)
      other.is_a?(self.class) && date == other.date
    end

    def <=>(other)
      date <=> other.date
    end

    def succ
      self.class.new date.tomorrow
    end

    def number
      date.day
    end

    def month
      @month ||= Cal::Month.new date.year, date.month
    end
  end
end