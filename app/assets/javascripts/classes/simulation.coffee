window.Simulation ||= {}

class Simulation.Form
  constructor: (el) ->
    @vm = new Vue
      el: el
      data: ->
        solarBatch: false
        windBatch: false
        costPerPanel: ''
        costPerTurbine: ''
        consumptionYear: ''
      mounted: ->
        form = document.querySelector('form')

        form?.addEventListener 'reset', =>
          setTimeout =>
            @solarBatch = document.querySelector('#simulation_simulate_solar_batch')?.checked
            @windBatch  = document.querySelector('#simulation_simulate_wind_batch')?.checked
            @costPerPanel = ''
            @costPerTurbine = ''
            @consumptionYear = ''
          , 50

        document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach (el) ->
          new bootstrap.Tooltip(el)

        document.addEventListener 'DOMContentLoaded', ->
          document.querySelectorAll('.card-animated').forEach (el, i) ->
            setTimeout ->
              el.classList.add('visible')
            , i * 150

        button = document.querySelector('.simular-btn')
        if button
          button.addEventListener 'mouseenter', ->
            button.classList.add('glow')
          button.addEventListener 'mouseleave', ->
            button.classList.remove('glow')

      methods:
        formatCurrency: (field) ->
          value = @[field]
          value = value.toString().replace(/[^\d]/g, '')
          value = (parseFloat(value) / 100).toFixed(2)
          value = value.replace('.', ',').replace(/\B(?=(\d{3})+(?!\d))/g, '.')
          @[field] = "R$ #{value}"

        formatNumber: (field) ->
          value = @[field]
          value = value.toString().replace(/[^\d]/g, '')
          if value
            value = parseInt(value).toLocaleString('pt-BR')
          @[field] = value

document.addEventListener 'DOMContentLoaded', ->
  document.querySelectorAll('.card-animated').forEach (el, i) ->
    setTimeout ->
      el.classList.add('visible')
    , i * 150
