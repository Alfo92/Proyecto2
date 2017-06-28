class AddAcceptTermsToListings < ActiveRecord::Migration
  def change
    add_column :listings, :accept_terms, :boolean, default: false
  end
end
