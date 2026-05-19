require "test_helper"

class RegistrationControllerTest < ActionDispatch::IntegrationTest
  def valid_params
    {
      registration: {
        nome_completo: "Carlos Teste",
        cpf: "111.222.333-44",
        curso: "Sistemas de Informação",
        matricula: "11911SI999",
        periodo: "5",
        email: "carlos.teste@ufu.br",
        contribuicao: "Quero ajudar no projeto."
      }
    }
  end

  # ─── GET /registration ───────────────────────────────────────────────────────

  test "GET /registration renderiza o formulário" do
    get "/registration"
    assert_response :ok
    assert_select "form"
    assert_select "input[name='registration[nome_completo]']"
    assert_select "input[name='registration[email]']"
    assert_select "input[name='registration[cpf]']"
    assert_select "input[name='registration[curso]']"
    assert_select "input[name='registration[matricula]']"
    assert_select "input[name='registration[periodo]']"
    assert_select "textarea[name='registration[contribuicao]']"
  end

  # ─── POST /registration — sucesso ────────────────────────────────────────────

  test "POST válido cria registro e redireciona" do
    assert_difference "Registration.count", 1 do
      post "/registration", params: valid_params
    end
    assert_redirected_to "/registration"
  end

  test "mensagem de sucesso está presente no flash após redirect" do
    post "/registration", params: valid_params
    follow_redirect!
    assert_match /sucesso/i, response.body
  end

  test "dados são persistidos corretamente no banco" do
    post "/registration", params: valid_params
    r = Registration.find_by!(email: "carlos.teste@ufu.br")
    assert_equal "Carlos Teste", r.nome_completo
    assert_equal "111.222.333-44", r.cpf
    assert_equal "11911SI999", r.matricula
  end

  # ─── POST /registration — falhas de validação ─────────────────────────────────

  test "POST sem nome_completo não cria registro e retorna 422" do
    params = valid_params.deep_merge(registration: { nome_completo: "" })
    assert_no_difference "Registration.count" do
      post "/registration", params: params
    end
    assert_response :unprocessable_entity
  end

  test "POST sem email não cria registro e retorna 422" do
    params = valid_params.deep_merge(registration: { email: "" })
    assert_no_difference "Registration.count" do
      post "/registration", params: params
    end
    assert_response :unprocessable_entity
  end

  test "POST com email inválido não cria registro e retorna 422" do
    params = valid_params.deep_merge(registration: { email: "nao-e-email" })
    assert_no_difference "Registration.count" do
      post "/registration", params: params
    end
    assert_response :unprocessable_entity
  end

  test "POST sem cpf não cria registro e retorna 422" do
    params = valid_params.deep_merge(registration: { cpf: "" })
    assert_no_difference "Registration.count" do
      post "/registration", params: params
    end
    assert_response :unprocessable_entity
  end

  test "POST sem matricula não cria registro e retorna 422" do
    params = valid_params.deep_merge(registration: { matricula: "" })
    assert_no_difference "Registration.count" do
      post "/registration", params: params
    end
    assert_response :unprocessable_entity
  end

  test "POST sem periodo não cria registro e retorna 422" do
    params = valid_params.deep_merge(registration: { periodo: "" })
    assert_no_difference "Registration.count" do
      post "/registration", params: params
    end
    assert_response :unprocessable_entity
  end

  test "POST sem curso não cria registro e retorna 422" do
    params = valid_params.deep_merge(registration: { curso: "" })
    assert_no_difference "Registration.count" do
      post "/registration", params: params
    end
    assert_response :unprocessable_entity
  end

  # ─── POST /registration — unicidade ──────────────────────────────────────────

  test "POST com cpf duplicado não cria segundo registro" do
    post "/registration", params: valid_params
    assert_no_difference "Registration.count" do
      post "/registration", params: valid_params.deep_merge(registration: { matricula: "OUTRO001" })
    end
    assert_response :unprocessable_entity
  end

  test "POST com matricula duplicada não cria segundo registro" do
    post "/registration", params: valid_params
    assert_no_difference "Registration.count" do
      post "/registration", params: valid_params.deep_merge(registration: { cpf: "999.888.777-66" })
    end
    assert_response :unprocessable_entity
  end

  # ─── POST /registration — parâmetros não permitidos (mass assignment) ─────────

  test "parâmetro id externo não é aceito (proteção contra mass assignment)" do
    post "/registration", params: valid_params.deep_merge(registration: { id: 9999 })
    assert_not_equal 9999, Registration.last&.id
  end

  # ─── POST sem body de registration ───────────────────────────────────────────

  test "POST sem o namespace registration retorna bad request ou 422" do
    assert_no_difference "Registration.count" do
      post "/registration", params: { nome_completo: "Teste" }
    end
    assert_includes [ 400, 422 ], response.status
  end

  # ─── POST /registration — validação de período server-side ───────────────────

  test "POST com período fora do intervalo (15) retorna 422" do
    params = valid_params.deep_merge(registration: { periodo: "15" })
    assert_no_difference "Registration.count" do
      post "/registration", params: params
    end
    assert_response :unprocessable_entity
  end

  test "POST com período zero retorna 422" do
    params = valid_params.deep_merge(registration: { periodo: "0" })
    assert_no_difference "Registration.count" do
      post "/registration", params: params
    end
    assert_response :unprocessable_entity
  end

  test "POST com período como texto retorna 422" do
    params = valid_params.deep_merge(registration: { periodo: "abc" })
    assert_no_difference "Registration.count" do
      post "/registration", params: params
    end
    assert_response :unprocessable_entity
  end

  # ─── POST /registration — unicidade de e-mail ────────────────────────────────

  test "POST com email duplicado não cria segundo registro" do
    post "/registration", params: valid_params
    assert_no_difference "Registration.count" do
      post "/registration", params: valid_params.deep_merge(
        registration: { cpf: "555.444.333-22", matricula: "OUTRO002" }
      )
    end
    assert_response :unprocessable_entity
  end

  # ─── GET /registration/show — autenticação obrigatória ───────────────────────

  test "GET /registration/show sem credenciais retorna 401" do
    get "/registration/show"
    assert_response :unauthorized
  end

  test "GET /registration/show com credenciais erradas retorna 401" do
    get "/registration/show",
        headers: { "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials("admin", "errado") }
    assert_response :unauthorized
  end

  test "GET /registration/show com credenciais corretas retorna JSON" do
    original_pass = ENV["ADMIN_PASSWORD"]
    ENV["ADMIN_PASSWORD"] = "s3cr3t"

    post "/registration", params: valid_params
    get "/registration/show",
        headers: { "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials("admin", "s3cr3t") }

    assert_response :ok
    assert_equal "application/json", response.content_type.split(";").first
    data = JSON.parse(response.body)
    assert data.is_a?(Array)
    assert data.any? { |r| r["email"] == "carlos.teste@ufu.br" }
  ensure
    ENV["ADMIN_PASSWORD"] = original_pass
  end

  # ─── headers de segurança ─────────────────────────────────────────────────────

  test "resposta inclui X-Content-Type-Options: nosniff" do
    get "/registration"
    assert_equal "nosniff", response.headers["X-Content-Type-Options"]
  end

  test "resposta inclui X-Frame-Options: DENY" do
    get "/registration"
    assert_equal "DENY", response.headers["X-Frame-Options"]
  end

  test "resposta inclui Referrer-Policy" do
    get "/registration"
    assert response.headers["Referrer-Policy"].present?
  end
end
