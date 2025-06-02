class Users::RegistrationsController < Devise::RegistrationsController
    def create
      super do |resource|  # "resource" es el usuario recién creado
        # Si el usuario se guardó en la base (persisted?) y escogió plan_id
        if resource.persisted? && params[:user][:plan_id].present?
          plan = Plan.find_by(id: params[:user][:plan_id])  # Busca el plan por id
          if plan
            # Crea un Payment para ese usuario con plan, precio, fechas, estado activo
            resource.payments.create(
              plan: plan,
              amount_paid: plan.price,
              paid_on: Date.today,
              expires_on: Date.today + plan.duration.days,
              status: 'active'
            )
          end
        end
      end
    end
  
    # Permite que el parámetro plan_id entre al registro
    private
    def sign_up_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :plan_id)
    end
  end
  