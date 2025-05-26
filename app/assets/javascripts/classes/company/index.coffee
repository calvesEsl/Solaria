window.Company ||= {}

class Company.Index
  constructor: (el) ->
    console.log 'Company Index iniciado'
    @vm = new Vue
      el: el
      data: ->
        filtersEnabled: false
      methods:
        toggleFilters: ->
          @filtersEnabled = !@filtersEnabled