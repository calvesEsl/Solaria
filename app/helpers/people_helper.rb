module PeopleHelper
  def people_actions
    [
      { label: 'Editar', url: ->(p) { edit_person_path(p) }, class: 'btn btn-primary' },
      { label: 'Excluir', url: ->(p) { person_path(p) }, class: 'btn btn-danger', method: :delete, data: { confirm: 'Tem certeza?' } }
    ]
  end
end
