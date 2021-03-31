RSpec.describe FakerZextend do
  it "has a version number" do
    expect(FakerZextend::VERSION).not_to be nil
  end

  it "can generate chinese id" do
    id = Faker::Chinese::IDNumber.id_number
    expect(id.length).to eq(18)
  end

  it "can generate uniform social credit code" do
    id = Faker::Chinese::UniSocialCode.uni_social_code
    expect(id.length).to eq(18)
  end

  it "can generate bank card no" do
    no = Faker::Chinese::Bank.bank_card_no
    expect(no.length).to eq(19)
  end

  it "can generate bank union code" do
    union_code = Faker::Chinese::Bank.union_code
    expect(union_code.length).to eq(12)
  end

  it "can generate zip code" do
    zip = Faker::Chinese::Zip.zip
    expect(zip.length).to eq(6)
  end


  # Faker::Address.full_address
  # Faker::PhoneNumber.cell_phone
  # Faker::Name.name
  # Faker::Date.between(from: '2014-09-23', to: '2020-09-25').strftime("%Y-%m-%d")
  it "can generate company name" do
    name = Faker::Chinese::Company.name
    expect(name.length).to be > (6)
  end

  it "can generate random text" do
    text = Faker::Chinese::Text.random_text(100)

    expect(text.length).to be > (6)
    text_with_special = Faker::Chinese::Text.random_text_with_special(100)
    expect(text_with_special.length).to be > (6)

  end

end
