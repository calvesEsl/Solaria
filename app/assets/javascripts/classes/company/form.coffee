window.Company ||= {}

class Company.Form
  constructor: (el) ->
    console.log 'Company Form iniciado'
    @vm = new Vue
      el: el
      data: ->
        filtersEnabled: false
      methods:
        toggleFilters: ->
          @filtersEnabled = !@filtersEnabled

    @applyMasks()

  applyMasks: ->
    maskCNPJ = (v) ->
      v.replace(/\D/g, '')
       .replace(/^(\d{2})(\d)/, '$1.$2')
       .replace(/^(\d{2})\.(\d{3})(\d)/, '$1.$2.$3')
       .replace(/\.(\d{3})(\d)/, '.$1/$2')
       .replace(/(\d{4})(\d)/, '$1-$2')
       .slice(0, 18)

    maskPhone = (v) ->
      v.replace(/\D/g, '')
       .replace(/^(\d{2})(\d)/, '($1) $2')
       .replace(/(\d{5})(\d{4})$/, '$1-$2')
       .slice(0, 15)

    cnpjField = document.querySelector('input[name="company[cnpj]"]')
    phoneField = document.querySelector('input[name="company[phone]"]')

    cnpjField?.addEventListener 'input', (e) ->
      e.target.value = maskCNPJ(e.target.value)

    phoneField?.addEventListener 'input', (e) ->
      e.target.value = maskPhone(e.target.value)
