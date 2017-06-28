class Account::AgentController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_agent, only: [:show]
  def index
    @listings = current_user.listings.includes(:listing_properties, :primary_photo).order('id desc')
  end

  def show
    View.create(viewable:@user, ip_address:request.remote_ip)
  end

  def edit
    @agent = current_user
  end

  private

  def set_agent
    @user = User.find(params[:id])
  end
end
