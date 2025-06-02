class PlansController < ApplicationController
  def index
    @plans = [
      {
        name: "Plano Gratuito",
        description: "Ideal para quem quer explorar. Até 3 simulações por semana.",
        free: true,
        css_class: "btn-outline-secondary"
      },
      {
        name: "Plano Básico",
        price_id: "price_1RTZwyGaiFBNLHfXevoT21q3",
        description: "Ideal para quem está começando. Acesso às funcionalidades essenciais para simulações de energia renovável.",
        css_class: "btn-primary"
      },
      {
        name: "Plano Premium",
        price_id: "price_1RTZxrGaiFBNLHfX8KwxFxe7",
        description: "Solução completa para empresas. Inclui dashboards avançados, importação de planilhas e insights inteligentes para gestão energética.",
        css_class: "btn-success"
      }
    ]
  end
end
