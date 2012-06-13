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

Cal is a simple calendar structure. It **does not** render a calendar. It **does not** handle events.

See the Rails app [https://github.com/austinthecoder/cal-app](https://github.com/austinthecoder/cal-app) for an example.

### Rails example

``` ruby
# routes
match 'calendar/:month', :to => 'calendars#show'

# controller
calendar = Cal::MonthlyCalendar.from_param params[:month], :start_week_on => :monday

# view
%h3
  = link_to 'Previous month', calendar_path(calendar.previous)
  |
  = "#{calendar.month.to_s "%B"} #{calendar.year}"
  |
  = link_to 'Next month', calendar_path(calendar.next)

%table
  %thead
    %tr
      - calendar.day_names.each do |name|
        %th= name
  %tbody
    - calendar.weeks.each do |week|
      %tr
        - week.each do |day|
          %td{:class => ('today' if day.today?)}
            = day.number
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
