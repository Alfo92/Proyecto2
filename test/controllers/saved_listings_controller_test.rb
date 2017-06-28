require 'test_helper'

class SavedListingsControllerTest < ActionController::TestCase
  setup do
    @saved_listing = saved_listings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:saved_listings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create saved_listing" do
    assert_difference('SavedListing.count') do
      post :create, saved_listing: { listing_id: @saved_listing.listing_id, notes: @saved_listing.notes, sort_order: @saved_listing.sort_order, user_id: @saved_listing.user_id }
    end

    assert_redirected_to saved_listing_path(assigns(:saved_listing))
  end

  test "should show saved_listing" do
    get :show, id: @saved_listing
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @saved_listing
    assert_response :success
  end

  test "should update saved_listing" do
    patch :update, id: @saved_listing, saved_listing: { listing_id: @saved_listing.listing_id, notes: @saved_listing.notes, sort_order: @saved_listing.sort_order, user_id: @saved_listing.user_id }
    assert_redirected_to saved_listing_path(assigns(:saved_listing))
  end

  test "should destroy saved_listing" do
    assert_difference('SavedListing.count', -1) do
      delete :destroy, id: @saved_listing
    end

    assert_redirected_to saved_listings_path
  end
end
