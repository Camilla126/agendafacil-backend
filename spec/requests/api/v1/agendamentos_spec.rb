require "rails_helper"

RSpec.describe "rotas autenticadas de /api/v1/agendamentos", type: :request do
  let(:profissional) { create(:profissional) }
  let(:token) { JsonWebToken.encode(profissional_id: profissional.id) }

  it "rejeita acesso sem token" do
    get "/api/v1/agendamentos"
    expect(response).to have_http_status(:unauthorized)
  end

  it "rejeita acesso com token inválido" do
    get "/api/v1/agendamentos", headers: { "Authorization" => "Bearer token-invalido" }
    expect(response).to have_http_status(:unauthorized)
  end

  it "lista os agendamentos do profissional autenticado" do
    servico = create(:servico, profissional: profissional)
    create(:agendamento, profissional: profissional, servico: servico)

    get "/api/v1/agendamentos", headers: { "Authorization" => "Bearer #{token}" }

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body).size).to eq(1)
  end

  it "cancela um agendamento" do
    servico = create(:servico, profissional: profissional)
    agendamento = create(:agendamento, profissional: profissional, servico: servico)

    patch "/api/v1/agendamentos/#{agendamento.id}/cancelar", headers: { "Authorization" => "Bearer #{token}" }

    expect(response).to have_http_status(:ok)
    expect(agendamento.reload.status).to eq("cancelado")
  end

  it "não deixa cancelar agendamento de outro profissional" do
    outro_profissional = create(:profissional)
    servico = create(:servico, profissional: outro_profissional)
    agendamento = create(:agendamento, profissional: outro_profissional, servico: servico)

    patch "/api/v1/agendamentos/#{agendamento.id}/cancelar", headers: { "Authorization" => "Bearer #{token}" }

    expect(response).to have_http_status(:not_found)
  end
end
