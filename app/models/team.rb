class Team < ActiveRecord::Base
  has_many :solves
  has_many :puzzles, :through => :solves
  validates :team_name, :uniqueness => true, :presence => true
  validates :internal_name, :uniqueness => true, :presence => true
  validates :pass_hash, :presence => true

  def num_total_puzzles_solved
    self.puzzles.length
  end

  def num_nonmeta_puzzles_solved
    self.puzzles.select{|p| p.is_meta == false}.length
  end

  def num_meta_puzzles_solved
    self.puzzles.select{|p| p.is_meta == true}.length
  end

  def most_recent_puzzle_solved
    solves = self.solves.sort_by{|e| e.time_solved}
    if solves.length == 0
      return 'none solved yet'
    end
    return [solves.first.puzzle.puzzle_name, solves.first.time_solved]
  end
end

# TESTING PASSWORDS
# Change here for future reference if you modify the database
# god: militarycenturiesdirection
# Team Rocket: associatedliabilitydestroy