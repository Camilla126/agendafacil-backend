require "rails_helper"

RSpec.describe Agendamento, type: :model do
  let(:profissional) { create(:profissional) }
  let(:servico_30min) { create(:servico, profissional: profissional, duracao_minutos: 30) }
  let(:data) { Date.new(2026, 9, 1) }

  def novo_agendamento(servico:, hora_inicio:, cliente_email: "outro@example.com")
    build(:agendamento,
          profissional: profissional,
          servico: servico,
          data: data,
          hora_inicio: hora_inicio,
          cliente_email: cliente_email)
  end

  it "calcula hora_fim a partir da duração do serviço" do
    agendamento = novo_agendamento(servico: servico_30min, hora_inicio: "09:00")
    agendamento.save!

    expect(agendamento.hora_fim.strftime("%H:%M")).to eq("09:30")
  end

  describe "validação de conflito de horário" do
    before { create(:agendamento, profissional: profissional, servico: servico_30min, data: data, hora_inicio: "09:00") }

    it "permite um agendamento que encaixa exatamente antes" do
      agendamento = novo_agendamento(servico: servico_30min, hora_inicio: "08:30")
      expect(agendamento).to be_valid
    end

    it "permite um agendamento que encaixa exatamente depois" do
      agendamento = novo_agendamento(servico: servico_30min, hora_inicio: "09:30")
      expect(agendamento).to be_valid
    end

    it "rejeita sobreposição parcial no início do existente" do
      agendamento = novo_agendamento(servico: create(:servico, profissional: profissional, duracao_minutos: 30), hora_inicio: "08:45")
      expect(agendamento).not_to be_valid
      expect(agendamento.errors[:base]).to include("conflita com outro agendamento existente")
    end

    it "rejeita sobreposição parcial no fim do existente" do
      agendamento = novo_agendamento(servico: servico_30min, hora_inicio: "09:15")
      expect(agendamento).not_to be_valid
    end

    it "rejeita um novo agendamento contido dentro do existente" do
      servico_10min = create(:servico, profissional: profissional, duracao_minutos: 10)
      agendamento = novo_agendamento(servico: servico_10min, hora_inicio: "09:10")
      expect(agendamento).not_to be_valid
    end

    it "rejeita um novo agendamento que contém o existente" do
      servico_60min = create(:servico, profissional: profissional, duracao_minutos: 60)
      agendamento = novo_agendamento(servico: servico_60min, hora_inicio: "08:30")
      expect(agendamento).not_to be_valid
    end

    it "não considera agendamentos cancelados como conflito" do
      Agendamento.first.update!(status: :cancelado)
      agendamento = novo_agendamento(servico: servico_30min, hora_inicio: "09:00")
      expect(agendamento).to be_valid
    end

    it "não considera conflito com outro profissional" do
      outro_profissional = create(:profissional)
      outro_servico = create(:servico, profissional: outro_profissional, duracao_minutos: 30)
      agendamento = build(:agendamento, profissional: outro_profissional, servico: outro_servico, data: data, hora_inicio: "09:00")
      expect(agendamento).to be_valid
    end
  end
end
