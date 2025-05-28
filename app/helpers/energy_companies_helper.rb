module EnergyCompaniesHelper
  def energy_company_fields
    {
      name: { label: 'Nome' },
      price_per_kwh: { label: 'Preço por kWh' },
      city: { label: 'Cidade', value: ->(e) { e.city&.name } }
    }
  end

  def energy_company_actions_helper
    [
      {
        label: 'Editar',
        url: ->(e) { edit_energy_company_path(e) },
        class: ''
      },
      {
        label: 'Excluir',
        url: ->(e) { energy_company_path(e) },
        class: 'text-danger',
        method: :delete,
        data: { confirm: 'Tem certeza que deseja excluir esta concessionária?' }
      }
    ]
  end
end
