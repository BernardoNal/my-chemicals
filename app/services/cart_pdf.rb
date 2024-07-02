require 'prawn'

class CartPdf
  attr_reader :carts, :one_chemical

  def initialize(carts, singular)
    @carts = carts
    @one_chemical = singular
  end

  def call
    header_height = 60
    top_margin = header_height + 10
    Prawn::Document.new(margin: [top_margin, 40, 40, 40]) do |pdf|
      pdf.canvas do
        pdf.repeat :all do
          space_from_top = 0
          header_top_y = pdf.bounds.top - space_from_top
          image_path = File.expand_path('../assets/images/folhas_cinzas_3.jpg', __dir__)
          pdf.fill_color "6d7760"
          pdf.fill_rectangle [0, header_top_y], pdf.bounds.width, header_height
          pdf.image image_path, at: [pdf.bounds.width - 515, pdf.bounds.top - 8], width: 35, height: 35
        end
      end
      pdf.repeat :all do
        pdf.fill_color "F4F4F4"
        pdf.text_box "MyChemicals", at: [pdf.bounds.width - 560, pdf.bounds.top - -46], width: 100, height: 20, size: 15
        pdf.text_box "Relatório de Movimentação", at: [pdf.bounds.left, pdf.bounds.top - -47], width: pdf.bounds.width, height: 30, align: :center, size: 20
      end
      pdf.move_down 5
      if carts.any? && one_chemical == false
        carts.each do |(date_move, carts_group)|
          # pdf.start_new_page if index > 0 # Inicia uma nova página para cada data, exceto a primeira
          pdf.text "Data: #{date_move.strftime("%d-%m-%y")} ", style: :bold, color: "6d7760", align: :center, size: 15
          pdf.move_down 10

          carts_group.each do |cart|
            text = "<b>Data da solicitação: </b> #{cart.created_at.strftime("%d-%m-%y %H:%M")} | " \
                   "<b>Data da aprovação: </b> #{cart.updated_at.strftime("%d-%m-%y %H:%M")}\n" \
                   "<b>Fazenda:</b> #{cart.storage.farm.name} | <b>Galpão:</b> #{cart.storage.name}\n" \
                   "<b>Solicitante:</b> #{cart.requestor.first_name.titleize} #{cart.requestor.last_name.titleize} | " \
                   "<b>Aprovador:</b> #{cart.approver.first_name.titleize} #{cart.approver.last_name.titleize}\n \n" \
                   "<b>Produto(s):</b>"
            pdf.text text, color: "343434", inline_format: true

            cart.cart_chemicals.each do |cart_chemical|
              text = "• #{cart_chemical.chemical.product_name} - <b> Mov: </b> " \
                     "#{cart_chemical.quantity * cart_chemical.chemical.amount} " \
                     "#{cart_chemical.chemical.measurement_unit}"
              if cart_chemical.quantity.positive?
                pdf.text text, color: "6d7760", inline_format: true
              else
                pdf.text text, color: "8f4445", inline_format: true
              end
              pdf.move_down 0
            end

            text="\n\n"
            pdf.text text, color: "6d7760", inline_format: true
          end

          pdf.move_down 6
        end
      else
        pdf.text "Químico: #{one_chemical.product_name}", style: :bold, align: :center, size: 24
        pdf.move_down 5

        carts.each do |(date_move, carts_group)|
          pdf.text "Data: #{date_move.strftime("%d-%m-%y")} \n", style: :bold, color: "6d7760", align: :center, size: 15
          pdf.move_down 10

          carts_group.each do |cart|
            text = "<b>Registro: </b> #{cart.id} | " \
                   "<b>Fazenda:</b> #{cart.storage.farm.name} | <b>Galpão:</b> #{cart.storage.name}\n" \
                   "<b>Solicitante:</b> #{cart.requestor.first_name.titleize} #{cart.requestor.last_name.titleize} | " \
                   "<b>Aprovador:</b> #{cart.approver.first_name.titleize} #{cart.approver.last_name.titleize}\n \n"

            pdf.text text, color: "343434", inline_format: true

            cart.cart_chemicals.each do |cart_chemical|
              if cart_chemical.chemical == one_chemical
                text = "• <b> Mov: </b> " \
                      "#{cart_chemical.quantity * cart_chemical.chemical.amount} " \
                      "#{cart_chemical.chemical.measurement_unit}"
                if cart_chemical.quantity.positive?
                  pdf.text text, color: "6d7760", inline_format: true
                else
                  pdf.text text, color: "8f4445", inline_format: true
                end
                pdf.move_down 0
              end
            end

            text="\n\n"
            pdf.text text, color: "6d7760", inline_format: true
          end

          pdf.move_down 6
        end
        # pdf.move_down 20
        # pdf.text "No carts available for this period.", color: "6d7760", align: :center, size: 12
      end
      options = {
        at: [pdf.bounds.right - 50, 0],
        width: 80,
        align: :right,
        start_count_at: 1,
        color: "808080"
      }
      pdf.number_pages "Página <page> de <total>", options
    end.render
  end
end
