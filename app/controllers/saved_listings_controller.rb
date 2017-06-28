class SavedListingsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_saved_listing, only: [:show, :edit, :update, :destroy]

  # GET /saved_listings
  # GET /saved_listings.json
  def index
    @saved_listings = SavedListing.all
  end

  # GET /saved_listings/1
  # GET /saved_listings/1.json
  def show
  end

  # GET /saved_listings/new
  def new
    @saved_listing = SavedListing.new
  end

  # GET /saved_listings/1/edit
  def edit
  end

  # POST /saved_listings
  # POST /saved_listings.json
  def create
    @saved_listing = SavedListing.new(saved_listing_params)

    respond_to do |format|
      if @saved_listing.save
        format.html { redirect_to @saved_listing, notice: 'Saved listing was successfully created.' }
        format.js { render :show }
      else
        format.html { render :new }
        format.js { render json: @saved_listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /saved_listings/1
  # PATCH/PUT /saved_listings/1.json
  def update
    respond_to do |format|
      if @saved_listing.update(saved_listing_params)
        format.html { redirect_to @saved_listing, notice: 'Saved listing was successfully updated.' }
        format.json { render :show, status: :ok, location: @saved_listing }
      else
        format.html { render :edit }
        format.js { render json: @saved_listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /saved_listings/1
  # DELETE /saved_listings/1.json
  def destroy
    @listing = @saved_listing.listing
    @saved_listing.destroy

    respond_to do |format|
      format.html { redirect_to saved_listings_url, notice: 'Saved listing was successfully destroyed.' }
      format.js {  }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_saved_listing
      @saved_listing = current_user.saved_listings.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def saved_listing_params
      params.require(:saved_listing).permit(:user_id, :listing_id, :sort_order, :notes).merge(user_id:current_user.id)
    end
end
