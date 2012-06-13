module Cal
  class Month

    include Comparable

    def initialize(year, number)
      @year = year.to_i
      @number = number.to_i
    end

    attr_reader :year, :number

    alias_method :to_i, :number

    def <=>(other)
      date <=> other.send(:date) if other.is_a?(self.class)
    end

    def to_s(*args)
      date.strftime *args
    end

    def succ
      self.class.new *(number == 12 ? [(year + 1), 1] : [year, (number + 1)])
    end

    def previous
      self.class.new *(number == 1 ? [(year - 1), 12] : [year, (number - 1)])
    end

    def to_month
      self
    end

  private

    def date
      @date ||= Date.new year, number
    end

  end
end