class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  # belongs_to :company
  has_many :acts
  has_many :tickets

  mount_uploader :avatar, AvatarUploader

  audited

  enum role: {
    admin: 0,
    storekeeper: 1,
    user: 2
  }
  
  def remember_me!
    self.remember_token_expires_at = 1.year.from_now
    self.remember_created_at = Time.now.utc
    save(validate: false)
  end

  def logs
    Audited::Audit.where(user_id: id)
  end

  def instruments
    user_instruments = []

    Instrument.all.each do |instrument|
      if instrument.last_act
        user_instruments << instrument if instrument.last_act.user == self
      end
    end

    user_instruments
  end
end
