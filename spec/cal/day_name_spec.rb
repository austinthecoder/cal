require 'spec_helper'

describe Cal::DayName do

  describe "class method" do
    subject { described_class }

    describe "all" do
      it "returns all the days, starting with sunday" do
        subject.all.should == [
          subject.sunday,
          subject.monday,
          subject.tuesday,
          subject.wednesday,
          subject.thursday,
          subject.friday,
          subject.saturday
        ]
      end

      it "when given a day name symbol as the :start_on option, it starts the week on that day" do
        subject.all(:start_on => :tuesday).should == [
          subject.tuesday,
          subject.wednesday,
          subject.thursday,
          subject.friday,
          subject.saturday,
          subject.sunday,
          subject.monday
        ]
      end

      it "accepts the :start_on option in various formats" do
        [:tuesday, 'Tuesday', 'tuesday'].each do |start_on|
          subject.all(:start_on => start_on).should == [
            subject.tuesday,
            subject.wednesday,
            subject.thursday,
            subject.friday,
            subject.saturday,
            subject.sunday,
            subject.monday
          ]
        end
      end

      it "without the :start_on option, it returns the same object" do
        subject.all.equal?(subject.all).should be_true
      end
    end

    it "doesn't allow direct initialization" do
      expect { subject.new }.to raise_error NoMethodError
    end
  end

  describe "instance method" do
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
        subject { described_class.send day }

        it "is the same instance as another #{day}" do
          subject.equal?(described_class.send(day)).should be_true
        end

        describe "to_sym" do
          it "is #{day.inspect}" do
            subject.to_sym.should == day
          end
        end

        describe "to_s" do
          it "is #{string.inspect}" do
            subject.to_s.should == string
          end
        end

        describe "position" do
          it "is #{position.inspect}" do
            subject.position.should == position
          end
        end
      end
    end

    describe "succ" do
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
          described_class.send(day).succ.should == described_class.send(next_day)
        end
      end
    end

    describe "next" do
      it "is an alias of #succ" do
        day_name = described_class.friday
        day_name.next.should == day_name.succ
      end
    end

    describe "previous" do
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
          described_class.send(day).previous.should == described_class.send(previous_day)
        end
      end
    end
  end

end