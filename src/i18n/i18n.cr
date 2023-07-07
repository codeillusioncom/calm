macro t(str)
  {% if str.id.starts_with?(".") %}
    I18n.t("#{self.class.to_s.underscore}.{{@def.name}}{{str.id}}")
  {% else %}
    I18n.t({{str}})
  {% end %}
end
