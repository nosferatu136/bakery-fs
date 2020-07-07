class CookiesController < ApplicationController
  before_action :authenticate_user!

  def new
    @oven = current_user.ovens.find_by!(id: params[:oven_id])
    if @oven.cookies.present?
      redirect_to @oven, alert: 'Some cookies are already in the oven!'
    else
      @cookie = @oven.cookies.build
    end
  end

  def create
    @oven = current_user.ovens.find_by!(id: params[:oven_id])
    @cookie = @oven.cookies.create!(cookie_params)
    redirect_to oven_path(@oven)
  end

  private

  def cookie_params
    (params[:cookie_quantity].present? ? params[:cookie_quantity].to_i : 1).times.map do |_|
      { fillings: params[:fillings] }
    end
  end
end
