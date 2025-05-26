module ApplicationHelper
  def render_filters(filters = {}, path:, method: :get)
    form_with url: path, method: method, local: true, class: 'row g-2 mb-3 align-items-end filter-form' do |f|
      filters.each do |field, opts|
        concat(content_tag(:div, class: 'col-md-2') do
          concat(f.label field, opts[:label], class: 'form-label small')
          if opts[:type] == :select
            concat(f.select field, opts[:choices], { include_blank: 'Selecione' }, class: 'form-select form-select-sm')
          else
            concat(f.text_field field, class: 'form-control form-control-sm')
          end
        end)
      end
      concat(content_tag(:div, class: 'col-auto') do
        f.submit '', class: 'btn btn-orange btn-sm fa fa-search'
      end)
    end
  end

  def modern_paginated_table(collection, headers:, fields:, actions: [], per_page_options: [10, 20, 50])
    content_tag(:div, class: 'table-responsive shadow-sm rounded bg-white p-3') do
      concat(content_tag(:table, class: 'table table-bordered table-sm align-middle mb-0') do
        concat(content_tag(:thead, class: 'bg-orange text-white') do
          content_tag(:tr) do
            headers.each { |h| concat content_tag(:th, h, class: 'fw-bold') }
            concat content_tag(:th, '', class: 'text-end actions-col') if actions.present?
          end
        end)

        concat(content_tag(:tbody) do
          if collection.any?
            collection.each do |item|
              concat(content_tag(:tr) do
                fields.each do |f|
                  concat content_tag(:td, item.send(f))
                end

                if actions.present?
                  concat(content_tag(:td, class: 'text-center actions-col') do
                    content_tag(:div, class: 'dropdown') do
                      concat(content_tag(:button, class: 'btn btn-light btn-sm dropdown-toggle', data: { bs_toggle: 'dropdown' }, aria: { expanded: false }) do
                        content_tag(:i, '', class: 'fas fa-ellipsis-v')
                      end)
                      concat(content_tag(:ul, class: 'dropdown-menu dropdown-menu-end') do
                        actions.each do |action|
                          concat(content_tag(:li) do
                            link_to action[:label], action[:url].call(item), class: "dropdown-item #{action[:class]}", method: action[:method], data: action[:data]
                          end)
                        end
                      end)
                    end
                  end)
                end
              end)
            end
          else
            concat(content_tag(:tr) do
              concat content_tag(:td, 'Nenhum registro encontrado', colspan: headers.size + (actions.present? ? 1 : 0), class: 'text-center')
            end)
          end
        end)
      end)

      concat(content_tag(:div, class: 'table-footer d-flex justify-content-between align-items-center mt-3 p-3 rounded shadow-sm bg-white border-top') do
        concat(content_tag(:div, class: 'd-flex align-items-center') do
          concat content_tag(:span, 'Qtd:', class: 'me-2 fw-semibold text-muted')
          concat select_tag('per_page', options_for_select(per_page_options, params[:per_page] || 10), class: 'form-select form-select-sm w-auto')
        end)

        concat(content_tag(:div, class: 'pagination-wrapper') do
          paginate(collection)
        end)
      end)
    end
  end
end
