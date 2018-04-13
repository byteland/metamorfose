require 'csv'

module Metamorfose
  module Output
    class CSV
      attr_reader :filename, :settings

      def initialize(settings: {})
        @filename = settings.delete(:filename)
        @headers = settings[:headers]
        @settings = settings
      end

      def write(row)
        @csv ||= ::CSV.open(@filename, 'wb', @settings)
        @headers ||= row.keys
        @headers_written ||= (@csv << @headers; true)
        @csv << row.fetch_values(*@headers)
      end

      def close
        @csv.close
      end
    end
  end
end
