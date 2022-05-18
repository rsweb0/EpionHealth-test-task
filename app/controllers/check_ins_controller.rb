class CheckInsController < ApplicationController
  def new
  end

  def create
    check_in = CheckIn.create(patient: current_patient)
    redirect_to check_in_path(check_in)
  end

  def show
    @check_in = CheckIn.find(params[:id])

    if @check_in.screeners.present? && !@check_in.completed?
      next_phq_level = @check_in.next_phq_level
      @screener = @check_in.screeners.new(phq_level: next_phq_level)
      Screener::QUESTIONS[next_phq_level].size.times { @screener.responses.new }
    end
  end

  def update
    CheckIn.find(params[:id])
    redirect_to new_check_in_path
  end
end
