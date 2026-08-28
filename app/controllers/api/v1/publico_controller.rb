module Api
  module V1
    class PublicoController < ApplicationController
      def show
        profissional = Profissional.find_by!(slug: params[:slug])
        render json: {
          nome: profissional.nome,
          slug: profissional.slug,
          servicos: profissional.servicos.order(:nome)
        }
      rescue ActiveRecord::RecordNotFound
        render_nao_encontrado
      end

      def horarios
        profissional = Profissional.find_by!(slug: params[:slug])
        servico = profissional.servicos.find(params[:servico_id])
        data = Date.parse(params[:data])

        horarios = HorariosLivres.calcular(profissional: profissional, servico: servico, data: data)
        render json: horarios.map { |horario| horario.strftime("%H:%M") }
      rescue ActiveRecord::RecordNotFound
        render_nao_encontrado
      rescue Date::Error, TypeError
        render json: { errors: { data: ["formato inválido, use YYYY-MM-DD"] } }, status: :unprocessable_entity
      end

      private

      def render_nao_encontrado
        render json: { errors: { base: ["não encontrado"] } }, status: :not_found
      end
    end
  end
end
