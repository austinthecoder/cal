require_relative '../../lib/cal/week_set'
require 'ostruct'

describe Cal::WeekSet do

  subject { described_class.new @calendar }

  before do
    @calendar = OpenStruct.new :date => Date.current
  end

  describe "calendar" do
    its(:calendar) { should == @calendar }
  end

  describe "each" do
    describe "the yielded objects" do
      def yielded_objects
        objects = []
        subject.each { |o| objects << o }
        objects
      end

      it "yields the weeks to the block" do
        yielded_objects.all? { |w| w.is_a?(Cal::Week) }.should be_true
      end

      it "all weeks have a reference to the week_set" do
        yielded_objects.all? { |w| w.week_set == subject }.should be_true
      end

      it "size is equal to the number of weeks in the calendar" do
        [
          [Date.parse("2009-02-01"), 4],
          [Date.parse("2012-01-01"), 5],
          [Date.parse("2012-09-01"), 6]
        ].each do |date, size|
          @calendar.date = date
          yielded_objects.size.should == size
        end
      end
    end
  end

end