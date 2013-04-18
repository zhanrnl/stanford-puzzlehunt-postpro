require 'digest/sha1'

class TeamsController < ApplicationController
  # GET /teams
  # GET /teams.json
  def index
    (kick and return) if not is_god?
    @teams = Team.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @teams }
    end
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    (kick and return) if not is_god?
    @team = Team.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @team }
    end
  end

  # GET /teams/new
  # GET /teams/new.json
  def new
    (kick and return) if not is_god?
    @team = Team.new
    @mode = :new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @team }
    end
  end

  # GET /teams/1/edit
  def edit
    (kick and return) if not is_god?
    @team = Team.find(params[:id])
    @all_puzzles = Puzzle.all
    @mode = :edit
  end

  # POST /teams
  # POST /teams.json
  def create
    (kick and return) if not is_god?
    if (params[:team].has_key? :pass_hash) and (params.has_key? :do_hash)
      clear_pass = params[:team][:pass_hash]
      hash = Digest::SHA1.base64digest clear_pass
      params[:team][:pass_hash] = hash
    end
    @team = Team.new(params[:team])

    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render json: @team, status: :created, location: @team }
      else
        format.html { render action: "new" }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /teams/1
  # PUT /teams/1.json
  def update
    (kick and return) if not is_god?
    if (params[:team].has_key? :pass_hash) and (params.has_key? :do_hash)
      clear_pass = params[:team][:pass_hash]
      hash = Digest::SHA1.base64digest clear_pass
      params[:team][:pass_hash] = hash
    end
    @team = Team.find(params[:id])
    points_adjust = params[:points_adjust].to_i
    @team.points = @team.points + points_adjust

    pref = 'has_solved_'
    puzzles_to_set_solved = params.keys.select do |k| 
      k.start_with? pref
    end.map do |k|
      k.sub(pref, '').to_i
    end
    actual_solved_ids = @team.puzzles.map{|p| p.id}
    # puts actual_solved_ids.inspect
    # puts puzzles_to_set_solved.inspect

    puzzles_to_set_solved.each do |pid|
      if not actual_solved_ids.include? pid
        s = Solve.new(:puzzle_id => pid, :team_id => @team.id, :time_solved => Time.now)
        s.save
      end
    end
    actual_solved_ids.each do |pid|
      if not puzzles_to_set_solved.include? pid
        Solve.where(:puzzle_id => pid, :team_id => @team.id).destroy_all
        Callin.where(:puzzle_id => pid, :team_id => @team.id).destroy_all
      end
    end

    respond_to do |format|
      if @team.update_attributes(params[:team])
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    (kick and return) if not is_god?
    @team = Team.find(params[:id])
    @team.destroy

    respond_to do |format|
      format.html { redirect_to teams_url }
      format.json { head :no_content }
    end
  end

  # /genpassword
  def genpassword
    (kick and return) if not is_god?
    valid_words = File.read("app/assets/words").split(' ').find_all do |w|
      w.length > 5 and not w.include? "'"
    end
    render :text => valid_words.sample(3).join
  end
end
