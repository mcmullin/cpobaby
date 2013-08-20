class RepsController < ApplicationController
  def index
    @reps = Rep.order(:number).where("number like ?", "%#{params[:term]}%")
    render json: @reps.map(&:number)
  end
end
