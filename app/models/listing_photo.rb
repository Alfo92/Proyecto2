# == Schema Information
#
# Table name: listing_photos
#
#  id                :integer          not null, primary key
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer
#  file_updated_at   :datetime
#  file_fingerprint  :string(255)
#  name              :string(255)
#  comment           :string(255)
#  sort_order        :integer
#  listing_id        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class ListingPhoto < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :listing

  after_initialize :set_sort_order
  after_save      :set_primary_photo,  if: Proc.new { |photo| photo.sort_order == 0 }

  has_attached_file :file, processors: [:custom], styles: { original: {},
                                                               xlarge: {geometry: "800x600", watermark_path: "#{Rails.root}/public/images/watermark.png"},
                                                               large: {geometry: "624x377#", watermark_path: "#{Rails.root}/public/images/watermark.png"},
                                                               medium: "150x110", thumb: "108x108#", mini: "75X55#" },
  storage: :s3, path: "/listings/:listing_id/:id_partition/:style/:filename", s3_host_name: 's3-sa-east-1.amazonaws.com',
                    s3_credentials: Proc.new{ |a| storage_s3_credentials }

  validates_attachment_content_type :file, :content_type => /\Aimage\/.*\Z/

  def thumb_url
    file.url(:thumb)
  end

  def medium_url
    file.url(:medium)
  end

  def large_url
    file.url(:large)
  end
  
  def xlarge_url
    file.url(:xlarge)
  end

  def original_url
    file.url
  end

  def set_sort_order
    self.sort_order ||= listing.listing_photos.count
  end

  def set_primary_photo
    listing.update(primary_photo_id: self.id)
  end
end
