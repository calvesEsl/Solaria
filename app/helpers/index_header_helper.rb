module IndexHeaderHelper
  def index_header(model_class, new_path)
    model_name = model_class.model_name.human(count: :many)

    content_tag(:div, class: "d-flex justify-content-between align-items-center mb-3") do
      concat content_tag(:h2, model_name, class: "index-title mb-0")
      concat link_to "Nova #{model_class.model_name.human}", new_path, class: "btn btn-success"
    end
  end
end
