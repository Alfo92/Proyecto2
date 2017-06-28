# == Schema Information
#
# Table name: agent_profiles
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  license     :string(255)
#  specialties :string(255)
#  slug        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class AgentProfile < ActiveRecord::Base
  belongs_to :user

  serialize :specialties

  after_create              :generate_slug
  
  validates_uniqueness_of :slug, allow_nil: true
  RATEABLE = ["honesty", "knowledge", "expertise", "agile_response", "negotiation", "general"]
  ratyrate_rateable "honesty", "knowledge", "expertise", "agile_response", "negotiation", "general"

  def general_rate
    number_of_categories = 5
    sum_of_rates = 0
    ["honesty", "knowledge", "expertise", "agile_response", "negotiation"].each do |rate_property|
      if !(result = send("#{rate_property}_average") ).nil?
        sum_of_rates += result.avg
      end
    end
    sum_of_rates / number_of_categories
  end


  private
  def generate_slug

    slug = "#{user.name}"
    #if service_areas.count
    #  self.slug << " " << service_areas.first.name
    #end
    slug << " #{id}"
    self.slug = slug.parameterize
    save
  end
  
end
