FactoryBot.define do
  factory :agendamento do
    profissional
    servico { association :servico, profissional: profissional }
    cliente_nome { "Cliente Teste" }
    cliente_email { "cliente@example.com" }
    data { Date.new(2026, 9, 1) }
    hora_inicio { "09:00" }
    status { :confirmado }
  end
end
