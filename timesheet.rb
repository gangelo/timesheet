# !/usr/bin/env ruby

require 'date'

module Timesheet

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
      puts 'The date entered is invalid' and return unless valid?
      puts rcmt_filename
      puts sandata_filename
    end

    def self.get_date
      date = gets.chomp
      return date unless date.empty?
      return DateTime.now
    end

    def self.get_week_number
      week_number = gets.chomp
      return week_number unless week_number.empty?
      return week_number.to_i
    end

    protected 

    def rcmt_filename
      start_date = nil
      end_date = nil

      start_date_for(@date) do |date| 
        if date.sunday?
          start_date = date
          break
        end 
      end

      end_date_for(@date) do |date| 
        if date.saturday?
          end_date = date
          break
        end 
      end

      "#{@week_number} - RCMT Timesheet - #{format_date(start_date)} thru #{format_date(end_date)}"
    end

    def sandata_filename
      start_date = nil
      end_date = nil

      start_date_for(@date) do |date| 
        if date.saturday?
          start_date = date
          break
        end 
      end

      end_date_for(@date) do |date| 
        if date.friday?
          end_date = date
          break
        end 
      end

      "#{@week_number} - Sandata Timesheet - #{format_date(start_date)} thru #{format_date(end_date)}"
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

    def format_date(date)
      date.strftime('%a %F') if date.respond_to? :strftime
    end
    
    def scrub_date
      begin
        @date = DateTime.parse(@date) unless @date.is_a? DateTime
        @valid = true
      rescue
        @date = DateTime.now
        @valid = false
      end
    end
  end
end

print 'Enter a date (yyyy-mm-dd) that falls within the week starting/ending dates (blank for current date): '
date = Timesheet::Timesheet.get_date

print 'Enter the week number for this timesheet period: '
week_number = Timesheet::Timesheet.get_week_number

timesheet = Timesheet::Timesheet.new date, week_number
timesheet.show

exit 0










