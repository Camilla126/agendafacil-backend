module Api
  module V1
    class ProfissionaisController < ApplicationController
      def create
        profissional = Profissional.new(profissional_params)

        if profissional.save
          render json: perfil(profissional), status: :created
        else
          render json: { errors: profissional.errors }, status: :unprocessable_content
        end
      end

      private

      def profissional_params
        params.require(:profissional).permit(:nome, :email, :senha)
      end

      def perfil(profissional)
        {
          id: profissional.id,
          nome: profissional.nome,
          email: profissional.email,
          slug: profissional.slug
        }
      end
    end
  end
end
