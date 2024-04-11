class CartMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def create_pendence
    @cart = params
    @user = User.find(@cart.requestor_id)
    @url  = 'https://my-chemicals-d734b9db170a.herokuapp.com/pending'
    mail(to: @user.email, subject: 'New Pendence')
  end
end
