
require 'csv'

module Faker
  class Chinese
    class Company < Base

      class << self
        def name
          @all_names ||= CSV.read(::File.join(__dir__, "company_name.csv"))
          @all_names.sample[0]
        end
      end
    end
  end
end