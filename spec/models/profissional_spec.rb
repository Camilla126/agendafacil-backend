require "rails_helper"

RSpec.describe Profissional, type: :model do
  it "gera o slug a partir do nome" do
    profissional = create(:profissional, nome: "Ana Silva")
    expect(profissional.slug).to eq("ana-silva")
  end

  it "desambigua o slug quando já existe um igual" do
    create(:profissional, nome: "Ana Silva")
    outra = create(:profissional, nome: "Ana Silva")

    expect(outra.slug).to eq("ana-silva-2")
  end

  it "não permite dois profissionais com o mesmo email" do
    create(:profissional, email: "ana@example.com")
    duplicado = build(:profissional, email: "ana@example.com")

    expect(duplicado).not_to be_valid
  end

  it "autentica com a senha correta e rejeita a incorreta" do
    profissional = create(:profissional, senha: "segredo123")

    expect(profissional.authenticate_senha("segredo123")).to eq(profissional)
    expect(profissional.authenticate_senha("errada")).to be false
  end

  it "exige senha com pelo menos 6 caracteres" do
    profissional = build(:profissional, senha: "123")
    expect(profissional).not_to be_valid
  end
end
