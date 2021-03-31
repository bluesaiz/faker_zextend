# zip code
require 'json'
module Faker
  class Chinese
    class Zip < Base

      class << self
        def zip
          @all_zip ||= JSON.parse(::File.read(::File.join(__dir__, "chinese_zip.json")))
          @all_zip.sample["child"].sample["child"].sample["zipcode"]
        end
      end
    end
  end
end