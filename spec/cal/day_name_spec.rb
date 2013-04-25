require 'spec_helper'

describe Cal::DayName do
  describe ".all" do
    it "returns all the days, starting with sunday" do
      Cal::DayName.all.should == [
        Cal::DayName.sunday,
        Cal::DayName.monday,
        Cal::DayName.tuesday,
        Cal::DayName.wednesday,
        Cal::DayName.thursday,
        Cal::DayName.friday,
        Cal::DayName.saturday
      ]
    end

    it "when given a day name symbol as the :start_on option, it starts the week on that day" do
      Cal::DayName.all(:start_on => :tuesday).should == [
        Cal::DayName.tuesday,
        Cal::DayName.wednesday,
        Cal::DayName.thursday,
        Cal::DayName.friday,
        Cal::DayName.saturday,
        Cal::DayName.sunday,
        Cal::DayName.monday
      ]
    end

    it "accepts the :start_on option in various formats" do
      [:tuesday, 'Tuesday', 'tuesday'].each do |start_on|
        Cal::DayName.all(:start_on => start_on).should == [
          Cal::DayName.tuesday,
          Cal::DayName.wednesday,
          Cal::DayName.thursday,
          Cal::DayName.friday,
          Cal::DayName.saturday,
          Cal::DayName.sunday,
          Cal::DayName.monday
        ]
      end
    end

    it "without the :start_on option, it returns the same object" do
      Cal::DayName.all.equal?(Cal::DayName.all).should be_true
    end
  end

  it "doesn't allow direct initialization" do
    expect { Cal::DayName.new }.to raise_error NoMethodError
  end

  [
    [:sunday, 'Sunday', 1],
    [:monday, 'Monday', 2],
    [:tuesday, 'Tuesday', 3],
    [:wednesday, 'Wednesday', 4],
    [:thursday, 'Thursday', 5],
    [:friday, 'Friday', 6],
    [:saturday, 'Saturday', 7]
  ].each do |day, string, position|
    context "when the day is #{day}" do
      it "is the same instance as another #{day}" do
        Cal::DayName.send(day).equal?(Cal::DayName.send(day)).should be_true
      end

      describe "to_sym" do
        it "is #{day.inspect}" do
          Cal::DayName.send(day).to_sym.should == day
        end
      end

      describe "to_s" do
        it "is #{string.inspect}" do
          Cal::DayName.send(day).to_s.should == string
        end
      end

      describe "position" do
        it "is #{position.inspect}" do
          Cal::DayName.send(day).position.should == position
        end
      end
    end
  end

  describe "#succ" do
    [
      [:sunday, :monday],
      [:monday, :tuesday],
      [:tuesday, :wednesday],
      [:wednesday, :thursday],
      [:thursday, :friday],
      [:friday, :saturday],
      [:saturday, :sunday]
    ].each do |day, next_day|
      it "is #{next_day} when the say is #{day}" do
        Cal::DayName.send(day).succ.should == Cal::DayName.send(next_day)
      end
    end
  end

  describe "#next" do
    it "is an alias of #succ" do
      day_name = Cal::DayName.friday
      day_name.next.should == day_name.succ
    end
  end

  describe "#previous" do
    [
      [:sunday, :saturday],
      [:monday, :sunday],
      [:tuesday, :monday],
      [:wednesday, :tuesday],
      [:thursday, :wednesday],
      [:friday, :thursday],
      [:saturday, :friday]
    ].each do |day, previous_day|
      it "is #{previous_day} when the say is #{day}" do
        Cal::DayName.send(day).previous.should == Cal::DayName.send(previous_day)
      end
    end
  end
end