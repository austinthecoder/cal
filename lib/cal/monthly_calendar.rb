require 'active_support/core_ext/array/grouping'
require 'active_support/core_ext/string/conversions'

module Cal
  class MonthlyCalendar

    include Comparable

    DAY_NAMES = {
      :sunday => 0,
      :monday => 1,
      :tuesday => 2,
      :wednesday => 3,
      :thursday => 4,
      :friday => 5,
      :saturday => 6
    }

    class << self
      def from_month(month, options = {})
        month = month.to_month
        new month.year, month.number, options
      end

      def from_param(param)
        year, month_number = if param.present?
          param.split '-'
        else
          now = Date.current
          [now.year, now.month]
        end
        new year, month_number
      end
    end

    def initialize(year, month_number, options = {})
      @start_week_on = options[:start_week_on] || :sunday
      @month = Month.new year, month_number
    end

    attr_reader :month

    delegate :year, :to => :month

    def <=>(other)
      if other.is_a?(MonthlyCalendar) && start_week_on == other.send(:start_week_on)
        month <=> other.month
      end
    end

    def first_day
      @first_day ||= begin
        date = Date.new(year, month.to_i).beginning_of_month.beginning_of_week(start_week_on)
        Day.new date, self
      end
    end

    def last_day
      @last_day ||= begin
        date = Date.new(year, month.to_i).end_of_month.end_of_week(start_week_on)
        Day.new date, self
      end
    end

    def days
      @days ||= first_day..last_day
    end

    def weeks
      @weeks ||= days.to_a.in_groups_of 7
    end

    def previous
      self.class.from_month month.previous, :start_week_on => start_week_on
    end

    def next
      self.class.from_month month.succ, :start_week_on => start_week_on
    end

    def day_names
      %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday].rotate DAY_NAMES[start_week_on]
    end

    def to_param
      "#{year}-#{month.to_i}"
    end

  private

    attr_reader :start_week_on

  end
end