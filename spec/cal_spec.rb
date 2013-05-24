require 'spec_helper'
require 'cal'

describe Cal do
  describe ".new_monthly_calendar" do
    it "is delegated to MonthlyCalendar.new" do
      monthly_calendar = Object.new
      Cal::MonthlyCalendar.stub(:new).with(1, 2, 3) { monthly_calendar }
      Cal.new_monthly_calendar(1, 2, 3).should == monthly_calendar
    end
  end
end