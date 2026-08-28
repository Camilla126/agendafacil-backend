class Servico < ApplicationRecord
  belongs_to :profissional
  has_many :agendamentos, dependent: :destroy

  validates :nome, presence: true
  validates :duracao_minutos, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :valor, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
