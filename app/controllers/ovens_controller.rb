class OvensController < ApplicationController
  before_action :authenticate_user!

  def index
    @ovens = current_user.ovens
  end

  def show
    @oven = current_user.ovens.find_by!(id: params[:id])
  end

  def empty
    @oven = current_user.ovens.find_by!(id: params[:id])
    if @oven.cookies.present?
      @oven.cookies.update_all(
        storage_type: current_user.class,
        storage_id: current_user.id
      )
    end
    redirect_to @oven, alert: 'Oven emptied!'
  end
end
