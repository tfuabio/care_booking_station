class CareManager < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :users, dependent: :destroy  # 現時点では利用者情報はケアマネージャー主体として扱う
  has_many :use_plans, dependent: :destroy
  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :last_name_kana, presence: true
  validates :first_name_kana, presence: true
  validates :address, presence: true
  validates :post_code, presence: true
  validates :phone_number, presence: true
  validates :office_name, presence: true
  has_one_attached :image

  # ユーザーが有効のときにtrue
  def active_for_authentication?
    super && (is_deleted == false)
  end

  # ゲストログイン
  def self.guest
    find_or_create_by!(email: ENV['GUEST_EMAIL']) do |care_manager|
      care_manager.password = SecureRandom.urlsafe_base64
      care_manager.last_name = "ゲスト"
      care_manager.first_name = "太郎"
      care_manager.last_name_kana = "ゲスト"
      care_manager.first_name_kana = "タロウ"
      care_manager.address = "ゲスト県ゲスト市ゲスト1-1"
      care_manager.post_code = "XXXXXXX"
      care_manager.phone_number = "080XXXXXXXX"
      care_manager.office_name = "居宅会後支援事業所ゲスト"
    end
  end

  # フルネームを取得
  def full_name
    self.last_name + " " + self.first_name
  end
end