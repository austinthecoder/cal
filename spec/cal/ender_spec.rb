require_relative '../../lib/cal/ender'

describe Cal::Ender do
  subject { Cal::Ender.new @date }

  before do
    @date = Date.parse("2012-01-23")
  end

  describe "date" do
    it "is the date given" do
      subject.date.should == @date
    end
  end

  describe "month" do
    it "is a month" do
      subject.month.should be_a(Cal::Month)
    end

    it "has a reference to the calendar" do
      subject.month.calendar.should == subject
    end
  end

  describe "weeks" do
    it "is a set of weeks" do
      subject.weeks.should be_a(Cal::WeekSet)
    end

    it "has a reference to the calendar" do
      subject.weeks.calendar.should == subject
    end
  end

end