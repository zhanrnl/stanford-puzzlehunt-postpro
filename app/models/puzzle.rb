class Puzzle < ActiveRecord::Base
  has_many :solves
  has_many :teams, :through => :solves
  has_and_belongs_to_many :linked_puzzles, :class_name => "Puzzle", :join_table => :puzzle_links, 
  :foreign_key => :puzzle1_id, :association_foreign_key => :puzzle2_id, 
  :after_add => :create_reverse_association, :after_remove => :remove_reverse_association
  validates :puzzle_name, :uniqueness => true, :presence => true
  validates :internal_name, :uniqueness => true, :presence => true

  def create_reverse_association(p)
    if not p.linked_puzzles.include? self then
      p.linked_puzzles << self
    end
  end

  def remove_reverse_association(p)
    if p.linked_puzzles.include? self then
      p.linked_puzzles.delete(self)
    end
  end
end
