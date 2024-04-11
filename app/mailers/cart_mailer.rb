class CartMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def create_pendence
    @cart = params
    @user = User.find(@cart.requestor_id)
    @url  = 'https://my-chemicals-d734b9db170a.herokuapp.com/pending'
    mail(to: @cart.storage.farm.user.email, subject: 'New Pendence')
    @cart.storage.farm.employees.each do |manager|
      mail(to: manager.user.email, subject: 'New Pendence') if manager.manager
    end
  end
end
