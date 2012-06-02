require 'cal/month'
require 'cal/week_set'

module Cal
  class Ender

    def initialize(date)
      @date = date
    end

    attr_reader :date

    def month
      Month.new self
    end

    def weeks
      WeekSet.new self
    end

  end
end