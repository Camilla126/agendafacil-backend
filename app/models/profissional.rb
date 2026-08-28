class Profissional < ApplicationRecord
  has_secure_password :senha

  before_validation :gerar_slug, on: :create

  validates :nome, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                     format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :slug, presence: true, uniqueness: true
  validates :senha, length: { minimum: 6 }, if: -> { new_record? || !senha.nil? }

  before_save { self.email = email.downcase }

  private

  def gerar_slug
    return if slug.present?
    return if nome.blank?

    base = nome.to_s.parameterize
    candidato = base
    contador = 1

    while Profissional.exists?(slug: candidato)
      contador += 1
      candidato = "#{base}-#{contador}"
    end

    self.slug = candidato
  end
end
