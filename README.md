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
- calendar = Cal::Ender.new

%table
  %thead
    %tr
      - calendar.week_headings.each do |heading|
        %th= heading
  %tbody
    - calendar.weeks.each do |week|
      %tr
        - week.days.each do |day|
          %td{:class => ('current' if day.current?)}
            = day.number
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
