module Api
  module V1
    class ServicosController < BaseController
      before_action :set_servico, only: [:update, :destroy]

      def index
        render json: profissional_atual.servicos.order(:nome)
      end

      def create
        servico = profissional_atual.servicos.new(servico_params)

        if servico.save
          render json: servico, status: :created
        else
          render json: { errors: servico.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @servico.update(servico_params)
          render json: @servico
        else
          render json: { errors: @servico.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @servico.destroy
        head :no_content
      end

      private

      def set_servico
        @servico = profissional_atual.servicos.find(params[:id])
      end

      def servico_params
        params.require(:servico).permit(:nome, :duracao_minutos, :valor)
      end
    end
  end
end
