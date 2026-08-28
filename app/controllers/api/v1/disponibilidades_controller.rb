module Api
  module V1
    class DisponibilidadesController < BaseController
      def index
        render json: profissional_atual.disponibilidades.order(:dia_semana, :hora_inicio)
      end

      def create
        disponibilidade = profissional_atual.disponibilidades.new(disponibilidade_params)

        if disponibilidade.save
          render json: disponibilidade, status: :created
        else
          render json: { errors: disponibilidade.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        disponibilidade = profissional_atual.disponibilidades.find(params[:id])
        disponibilidade.destroy
        head :no_content
      end

      private

      def disponibilidade_params
        params.require(:disponibilidade).permit(:dia_semana, :hora_inicio, :hora_fim)
      end
    end
  end
end
