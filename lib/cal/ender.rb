require 'active_support/time'
require 'active_support/core_ext/array/grouping'

module Cal
  class Ender

    def initialize(date)
      @date = date
    end

    attr_reader :date

    def ==(other)
      other.is_a?(Ender) && other.date == date
    end

    def month
      @mont ||= Month.new self
    end

    def weeks
      @weeks ||= days.in_groups_of 7
    end

    def days
      @days ||= begin
        day = date.beginning_of_month.beginning_of_week :sunday
        last_day = date.end_of_month.end_of_week :sunday

        days = []
        while day <= last_day
          days << Day.new(self, day)
          day = day.tomorrow
        end
        days
      end
    end

    def week_headings
      @week_headings ||= %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
    end

  end
end