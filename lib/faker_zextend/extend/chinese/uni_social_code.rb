
# Uniform social credit code

module Faker
  class Chinese
    class UniSocialCode < Base
      flexible :uni_social_code

      # 统一社会信用代码：（登记管理部门代码（1位）、机构类别代码（1位）、登记管理机关行政区划码（6位）、主体标识码（组织机构代码）（9位）和校验码（1位）5个部分组成）

      class << self
          
          # 统一社会信用代码最后一位：代码字符集
        CHAR_VALUE = {
          "0" => 0, "1" => 1, "2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, "7" => 7, "8" => 8, "9" => 9,
          "A" => 10, "B" => 11, "C" => 12, "D" => 13, "E" => 14, "F" => 15, "G" => 16, "H" => 17, "J" => 18, "K" => 19, "L" => 20, "M" => 21,
          "N" => 22, "P" => 23, "Q" => 24, "R" => 25, "T" => 26, "U" => 27, "W" => 28, "X" => 29, "Y" => 30
        }

        CHAR_RANGE = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "J", "K", "L", "M", "N", 
          "P", "Q", "R", "T", "U", "W", "X", "Y"]
        
        
        # 组织机构代码 9位
        def gen_org_code()
          weight_code = [3,7,9,10,5,8,4,2]      # Wi 代表第i位上的加权因子=pow(3,i-1)%31
          org_code = []                         # 组织机构代码列表
          sum = 0
          for i in 0...8
            index = rand(0..30)
            org_code << CHAR_RANGE[index]     # 前八位本体代码：0~9 + A~Z 31个
            sum = sum + index * weight_code[i]
          end

          c9 = 11-sum % 11                      # 代表校验码：11-MOD（∑Ci(i=1→8)×Wi,11）-->前8位加权后与11取余，然后用11减
          if c9 == 10
            last_code = 'X'
          elsif c9 == 11
            last_code = '0'
          else
            last_code = c9.to_s
          end

          org_code << last_code
          return org_code.join('')
    
        end
        
        
        # 统一社会信用代码 18位
        def uni_social_code()
            manage_code = [1, 5, 9]            # 机构编制：1  民政：5  工商：9  其他：Y
            type_code = [1,2,3,9]        # 9-1-企业，9-2-个体工商户，9-3-农民专业合作社，9-9-其他
            area_code = '100000'         # 登记管理机关行政区划码：100000-国家用
            org_code = gen_org_code()    # 组织机构代码
            sum = 0
            weight_code = [1, 3, 9, 27, 19, 26, 16, 17,20,29,25,13,8,24,10,30,28]     # Wi 代表第i位上的加权因子=pow(3,i-1)%31
            code = manage_code[rand(0...manage_code.count)].to_s + type_code[rand(0...type_code.count)].to_s + area_code + org_code

            17.times do |i|
              sum = sum + CHAR_VALUE[code[i]] * weight_code[i]
            end
            c18 = CHAR_RANGE[31-(sum % 31 == 0 ? 31 : sum % 31)] # 校验位的mod值为0的时候,校验码的值为0
            social_code = code + c18

            return social_code
        end

      end
 
    end
  end
end
