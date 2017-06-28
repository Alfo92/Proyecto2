module ApplicationHelper

  def current_user_account_path
    current_user.class == Agent ? account_agent_index_path : account_consumer_index_path
  end

  def states_for_country(country)
    if country == "US"
      us_states
    else
               [  "Asunción (Capital)",
                  "Concepción",
                  "San Pedro",
                  "Cordillera",
                  "Caazapá",
                  "Guairá",
                  "Caaguazú",
                  "Itapúa",
                  "Misiones",
                  "Paraguarí",
                  "Alto Paraná",
                  "Central",
                  "Ñeembucú",
                  "Amambay",
                  "Canindeyú",
                  "Presidente Hayes",
                  "Alto Paraguay",
                  "Boquerón"]
    end

  end

  def us_states
      ['Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut', 'Delaware', 'District of Columbia', 'Florida', 'Georgia', 'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota', 'Mississippi', 'Missouri', 'Montana', 'Nebraska',
      'Nevada', 'New Hampshire', 'New Jersey', 'New Mexico', 'New York', 'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma', 'Oregon', 'Pennsylvania', 'Puerto Rico', 'Rhode Island', 'South Carolina', 'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming']
  end

  def account_types_select
    [[t("buyer"),"Buyer"],[t("seller"),"Seller"], [t("both"),"Both"]]
  end

  def average_rating_for(obj)
    #todo:
    rates = Rate.where(:rateable => obj)
    rates.sum(:stars)/rates.count
  end

  def get_language
    supported_languages = User.language.values
    default_language = 'es'
    if current_user && !current_user.language.blank?
      language = current_user.language
    else
      language = cookies[:language]
      if !supported_languages.include?(language)
        language = default_language
        cookies[:language] = language
      end
    end
    language
  end

  def datetime(datetime)
    datetime ? l(datetime) : ""
  end
end
