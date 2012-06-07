# Cal

A low level calendar engine.

[![Build Status](https://secure.travis-ci.org/austinthecoder/cal.png?branch=master)](http://travis-ci.org/austinthecoder/poser)

## Installation

Add this line to your application's Gemfile:

    gem 'cal'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cal

## Usage

### Rails example

``` ruby
# in the controller
- calendar = Cal::MonthlyCalendar.new params[:date]

# in the view
%h3
  = link_to 'Previous month', url_for(:date => calendar.previous.date)
  |
  = calendar.month
  |
  = link_to 'Next month', url_for(:date => calendar.next.date)

%table
  %thead
    %tr
      %th Sunday
      %th Monday
      %th Tuesday
      %th Wednesday
      %th Thursday
      %th Friday
      %th Saturday
  %tbody
    - calendar.weeks.each do |week|
      %tr
        - week.days.each do |day|
          %td{:class => ('today' if day.today?)}
            = day.number
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
