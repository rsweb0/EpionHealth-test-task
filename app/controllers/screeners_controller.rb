class ScreenersController < ApplicationController
  before_action :load_check_in
  before_action :load_screener, only: [:edit, :update]

  def new
    @screener = @check_in.screeners.new
    Screener::QUESTIONS[1].size.times { @screener.responses.new }
  end

  def create
    @screener = @check_in.screeners.new(screen_params)
    if @screener.save
      flash[:notice] = "Your response has been recorded successfully."
      set_message_and_initialize_next_screener
    else
      flash[:error] = @screener.errors.full_messages.uniq.to_sentence
    end
  end

  def edit; end

  def update
    if @screener.update(screen_params)
      flash[:notice] = "Your response has been updated successfully."
      set_message_and_initialize_next_screener
    else
      flash[:error] = @screener.errors.full_messages.uniq.to_sentence
    end
  end

  private

  def screen_params
    params.require(:screener).permit(:phq_level,
                                     responses_attributes: [:id, :question, :answer])
  end

  def load_check_in
    @check_in = CheckIn.find_by(id: params[:check_in_id])
  end

  def load_screener
    @screener = @check_in.screeners.find_by(id: params[:id])
  end

  def set_message_and_initialize_next_screener
    @message =
      if @screener.last_phq?
        "Thank you for completing check in!!!"
      elsif @screener.high_scored?
        initialize_next_screener

        "Additional screening should be completed."
      else
        "Additional screening is not needed."
      end
  end

  def initialize_next_screener
    next_phq_level = @screener.phq_level + 1
    next_questions = Screener::QUESTIONS[next_phq_level]

    @next_screener = @check_in.screeners.find_or_initialize_by(phq_level: next_phq_level)

    (next_questions.size - @next_screener.responses.size).times do
      @next_screener.responses.new
    end
  end
end
