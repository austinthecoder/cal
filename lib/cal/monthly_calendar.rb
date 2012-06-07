require 'active_support/time'
require 'active_support/core_ext/array/grouping'
require 'active_support/core_ext/string/conversions'

module Cal
  class MonthlyCalendar

    def initialize(dateable)
      @date = dateable.to_date
    end

    attr_reader :date

    def ==(other)
      other.is_a?(MonthlyCalendar) &&
        other.date.year == date.year &&
        other.date.month == date.month
    end

    def month
      @month ||= Month.new self
    end

    def days
      @days ||= dates.map { |date| Day.new self, date }
    end

    def weeks
      @weeks ||= days.in_groups_of 7
    end

    def previous
      self.class.new date.prev_month
    end

    def next
      self.class.new date.next_month
    end

  private

    # TODO: simplify/improve this
    def dates
      [].tap do |dates|
        day = date.beginning_of_month.beginning_of_week :sunday
        last_day = date.end_of_month.end_of_week :sunday

        while day <= last_day
          dates << day
          day = day.tomorrow
        end
      end
    end

  end
end