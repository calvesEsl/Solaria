window.People ||= {}

class People.Index
  constructor: (id) ->
    @vm = new Vue
      el: id
      data:
        peoples: {}
        filtersEnabled: true
      methods:
        toggleFilters: ->
          @filtersEnabled = !@filtersEnabled
