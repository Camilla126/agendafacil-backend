module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :autenticar_profissional!
  end

  private

  def autenticar_profissional!
    token = token_do_header

    return render_nao_autorizado if token.blank?

    payload = JsonWebToken.decode(token)
    return render_nao_autorizado if payload.blank?

    @profissional_atual = Profissional.find_by(id: payload[:profissional_id])
    render_nao_autorizado if @profissional_atual.nil?
  end

  def profissional_atual
    @profissional_atual
  end

  def token_do_header
    header = request.headers["Authorization"]
    header&.split(" ")&.last
  end

  def render_nao_autorizado
    render json: { errors: { base: ["não autorizado"] } }, status: :unauthorized
  end
end
