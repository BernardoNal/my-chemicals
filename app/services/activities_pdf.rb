require 'prawn'

class ActivitiesPdf
  attr_reader :activities

  def initialize(activities,date_start,date_end,last)
    @activities = activities
    @date_start = date_start
    @date_end = date_end
    @last = last
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
        pdf.text_box "Histórico de Atividades", at: [pdf.bounds.left, pdf.bounds.top - -47], width: pdf.bounds.width, height: 30, align: :center, size: 20
      end
      if @last
        pdf.text "Período: #{@date_start.strftime("%d-%m-%y")} a #{@date_end.strftime("%d-%m-%y")} ", style: :bold, color: "6d7760", align: :center, size: 15
      end
      pdf.move_down 5
      separator = "-------------------------------------------------------------------------------------------"

      if activities.any?
        activities.order(date_end: :desc).each_with_index do |activity, index|

            pdf.move_down 10

            text = "<b>#{index + 1}: #{activity.activity_type.titleize} </b> - #{activity.description} \n" \
                   "Realizado entre #{activity&.date_start&.strftime("%d-%m-%y")} a #{activity&.date_end&.strftime("%d-%m-%y")} \n"
            if activity.responsibles.present?
                            text += "Por: "
                            activity.responsibles.each do |responsible|
                              text += " #{responsible.name} /"
                            end
                            text += "\n"
            end

            if activity.activity_chemicals.present?
              text += "\n<b>Químicos usados:</b>"
              pdf.text text, color: "343434", inline_format: true
              activity.activity_chemicals.each do |chemical|
                text = "• #{chemical.chemical.product_name} - <b> Mov: </b> " \
                       "#{chemical.quantity} " \
                       "#{chemical.chemical.measurement_unit}"
                  pdf.text text, color: "6d7760", inline_format: true
                pdf.move_down 0
              end
            else
              pdf.text text, color: "343434", inline_format: true
            end
            pdf.move_down 15
          pdf.text separator, color: "343434", inline_format: true
        end




      else
        pdf.move_down 20
        pdf.text "Sem Atvidades nessa filtragem.", color: "6d7760", align: :center, size: 12
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
