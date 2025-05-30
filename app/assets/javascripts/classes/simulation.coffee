window.Simulation ||= {}

class Simulation.Form
  constructor: (el) ->
    @vm = new Vue
      el: el
      data: ->
        solarBatch: false
        windBatch: false
      mounted: ->
        form = document.querySelector('form')

        form?.addEventListener 'reset', =>
          setTimeout =>
            @solarBatch = document.querySelector('#simulation_simulate_solar_batch')?.checked
            @windBatch  = document.querySelector('#simulation_simulate_wind_batch')?.checked
          , 50

        document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach (el) ->
          new bootstrap.Tooltip(el)

        document.addEventListener 'DOMContentLoaded', ->
          document.querySelectorAll('.card-animated').forEach (el, i) ->
            setTimeout ->
              el.classList.add('visible')
            , i * 150

      document.addEventListener 'DOMContentLoaded', ->
        button = document.querySelector('.simular-btn')
        if button
          button.addEventListener 'mouseenter', ->
            button.classList.add('glow')
          button.addEventListener 'mouseleave', ->
            button.classList.remove('glow')

      document.querySelector('form')?.addEventListener 'reset', =>
        setTimeout =>
          @solarBatch = false
          @windBatch = false
        , 50


document.addEventListener 'DOMContentLoaded', ->
  document.querySelectorAll('.card-animated').forEach (el, i) ->
    setTimeout ->
      el.classList.add('visible')
    , i * 150