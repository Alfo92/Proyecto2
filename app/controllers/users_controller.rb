class UsersController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!

  def index
    if current_user.is_agent?
      redirect_to account_agent_index_path
    else
      redirect_to account_consumer_index_path
    end
  end

  def set_language
    supported_languages = User.language.values
    if supported_languages.include? params[:language]
      if current_user
        if current_user.update_attributes(language: params[:language])
          cookies[:language] = params[:language]
          flash[:success] = t(".success")
        else
          flash[:success] = t(".error")
        end
      else
        cookies[:language] = params[:language]
        flash[:success] = t(".success")
      end
    else
      # not supported
      flash[:error] = t(".not_supported")
    end

    redirect_to(:back)
  end
  
end