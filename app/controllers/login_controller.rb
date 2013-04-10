require 'digest/sha1'

class LoginController < ApplicationController
  def index
    (redirect_to god_path and return) if is_god?
    (redirect_to puzzles_path and return) if is_team?
  end

  def login
    internal_name = params[:internal_name]
    test_hash = Digest::SHA1.base64digest params[:clear_pass]
    team = Team.where('internal_name = ?', internal_name).first;
    if team.nil? 
      del_sess_name
      redirect_to root_path, :alert => :wrong and return
    end
    ref_hash = team.pass_hash
    if test_hash != ref_hash
      del_sess_name
      redirect_to root_path, :alert => :wrong and return
    end
    set_sess_name internal_name
    if internal_name == 'god'
      redirect_to god_path
    else
      redirect_to puzzles_path
    end
  end

  def logout
    del_sess_name
    redirect_to root_path, :alert => :logout
  end
end
