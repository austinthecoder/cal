require 'spec_helper'

describe Cal::Month do

  subject { Cal::Month.new @calendar }

  before do
    @calendar = OpenStruct.new
  end

  describe "name" do
    it "is the name of the month" do
      [
        [Date.parse('2012-01-21'), 'January'],
        [Date.parse('2012-02-21'), 'February']
      ].each do |date, name|
        @calendar.date = date
        subject.name.should == name
      end
    end
  end

end