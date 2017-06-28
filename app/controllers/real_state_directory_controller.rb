class RealStateDirectoryController < ApplicationController
  def index
    @q = User.ransack(params[:q])
    @users = @q.result.where(disabled_at: nil)
  end
end
