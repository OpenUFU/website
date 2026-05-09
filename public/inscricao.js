document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('inscricaoForm');
    const feedback = document.getElementById('formFeedback');

    if (form) {
        form.addEventListener('submit', async (e) => {
            e.preventDefault();

            const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
            const formData = new FormData(form);
            const payload = {
                registration: {
                    nome_completo: formData.get('nomeCompleto'),
                    cpf: formData.get('cpf'),
                    curso: formData.get('curso'),
                    matricula: formData.get('matricula'),
                    periodo: formData.get('periodo')
                }
            };

            const response = await fetch('/registration', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-Token': csrfToken,
                },
                body: JSON.stringify(payload),
            });

            if (response.ok) {
                form.style.display = 'none';
                feedback.classList.remove('hidden');
            }
        });
    }
});
