FactoryBot.define do
  factory :servico do
    profissional { nil }
    nome { "MyString" }
    duracao_minutos { 1 }
    valor { "9.99" }
  end
end
