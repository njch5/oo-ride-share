require_relative 'csv_record'
require 'pry'

module RideShare
  class Passenger < CsvRecord
    attr_reader :name, :phone_number, :trips

    def initialize(id:, name:, phone_number:, trips: nil)
      super(id)

      @name = name
      @phone_number = phone_number
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def net_expenditures
      expenditures = 0
      @trips.each do |trip|
        expenditures += trip.cost
      end 
      return expenditures
    end

    private

    # overriding from the CsvRecord class.
    def self.from_csv(record)

      #binding.pry
      
      return new(
        id: record[:id],
        name: record[:name],
        phone_number: record[:phone_num]
      )
    end
  end
end
