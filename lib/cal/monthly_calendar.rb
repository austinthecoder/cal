require 'active_support/core_ext/array/grouping'
require 'active_support/core_ext/string/conversions'

module Cal
  class MonthlyCalendar

    def initialize(dateable, options = {})
      options = options.reverse_merge :start_week_on => :sunday
      @date = dateable.to_date
      @options = options
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

    def first_day
      @first_day ||= Day.new date.beginning_of_month.beginning_of_week(@options[:start_week_on]), self
    end

    def last_day
      @last_day ||= Day.new date.end_of_month.end_of_week(@options[:start_week_on]), self
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

  end
end