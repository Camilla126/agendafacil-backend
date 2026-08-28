require "rails_helper"

RSpec.describe "rotas públicas de agendamento", type: :request do
  let(:profissional) { create(:profissional, nome: "Ana Silva") }
  let(:servico) { create(:servico, profissional: profissional, duracao_minutos: 30) }

  it "retorna os dados públicos do profissional" do
    servico

    get "/api/v1/publico/#{profissional.slug}"

    expect(response).to have_http_status(:ok)
    corpo = JSON.parse(response.body)
    expect(corpo["nome"]).to eq("Ana Silva")
    expect(corpo["servicos"].size).to eq(1)
  end

  it "retorna 404 para slug inexistente" do
    get "/api/v1/publico/nao-existe"
    expect(response).to have_http_status(:not_found)
  end

  it "cria um agendamento confirmado" do
    post "/api/v1/publico/#{profissional.slug}/agendamentos", params: {
      agendamento: {
        servico_id: servico.id,
        cliente_nome: "Bia Cliente",
        cliente_email: "bia@example.com",
        data: "2026-09-01",
        hora_inicio: "09:00"
      }
    }

    expect(response).to have_http_status(:created)
    expect(JSON.parse(response.body)["status"]).to eq("confirmado")
  end

  it "retorna 422 ao tentar agendar em cima de um horário já ocupado" do
    create(:agendamento, profissional: profissional, servico: servico, data: Date.new(2026, 9, 1), hora_inicio: "09:00")

    post "/api/v1/publico/#{profissional.slug}/agendamentos", params: {
      agendamento: {
        servico_id: servico.id,
        cliente_nome: "Caio",
        cliente_email: "caio@example.com",
        data: "2026-09-01",
        hora_inicio: "09:15"
      }
    }

    expect(response).to have_http_status(:unprocessable_content)
    expect(JSON.parse(response.body)["errors"]["base"]).to be_present
  end
end
