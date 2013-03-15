class PuzzlesController < ApplicationController
  # GET /puzzles
  # GET /puzzles.json
  def index
    (kick and return) if not is_team?

    @puzzles = Puzzle.all

    # render puzzle hunt index page teams will see
    if not is_god? 
      @unlocked_puzzles = @puzzles.select do |p|
        p.starts_unlocked == true
      end
      render 'huntindex' and return
    end

    # god (admin) page
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @puzzles }
    end
  end

  def has_team_solved?(puzzle)
    team = Team.where('internal_name = ?', get_sess_name).first
    solved_puzzles = team.puzzles.to_a
    solved_puzzles.include? puzzle
  end

  # GET /puzzles/1
  # GET /puzzles/1.json
  def show
    (kick and return) if not is_god?

    @puzzle = Puzzle.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @puzzle }
    end
  end

  # GET /puzzles/new
  # GET /puzzles/new.json
  def new
    (kick and return) if not is_god?
    @puzzle = Puzzle.new
    @other_puzzles = Puzzle.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @puzzle }
    end
  end

  # GET /puzzles/1/edit
  def edit
    (kick and return) if not is_god?
    @puzzle = Puzzle.find(params[:id])
    @other_puzzles = Puzzle.all - [@puzzle]
  end

  # POST /puzzles
  # POST /puzzles.json
  def create
    (kick and return) if not is_god?
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
    (kick and return) if not is_god?
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
    (kick and return) if not is_god?
    @puzzle = Puzzle.find(params[:id])
    @puzzle.destroy

    respond_to do |format|
      format.html { redirect_to puzzles_url }
      format.json { head :no_content }
    end
  end

  # /puzzles/god
  def god
    (kick and return) if not is_god?
  end
end
