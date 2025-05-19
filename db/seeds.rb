require 'csv'

puts "Limpando dados..."
City.delete_all
State.delete_all

puts "Importando Estados..."
states = {}
CSV.foreach(Rails.root.join('db/csv/estados.csv'), headers: true) do |row|
  state = State.create!(
    code: row['codigo_uf'],
    acronym: row['uf'],
    name: row['nome'],
    region: row['regiao'],
    latitude: row['latitude'],
    longitude: row['longitude']
  )
  states[row['codigo_uf']] = state
end

puts "Importando Cidades..."
CSV.foreach(Rails.root.join('db/csv/municipios.csv'), headers: true) do |row|
  state = states[row['codigo_uf']]
  next unless state

  City.create!(
    code_ibge: row['codigo_ibge'],
    name: row['nome'],
    latitude: row['latitude'],
    longitude: row['longitude'],
    capital: row['capital'] == '1',
    siafi_id: row['siafi_id'],
    ddd: row['ddd'],
    timezone: row['fuso_horario'],
    state: state
  )
end

puts "✅ Dados importados com sucesso!"
