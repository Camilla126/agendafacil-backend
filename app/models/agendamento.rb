class Agendamento < ApplicationRecord
  belongs_to :profissional
  belongs_to :servico

  enum :status, { pendente: 0, confirmado: 1, cancelado: 2 }

  scope :ativos, -> { where.not(status: :cancelado) }

  before_validation :calcular_hora_fim, on: :create

  validates :cliente_nome, presence: true
  validates :cliente_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :data, presence: true
  validates :hora_inicio, presence: true
  validates :hora_fim, presence: true
  validate :sem_conflito_de_horario

  private

  def calcular_hora_fim
    return if hora_inicio.blank? || servico.blank?

    self.hora_fim = hora_inicio + servico.duracao_minutos.minutes
  end

  def sem_conflito_de_horario
    return if profissional.blank? || data.blank? || hora_inicio.blank? || hora_fim.blank?

    conflitantes = Agendamento.ativos.where(profissional_id: profissional_id, data: data).where.not(id: id)

    tem_conflito = conflitantes.any? do |agendamento|
      SobreposicaoDeHorario.sobrepoe?(hora_inicio, hora_fim, agendamento.hora_inicio, agendamento.hora_fim)
    end

    errors.add(:base, "conflita com outro agendamento existente") if tem_conflito
  end
end
