class ScreenersController < ApplicationController
  before_action :initialize_check_in

  def new
    @screener = @check_in.screeners.new
    @screener.responses.new
  end

  def create
    @screener = @check_in.screeners.new(screen_params)
    if @screener.save
      flash[:notice] = "Your response has been recorded successfully."
      set_message
    else
      flash[:error] = @screener.errors.full_messages.to_sentence
    end
  end

  private

  def screen_params
    params.require(:screener).permit(responses_attributes: [:id, :question, :answer])
  end

  def initialize_check_in
    @check_in = CheckIn.find_by(id: params[:check_in_id])
  end

  def set_message
    @message =
      if @screener.high_scored?
        "Additional screening should be completed."
      else
        "Additional screening is not needed."
      end
  end
end
