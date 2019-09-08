class User < ApplicationRecord
  include BCrypt

  validates :login, presence: true, uniqueness: true
  validates :provider, presence: true
  validates :password, presence: true, if: -> { provider == "standard" }

  has_one :access_token, dependent: :destroy
  has_many :articles, dependent: :destroy

  def password
    @password ||= Password.new(encrypted_password) if encrypted_password.present?
  end

  def password=(new_password)
    @password = Password.create(new_password) if new_password.present?
    self.encrypted_password = @password
  end
end
