class RegistrationController < ApplicationController
  before_action :authenticate_admin!, only: :show

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

  def authenticate_admin!
    credentials = ActionController::HttpAuthentication::Basic.user_name_and_password(request)
    expected_user = ENV.fetch("ADMIN_USER", "admin")
    expected_pass = ENV.fetch("ADMIN_PASSWORD", nil)

    unless expected_pass &&
           ActiveSupport::SecurityUtils.secure_compare(credentials&.first.to_s, expected_user) &&
           ActiveSupport::SecurityUtils.secure_compare(credentials&.last.to_s, expected_pass)
      request_http_basic_authentication("OpenUFU Admin")
    end
  end

  def registration_params
    params.require(:registration).permit(:nome_completo, :cpf, :curso, :matricula, :periodo, :email, :contribuicao)
  end
end
