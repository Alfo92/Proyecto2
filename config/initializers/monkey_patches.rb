class String
  def possessivize
    length ? ends_with?('s') ? dup + "'" : dup + "'s" : ""
  end
end