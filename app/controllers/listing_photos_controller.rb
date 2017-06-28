class ListingPhotosController < ApplicationController

  def create
    @listing = Listing.find(params[:id])
    @listing_photo = @listing.listing_photos.build(listing_photo_params)

    respond_to do |format|
      if @listing_photo.save
        format.json { render json:@listing_photo.to_json(methods:"thumb_url"), status: :created, location: @listing_photo }
      else
        format.json { render json: @listing_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @listing_photo = ListingPhoto.find(params[:id])
    respond_to do |format|
      if @listing_photo.destroy
        format.js
        format.json { render json: @listing_photo.to_json(methods:"thumb_url"), status: :created, location: @listing_photo }
      else
        format.js
        format.json { render json: @listing_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def listing_photo_params
     params.require(:listing_photo).permit(:file, :name, :comment, :sort_order)
  end

end