# !/usr/bin/env ruby

require 'date'

module Timesheet
  # The timesheet class. Generates my timesheet file names.
  class Timesheet
    attr_reader :date, :week_number

    def initialize(date, week_number)
      @date = date
      @week_number = week_number
      scrub_date
      @date = @date.prev_day if @date.friday?
    end

    def valid?
      @valid
    end

    def show
      puts 'The date entered is invalid' && return unless valid?
      puts rcmt_filename
      puts sandata_filename
    end

    def self.gets_date
      date = gets.chomp
      return date unless date.empty?
      DateTime.now
    end

    def self.gets_week_number
      week_number = gets.chomp
      return week_number unless week_number.empty?
      week_number.to_i
    end

    protected

    def rcmt_filename
      start_date = find_start_date_for(@date, :sunday?)
      end_date = find_end_date_for(@date, :saturday?)

      "#{@week_number} - RCMT Timesheet - " \
        "#{format_date(start_date)} thru " \
          "#{format_date(end_date)}.xls"
    end

    def sandata_filename
      start_date = find_start_date_for(@date, :saturday?)
      end_date = find_end_date_for(@date, :friday?)

      "#{@week_number} - Sandata Timesheet - " \
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
  end
end

print 'Enter a date (yyyy-mm-dd) ' \
  'that falls within the week starting/ending dates (blank for current date): '
date = Timesheet::Timesheet.gets_date

print 'Enter the week number for this timesheet period: '
week_number = Timesheet::Timesheet.gets_week_number

timesheet = Timesheet::Timesheet.new date, week_number
timesheet.show

exit 0










