window.People ||= {}

class People.Index
  constructor: (id) ->
    console.log 'Vue iniciado via CoffeeScript'
    @vm = new Vue
      el: id
      data:
        peoples: {}
        filtersEnabled: true
      methods:
        toggleFilters: ->
          @filtersEnabled = !@filtersEnabled
