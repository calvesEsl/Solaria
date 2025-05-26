module IndividualsHelper
  def individual_fields
    {
      name: { label: 'Nome' },
      email: { label: 'Email' }
    }
  end

  def individual_actions_helper
    [
      {
        label: 'Editar',
        url: ->(i) { edit_individual_path(i) },
        class: ''
      },
      {
        label: 'Excluir',
        url: ->(i) { individual_path(i) },
        class: 'text-danger',
        method: :delete,
        data: { confirm: 'Tem certeza que deseja excluir?' }
      }
    ]
  end
end
