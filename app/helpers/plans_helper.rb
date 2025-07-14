module PlansHelper
  def plan_duration_text(plan)
    "#{plan.duration} #{'mes'.pluralize(plan.duration)}"
  end
end
