require 'prawn'

class CartPdf
  attr_reader :carts

  def initialize(carts)
    @carts = carts
  end

  def call
    Prawn::Document.new do |pdf|
      pdf.text "Carts Report", align: :center, size: 25

      if carts.any?
        carts.each do |date_move, carts_group|
          pdf.text "Date: #{date_move}", style: :bold
          carts_group.each do |cart|
            pdf.text "Cart ##{cart.id} - Additional details here"
          end
        end
      else
        pdf.text "No carts available for this period."
      end
    end.render
  end
end
