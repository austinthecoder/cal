require 'spec_helper'

describe Cal::Month do

  subject { described_class.new @calendar }

  before do
    @calendar = OpenStruct.new :date => Date.new(2012, 3, 13)
  end

  describe "==" do
    it "is true with a Cal::Month with the same calendar" do
      subject.should == described_class.new(@calendar)
    end

    it "is false with a Cal::Month with a different calendar" do
      subject.should_not == described_class.new(Object.new)
    end

    it "is false with a non-Cal::Month" do
      subject.should_not == Object.new
    end
  end

  describe "calendar" do
    it "is the given calendar" do
      subject.calendar.should == @calendar
    end
  end

  describe "to_s" do
    it { subject.to_s.should == 'March' }
  end

end