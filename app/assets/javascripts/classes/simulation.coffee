window.Simulation ||= {}

class Simulation.Form
  constructor: (el) ->
    console.log 'Simulation.Form iniciado'
    @vm = new Vue
      el: el
      data: ->
        solarBatch: false
        windBatch: false
      mounted: ->
        @solarBatch = document.querySelector('#simulation_simulate_solar_batch')?.checked
        @windBatch = document.querySelector('#simulation_simulate_wind_batch')?.checked
