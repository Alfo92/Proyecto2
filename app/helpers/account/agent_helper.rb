module Account::AgentHelper

  def show_reviews(user)
    #todo
    t('account.agent.no_reviews_yet')
  end

  def show_specialties(user)
    #todo
    user.agent_profile.specialties.collect{|s| t(s)}.join(",") rescue ""
  end
end
