require 'cal/monthly_calendar'

module Cal
  def self.new_monthly_calendar(*args)
    MonthlyCalendar.new *args
  end
end