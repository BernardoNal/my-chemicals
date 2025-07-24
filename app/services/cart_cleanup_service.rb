# app/services/cart_cleanup_service.rb
class CartCleanupService
  def self.call
    Cart.where(approved: nil)
        .where('created_at <= ?', 6.hours.ago)
        .destroy_all
  end
end
