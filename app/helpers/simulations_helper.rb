module SimulationsHelper
  def format_kwh(value)
    number_with_precision(value, precision: 2, delimiter: '.', separator: ',') + ' kWh'
  end

  def format_money(value)
    number_to_currency(value, unit: 'R$ ', delimiter: '.', separator: ',')
  end

  def simulation_index_headers
    ['ID', 'Cidade', 'Concessionária', 'Data']
  end

  def simulation_index_fields
    [:id, :city_name, :energy_company_name, :created_at_short]
  end

  def simulation_index_actions
    [
      {
        label: raw('<i class="fas fa-eye me-1"></i> Ver'),
        url: ->(s) { simulation_path(s) },
        class: 'btn btn-sm btn-primary'
      },
      {
        label: raw('<i class="fas fa-file-excel me-1"></i> Excel'),
        url: ->(s) { simulation_path(s, format: :xlsx) },
        class: 'btn btn-sm btn-success'
      },
      {
        label: raw('<i class="fas fa-chart-pie me-1"></i> Power BI'),
        url: ->(s) { export_power_bi_simulation_path(s) },
        class: 'btn btn-sm btn-outline-primary'
      }
    ]
  end
end
