FactoryBot.define do
  factory :servico do
    profissional
    nome { "Corte de cabelo" }
    duracao_minutos { 30 }
    valor { 50.0 }
  end
end
