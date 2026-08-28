FactoryBot.define do
  factory :agendamento do
    profissional { nil }
    servico { nil }
    cliente_nome { "MyString" }
    cliente_email { "MyString" }
    cliente_telefone { "MyString" }
    data { "2026-08-27" }
    hora_inicio { "2026-08-27 22:57:54" }
    hora_fim { "2026-08-27 22:57:54" }
    status { 1 }
  end
end
