require 'csv'
require 'time'

require 'pry'

module RideShare
  class CsvRecord
    attr_reader :id

    def initialize(id)
      self.class.validate_id(id)
      @id = id
    end
    
    def self.load_all(file_name=nil)
      # TODO DPR: make this less fancy
      unless file_name
        class_name = self.class.to_s.split('::').last
        file_name = class_name.downcase + 's.csv'
      end

      return CSV.read(file_name, headers: true, header_converters: :symbol, converters: :numeric).map do |record|
        self.from_csv(record)
      end
    end

    def self.validate_id(id)
      if id.nil? || id <= 0
        raise ArgumentError, 'ID cannot be blank or less than zero.'
      end
    end

    private
    def self.from_csv
      raise NotImplementedError, 'Implement me in a child class!'
    end
  end
end