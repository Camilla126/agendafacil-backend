module Api
  module V1
    class SessionsController < ApplicationController
      def create
        profissional = Profissional.find_by(email: params[:email].to_s.downcase)

        if profissional&.authenticate_senha(params[:senha])
          token = JsonWebToken.encode(profissional_id: profissional.id)
          render json: { token: token, profissional: perfil(profissional) }, status: :ok
        else
          render json: { errors: { base: ["email ou senha inválidos"] } }, status: :unauthorized
        end
      end

      private

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
