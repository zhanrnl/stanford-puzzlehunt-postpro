require 'digest/sha1'

class PuzzlesController < ApplicationController
  # GET /puzzles
  # GET /puzzles.json
  def index
    kick and return if not is_team?
    
    @puzzles = Puzzle.all
    t = get_team
    @team_name = t.team_name
    
    # render puzzle hunt index page teams will see
    if not is_god? 
      @unlocked_puzzles = unlocked_puzzles
      @solved_puzzles = t.puzzles
      @points = t.points

      @puzzle_boxes = []
      @puzzles.each do |p|
        obj = {:id => "p#{p.id}", :nn => p.neighbors_needed, 
          :unlocked => false, :x => p.xcoord, :y => p.ycoord, 
          :solved => false}
        if p.color == 'blue'
          obj[:color] = 'boxblue'
        elsif p.color == 'red'
          obj[:color] = 'boxred'
        elsif p.color == 'green'
          obj[:color] = 'boxgreen'
        else
          obj[:color] = 'boxwhite'
        end
        if @unlocked_puzzles.include? p
          obj[:name] = p.puzzle_name
          obj[:url] = p.internal_name
          obj[:unlocked] = true
        end
        if @solved_puzzles.include? p
          obj[:solved] = true
        end
        obj[:ismeta] = p.is_meta
        @puzzle_boxes << obj.clone
      end

      @puzzle_links = []
      Puzzle.all.each do |p|
        p.linked_puzzles.each do |lp|
          if p.is_meta or lp.is_meta
            next
          end
          @puzzle_links << {
            :ids => [p.id, lp.id].sort, 
            :unlocked => @solved_puzzles.include?(p) || @solved_puzzles.include?(lp)
          }
        end
      end
      @puzzle_links.uniq!

      @announcements = Announcement.order('"order"').select do |a|
        a.starts_unlocked or @solved_puzzles.include? a.puzzle
      end

      render 'huntindex' and return
    end

    # god (admin) page
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @puzzles }
    end
  end

  def get_team
    Team.where('internal_name = ?', get_sess_name).first
  end

  def unlocked_puzzles
    team = get_team
    solved_puzzles = team.puzzles.to_a
    all_puzzles = Puzzle.all
    neighbors = []
    all_puzzles.each do |p|
      nn = p.neighbors_needed
      num_solved = 0
      p.linked_puzzles.each do |pn|
        if solved_puzzles.include? pn
          num_solved += 1
        end
      end
      if num_solved >= nn
        neighbors << p
      end
    end
    starts_unlocked = Puzzle.where('starts_unlocked = ?', true).to_a
    (solved_puzzles + neighbors + starts_unlocked).uniq
  end

  def has_team_solved?(puzzle)
    team = get_team
    solved_puzzles = team.puzzles.to_a
    solved_puzzles.include? puzzle
  end

  def is_unlocked?(puzzle)
    unlocked_puzzles.include? puzzle
  end

  # GET /puzzles/1
  # GET /puzzles/1.json
  def show
    (kick and return) if not is_team?

    if not is_god?
      @puzzle = Puzzle.where('internal_name = ?', params[:id]).first
      if @puzzle.nil? or not is_unlocked?(@puzzle)
        raise ActionController::RoutingError.new('Puzzle not found') 
      end
      render 'huntshow' and return
    end

    @puzzle = Puzzle.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @puzzle }
    end
  end

  # GET /puzzles/new
  # GET /puzzles/new.json
  def new
    kick and return if not is_god?
    @puzzle = Puzzle.new
    @other_puzzles = Puzzle.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @puzzle }
    end
  end

  # GET /puzzles/1/edit
  def edit
    kick and return if not is_god?
    @puzzle = Puzzle.find(params[:id])
    @other_puzzles = Puzzle.all - [@puzzle]
  end

  # POST /puzzles
  # POST /puzzles.json
  def create
    kick and return if not is_god?
    @puzzle = Puzzle.new(params[:puzzle])
    link_ids = extract_link_ids(params)
    link_ids.each do |lid|
      @puzzle.linked_puzzles << Puzzle.find(lid)
    end

    respond_to do |format|
      if @puzzle.save
        format.html { redirect_to @puzzle, notice: 'Puzzle was successfully created.' }
        format.json { render json: @puzzle, status: :created, location: @puzzle }
      else
        format.html { render action: "new" }
        format.json { render json: @puzzle.errors, status: :unprocessable_entity }
      end
    end
  end

  def extract_link_ids(params)
    link_ids = []
    params.each_key do |k|
      if k.start_with? 'neighbor_'
        link_ids << k.split('_')[1].to_i
      end
    end
    return link_ids
  end

  # PUT /puzzles/1
  # PUT /puzzles/1.json
  def update
    kick and return if not is_god?
    @puzzle = Puzzle.find(params[:id])
    @puzzle.linked_puzzles.clear
    link_ids = extract_link_ids(params)
    link_ids.each do |lid|
      @puzzle.linked_puzzles << Puzzle.find(lid)
    end

    respond_to do |format|
      if @puzzle.update_attributes(params[:puzzle])
        format.html { redirect_to @puzzle, notice: 'Puzzle was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @puzzle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /puzzles/1
  # DELETE /puzzles/1.json
  def destroy
    kick and return if not is_god?
    @puzzle = Puzzle.find(params[:id])
    @puzzle.destroy

    respond_to do |format|
      format.html { redirect_to puzzles_url }
      format.json { head :no_content }
    end
  end

  # /puzzles/god
  def god
    kick and return if not is_god?

    @teams = Team.all
  end

  def callin
    @puzzle = Puzzle.where('internal_name = ?', params[:id]).first
    if @puzzle.nil? or not is_unlocked?(@puzzle)
      raise ActionController::RoutingError.new('Puzzle not found') 
    end
    team = get_team
    @solved = Solve.where('puzzle_id = ? AND team_id = ?', @puzzle.id, team.id).first
    if @solved.nil?
      @callin = Callin.new
    end
    @previous_callins = Callin.where('puzzle_id = ? AND team_id = ?', @puzzle.id, team.id).to_a
  end

  def process_answer answer
    answer = answer.gsub(/[^A-Za-z]/, '').upcase
    return answer
  end

  def post_callin
    @puzzle = Puzzle.where('internal_name = ?', params[:id]).first
    if @puzzle.nil? or not is_unlocked?(@puzzle)
      raise ActionController::RoutingError.new('Puzzle not found') 
    end

    puzzle_url = "/puzzles/#{@puzzle.internal_name}/callin"

    team_id = get_team().id
    if Callin.where('team_id = ? AND puzzle_id = ? AND answered = "f"', team_id, @puzzle.id).count > 0
      redirect_to puzzle_url, :alert => :too_many
      return
    end

    params[:callin][:puzzle_id] = @puzzle.id
    params[:callin][:team_id] = team_id
    params[:callin][:time_called] = Time.now
    params[:callin][:answered] = false

    params[:callin][:answer] = process_answer(params[:callin][:answer])

    @callin = Callin.new(params[:callin])

    missing_info = (params[:callin][:answer].empty? or params[:callin][:phone_num].empty?)
    if missing_info
      redirect_to puzzle_url, :alert => :missing_info
      return
    end 

    if @callin.save
      redirect_to puzzle_url, :alert => :success
    else
      redirect_to puzzle_url, :alert => :missing_info
    end
  end

  def upload
    @uploaded = Resource.all
    # @uploaded = (Dir.entries "public/resources").select do |fn|
    #   fn[0] != '.'
    # end
  end

  def upload_post
    uploaded_io = params[:file]
    if uploaded_io.nil?
      redirect_to upload_url, :alert => {:type => :nofile}
      return
    end
    fn = uploaded_io.original_filename
    hashsource = Time.now.to_s + fn
    extwithdot = fn.slice(fn.rindex('.'), fn.length)
    hashfn = (Digest::SHA1.hexdigest hashsource).slice(0,8) + extwithdot
    File.open("public/resources/#{hashfn}", 'wb') do |file|
      file.write(uploaded_io.read)
    end
    r = Resource.new(:original => fn, :hashed => hashfn, :notes => params[:notes])
    r.save
    redirect_to upload_url, :alert => {:type => :upload_success}
  end

  def resource_delete
    Resource.destroy_all(:original => params[:original])
    redirect_to upload_url, :alert => {:type => :delete_success}
  end

  def ask_question
    @question = Question.new
  end

  def submit_question
    q = Question.new(params[:question])
    team = get_team
    q.team_id = team.id
    q.time_called = Time.now
    q.answered = false
    if q.save
      redirect_to ask_question_url, :alert => {:type => :success}
    else
      redirect_to ask_question_url, :alert => {:type => :problem}
    end
  end
end
