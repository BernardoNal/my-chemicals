require 'prawn'

class ActivitiessPdf
  attr_reader :activities

  def initialize(activities)
    @activities = activities
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
        pdf.text_box "Estoque do Químicos", at: [pdf.bounds.left, pdf.bounds.top - -47], width: pdf.bounds.width, height: 30, align: :center, size: 20
      end

      pdf.text "Fazenda: #{@storage.farm.name} - #{@storage.name}", style: :bold, color: "6d7760", align: :center, size: 16
      pdf.text "Data: #{Time.now.strftime("%d-%m-%y")} ", style: :bold, color: "6d7760", align: :center, size: 15
      pdf.move_down 5

      if activities.any?
        activities.each_with_index do |activity, index|

            pdf.move_down 10

            # text = "<b>#{index + 1}:  #{chemical.product_name}</b> " \
            #        "(#{chemical.type_product.titleize}) - #{chemical.total.round(2)}#{chemical.measurement_unit}\n" \
            #        "-------------------------------------------------------------------------------------"
            # pdf.text text, color: "343434", inline_format: true

        end




      else
        pdf.move_down 20
        pdf.text "Sem Atvidades nesse filtragem.", color: "6d7760", align: :center, size: 12
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
