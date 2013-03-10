class Puzzle < ActiveRecord::Base
  has_many :solves
  has_many :teams, :through => :solves
end
