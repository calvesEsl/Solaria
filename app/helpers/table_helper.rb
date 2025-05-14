# Helper para renderizar tabelas index com cabeçalhos, campos e ações.
module TableHelper
  def paginated_table(records, headers:, fields:, actions: [])
    return content_tag(:p, 'Nenhum registro encontrado.') if records.blank?

    content_tag :div, class: 'table-responsive' do
      content_tag :table, class: 'table table-bordered index-table' do
        concat(
          content_tag(:thead) do
            content_tag(:tr) do
              headers.each { |header| concat(content_tag(:th, header)) }
              concat(content_tag(:th, 'Ações')) if actions.any?
            end
          end
        )

        concat(
          content_tag(:tbody) do
            records.each do |record|
              concat(
                content_tag(:tr) do
                  fields.each { |field| concat(content_tag(:td, record.send(field))) }

                  if actions.any?
                    concat(content_tag(:td, class: 'index-actions') do
                      actions.each do |action|
                        concat(link_to(action[:label], action[:url].call(record), class: action[:class],
                                                                                  method: action[:method] || :get, data: action[:data]))
                      end
                    end)
                  end
                end
              )
            end
          end
        )
      end
    end
  end
end
