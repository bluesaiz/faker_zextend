# frozen_string_literal: true
require 'date'
module Faker
  class Chinese
    class IDNumber < Base
      flexible :chinese_id_number

      class << self
        def rand_region_id()
          region_list = ["140300", "362204", "522725", "220202", "530128", "350103", "360321", "320103", "152201", "430482", "410882", "532331", 
            "142422", "152105", "140603", "230100", "320323", "410500", "130823", "350801", "211421", "130302", "532522", "430482", "422801", 
            "370683", "431027", "362302", "140431", "411330", "410822", "152634", "220521", "445122", "310103", "210711", "410403", "421127", 
            "211121", "310114", "500111", "220701", "220401", "522225", "371121", "110105", "421000", "540124", "522701", "530113", "433130", 
            "432501", "150421", "430501", "532500", "152701", "441426", "320106", "340402", "332522", "360281", "130300", "120110", "320481", 
            "513426", "130426", "520326", "420201", "340322", "140322", "513100", "440582", "110221", "230101", "340302", "130202", "410727", 
            "511000", "430481", "350403", "150104", "321324", "130322", "522422", "445100", "372926", "441381", "231123", "410621", "130726", 
            "150302", "440700", "320124", "360726", "150124", "211081", "360733", "420200", "360733", "460039"]
          region = region_list[rand(0...region_list.length)]
          return region
        end

        def calc_check_digit(id_left_str)
          # 通过身份证前17位生成校验码
          check_sum = 0
          id_left_str.chars.each_with_index do |c, i|
            check_sum += ((1 << (17 - i)) % 11) * c.to_i
          end
          check_digit = (12 - (check_sum % 11)) % 11
          return check_digit < 10 ? check_digit : 'X'
        end

        def id_number(input_region_id=nil)
          # 6位的地区码
          input_region_id = rand_region_id() unless input_region_id
          id = ""
          id += input_region_id
          # 生日期范围(8位数)
          start_date, end_date = ::Date.strptime('1960-01-01', '%Y-%m-%d'), ::Date.strptime("2020-12-30", "%Y-%m-%d")
          birth_days = (start_date + rand((end_date - start_date).to_i)).strftime("%Y%m%d")
          id += birth_days
          # 顺序码(2位数)
          id += String(rand(10..99))
          # 性别码(1位数)
          id += String(rand(0..9))
          # 校验码(1位数)
          id += String(calc_check_digit(id))
          return id
        end
 
      end
    end
  end
end
