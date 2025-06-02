window.EnergyCompany ||= {}

class EnergyCompany.Form
  constructor: (el) ->
    @vm = new Vue
      el: el
      data:
        loading_ocr: false
      methods:
        handleBillUpload: (event) =>
          @vm.loading_ocr = true
          file = event.target.files[0]
          return unless file

          # Preview da imagem
          reader = new FileReader()
          reader.onload = (e) ->
            preview = document.getElementById("preview")
            container = document.getElementById("image-preview-container")
            preview.src = e.target.result
            preview.style.display = "block"
            container.style.display = "block"

          reader.readAsDataURL(file)

          # OCR
          formData = new FormData()
          formData.append("bill_image", file)

          fetch("/energy_companies/extract_data",
            method: "POST"
            headers:
              "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
            body: formData
          ).then((res) -> res.json())
          .then((data) ->
            if data.error
              alert(data.error)
            else
              document.getElementById("company-name").value = data.name or ''
              document.getElementById("company-price").value = data.price_per_kwh or ''
              if data.city_id?
                document.getElementById("city-select")?.value = data.city_id
          ).catch((error) ->
            alert("Erro ao processar a imagem.")
          ).finally =>
            @vm.loading_ocr = false

    document.getElementById('bill-upload')?.addEventListener 'change', (e) =>
      @vm.handleBillUpload(e)
