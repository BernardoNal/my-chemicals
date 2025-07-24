# lib/tasks/cart_cleanup.rake
namespace :cart do
  desc "Remove todos os carts não aprovados com mais de 6h"
  task cleanup: :environment do
    CartCleanupService.call
    puts "Carts antigos removidos com sucesso."
  end
end
