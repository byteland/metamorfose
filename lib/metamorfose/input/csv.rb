require 'csv'

module Metamorfose
  module Input
    class CSV
      attr_reader :filename, :settings

      def initialize(settings: {})
        @filename = settings.delete(:filename)
        @settings = settings
      end

      def each
        @csv ||= ::CSV.open(@filename, @settings)

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
