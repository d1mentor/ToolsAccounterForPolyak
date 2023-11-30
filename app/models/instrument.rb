class Instrument < ApplicationRecord
  has_many :acts

  mount_uploaders :images, ImageUploader

  audited

  enum state: {
    good: 0,
    normal: 1,
    damaged: 2,
    broken: 3,
    in_service: 4
  }

  def last_act
    self.acts.sort_by { |act| act.created_at }.reverse.first
  end 
end
