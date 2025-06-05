window.EnergyCompanies ||= {}

class EnergyCompanies.Index
  constructor: (el) ->
    @vm = new Vue
      el: el
      data: -> filtersEnabled: false
      methods:
        toggleFilters: -> @filtersEnabled = !@filtersEnabled

    EnergyCompanies.Index.initSelect2Ajax()

EnergyCompanies.Index.initSelect2Ajax = ->
  document.querySelectorAll('.select2-ajax').forEach (select) ->
    $select = $(select)
    $select.select2
      theme: 'bootstrap-5'
      placeholder: 'Selecione a cidade'
      allowClear: true
      width: 'style'
      ajax:
        url: select.dataset.url
        dataType: 'json'
        delay: 250
        data: (params) -> q: params.term
        processResults: (data) ->
          results: data
