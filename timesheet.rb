# !/usr/bin/env ruby

require 'date'

module Timesheet
  # The timesheet class. Generates my timesheet file names.
  class Timesheet
    attr_reader :date

    def initialize(date)
      @date = date
      scrub_date
      @date = @date.prev_day if @date.friday?
    end

    def valid?
      @valid
    end

    def show
      puts 'The date entered is invalid' && return unless valid?
      puts mw_invoice_number
      puts mw_filename
      puts sandata_filename
    end

    def self.gets_date
      date = gets.chomp
      return date unless date.empty?
      DateTime.now
    end

    protected

    def mw_invoice_number
      start_date = find_start_date_for(@date, :saturday?)
      end_date = find_end_date_for(@date, :friday?)

      "Mohojo Werks Invoice Number: #{calendar_week_full}"
    end

    def mw_filename
      start_date = find_start_date_for(@date, :saturday?)
      end_date = find_end_date_for(@date, :friday?)

      "#{calendar_week_full} - Mohojo Werks Invoice for " \
        "#{format_date(start_date)} thru " \
          "#{format_date(end_date)}.xlsx"
    end

    def sandata_filename
      start_date = find_start_date_for(@date, :saturday?)
      end_date = find_end_date_for(@date, :friday?)

      "#{calendar_week_full} - Sandata Timesheet for " \
        "#{format_date(start_date)} thru " \
          "#{format_date(end_date)}.png"
    end

    def start_date_for(date)
      throw 'Block is required' unless block_given?
      start_date = date
      loop do
        start_date = start_date.prev_day
        yield start_date
      end
    end

    def end_date_for(date)
      throw 'Block is required' unless block_given?
      end_date = date
      loop do
        end_date = end_date.next_day
        yield end_date
      end
    end

     def find_start_date_for(start_date, eval)
      start_date_for(start_date) do |date|
        if date.instance_eval eval.to_s
          return date
        end
      end
    end

    def find_end_date_for(end_date, eval)
      end_date_for(end_date) do |date|
        if date.instance_eval eval.to_s
          return date
        end
      end
    end

    def format_date(date)
      date.strftime('%a %F') if date.respond_to? :strftime
    end

    def scrub_date
      begin
        @date = DateTime.parse(@date) unless @date.is_a? DateTime
        @valid = true
      rescue ArgumentError => e
        puts "Error parsing input date: #{e.message}"
        @date = DateTime.now
        @valid = false
      end
    end

    def calendar_week_full
      "#{@date.cwyear}-#{formated_calendar_week}"
    end

    def formated_calendar_week
      "%02d" % @date.cweek
    end
  end
end

print 'Enter a date (yyyy-mm-dd) ' \
  'that falls within the week starting/ending dates (blank for current date): '
date = Timesheet::Timesheet.gets_date

timesheet = Timesheet::Timesheet.new date
timesheet.show

exit 0










