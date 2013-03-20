class QueueController < ApplicationController
  def get_num_callins
    n = Callin.where('answered = ?', false).count
    render :text => n.to_s
  end

  def dequeue_callin
    query = Callin.where('answered = ?', false)
    if query.count == 0
      render :text => :none and return
    end
    callin = query.order('time_called').first
    callin.answered = true
    callin.save
    render :json => callin.as_json(:include => {
      :team => {:only => :team_name}, 
      :puzzle => {:only => [:answer, :puzzle_name]}
      })
  end

  def correct
    c = Callin.find(params[:id])
    s = Solve.new({
      :team_id => c.team_id, 
      :puzzle_id => c.puzzle_id, 
      :time_solved => c.time_called})
    if s.save
      render :text => :okay
    else
      render :text => :error
    end
  end

  def incorrect
    # nothing to be done, no solve needs to be created and the call-in has 
    # already been marked as answered
    render :text => :okay
  end

  def requeue
    c = Callin.find(params[:id])
    c.answered = false
    c.save
    if s.save
      render :text => :okay
    else
      render :text => :error
    end
  end

  def index
    kick and return if not is_god?

    @num_callins = Callin.where('answered = ?', false).count
  end
end
