require "test_helper"

class RegistrationTest < ActiveSupport::TestCase
  def valid_attrs
    {
      nome_completo: "Carlos Teste",
      cpf: "111.222.333-44",
      curso: "Sistemas de Informação",
      matricula: "11911SI999",
      periodo: "5",
      email: "carlos.teste@ufu.br"
    }
  end

  # ─── presença ────────────────────────────────────────────────────────────────

  test "válido com todos os atributos obrigatórios" do
    assert Registration.new(valid_attrs).valid?
  end

  test "inválido sem nome_completo" do
    r = Registration.new(valid_attrs.merge(nome_completo: ""))
    assert_not r.valid?
    assert_includes r.errors[:nome_completo], "can't be blank"
  end

  test "inválido sem cpf" do
    r = Registration.new(valid_attrs.merge(cpf: ""))
    assert_not r.valid?
    assert_includes r.errors[:cpf], "can't be blank"
  end

  test "inválido sem curso" do
    r = Registration.new(valid_attrs.merge(curso: ""))
    assert_not r.valid?
    assert_includes r.errors[:curso], "can't be blank"
  end

  test "inválido sem matricula" do
    r = Registration.new(valid_attrs.merge(matricula: ""))
    assert_not r.valid?
    assert_includes r.errors[:matricula], "can't be blank"
  end

  test "inválido sem periodo" do
    r = Registration.new(valid_attrs.merge(periodo: ""))
    assert_not r.valid?
    assert_includes r.errors[:periodo], "can't be blank"
  end

  test "inválido sem email" do
    r = Registration.new(valid_attrs.merge(email: ""))
    assert_not r.valid?
    assert_includes r.errors[:email], "can't be blank"
  end

  # ─── unicidade ───────────────────────────────────────────────────────────────

  test "inválido com cpf duplicado" do
    Registration.create!(valid_attrs)
    dup = Registration.new(valid_attrs.merge(matricula: "DUPL999", email: "dup@ufu.br"))
    assert_not dup.valid?
    assert_includes dup.errors[:cpf], "has already been taken"
  end

  test "inválido com matricula duplicada" do
    Registration.create!(valid_attrs)
    dup = Registration.new(valid_attrs.merge(cpf: "999.111.222-33", email: "dup2@ufu.br"))
    assert_not dup.valid?
    assert_includes dup.errors[:matricula], "has already been taken"
  end

  test "dois registros com cpf idêntico são rejeitados" do
    Registration.create!(valid_attrs)
    dup = Registration.new(valid_attrs.merge(matricula: "OUTRO999", email: "outro@ufu.br"))
    assert_not dup.valid?
  end

  test "dois registros com matricula idêntica são rejeitados" do
    Registration.create!(valid_attrs)
    dup = Registration.new(valid_attrs.merge(cpf: "999.888.777-66", email: "outro2@ufu.br"))
    assert_not dup.valid?
  end

  # ─── formato de e-mail ────────────────────────────────────────────────────────

  test "email válido com domínio comum" do
    assert Registration.new(valid_attrs.merge(email: "aluno@ufu.br")).valid?
  end

  test "inválido: email sem @" do
    r = Registration.new(valid_attrs.merge(email: "semdominio"))
    assert_not r.valid?
    assert r.errors[:email].any?
  end

  test "inválido: email sem domínio após @" do
    r = Registration.new(valid_attrs.merge(email: "usuario@"))
    assert_not r.valid?
    assert r.errors[:email].any?
  end

  test "inválido: email só com espaços" do
    r = Registration.new(valid_attrs.merge(email: "   "))
    assert_not r.valid?
    assert r.errors[:email].any?
  end

  test "inválido: email com espaço interno" do
    r = Registration.new(valid_attrs.merge(email: "joao silva@ufu.br"))
    assert_not r.valid?
    assert r.errors[:email].any?
  end

  # ─── unicidade de email ───────────────────────────────────────────────────────

  test "inválido com email duplicado" do
    Registration.create!(valid_attrs)
    dup = Registration.new(valid_attrs.merge(cpf: "999.888.777-00", matricula: "OUTRO001"))
    assert_not dup.valid?
    assert_includes dup.errors[:email], "has already been taken"
  end

  # ─── validação de periodo ─────────────────────────────────────────────────────

  test "período numérico válido" do
    assert Registration.new(valid_attrs.merge(periodo: "7")).valid?
  end

  test "período = 1 (mínimo) é válido" do
    assert Registration.new(valid_attrs.merge(periodo: "1")).valid?
  end

  test "período = 14 (máximo) é válido" do
    assert Registration.new(valid_attrs.merge(periodo: "14")).valid?
  end

  test "período 0 é inválido" do
    r = Registration.new(valid_attrs.merge(periodo: "0"))
    assert_not r.valid?
    assert r.errors[:periodo].any?
  end

  test "período 15 é inválido" do
    r = Registration.new(valid_attrs.merge(periodo: "15"))
    assert_not r.valid?
    assert r.errors[:periodo].any?
  end

  test "período negativo é inválido" do
    r = Registration.new(valid_attrs.merge(periodo: "-1"))
    assert_not r.valid?
    assert r.errors[:periodo].any?
  end

  test "período com texto é inválido" do
    r = Registration.new(valid_attrs.merge(periodo: "abc"))
    assert_not r.valid?
    assert r.errors[:periodo].any?
  end

  # ─── campo contribuicao (opcional no modelo) ─────────────────────────────────

  test "válido sem contribuicao (campo opcional)" do
    assert Registration.new(valid_attrs.merge(contribuicao: nil)).valid?
  end

  test "válido com contribuicao preenchida" do
    assert Registration.new(valid_attrs.merge(contribuicao: "Quero ajudar com design.")).valid?
  end

  test "contribuicao acima de 5000 caracteres é inválida" do
    r = Registration.new(valid_attrs.merge(contribuicao: "x" * 5001))
    assert_not r.valid?
    assert r.errors[:contribuicao].any?
  end

  test "contribuicao com exatamente 5000 caracteres é válida" do
    assert Registration.new(valid_attrs.merge(contribuicao: "x" * 5000)).valid?
  end

  # ─── persistência ────────────────────────────────────────────────────────────

  test "salva no banco com atributos válidos" do
    assert_difference "Registration.count", 1 do
      Registration.create!(valid_attrs)
    end
  end

  test "não salva no banco quando email é inválido" do
    assert_no_difference "Registration.count" do
      Registration.create(valid_attrs.merge(email: "invalido"))
    end
  end

  test "não salva no banco quando cpf está em branco" do
    assert_no_difference "Registration.count" do
      Registration.create(valid_attrs.merge(cpf: ""))
    end
  end
end
