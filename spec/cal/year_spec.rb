require 'spec_helper'

describe Cal::Year do

  subject { described_class.new @calendar }

  before { @calendar = OpenStruct.new }

  describe "==" do
    it "is true with another year with the same calendar" do
      (subject == described_class.new(@calendar)).should be_true
    end

    it "is false with another year with a different calendar" do
      (subject == described_class.new(Object.new)).should be_false
    end

    it "is false with a non year" do
      (subject == Object.new).should be_false
    end
  end

  describe "calendar" do
    it "is the given calendar" do
      subject.calendar.should == @calendar
    end
  end

  describe "to_s" do
    before { @calendar.date = Date.new 1983 }
    it { subject.to_s.should == '1983' }
  end

end