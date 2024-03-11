class Group < ApplicationRecord
  belongs_to :organisation

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  has_many :group_forms, dependent: :restrict_with_exception

  scope :for_user, ->(user) { joins(:memberships).where(memberships: { user_id: user.id }) }

  validates :name, presence: true
  before_create :set_external_id

  def to_param
    external_id
  end

private

  def set_external_id
    self.external_id = ExternalIdProvider.generate_id
  end
end
