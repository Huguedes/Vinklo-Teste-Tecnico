class User < ApplicationRecord
  validates :name, :email, :cpf, :phone, presence: true
  
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validate :validar_cpf

  private

  def validar_cpf
    return if cpf.blank?

    unless cpf_valido?(cpf)
      errors.add(:cpf, "não é válido")
    end
  end

  def cpf_valido?(cpf)
    cpf_limpo = cpf.gsub(/[^0-9]/, '')

    return false if cpf_limpo.length != 11

    return false if cpf_limpo.chars.all?{ |char| char == cpf_limpo[0] }

    digitos = cpf_limpo.chars.map(&:to_i)
    verificador_um = calcular_digito_verificador(digitos, 10)
    verificador_dois = calcular_digito_verificador(digitos, 11)

    verificador_um == digitos[9] && verificador_dois == digitos[10]
  end

  def calcular_digito_verificador(digitos, posicao)
    soma = digitos[0..(posicao - 2)].each_with_index.sum { |digito, index| digito * (posicao - index) }

    resto = soma % 11

    resto < 2 ? 0 : 11 - resto
  end

  
end
