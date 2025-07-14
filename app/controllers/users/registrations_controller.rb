class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :gym_location_id, :plan_id])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :gym_location_id, :plan_id])
  end

  # Asignar rol por defecto si no se especifica
  def build_resource(hash = {})
    hash[:role] ||= 1 # Usuario común por defecto
    super
  end
end
