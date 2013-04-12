class Question < ActiveRecord::Base
  belongs_to :team
  validates :phone_num, format: { with: /\A\d\d\d\-\d\d\d-\d\d\d\d\Z/i }
end
