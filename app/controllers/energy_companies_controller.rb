class EnergyCompaniesController < ApplicationController
  require 'rtesseract'
  require 'mini_magick'
  require 'openai'

  def new
    @energy_company = EnergyCompany.new
  end

  def create
    @energy_company = EnergyCompany.new(energy_company_params)

    if @energy_company.save
      redirect_to @energy_company, notice: 'Empresa cadastrada com sucesso.'
    else
      render :new
    end
  end

  def show
    @energy_company = EnergyCompany.find(params[:id])
  end

  def extract_data
    unless params[:bill_image].present?
      render json: { error: 'Nenhuma imagem enviada.' }, status: :unprocessable_entity
      return
    end

    begin
      # Pré-processamento
      original = MiniMagick::Image.open(params[:bill_image].tempfile.path)
      original.auto_orient
      original.colorspace 'Gray'
      original.contrast
      original.normalize
      original.resize '1500x1500>'
      temp_path = Rails.root.join('tmp', "processed_#{SecureRandom.hex(8)}.png")
      original.write(temp_path)

      # OCR com RTesseract
      image = RTesseract.new(temp_path.to_s, lang: 'por')
      raw_text = image.to_s

      # Chamada ao OpenIA
      client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])

      response = client.chat(
        parameters: {
          model: 'gpt-3.5-turbo',
          temperature: 0.4,
          messages: [
            {
              role: 'system',
              content: <<~TEXT
                Você é um extrator de dados de contas de energia. Extraia apenas os seguintes campos do texto da imagem OCR:
                - name: Nome da empresa fornecedora de energia (ex: CPFL, ENEL, CEMIG, COELBA).
                - city_name: Nome da cidade da empresa. Deve estar localizado próximo ao endereço da sede ou local de emissão da fatura. Se houver múltiplas cidades no texto, escolha aquela que acompanha um endereço.
                - price_per_kwh: Divida o valor total da fatura pelo consumo total em kWh. Retorne com 3 casas decimais. valor total: valor total da conta, sem R$, com . como separador decimal. consumo_kwh: total de kWh consumidos, como número com ponto decimal

                Responda apenas com um JSON com os campos: name, city_name, price_per_kwh.
              TEXT
            },
            {
              role: 'user',
              content: raw_text
            }
          ]
        }
      )

      json = JSON.parse(response.dig('choices', 0, 'message', 'content'))
      city = City.find_by(name: json['city_name'])

      render json: {
        name: json['name'],
        city: city&.name,
        city_id: city&.id,
        price_per_kwh: json['price_per_kwh']
      }
    rescue StandardError => e
      render json: { error: "Erro ao processar imagem: #{e.message}" }, status: :internal_server_error
    ensure
      File.delete(temp_path) if temp_path && File.exist?(temp_path)
    end
  end

  private

  def energy_company_params
    params.require(:energy_company).permit(:name, :price_per_kwh, :city_id)
  end
end
