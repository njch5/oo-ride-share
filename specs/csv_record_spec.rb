require_relative 'spec_helper'

describe RideShare::CsvRecord do
  describe 'constructor' do
    it 'takes and saves an id' do
      id = 7
      record = RideShare::CsvRecord.new(id)
      expect(record.id).must_equal id
    end

    it 'validates the ID' do
      id = -7
      expect {
        RideShare::CsvRecord.new(id)
      }.must_raise ArgumentError
    end
  end

  describe 'load_all' do
    it "raises an error if neither full_path nor directory is provided" do
      expect {
        RideShare::CsvRecord.load_all
      }.must_raise ArgumentError
    end

    it "raises an error if invoked directly (without subclassing)" do
      full_path = 'specs/test_data/testrecords.csv'
      expect {
        RideShare::CsvRecord.load_all(full_path: full_path)
      }.must_raise NotImplementedError
    end
  end

  describe 'validate_id' do
    it 'accepts natural numbers' do
      # Should not raise
      [1, 10, 9999].each do |id|
        RideShare::CsvRecord.validate_id(id)
      end
    end

    it 'raises for negative numbers and 0' do
      [0, -1, -10, -9999].each do |id|
        expect {
          RideShare::CsvRecord.validate_id(id)
        }.must_raise ArgumentError
      end
    end

    it 'raises for nil' do
      expect {
        RideShare::CsvRecord.validate_id(nil)
      }.must_raise ArgumentError
    end
  end

  describe 'extension' do
    class TestRecord < RideShare::CsvRecord
      attr_reader :name
      def initialize(id:, name:)
        super(id)
        @name = name
      end

      def self.from_csv(record)
        new(**record)
      end
    end

    describe 'load_all' do
      it 'finds data given a directory' do
        directory = 'specs/test_data'
        records = TestRecord.load_all(directory: directory)

        expect(records.length).must_equal 2
      end

      it 'finds data given a directory and filename' do
        directory = 'specs/test_data'
        file_name = 'custom_filename_test.csv'
        records = TestRecord.load_all(directory: directory, file_name: file_name)

        expect(records.length).must_equal 2
      end

      it 'finds data given a full path' do
        path = 'specs/test_data/custom_filename_test.csv'
        records = TestRecord.load_all(full_path: path)

        expect(records.length).must_equal 2
      end
    end
  end
end