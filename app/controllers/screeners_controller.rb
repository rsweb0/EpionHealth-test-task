class ScreenersController < ApplicationController
  before_action :initialize_check_in

  def new
    @screener = @check_in.screeners.new
  end

  private

  def initialize_check_in
    @check_in = CheckIn.find_by(id: params[:check_in_id])
  end
end
