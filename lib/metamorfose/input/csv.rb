require 'csv'

module Metamorfose
  module Input
    class CSV
      def initialize(filename:, headers: true, col_sep: ',', converters: :all)
        @filename = filename
        @headers = headers
        @col_sep = col_sep
        @converters = converters
      end

      def each
        csv = ::CSV.open(
          @filename,
          headers: @headers,
          col_sep: @col_sep,
          converters: @converters,
          header_converters: :symbol
        )

        csv.each { |row| yield row.to_hash }
        csv.close
      end
    end
  end
end
