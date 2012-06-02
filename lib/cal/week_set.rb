require 'cal/week'
require 'active_support/time'

module Cal
  class WeekSet

    def initialize(calendar)
      @calendar = calendar
    end

    attr_reader :calendar

    def each
      last_day = calendar.date.end_of_month.end_of_week(:sunday)
      first_day = calendar.date.beginning_of_month.beginning_of_week(:sunday)
      ((last_day - first_day) / 7.0).ceil.times.map do
        yield Week.new(self)
      end
    end

  end
end