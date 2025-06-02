json.extract! payment, :id, :user_id, :plan_id, :amount_paid, :paid_on, :expires_on, :status, :created_at, :updated_at
json.url payment_url(payment, format: :json)
