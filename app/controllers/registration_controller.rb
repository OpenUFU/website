class RegistrationController < ApplicationController
  def index
    render template: "pages/registration"
  end

  def create
    registration = Registration.new(registration_params)
    if registration.save
      redirect_to "/registration", notice: "Inscrição recebida com sucesso! Em breve entraremos em contato."
    else
      render template: "pages/registration", status: :unprocessable_entity
    end
  end

  def show
    @registrations = Registration.all
    render json: @registrations
  end

  private

  def registration_params
    params.require(:registration).permit(:nome_completo, :cpf, :curso, :matricula, :periodo, :email)
  end
end
