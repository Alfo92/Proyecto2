class ListingsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index, :search]
  before_action :set_listing, only: [:show, :edit, :step1, :step2, :step3, :update, :destroy]
  before_action :check_listing_owner, only: [:edit, :step1, :step2, :step3, :update, :destroy]
  before_action :remove_commas_on_price, only: [:create, :update]

  def check_listing_owner
    render_404 unless current_user.is_listing_owner(@listing)
  end

  def new
    if current_user.disabled_at
      flash[:notice] = t('users.disable.info')            
      redirect_to user_root_path
    else
      @listing = Listing.new
    end
  end

  def create
    @listing = Listing.new(listing_params.merge(agent_id: current_user.id))
    @listing.properties = listing_params["properties"]
    set_date    
    respond_to do |format|
      if @listing.save
        format.html { redirect_to step2_listing_path(@listing) }
        format.json { render :show, status: :created, location: @listing }
      else
        format.html { render :new }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end
  def update
    respond_to do |format|
      @listing.assign_attributes(listing_params)
      set_date
      if listing_params["properties"]
        @listing.listing_properties.each do |property|
          value = listing_params["properties"][property.key]
          property.assign_attributes(value: value) if value
        end
      end
      
      if @listing.save
        format.html { redirect_to listing_step }
        format.json { render json:@listing, status: :ok }
      else
        format.html { render action: previous_listing_action  }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
      @listing.destroy
        respond_to do |format|
          format.js {render inline: "location.reload();" }
        end
  end

  def step1
    render action:"new"
  end

  def step2
  end

  def step3
  end

  def show
    if !request.xhr?
      # if not ajax request (we use ajax to refresh rating section), count view
      View.create(viewable:@listing, ip_address:request.remote_ip)
    end
  end

  def index
    @listings = Listing.ready.where(:listing_type => params[:listing_type])
    if params[:where]
      @listings = @listings.near("#{params[:where]}, Paraguay", 300)
    end

    @listings = @listings.page
    @heading = t(Listing::LISTING_TYPE[params[:listing_type]])
    respond_to do |format|
      format.html {

      }
      format.json {
        render json: @listings.as_json
      }

    end
  end

  def edit
    render action: 'new'
  end

  def search

    if params[:listing]
      [:list_price_gteq, :list_price_lteq].each do |attr|
        if params[:listing][attr]
          params[:listing][attr] = params[:listing][attr].gsub(/,/, '')
        end
      end
    end


    current_user.searches.create(searchs_for: params[:full_info_unnacent_cont]) if current_user
    query_condition = filter_params

    @listings = Listing.ready.ransack(query_condition).result
    @heading = t("Search")
    respond_to do |format|
      format.html {  render :index  }
      format.json {
        render json: @listings.as_json
      }

    end
  end

  private

  def set_listing
    @listing = Listing.find(params[:id])
  end

  def listing_params

    params.require(:listing).permit!
    #(:type,:status_id,:list_price,:list_date,:primary_photo_id,
    #          :hide_address,:address1,:address2,:city,:state,:postal_code,:country,:latitude,:longitude,
    #          :listing_type,properties:[Apartment::PROPERTIES],listing_photos_attributes:[:id,:sort_order,:_destroy])

  end

  def filter_params
    keys_to_add = {}
    params[:listing].each do |condition, value|
      if condition[-5..-1] == 'range'
        values = value.split('-')
        starting = values[0]
        ending = values[1]
        params[:listing].delete(condition)
        keys_to_add["#{condition[0..-6]}gteq"] = starting
        keys_to_add["#{condition[0..-6]}lteq"] = ending
      else
        keys_to_add[condition] = value unless value.blank?
      end
    end if params[:listing]
    keys_to_add
  end

  def listing_step
    if listing_params[:step].present?
      case listing_params[:step]
      when "1"
        step2_listing_path(@listing)
      when "2"
        step3_listing_path(@listing)
      else
        @listing
      end
    elsif @listing.active? || @listing.sold
      @listing
    elsif @listing.listing_photos.empty?
      step2_listing_path(@listing)
    else
      step3_listing_path(@listing)
    end
  end

  def previous_listing_action
    if @listing.active?
      :step3
    elsif @listing.listing_photos.empty?
      :step2
    else
      :new
    end
  end

  def remove_commas_on_price
    if params[:listing] && params[:listing][:list_price]
      params[:listing][:list_price] = params[:listing][:list_price].gsub(/,/, '')
    end
  end

  # Avoid nil list_date, when use American format mm/dd/aaaa 
  def set_date    
    @listing.list_date = DateTime.strptime(listing_params[:list_date], '%m/%d/%Y') if I18n.locale==:en
  end
end
