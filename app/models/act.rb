class Act < ApplicationRecord
    belongs_to :user
    belongs_to :instrument
    belongs_to :previous_act, :class_name => 'Act', optional: true

    mount_uploaders :images, ImageUploader

    audited

    enum intstrument_state: {
        good: 0,
        normal: 1,
        damaged: 2,
        broken: 3,
        in_service: 4
      }
end
