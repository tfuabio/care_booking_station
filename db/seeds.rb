# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# CareManager.create!(
#     email: "hanako@mail.com",
#     password: "testtest",
#     last_name: "山田",
#     first_name: "花子",
#     last_name_kana: "やまだ",
#     first_name_kana: "はなこ",
#     address: "埼玉県花子市123",
#     post_code: "1234567",
#     phone_number: "08012345678",
#     office_name: " 居宅介護支援事業所れいわ",
#     is_deleted: false
# )

CareManager.create!(
  [
    {
      email: "hanako@mail.com",
      password: "testtest",
      last_name: "山田",
      first_name: "花子",
      last_name_kana: "やまだ",
      first_name_kana: "はなこ",
      address: "埼玉県花子市123",
      post_code: "1234567",
      phone_number: "08012345678",
      office_name: "居宅介護支援事業所れいわ",
      is_deleted: false
    },
    {
      email: "taro@mail.com",
      password: "testtest",
      last_name: "山田",
      first_name: "太郎",
      last_name_kana: "やまだ",
      first_name_kana: "たろう",
      address: "埼玉県太郎市123",
      post_code: "1234567",
      phone_number: "08023456789",
      office_name: "居宅介護支援事業所へいせい",
      is_deleted: false
    }
  ]
)

Facility.create!(
  [
    {
      email: "reiwa@mail.com",
      password: "testtest",
      name: "ケアセンター令和",
      kana_name: "ケアセンターレイワ",
      address: "埼玉県令和市令和123",
      post_code: "7654321",
      phone_number: "0123456789",
      capacity: 20,
      is_deleted: false
    },
    {
      email: "heisei@mail.com",
      password: "testtest",
      name: "ケアセンター平成",
      kana_name: "ケアセンターヘイセイ",
      address: "埼玉県平成市平成123",
      post_code: "8765432",
      phone_number: "1234567890",
      capacity: 25,
      is_deleted: false
    }
  ]
)

User.create!(
  [
    {
      care_manager_id: 1,
      last_name: "令和",
      first_name: "道子",
      last_name_kana: "レイワ",
      first_name_kana: "ミチコ",
      address: "埼玉県てすと市てすと123",
      post_code: "1234567",
      phone_number: "08012345678",
      current_status: "home_care",
      care_level_status: "long_term_care_level_1",
      gender: "female",
      birthday: Date.new(1937, 8, 30),
      life_history: "○○小学校を卒業後、洋裁学校に通った。成人してからは文房具製造工場に勤め、結婚後は家業の農家を手伝っていた。夫は幼なじみで恋愛結婚であった。几帳面で面倒見の良い性格で、夫が亡くなってからも畑仕事に精を出しては近所に配ったりしていた。また、孫が顔を見せに行くと大変喜んでいた。現在は年金と長男からの仕送りで生活している。",
      medical_history: "【既往歴】\r\nなし\r\n【現病歴】\r\n① 高血圧：平成 6 年（55 歳）頃診断。通院、内服治療を受けていた。② 糖尿病（II 型）：平成 6 年（55 歳）頃診断。通院、内服治療を受けていた。\r\n③ 両変形性膝関節症：平成 21 年（70 歳）診断。通院、内服治療を受けていた。\r\n④ アルツハイマー性認知症：平成 28 年（77 歳） △△病院にて確定診断され治療開始\r\n→①②③については、入所後は嘱託医が継続して診察する\r\n→④については、△△病院（脳神経内科 XXX 医師）に継続して通院する（連絡先：XXX-XXXX-XXXX）\r\n≪主治医≫\r\n嘱託医 ○○医師 （高血圧、糖尿病、変形性膝関節症の診察）"
    }
  ]
)