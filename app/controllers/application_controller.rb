class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :plan_id])
  end
  def after_sign_in_path_for(resource)
    if resource.ceo?
      ceo_dashboard_path
    else
      users_dashboard_path
    end
  end
end
