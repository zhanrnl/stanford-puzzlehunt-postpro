class Team < ActiveRecord::Base
  has_many :solves
  has_many :puzzles, :through => :solves
end
