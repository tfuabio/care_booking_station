# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

CareManager.create!(
  email: "hanako@mail.com",
  password: "testtest",
  last_name: "山田",
  first_name: "花子",
  last_name_kana: "やまだ",
  first_name_kana: "はなこ",
  address: "埼玉県花子市８７８７",
  post_code: "1111111",
  phone_number: "08087878787",
  office_name: " 居宅介護支援事業所れいわ",
  is_deleted: false
)