require "rails_helper"

RSpec.describe "POST /api/v1/login", type: :request do
  let!(:profissional) { create(:profissional, email: "ana@example.com", senha: "segredo123") }

  it "retorna um token com credenciais válidas" do
    post "/api/v1/login", params: { email: "ana@example.com", senha: "segredo123" }

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)["token"]).to be_present
  end

  it "retorna 401 com senha incorreta" do
    post "/api/v1/login", params: { email: "ana@example.com", senha: "errada" }

    expect(response).to have_http_status(:unauthorized)
  end

  it "retorna 401 para email inexistente" do
    post "/api/v1/login", params: { email: "ninguem@example.com", senha: "segredo123" }

    expect(response).to have_http_status(:unauthorized)
  end
end
