# FakerZextend

[![Gem Version](https://img.shields.io/gem/v/faker_zextend.svg)](https://rubygems.org/gems/faker_zextend)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE.txt)

A Ruby gem that extends the popular [Faker](https://github.com/faker-ruby/faker) library with **Chinese-specific fake data generators** — valid 18-digit resident ID cards, uniform social credit codes, bank card numbers with Luhn check digits, Chinese zip codes, company names, and mixed Chinese text.

> 仓库地址: <https://github.com/bluesaiz/faker_zextend>

## 特性 Features

- 18 位中国居民身份证号（含真实校验位算法）
- 18 位统一社会信用代码（含 9 位组织机构代码 + 加权校验位）
- 19 位银行卡号（Luhn 算法校验，覆盖 10 家主流银行 BIN）
- 12 位银行联行号
- 6 位中国大陆邮政编码
- 中文公司名（自 CSV 词库随机组合）
- 混合中文/数字/字母文本，可选特殊符号

所有模块在加载时自动将 `Faker::Config.locale` 设为 `zh-CN`，因此原生 `Faker::Name.name`、`Faker::Address.full_address`、`Faker::PhoneNumber.cell_phone` 等同样返回中文数据。

## 安装 Installation

将下面这行加到你的 `Gemfile` 中：

```ruby
gem 'faker_zextend'
```

然后执行：

```bash
bundle install
```

或直接安装：

```bash
gem install faker_zextend
```

## 快速开始 Quick Start

```ruby
require 'faker_zextend'

Faker::Chinese::IDNumber.id_number             # => "14030019600512831X"
Faker::Chinese::UniSocialCode.uni_social_code # => "91100000X001TEST0A"
Faker::Chinese::Bank.bank_card_no             # => "6230621234567890123"
Faker::Chinese::Bank.union_code               # => "102100000001"
Faker::Chinese::Zip.zip                       # => "100089"
Faker::Chinese::Company.name                  # => "杭州阿里巴巴网络科技有限公司"
Faker::Chinese::Text.random_text(20)          # => "北京shanghai58XY..."
Faker::Chinese::Text.random_text_with_special(20)
```

由 gem 设置的 `Faker::Config.locale = 'zh-CN'` 会同时作用于原生 Faker：

```ruby
Faker::Name.name              # => "李明"
Faker::Address.full_address   # => "上海市浦东新区张江路 88 号"
Faker::PhoneNumber.cell_phone # => "13912345678"
Faker::Internet.email         # => "test@example.cn"
Faker::Internet.url           # => "http://www.example.cn"
```

## 模块详解 Module Reference

### `Faker::Chinese::IDNumber`

生成符合 GB 11643-1999 标准的 18 位身份证号。

```ruby
# 完全随机（6 位地区码 + 8 位生日 + 3 位顺序码 + 1 位校验码）
Faker::Chinese::IDNumber.id_number
# => "430482199203157218"

# 指定地区码（必须是 6 位有效行政区划码）
Faker::Chinese::IDNumber.id_number("110105")
# => "11010519880101123X"
```

生日范围：1960-01-01 ~ 2020-12-30。校验位使用 ISO 7064:1983 MOD 11-2 权重算法。

### `Faker::Chinese::UniSocialCode`

生成符合 GB 32100-2015 的 18 位统一社会信用代码。

```ruby
Faker::Chinese::UniSocialCode.uni_social_code
# => "91100008MA5XYZ1A2K"
```

结构：登记管理部门代码 (1) + 机构类别代码 (1) + 行政区划码 (6) + 组织机构代码 (9) + 校验码 (1)。组织机构代码前 8 位从 31 个合法字符随机生成，第 9 位根据加权算法得出。

### `Faker::Chinese::Bank`

```ruby
# 19 位银行卡号（默认从 10 家银行 BIN 池随机）
Faker::Chinese::Bank.bank_card_no
# => "6213431234567890123"

# 指定 BIN（6 位）
Faker::Chinese::Bank.bank_card_no("622848")  # 农业银行 BIN

# 自定义长度（默认 19）
Faker::Chinese::Bank.bank_card_no(nil, 16)

# 12 位银行联行号
Faker::Chinese::Bank.union_code
# => "313100000001"
```

支持的银行 BIN：

| 银行 | BIN |
|---|---|
| 工商银行 | 623062 |
| 中国银行 | 621343 |
| 建设银行 | 622676 |
| 招商银行 | 410062 |
| 中信银行 | 433680 |
| 光大银行 | 622663 |
| 民生银行 | 622622 |
| 交通银行 | 621335 |
| 平安银行 | 622989 |
| 农业银行 | 622848 |

最后一位使用 Luhn 算法校验。

### `Faker::Chinese::Zip`

```ruby
Faker::Chinese::Zip.zip
# => "200120"
```

从内置的省/市/区三级 `chinese_zip.json` 词库中随机抽取一个真实邮编。

### `Faker::Chinese::Company`

```ruby
Faker::Chinese::Company.name
# => "深圳市腾讯计算机系统有限公司"
```

名称来自 `company_name.csv` 词库，约 3.8 万条真实公司名样本。

### `Faker::Chinese::Text`

```ruby
# 长度 len，混合汉字 + 数字 + 字母，比例随机约 3:1:1
Faker::Chinese::Text.random_text(30)
# => "上海科技有限公司MX8k上海信息..."

# 在 random_text 基础上追加全部特殊符号
Faker::Chinese::Text.random_text_with_special(30)
```

适合在测试中填充备注、地址、描述等中文字段。

## 开发 Development

```bash
git clone https://github.com/bluesaiz/faker_zextend.git
cd faker_zextend
bundle install
```

### 运行测试

```bash
bundle exec rspec
```

测试覆盖所有公共方法（ID 号、统一信用代码、银行卡号、联行号、邮编、公司名、随机文本）的长度与基本结构。

### 目录结构

```
faker_zextend/
├── lib/
│   ├── faker_zextend.rb              # 入口：设置 locale + 加载所有 extend
│   └── faker_zextend/
│       ├── version.rb
│       └── extend/
│           └── chinese/
│               ├── id_number.rb
│               ├── uni_social_code.rb
│               ├── bank_card.rb
│               ├── zip.rb
│               ├── company.rb
│               ├── text.rb
│               ├── chinese_zip.json      # 邮编省/市/区词库
│               ├── bank_union_code.json  # 联行号词库
│               └── company_name.csv      # 公司名词库
├── spec/                              # RSpec 测试
├── faker_zextend.gemspec
└── README.md
```

### 打包

```bash
rake build
```

产物会输出到 `pkg/faker_zextend-<version>.gem`。

发布到 RubyGems：

```bash
rake release
```

## 依赖 Dependencies

- Ruby `>= 2.3.0`
- [faker](https://github.com/faker-ruby/faker) `>= 3.x`

## 贡献 Contributing

1. Fork 仓库
2. 创建特性分支 (`git checkout -b feature/awesome-thing`)
3. 提交更改 (`git commit -m 'Add awesome thing'`)
4. 推送分支 (`git push origin feature/awesome-thing`)
5. 创建 Pull Request

欢迎补充新模块：车牌号、ISBN、组织机构代码、营业执照号等。词库更新也欢迎提 PR。

## 许可 License

[MIT](./LICENSE.txt) © 2021 saidev

## 仓库 Repository

<https://github.com/bluesaiz/faker_zextend>
