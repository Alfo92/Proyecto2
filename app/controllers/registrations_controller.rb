class RegistrationsController < Devise::RegistrationsController
  
  # POST /resource
  def create
    build_resource(sign_up_params)
    resource.assign_attributes(sign_up_params)
    resource.save
    yield resource if block_given?
    if resource.persisted?
      cookies[:language] = resource.language if !resource.language.blank?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_to do |format|
          format.html { respond_with resource, location: after_sign_up_path_for(resource) }
          UserEmail.bienvenido_email(resource).deliver_now
          format.json {render json:{success: true, user:resource}}
        end
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_to do |format|
          format.html { respond_with resource, location: after_inactive_sign_up_path_for(resource) }
          format.json {render json:{success: true, user:resource}}
        end        
      end
    else
      respond_to do |format|
        format.html { respond_with resource }
        format.json { render json: {success: false, errors:resource.errors.to_a.to_sentence} }
      end
    end
  end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      cookies[:language] = resource.language if !resource.language.blank?
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, bypass: true
      respond_with resource, location: after_update_path_for(resource)
      flash[:success] = flash[:notice]
      flash.delete(:notice)
    else
      clean_up_passwords resource
      respond_with resource
      flash[:error] = flash[:error] || flash[:notice]
      flash.delete(:notice)
    end
  end

  protected 

  def update_resource(resource, params)
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:current_password)
      params.delete(:password)
      params.delete(:password_confirmation)
    end
    if params[:current_password].present?
      resource.update_with_password(params) 
    else
     resource.update_without_password(params)
    end
  end
end
