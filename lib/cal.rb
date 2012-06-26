require "cal/version"
require 'active_support/time'

module Cal

  autoload :MonthlyCalendar, 'cal/monthly_calendar'
  autoload :Day, 'cal/day'
  autoload :Month, 'cal/month'
  autoload :DayName, 'cal/day_name'

  class << self
    def new_monthly_calendar(*args)
      MonthlyCalendar.new *args
    end
  end

end
