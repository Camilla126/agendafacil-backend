require "rails_helper"

RSpec.describe HorariosLivres do
  let(:profissional) { create(:profissional) }
  let(:servico) { create(:servico, profissional: profissional, duracao_minutos: 30) }
  let(:terca) { Date.new(2026, 9, 1) } # dia_semana == 2

  def horas(resultado)
    resultado.map { |h| h.strftime("%H:%M") }
  end

  it "retorna slots vazios sem disponibilidade cadastrada" do
    resultado = described_class.calcular(profissional: profissional, servico: servico, data: terca)
    expect(resultado).to eq([])
  end

  it "gera slots do tamanho da duração do serviço dentro da disponibilidade" do
    create(:disponibilidade, profissional: profissional, dia_semana: 2, hora_inicio: "09:00", hora_fim: "10:00")

    resultado = described_class.calcular(profissional: profissional, servico: servico, data: terca)

    expect(horas(resultado)).to eq(["09:00", "09:30"])
  end

  it "exclui slots que colidem com agendamentos ativos" do
    create(:disponibilidade, profissional: profissional, dia_semana: 2, hora_inicio: "09:00", hora_fim: "10:00")
    create(:agendamento, profissional: profissional, servico: servico, data: terca, hora_inicio: "09:00")

    resultado = described_class.calcular(profissional: profissional, servico: servico, data: terca)

    expect(horas(resultado)).to eq(["09:30"])
  end

  it "não considera agendamento cancelado" do
    create(:disponibilidade, profissional: profissional, dia_semana: 2, hora_inicio: "09:00", hora_fim: "10:00")
    create(:agendamento, profissional: profissional, servico: servico, data: terca, hora_inicio: "09:00", status: :cancelado)

    resultado = described_class.calcular(profissional: profissional, servico: servico, data: terca)

    expect(horas(resultado)).to eq(["09:00", "09:30"])
  end

  it "ignora disponibilidade de outro dia da semana" do
    create(:disponibilidade, profissional: profissional, dia_semana: 3, hora_inicio: "09:00", hora_fim: "10:00")

    resultado = described_class.calcular(profissional: profissional, servico: servico, data: terca)

    expect(resultado).to eq([])
  end
end
