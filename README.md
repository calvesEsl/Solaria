# Solaria

**Solaria** é uma plataforma inteligente desenvolvida para automatizar a análise de viabilidade energética com base em dados reais. Em poucos passos, o usuário entende sua economia potencial, impacto ambiental e o tempo estimado de retorno do investimento ao migrar para fontes renováveis como energia solar ou eólica.

---

## Funcionalidades Principais

### OCR com Inteligência Artificial
- Envio de imagem da conta de luz
- Extração automática de:
  - Nome da concessionária
  - Cidade
  - Tarifa por kWh
  - Consumo estimado
- Utiliza Tesseract OCR e OpenAI para interpretação inteligente
- Campos preenchidos automaticamente no frontend (Vue.js)

### Integração com Dados Climáticos Reais
- Conexão com a API da OpenWeatherMap
- Baseado na latitude e longitude do usuário
- Parâmetros utilizados:
  - Radiação solar
  - Velocidade do vento
  - Condições climáticas

### Dashboard Comparativo
- Visualização de indicadores:
  - Geração anual (kWh)
  - Economia estimada (R$)
  - Payback (anos)
  - CO₂ evitado
  - Retorno financeiro em até 5 anos
- Comparação entre cenários: Solar x Eólico

### Assistente com IA Explicativa
- Geração de uma explicação personalizada ao final da simulação
- Interpretação automática dos resultados com linguagem acessível
- Suporte via OpenAI API

### Contador de CO₂ em Tempo Real
- Cálculo baseado em médias públicas de emissão no Brasil
- Atualização contínua reforçando a urgência de soluções sustentáveis

---

## Objetivo

Unir sustentabilidade, automação e acessibilidade.  
A Solaria mostra como a tecnologia pode ser usada de forma concreta para gerar impacto positivo, democratizando o acesso à energia limpa por meio do uso inteligente de:
- Inteligência Artificial
- OCR
- Dados climáticos abertos

---

## Tecnologias Utilizadas

- Backend: Ruby on Rails
- Frontend: Vue.js + CoffeeScript
- OCR: Tesseract + IA via OpenAI
- Clima: OpenWeatherMap API
- Gráficos: Chartkick / ApexCharts (personalizável)
- Infraestrutura: PostgreSQL, Heroku/Docker

---

## Status do Projeto

Em desenvolvimento ativo.  
Planejamento contínuo de novas funcionalidades como:
- Simulação com múltiplas filiais
- Exportação de relatórios
- Plano de assinatura com Stripe

## Licença

Este projeto está licenciado sob a [MIT License](LICENSE).

