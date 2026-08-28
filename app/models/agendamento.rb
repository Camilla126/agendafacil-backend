class Agendamento < ApplicationRecord
  belongs_to :profissional
  belongs_to :servico

  enum :status, { pendente: 0, confirmado: 1, cancelado: 2 }

  scope :ativos, -> { where.not(status: :cancelado) }

  validates :cliente_nome, presence: true
  validates :cliente_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :data, presence: true
  validates :hora_inicio, presence: true
  validates :hora_fim, presence: true
end
