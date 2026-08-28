class Disponibilidade < ApplicationRecord
  DIAS_DA_SEMANA = (0..6).freeze

  belongs_to :profissional

  validates :dia_semana, presence: true, inclusion: { in: DIAS_DA_SEMANA }
  validates :hora_inicio, presence: true
  validates :hora_fim, presence: true
  validate :hora_fim_depois_da_hora_inicio

  private

  def hora_fim_depois_da_hora_inicio
    return if hora_inicio.blank? || hora_fim.blank?

    errors.add(:hora_fim, "deve ser depois da hora de início") if hora_fim <= hora_inicio
  end
end
