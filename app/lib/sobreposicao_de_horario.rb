module SobreposicaoDeHorario
  def self.sobrepoe?(inicio_a, fim_a, inicio_b, fim_b)
    inicio_a < fim_b && fim_a > inicio_b
  end
end
