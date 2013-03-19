module PuzzlesHelper
  def puzzle_url_name(puzzle)
    "#{puzzles_url}/#{puzzle.internal_name}"
  end
  
  def post_callin_puzzle_url_name(puzzle)
    "#{puzzles_url}/#{puzzle.internal_name}/post_callin"
  end
end
