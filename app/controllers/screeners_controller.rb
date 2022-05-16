class ScreenersController < ApplicationController
  before_action :initialize_check_in

  def show
    @screener = @check_in.screeners.find_by(id: params[:id])
  end

  def new
    @screener = @check_in.screeners.new
    2.times { @screener.responses.new }
  end

  def create
    @screener = @check_in.screeners.new(screen_params)
    if @screener.save
      flash[:notice] = "Your response has been recorded successfully."
      redirect_to check_in_screener_path(check_in_id: @check_in.id, id: @screener.id)
    else
      flash[:error] = @screener.errors.full_messages.uniq.to_sentence
      render :new
    end
  end

  private

  def screen_params
    params.require(:screener).permit(responses_attributes: [:id, :question, :answer])
  end

  def initialize_check_in
    @check_in = CheckIn.find_by(id: params[:check_in_id])

    return unless @check_in.blank?

    redirect_to root_path
  end
end
