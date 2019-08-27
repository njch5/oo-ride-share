require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :trips
    attr_accessor :status

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      valid_statuses = [:AVAILABLE, :UNAVAILABLE]

      @name = name
      if vin.length != 17
        raise ArgumentError, "The length of VIN must be at least 17"
      else
        @vin = vin
      end

      if valid_statuses.include?(status)
        @status = status
      else
        raise ArgumentError, "Invalid status!"
      end

      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
    end

    private

    def self.from_csv(record)
      return new(
               id: record[:id],
               name: record[:name],
               vin: record[:vin],
               status: record[:status].to_sym,
             )
    end
  end
end
