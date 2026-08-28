FactoryBot.define do
  factory :disponibilidade do
    profissional
    dia_semana { 2 }
    hora_inicio { "09:00" }
    hora_fim { "18:00" }
  end
end
