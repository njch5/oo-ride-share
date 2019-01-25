require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(driver_file: nil, passenger_file: nil, trip_file: nil)
      @passengers = Passenger.load_all(passenger_file)
      @trips = Trip.load_all(trip_file)
      connect_trips()
    end

    def connect_trips()
      @trips.each do |trip|
        driver = nil # find_driver(trip.driver_id)
        passenger = find_passenger(trip.passenger_id)
        trip.connect(driver, passenger)
      end

      return trips
    end

    def find_passenger(id)
      CsvRecord.validate_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end

    def inspect
      return "#<#{self.class.name}:0x#{self.object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end
  end
end
