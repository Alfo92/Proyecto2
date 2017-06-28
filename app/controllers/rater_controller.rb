class RaterController < ApplicationController

  def create
    if user_signed_in?
      obj = params[:klass].classify.constantize.find(params[:id])

      if obj.class::RATEABLE.include?(params[:dimension])
        if obj.send("#{params[:dimension]}_rater_ids").include?(current_user.id)
          obj.update_current_rate(params[:score].to_f, current_user, params[:dimension])
        else
          obj.rate params[:score].to_f, current_user, params[:dimension]
        end
      else
      end
      render :json => true
    else
      render :json => false
    end
  end

end
