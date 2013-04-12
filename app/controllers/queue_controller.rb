class QueueController < ApplicationController
  def get_num_callins
    n = Callin.where('answered = ?', false).count
    render :text => n.to_s
  end

  def get_num_questions
    n = Question.where('answered = ?', false).count
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
      :team => {:only => [:team_name, :team_id]}, 
      :puzzle => {:only => [:answer, :puzzle_name]}
      })
  end

  def dequeue_question
    query = Question.where('answered = ?', false)
    if query.count == 0
      render :text => :none and return
    end
    question = query.order('time_called').first
    question.answered = true
    question.save
    render :json => question.as_json(:include => {
      :team => {:only => :team_name}
      })
  end

  def correct
    c = Callin.find(params[:id])
    s = Solve.new({
      :team_id => c.team_id, 
      :puzzle_id => c.puzzle_id, 
      :time_solved => c.time_called
      })
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

  def answered_question
    # nothing to be done, the question has 
    # already been marked as answered
    render :text => :okay
  end

  def requeue
    c = Callin.find(params[:id])
    c.answered = false
    if c.save
      render :text => :okay
    else
      render :text => :error
    end
  end

  def attention_question
    q = Question.find(params[:id])
    q.answered = false
    q.notes = params[:notes]
    if q.save
      render :text => :okay
    else
      render :text => :error
    end
  end

  def delegate
    puts params
    puts params[:tid]
    q = Question.new(:team_id => params[:tid], :answered => false, 
                     :question => params[:text], :notes => params[:notes], 
                     :phone_num => params[:phone])
    if q.save
      render :text => :okay
    else
      render :text => :error
    end
  end

  def index
    kick and return if not is_god?

    @num_callins = Callin.where('answered = ?', false).count
  end

  def qindex
    kick and return if not is_god?

    @num_questions = Question.where('answered = ?', false).count
  end
end
