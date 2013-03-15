class Team < ActiveRecord::Base
  has_many :solves
  has_many :puzzles, :through => :solves
  validates :team_name, :uniqueness => true, :presence => true
  validates :internal_name, :uniqueness => true, :presence => true
  validates :pass_hash, :presence => true
end

# TESTING PASSWORDS
# Change here for future reference if you modify the database
# god: militarycenturiesdirection
# Team Rocket: associatedliabilitydestroy