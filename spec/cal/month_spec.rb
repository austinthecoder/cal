require 'spec_helper'
require 'cal/month'

describe Cal::Month do
  before do
    @year = 2012
    @month_number = 3
  end

  describe ".new" do
    it "coerces the year and month number to integers" do
      @year = "2012"
      @month_number = "04"
      Cal::Month.new(@year, @month_number).year.should == 2012
      Cal::Month.new(@year, @month_number).number.should == 4
    end
  end

  it { Cal::Month.new(@year, @month_number).should be_a(Comparable) }

  describe "#<=>" do
    it "is nil with a non month" do
      (Cal::Month.new(@year, @month_number) <=> Object.new).should be_nil
    end

    context "given another month" do
      before { @other = described_class.new @year, @month_number }

      context "when the other's year is the same" do
        it "is 0 when the other's month is the same" do
          (Cal::Month.new(@year, @month_number) <=> @other).should == 0
        end

        it "is -1 when the other's month is higher" do
          @month_number = 2
          (Cal::Month.new(@year, @month_number) <=> @other).should == -1
        end

        it "is 1 when the other's month is lower" do
          @month_number = 4
          (Cal::Month.new(@year, @month_number) <=> @other).should == 1
        end
      end

      it "is -1 when the other's year is higher" do
        @year = 2011
        (Cal::Month.new(@year, @month_number) <=> @other).should == -1
      end

      it "is 1 when the other's year is lower" do
        @year = 2013
        (Cal::Month.new(@year, @month_number) <=> @other).should == 1
      end
    end
  end

  describe "#==" do
    it "is false with a non month" do
      (Cal::Month.new(@year, @month_number) == Object.new).should be_false
    end

    context "given another month" do
      before { @month = described_class.new @year, @month_number }

      it "is true if the comparison is zero" do
        month = Cal::Month.new(@year, @month_number)
        month.stub(:<=>) { 0 }
        (month == @month).should be_true
      end

      it "is false if the comparison is not zero" do
        month = Cal::Month.new(@year, @month_number)
        month.stub(:<=>) { -1 }
        (month == @month).should be_false
      end
    end
  end

  it { Cal::Month.new(@year, @month_number).number.should == @month_number }

  describe "#to_s" do
    it "is the year and month" do
      Cal::Month.new(2013, 11).to_s.should == '2013-11'
    end
  end

  describe "#year" do
    it "is the given year" do
      Cal::Month.new(@year, @month_number).year.should == 2012
    end
  end

  describe "#succ" do
    [[2012, 12, 2013, 1], [2012, 1, 2012, 2]].each do |year, month_number, new_year, new_month_number|
      it "is the next month" do
        @year = year
        @month_number = month_number
        Cal::Month.new(@year, @month_number).succ.should == described_class.new(new_year, new_month_number)
      end
    end
  end

  describe "#previous" do
    [[2012, 12, 2012, 11], [2012, 1, 2011, 12]].each do |year, month_number, new_year, new_month_number|
      it "is the previous month" do
        @year = year
        @month_number = month_number
        Cal::Month.new(@year, @month_number).previous.should == described_class.new(new_year, new_month_number)
      end
    end
  end

  describe "#to_month" do
    it { Cal::Month.new(@year, @month_number).to_month.should == Cal::Month.new(@year, @month_number) }
  end
end