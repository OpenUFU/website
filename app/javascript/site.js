document.addEventListener('turbo:load', () => {
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

    // 2. Navbar minimal border effect on scroll
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
