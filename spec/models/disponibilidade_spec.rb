require "rails_helper"

RSpec.describe Disponibilidade, type: :model do
  it "exige que hora_fim seja depois de hora_inicio" do
    disponibilidade = build(:disponibilidade, hora_inicio: "18:00", hora_fim: "09:00")
    expect(disponibilidade).not_to be_valid
    expect(disponibilidade.errors[:hora_fim]).to be_present
  end

  it "rejeita dia_semana fora do intervalo 0..6" do
    disponibilidade = build(:disponibilidade, dia_semana: 7)
    expect(disponibilidade).not_to be_valid
  end
end
