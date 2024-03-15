module ApplicationHelper
  def highlight_background(text, term)
    return text if term.blank?

    normalized_query = I18n.transliterate(term.downcase)
    normalized_text = I18n.transliterate(text.downcase)

    if normalized_text.include?(normalized_query)
      content_tag(:span, text, class: "highlight-background")
    else
      text
    end
  end
end
