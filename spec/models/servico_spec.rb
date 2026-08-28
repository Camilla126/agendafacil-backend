require "rails_helper"

RSpec.describe Servico, type: :model do
  it "exige nome e duração maior que zero" do
    servico = build(:servico, nome: "", duracao_minutos: 0)
    expect(servico).not_to be_valid
    expect(servico.errors[:nome]).to be_present
    expect(servico.errors[:duracao_minutos]).to be_present
  end

  it "aceita valor em branco" do
    servico = build(:servico, valor: nil)
    expect(servico).to be_valid
  end
end
