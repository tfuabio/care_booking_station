class EmergencyContact < ApplicationRecord
  belongs_to :user
  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :phone_number, presence: true
  validates :relationship, presence: true
  validates :status, presence: true

  enum relationship: {
    eldest_daughter: 0,
    second_daughter: 1,
    eldest_son: 2,
    second_son: 3,
    wife_of_son: 4,
    other: 5
  }

  enum status: {
    living_together: 0,
    separated: 1
  }

  # フルネームを取得
  def full_name
    self.last_name + " " + self.first_name
  end
end