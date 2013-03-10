class PuzzlesController < ApplicationController
  def index
    kick_unauth_team
  end

  def puzzle
    kick_unauth_team
  end
end
