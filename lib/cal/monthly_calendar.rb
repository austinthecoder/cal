require 'active_support/core_ext/array/grouping'
require 'active_support/core_ext/string/conversions'

module Cal
  class MonthlyCalendar

    DAY_NAMES = {
      :sunday => 0,
      :monday => 1,
      :tuesday => 2,
      :wednesday => 3,
      :thursday => 4,
      :friday => 5,
      :saturday => 6
    }

    def initialize(dateable, options = {})
      @date = dateable.to_date
      @start_week_on = options[:start_week_on] || :sunday
      @month = Month.new self
      @year = Year.new self
    end

    attr_reader :date, :month, :year

    def ==(other)
      other.is_a?(MonthlyCalendar) &&
        other.date.year == date.year &&
        other.date.month == date.month
    end

    def first_day
      @first_day ||= Day.new date.beginning_of_month.beginning_of_week(@start_week_on), self
    end

    def last_day
      @last_day ||= Day.new date.end_of_month.end_of_week(@start_week_on), self
    end

    def days
      @days ||= first_day..last_day
    end

    def weeks
      @weeks ||= days.to_a.in_groups_of 7
    end

    def previous
      self.class.new date.prev_month
    end

    def next
      self.class.new date.next_month
    end

    def day_names
      %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday].rotate DAY_NAMES[@start_week_on]
    end

  end
end