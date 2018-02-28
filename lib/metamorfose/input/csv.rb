require 'csv'

module Metamorfose
  module Input
    class CSV
      attr_reader :filename, :csv_options

      def initialize(filename:, csv_options: {})
        @filename = filename
        @csv_options = csv_options
      end

      def each
        @csv ||= ::CSV.open(@filename, @csv_options)

        @csv.each do |row|
          yield headers? ? row.to_hash : row
        end

        @csv.close
      end

      private

      def headers?
        @csv.headers
      end
    end
  end
end
