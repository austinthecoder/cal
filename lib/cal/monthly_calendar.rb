require 'active_support/core_ext/array/grouping'
require 'active_support/core_ext/string/conversions'
require 'active_support/time'
require 'cal/day'
require 'cal/day_name'
require 'cal/month'

module Cal
  class MonthlyCalendar
    include Comparable

    def initialize(year, month_number, options = {})
      @start_week_on = options[:start_week_on] || :sunday
      @month = Month.new year, month_number
    end

    attr_reader :month

    delegate :year, :to => :month

    def <=>(other)
      if other.is_a?(self.class) && start_week_on == other.send(:start_week_on)
        month <=> other.month
      end
    end

    def first_day
      @first_day ||= begin
        date = Date.new(year, month.to_i).beginning_of_month.beginning_of_week(start_week_on)
        Day.new date
      end
    end

    def last_day
      @last_day ||= begin
        date = Date.new(year, month.to_i).end_of_month.end_of_week(start_week_on)
        Day.new date
      end
    end

    def days
      @days ||= first_day..last_day
    end

    def weeks
      @weeks ||= days.to_a.in_groups_of 7
    end

    def previous
      previous_month = month.previous
      self.class.new previous_month.year, previous_month.number, :start_week_on => start_week_on
    end

    def next
      next_month = month.succ
      self.class.new next_month.year, next_month.number, :start_week_on => start_week_on
    end

    def day_names
      @day_names ||= DayName.all :start_on => start_week_on
    end

    private

    attr_reader :start_week_on
  end
end