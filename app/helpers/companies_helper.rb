module CompaniesHelper
  def company_index_headers
    ['Nome', 'Email', 'CNPJ']
  end

  def company_index_fields
    [:name, :email, :cnpj]
  end

  def company_index_actions
    [
      {
        label: 'Editar',
        url: ->(c) { edit_company_path(c) },
        class: 'btn btn-sm btn-primary'
      },
      {
        label: 'Excluir',
        url: ->(c) { company_path(c) },
        class: 'btn btn-sm btn-danger',
        method: :delete,
        data: { confirm: 'Tem certeza que deseja excluir esta empresa?' }
      }
    ]
  end
end
