require 'spec_helper'

describe Cal do
  describe ".new_monthly_calendar" do
    it "creates a new monthly calendar with the given args" do
      @args = [1, 2, 3]
      monthly_calendar = Object.new
      Cal::MonthlyCalendar.stub :new do |*args|
        monthly_calendar if args == @args
      end
      Cal.new_monthly_calendar(*@args).should == monthly_calendar
    end
  end
end