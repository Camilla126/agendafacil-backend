class HorariosLivres
  def self.calcular(profissional:, servico:, data:)
    duracao = servico.duracao_minutos.minutes
    agendamentos = profissional.agendamentos.ativos.where(data: data).to_a

    profissional.disponibilidades.where(dia_semana: data.wday).order(:hora_inicio).flat_map do |disponibilidade|
      slots_do_bloco(disponibilidade, duracao, agendamentos)
    end
  end

  def self.slots_do_bloco(disponibilidade, duracao, agendamentos)
    horario = disponibilidade.hora_inicio
    slots = []

    while horario + duracao <= disponibilidade.hora_fim
      fim_do_slot = horario + duracao

      livre = agendamentos.none? do |agendamento|
        SobreposicaoDeHorario.sobrepoe?(horario, fim_do_slot, agendamento.hora_inicio, agendamento.hora_fim)
      end

      slots << horario if livre
      horario += duracao
    end

    slots
  end
  private_class_method :slots_do_bloco
end
