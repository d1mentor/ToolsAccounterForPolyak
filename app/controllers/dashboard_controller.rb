class DashboardController < ApplicationController
  before_action :storekeeper_level
  before_action :admin_level, only: %i[logs]

  def logs
    @logs = []
    query = params[:q]
    
    User.all.each do |user|
      user_logs = user.logs
      if query.present?
        user_logs = user_logs.where("action ILIKE :q OR auditable_type ILIKE :q OR user_id IN (SELECT id FROM users WHERE email ILIKE :q)", q: "%#{query}%")
      end
      
      user_logs.each do |log|
        @logs << { "#{user.email}" => log }
      end
    end
  
    @logs = @logs.sort_by { |user| user.values.last.created_at }.reverse
  end

  def dashboard
    @acts = Act.all
    @total_price = total_prices_by_currency
  end

  private

  def total_prices_by_currency
    instruments = Instrument.where.not(price: nil).group_by(&:price_currency)
    result = ""
    
    instruments.each do |currency, group|
      total_price = group.sum(&:price)
      result += " #{total_price} #{currency};"
    end
    
    result.strip
  end
  
end
