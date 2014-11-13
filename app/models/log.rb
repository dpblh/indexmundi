class Log < ActiveRecord::Base

  default_scope -> { order('created_at ASC') }

  validates :level, presence: true
  validates :level, inclusion: { in: [:info, :warning, :error]}
end
