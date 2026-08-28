module Api
  module V1
    class AgendamentosController < BaseController
      def index
        render json: profissional_atual.agendamentos.order(:data, :hora_inicio)
      end

      def cancelar
        agendamento = profissional_atual.agendamentos.find(params[:id])
        agendamento.update!(status: :cancelado)
        render json: agendamento
      rescue ActiveRecord::RecordNotFound
        render json: { errors: { base: ["não encontrado"] } }, status: :not_found
      end
    end
  end
end
