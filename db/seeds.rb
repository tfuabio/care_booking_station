# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

care_managers = CareManager.create!(
  [
    {
      email: ENV['GUEST_EMAIL'],
      password: SecureRandom.urlsafe_base64,
      last_name: "ゲスト",
      first_name: "太郎",
      last_name_kana: "ゲスト",
      first_name_kana: "タロウ",
      address: "ゲスト県ゲスト市ゲスト1-1",
      post_code: "XXXXXXX",
      phone_number: "080XXXXXXXX",
      office_name: "居宅会後支援事業所ゲスト",
      is_deleted: false
    },
    {
      email: ENV['TEST_EMAIL'],
      password: ENV['TEST_PASSWORD'],
      last_name: "山田",
      first_name: "花子",
      last_name_kana: "やまだ",
      first_name_kana: "はなこ",
      address: "埼玉県花子市123",
      post_code: "XXXXXXX",
      phone_number: "080XXXXXXXX",
      office_name: "居宅介護支援事業所れいわ",
      is_deleted: false
    }
  ]
)

facilities = Facility.create!(
  [
    {
      email: ENV['GUEST_EMAIL'],
      password: SecureRandom.urlsafe_base64,
      name: "ケアセンターげすと",
      kana_name: "ケアセンターゲスト",
      address: "ゲスト県ゲスト市ゲスト2-2",
      post_code: "XXXXXXX",
      phone_number: "080XXXXXXXX",
      capacity: 20,
      is_deleted: false
    },
    {
      email: 'reiwa@mail.com',
      password: ENV['TEST_PASSWORD'],
      name: "ケアセンター令和",
      kana_name: "ケアセンターレイワ",
      address: "埼玉県テスト市令和1-1",
      post_code: "XXXXXXX",
      phone_number: "080XXXXXXXX",
      capacity: 20,
      is_deleted: false
    },
    {
      email: 'heisei@mail.com',
      password: ENV['TEST_PASSWORD'],
      name: "ケアセンター平成",
      kana_name: "ケアセンターヘイセイ",
      address: "埼玉県テスト市平成1-1",
      post_code: "XXXXXXX",
      phone_number: "080XXXXXXXX",
      capacity: 20,
      is_deleted: false
    },
    {
      email: 'syouwa@mail.com',
      password: ENV['TEST_PASSWORD'],
      name: "ケアセンター昭和",
      kana_name: "ケアセンターショウワ",
      address: "埼玉県テスト市昭和1-1",
      post_code: "XXXXXXX",
      phone_number: "080XXXXXXXX",
      capacity: 20,
      is_deleted: false
    }
  ]
)

users = care_managers.first.users.create!(
  [
    {
      last_name: "令和",
      first_name: "令子",
      last_name_kana: "レイワ",
      first_name_kana: "レイコ",
      address: "埼玉県テスト市令和123",
      post_code: "1234567",
      phone_number: "08012345678",
      current_status: "home_care",
      care_level_status: "long_term_care_level_1",
      gender: "female",
      birthday: Date.new(1937, 8, 30),
      life_history: "○○小学校を卒業後、洋裁学校に通った。成人してからは文房具製造工場に勤め、結婚後は家業の農家を手伝っていた。夫は幼なじみで恋愛結婚であった。几帳面で面倒見の良い性格で、夫が亡くなってからも畑仕事に精を出しては近所に配ったりしていた。また、孫が顔を見せに行くと大変喜んでいた。現在は年金と長男からの仕送りで生活している。",
      medical_history: "【既往歴】\r\nなし\r\n【現病歴】\r\n① 高血圧：平成 6 年（55 歳）頃診断。通院、内服治療を受けていた。② 糖尿病（II 型）：平成 6 年（55 歳）頃診断。通院、内服治療を受けていた。\r\n③ 両変形性膝関節症：平成 21 年（70 歳）診断。通院、内服治療を受けていた。\r\n④ アルツハイマー性認知症：平成 28 年（77 歳） △△病院にて確定診断され治療開始\r\n→①②③については、入所後は嘱託医が継続して診察する\r\n→④については、△△病院（脳神経内科 XXX 医師）に継続して通院する（連絡先：XXX-XXXX-XXXX）\r\n≪主治医≫\r\n嘱託医 ○○医師 （高血圧、糖尿病、変形性膝関節症の診察）"
    },
    {
      last_name: "昭和",
      first_name: "昭子",
      last_name_kana: "ショウワ",
      first_name_kana: "アキコ",
      address: "埼玉県テスト市昭和123",
      post_code: "1234567",
      phone_number: "08012345678",
      current_status: "home_care",
      care_level_status: "long_term_care_level_3",
      gender: "female",
      birthday: Date.new(1925, 5, 2),
      life_history: "○○小学校を卒業後、洋裁学校に通った。成人してからは文房具製造工場に勤め、結婚後は家業の農家を手伝っていた。夫は幼なじみで恋愛結婚であった。几帳面で面倒見の良い性格で、夫が亡くなってからも畑仕事に精を出しては近所に配ったりしていた。また、孫が顔を見せに行くと大変喜んでいた。現在は年金と長男からの仕送りで生活している。",
      medical_history: "【既往歴】\r\nなし\r\n【現病歴】\r\n① 高血圧：平成 6 年（55 歳）頃診断。通院、内服治療を受けていた。② 糖尿病（II 型）：平成 6 年（55 歳）頃診断。通院、内服治療を受けていた。\r\n③ 両変形性膝関節症：平成 21 年（70 歳）診断。通院、内服治療を受けていた。\r\n④ アルツハイマー性認知症：平成 28 年（77 歳） △△病院にて確定診断され治療開始\r\n→①②③については、入所後は嘱託医が継続して診察する\r\n→④については、△△病院（脳神経内科 XXX 医師）に継続して通院する（連絡先：XXX-XXXX-XXXX）\r\n≪主治医≫\r\n嘱託医 ○○医師 （高血圧、糖尿病、変形性膝関節症の診察）"
    },
    {
      last_name: "大正",
      first_name: "正子",
      last_name_kana: "タイショウ",
      first_name_kana: "マサコ",
      address: "埼玉県テスト市大正234",
      post_code: "1234567",
      phone_number: "08012345678",
      current_status: "home_care",
      care_level_status: "long_term_care_level_5",
      gender: "female",
      birthday: Date.new(1915, 6, 5),
      life_history: "○○小学校を卒業後、洋裁学校に通った。成人してからは文房具製造工場に勤め、結婚後は家業の農家を手伝っていた。夫は幼なじみで恋愛結婚であった。几帳面で面倒見の良い性格で、夫が亡くなってからも畑仕事に精を出しては近所に配ったりしていた。また、孫が顔を見せに行くと大変喜んでいた。現在は年金と長男からの仕送りで生活している。",
      medical_history: "【既往歴】\r\nなし\r\n【現病歴】\r\n① 高血圧：平成 6 年（55 歳）頃診断。通院、内服治療を受けていた。② 糖尿病（II 型）：平成 6 年（55 歳）頃診断。通院、内服治療を受けていた。\r\n③ 両変形性膝関節症：平成 21 年（70 歳）診断。通院、内服治療を受けていた。\r\n④ アルツハイマー性認知症：平成 28 年（77 歳） △△病院にて確定診断され治療開始\r\n→①②③については、入所後は嘱託医が継続して診察する\r\n→④については、△△病院（脳神経内科 XXX 医師）に継続して通院する（連絡先：XXX-XXXX-XXXX）\r\n≪主治医≫\r\n嘱託医 ○○医師 （高血圧、糖尿病、変形性膝関節症の診察）"
    },
    {
      last_name: "明治",
      first_name: "明男",
      last_name_kana: "メイジ",
      first_name_kana: "アキオ",
      address: "埼玉県テスト市明治234",
      post_code: "1234567",
      phone_number: "08012345678",
      current_status: "home_care",
      care_level_status: "long_term_care_level_2",
      gender: "male",
      birthday: Date.new(1932, 9, 24),
      life_history: "",
      medical_history: ""
    }
  ]
)

users.each do |user|
  file_path = Rails.root.join("app/assets/images/sample/user_#{user.id}.jpg")
  user.image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
end

facilities.first.contracts.create!(user_id: users.first.id, is_contracted: true)