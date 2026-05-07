document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('inscricaoForm');
    const feedback = document.getElementById('formFeedback');

    if (form) {
        form.addEventListener('submit', (e) => {
            e.preventDefault();

            // Extract form data
            const formData = new FormData(form);
            const payload = {
                nomeCompleto: formData.get('nomeCompleto'),
                cpf: formData.get('cpf'),
                curso: formData.get('curso'),
                matricula: formData.get('matricula'),
                periodo: formData.get('periodo')
            };

            // Log the JSON payload (acting as the frontend delivery)
            console.log('--- Novo Registro de Inscrição ---');
            console.log(JSON.stringify(payload, null, 2));

            // Hide form and show success message
            form.style.display = 'none';
            feedback.classList.remove('hidden');
        });
    }
});
