module Cal
  class DayName

    class << self
      def all(options = {})
        if options[:start_on]
          sunday_to_saturday.rotate(send(options[:start_on].to_s.downcase.to_sym).position - 1)
        else
          sunday_to_saturday
        end
      end

      def sunday
        @sunday ||= new :sunday, 'Sunday', 1
      end

      def monday
        @monday ||= new :monday, 'Monday', 2
      end

      def tuesday
        @tuesday ||= new :tuesday, 'Tuesday', 3
      end

      def wednesday
        @wednesday ||= new :wednesday, 'Wednesday', 4
      end

      def thursday
        @thursday ||= new :thursday, 'Thursday', 5
      end

      def friday
        @friday ||= new :friday, 'Friday', 6
      end

      def saturday
        @saturday ||= new :saturday, 'Saturday', 7
      end

    private

      def sunday_to_saturday
        @sunday_to_saturday ||= [sunday, monday, tuesday, wednesday, thursday, friday, saturday]
      end
    end

    private_class_method :new

    def initialize(symbol, string, position)
      @to_sym = symbol
      @to_s = string
      @position = position
    end

    attr_reader :to_sym, :to_s, :position

    def succ
      self.class.all.detect do |day_name|
        day_name.position == (position < 7 ? position + 1 : 1)
      end
    end

    alias_method :next, :succ

    def previous
      self.class.all.detect do |day_name|
        day_name.position == (position > 1 ? position - 1 : 7)
      end
    end

  end
end