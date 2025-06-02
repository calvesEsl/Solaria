class AssistantController < ApplicationController
  protect_from_forgery except: :chatbot

  def chat
    render 'chatbot'
  end

  def chatbot
    question = params[:question]

    if question.blank?
      render json: { answer: 'Por favor, digite uma pergunta.' }
      return
    end

    begin
      client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])

      response = client.chat(
        parameters: {
          model: 'gpt-3.5-turbo',
          messages: [
            {
              role: 'system',
              content: <<~SYSTEM.strip
                Você é um assistente virtual inteligente da Solaria.

                A Solaria é uma plataforma de simulação de impacto ambiental de energias renováveis.
                O sistema foi idealizado por 4 alunos de uma universidade brasileira durante um trabalho escolar.
                A proposta era criar uma ferramenta que facilitasse o cálculo de economia energética com base em
                tecnologias sustentáveis, como painéis solares e turbinas eólicas.

                O projeto foi tão bem-sucedido que atraiu investidores e se transformou em uma startup com impacto global.
                Hoje, a Solaria oferece recursos como:
                - Simulações de economia de energia com base no consumo e localização;
                - Planos de assinatura (Gratuito, Básico, Premium);
                - Dashboards com insights estratégicos;
                - Comparativos entre fontes de energia;
                - Importação de planilhas (.xls) e relatórios;
                - Histórico de simulações e análises automáticas.

                Seu papel é responder às dúvidas dos usuários sobre:
                - Planos e funcionalidades da plataforma;
                - Economia energética;
                - Cálculo de simulações;
                - Explicações sobre energia renovável;
                - Suporte básico.

                Seja sempre simpático, direto, informativo e alinhado com a linguagem de um assistente moderno.
              SYSTEM
            },
            { role: 'user', content: question }
          ],
          temperature: 0.7
        }
      )

      answer = response.dig('choices', 0, 'message', 'content')
      render json: { answer: answer || 'Desculpe, não consegui entender. Pode reformular?' }
    rescue StandardError => e
      render json: { answer: "Erro ao acessar a IA: #{e.message}" }, status: :internal_server_error
    end
  end
end
