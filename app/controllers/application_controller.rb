class ApplicationController < ActionController::Base
  protect_from_forgery

  def kick_unauth_team
    redirect_to "/" if session[:team_name] == nil
  end

  def welcome_auth_team
    redirect_to "/puzzles" if session[:team_name] != nil
  end

  def kick_nongod
    redirect_to "/" if session[:team_name] != "god"
  end

  def welcome_auth_god
    redirect_to "/god" if session[:team_name] == "god"
  end
end
