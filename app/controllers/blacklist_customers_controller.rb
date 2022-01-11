class BlacklistCustomersController < ApplicationController
  before_action :admin_customer,     only: :destroy

  def show
    @customer = Customer.find(params[:id])
  end

  def index
    @customers = Customer.where(blacklist: true)
  end
end
