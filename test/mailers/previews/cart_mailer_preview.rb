# Preview all emails at http://localhost:3000/rails/mailers/cart_mailer
class CartMailerPreview < ActionMailer::Preview
  def create_pendence
    @cart = Cart.find(110)

    CartMailer.with(@cart).create_pendence
  end
end
