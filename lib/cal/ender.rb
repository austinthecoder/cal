require 'active_support/time'
require 'active_support/core_ext/array/grouping'

module Cal
  class Ender

    MONTHS = {
      1 => 'January',
      2 => 'February',
      3 => 'March',
      4 => 'April',
      5 => 'May',
      6 => 'June',
      7 => 'July',
      8 => 'August',
      9 => 'September',
      10 => 'October',
      11 => 'November',
      12 => 'December'
    }

    def initialize(options = {})
      options = {:format => :monthly}.merge options

      if options[:format] != :monthly
        raise ArgumentError, "only supported format currently is :monthly"
      end

      @month = if options.key? :month
        raise ArgumentError, "Unrecognized month" unless MONTHS.values.include?(options[:month])
        options[:month]
      end

      @current_day = if options.key? :current_day
        options[:current_day]
      end

      if month
        raise ArgumentError, "Either provide the current_day or don't provide the month" unless current_day
      else
        @current_day = Date.current unless current_day
        @month = current_day.strftime "%B"
      end

      d = Date.parse "#{current_day.year}-#{MONTHS.key @month}-01"
      @first_day = d.beginning_of_month.beginning_of_week :sunday
      @last_day = d.end_of_month.end_of_week :sunday

      if current_day < @first_day || current_day > @last_day
        raise ArgumentError, "Current day is outside of view"
      end

      @format = options[:format]
    end

    attr_reader :current_day, :format, :month

    def ==(other)
      other.is_a?(Ender) && other.format == format && other.month == month && other.current_day == current_day
    end

    def weeks
      @weeks ||= days.in_groups_of 7
    end

    def days
      @days ||= dates.map { |date| Day.new self, date }
    end

    def week_headings
      @week_headings ||= %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
    end

  private

    def dates
      @dates ||= [].tap do |dates|
        day = @first_day

        while day <= @last_day
          dates << day
          day = day.tomorrow
        end
      end
    end

  end
end