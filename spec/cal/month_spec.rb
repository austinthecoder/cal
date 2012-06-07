require 'spec_helper'

describe Cal::Month do

  subject { described_class.new @calendar }

  before { @calendar = OpenStruct.new }

  describe "==" do
    it "is true with another month with the same calendar" do
      (subject == described_class.new(@calendar)).should be_true
    end

    it "is false with another month with a different calendar" do
      (subject == described_class.new(Object.new)).should be_false
    end

    it "is false with a non month" do
      (subject == Object.new).should be_false
    end
  end

  describe "calendar" do
    it "is the given calendar" do
      subject.calendar.should == @calendar
    end
  end

  describe "to_s" do
    before { @calendar.stub(:date) { Date.new 2012, 3 } }
    it { subject.to_s.should == 'March' }
  end

end