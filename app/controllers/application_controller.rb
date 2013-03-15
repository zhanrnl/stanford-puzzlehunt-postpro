class ApplicationController < ActionController::Base
  protect_from_forgery

  def is_team?
    session.has_key? :team_name
  end

  def is_god?
    session[:team_name] == "god"
  end

  def kick
    redirect_to root_path
  end

  def del_sess_name
    session.delete :team_name
  end

  def get_sess_name
    session[:team_name]
  end

  def set_sess_name (name)
    session[:team_name] = name
  end
end
