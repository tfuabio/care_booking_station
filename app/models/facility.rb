class Facility < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :contracts, dependent: :destroy
  has_many :booking_contacts, dependent: :destroy
  has_many :use_plans, dependent: :destroy
  has_many :schedules, dependent: :destroy
  validates :name, presence: true
  validates :kana_name, presence: true
  validates :address, presence: true
  validates :post_code, presence: true
  validates :phone_number, presence: true
  validates :capacity, presence: true
  has_one_attached :image

  # 利用計画に対し施設が満床かどうかを判定するメソッド
  def no_beds?(use_plan)
    from = use_plan.start_date - 1
    to = use_plan.end_date + 1

    # 問い合わせ先の施設スケジュールを利用期間内のみ取得
    schedules = self.schedules.select { |schedule| schedule.date.after?(from) && schedule.date.before?(to) }

    # 定員に達している日程があればtrue、なければfalse
    schedules.each do |schedule|
      return true if schedule.use_details.count >= self.capacity.to_i
    end
    false
  end

  # ゲストログイン
  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |facility|
      facility.password = SecureRandom.urlsafe_base64
      facility.name = "guest"
      facility.kana_name = "ゲスト"
      facility.address = "ゲスト県ゲスト市ゲスト1-1"
      facility.post_code = "1234567"
      facility.phone_number = "0123456789"
      facility.capacity = "20"
    end
  end

  # 契約済みかどうかチェックする
  def new_user?(user)
    contract = Contract.find_by(facility_id: self.id, user_id: user.id)
    return contract.is_contracted
  end
end
