
# bank card number
require 'json'
module Faker
  class Chinese
    class Bank < Base

      class << self
        def gen_bin_no(bin_no = nil)

          bank_to_bin =  
          {
            "工商银行": "623062",
            "中国银行": "621343",
            "建设银行": "622676",
            "招商银行": "410062",
            "中信银行": "433680",
            "光大银行": "622663",
            "民生银行": "622622",
            "交通银行": "621335",
            "平安银行": "622989",
            "农业银行": "622848"
          }
          bins = bank_to_bin.values
          if bin_no
            return bin_no
          else
            return bins.sample
          end
        end

        # 银行卡的中间位
        def gen_mid_no(len = 19)
          mid_no = ""
          (len - 6 -1).times do |i|
            mid_no << rand(10).to_s
          end
          return mid_no
        end


        # 1.3.1. 从x的右边第1个数字开始，每隔一位乘以2
        # 1.3.2. 把第一步中获得的乘积各位数相加得sum1
        # 1.3.3. x中未乘2的各位数相加得sum2
        # 1.3.4. sum=sum1+sum2，sum对10取模后得到m
        # 1.3.5. 若n为0，则校验码为0，其余则为对应的10-n，即n对10得补数
        def gen_last_code(left_bank_card_no)
          sum = 0

          left_bank_card_no.chars.reverse.each_with_index do |c, i|
            if i % 2 == 0
              sum = sum + (c.to_i * 2).to_s.chars.map{|x| x.to_i}.sum
            else
              sum = sum + c.to_i
            end
          end
          if sum % 10 == 0
            return '0'
          else
            return (10 - sum % 10).to_s
          end
        end


        def bank_card_no(bin_no = nil, len=19)
          
          left_card_no = gen_bin_no(bin_no) + gen_mid_no(len)
          return left_card_no + gen_last_code(left_card_no)
        end
  

        def union_code
          @all_union_code ||= JSON.parse(::File.read(::File.join(__dir__, "bank_union_code.json")))
          @all_union_code.sample
        end
      end
 
    end
  end
end
