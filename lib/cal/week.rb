module Cal
  class Week
    def initialize(week_set)
      @week_set = week_set
    end

    attr_reader :week_set
  end
end