class Callin < ActiveRecord::Base
  belongs_to :team
  belongs_to :puzzle
  validates :phone_num, format: { with: /\A\d\d\d\-\d\d\d-\d\d\d\d\Z/i }
end
