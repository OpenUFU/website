document.addEventListener('DOMContentLoaded', () => {
    // 1. Simple Scroll Reveal Animation using Intersection Observer
    const revealElements = document.querySelectorAll('.reveal');
    
    const revealOptions = {
        threshold: 0.1,
        rootMargin: "0px 0px -50px 0px"
    };

    const revealObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('active');
                observer.unobserve(entry.target); // Animate only once
            }
        });
    }, revealOptions);

    revealElements.forEach(el => {
        revealObserver.observe(el);
    });

    // 2. CPF mask + validation on blur
    const cpfInput = document.getElementById('cpf');
    if (cpfInput) {
        function formatCPF(digits) {
            return digits.replace(/(\d{3})(\d{3})(\d{3})(\d{2})/, '$1.$2.$3-$4');
        }

        function isValidCPF(digits) {
            if (digits.length !== 11 || /^(\d)\1{10}$/.test(digits)) return false;
            let sum = 0;
            for (let i = 0; i < 9; i++) sum += parseInt(digits[i]) * (10 - i);
            let r = (sum * 10) % 11;
            if (r === 10 || r === 11) r = 0;
            if (r !== parseInt(digits[9])) return false;
            sum = 0;
            for (let i = 0; i < 10; i++) sum += parseInt(digits[i]) * (11 - i);
            r = (sum * 10) % 11;
            if (r === 10 || r === 11) r = 0;
            return r === parseInt(digits[10]);
        }

        let cpfError = document.createElement('span');
        cpfError.className = 'field-error';
        cpfError.style.cssText = 'color:#e53e3e;font-size:0.85rem;margin-top:4px;display:none;';
        cpfInput.parentNode.appendChild(cpfError);

        cpfInput.addEventListener('blur', () => {
            const digits = cpfInput.value.replace(/\D/g, '').slice(0, 11);
            if (digits.length === 0) return;
            cpfInput.value = formatCPF(digits);
            if (!isValidCPF(digits)) {
                cpfError.textContent = 'CPF inválido.';
                cpfError.style.display = 'block';
                cpfInput.style.borderColor = '#e53e3e';
            } else {
                cpfError.style.display = 'none';
                cpfInput.style.borderColor = '';
            }
        });

        cpfInput.addEventListener('focus', () => {
            cpfError.style.display = 'none';
            cpfInput.style.borderColor = '';
        });
    }

    // 3. Navbar minimal border effect on scroll
    const navbar = document.querySelector('.navbar');
    
    window.addEventListener('scroll', () => {
        if (window.scrollY > 20) {
            navbar.style.boxShadow = '0 2px 10px rgba(0,0,0,0.05)';
            navbar.style.borderBottom = 'none';
        } else {
            navbar.style.boxShadow = 'none';
            navbar.style.borderBottom = '1px solid var(--border-color)';
        }
    });
});
