class PermanentPolicy < AllowAllPolicy
  def disable?
    true
  end

  def enable?
    true
  end
end