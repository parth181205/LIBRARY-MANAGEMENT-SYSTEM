/**
 * AMITY UNIVERSITY NOIDA - LIBRARY MANAGEMENT SYSTEM FRONTEND ENGINE
 * Vanilla JavaScript component interactions & security utilities
 */

document.addEventListener('DOMContentLoaded', function () {
    initPasswordToggles();
    initSidebarToggle();
    initPortalTabs();
    initModals();
    initDemoFillers();
});

/**
 * Show / Hide password visibility toggle
 */
function initPasswordToggles() {
    document.querySelectorAll('.toggle-password-btn').forEach(button => {
        button.addEventListener('click', function (e) {
            e.preventDefault();
            const targetId = this.getAttribute('data-target') || 'password';
            const input = document.getElementById(targetId);
            if (!input) return;

            if (input.type === 'password') {
                input.type = 'text';
                this.innerHTML = `
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                        <line x1="1" y1="1" x2="23" y2="23"></line>
                    </svg>
                `;
            } else {
                input.type = 'password';
                this.innerHTML = `
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                        <circle cx="12" cy="12" r="3"></circle>
                    </svg>
                `;
            }
        });
    });
}

/**
 * Mobile sidebar drawer toggle
 */
function initSidebarToggle() {
    const toggleBtn = document.querySelector('.mobile-menu-toggle');
    const sidebar = document.querySelector('.app-sidebar');

    if (toggleBtn && sidebar) {
        toggleBtn.addEventListener('click', function () {
            sidebar.classList.toggle('open');
        });

        // Close when clicking outside on mobile
        document.addEventListener('click', function (e) {
            if (sidebar.classList.contains('open') && !sidebar.contains(e.target) && !toggleBtn.contains(e.target)) {
                sidebar.classList.remove('open');
            }
        });
    }
}

/**
 * Role tab switcher on login screen
 */
function initPortalTabs() {
    const tabButtons = document.querySelectorAll('.portal-tab-btn');
    const identifierInput = document.getElementById('identifier');
    const identifierLabel = document.getElementById('identifierLabel');

    tabButtons.forEach(btn => {
        btn.addEventListener('click', function () {
            tabButtons.forEach(b => b.classList.remove('active'));
            this.classList.add('active');

            const role = this.getAttribute('data-role');
            if (identifierLabel) {
                if (role === 'student') {
                    identifierLabel.textContent = 'Enrollment Number / Student Email';
                    if (identifierInput) identifierInput.placeholder = 'e.g., A2305221001 or student@amity.edu';
                } else if (role === 'librarian') {
                    identifierLabel.textContent = 'Librarian Employee ID / Email';
                    if (identifierInput) identifierInput.placeholder = 'e.g., LIB-2001 or librarian@amity.edu';
                } else {
                    identifierLabel.textContent = 'Admin ID / Official Email';
                    if (identifierInput) identifierInput.placeholder = 'e.g., ADM-1001 or admin@amity.edu';
                }
            }
        });
    });
}

/**
 * Modals open/close handling
 */
function initModals() {
    document.querySelectorAll('[data-modal-open]').forEach(trigger => {
        trigger.addEventListener('click', function (e) {
            e.preventDefault();
            const modalId = this.getAttribute('data-modal-open');
            const modal = document.getElementById(modalId);
            if (modal) modal.style.display = 'flex';
        });
    });

    document.querySelectorAll('[data-modal-close]').forEach(closer => {
        closer.addEventListener('click', function () {
            const modal = this.closest('.modal-backdrop');
            if (modal) modal.style.display = 'none';
        });
    });
}

/**
 * Demo 1-Click Credential Quick Fillers for University Evaluation
 */
function initDemoFillers() {
    document.querySelectorAll('.btn-demo-fill').forEach(btn => {
        btn.addEventListener('click', function () {
            const id = this.getAttribute('data-id');
            const pass = this.getAttribute('data-pass');
            const role = this.getAttribute('data-role');

            const idInput = document.getElementById('identifier');
            const passInput = document.getElementById('password');

            if (idInput && passInput) {
                idInput.value = id;
                passInput.value = pass;

                // switch tab
                const tab = document.querySelector(`.portal-tab-btn[data-role="${role}"]`);
                if (tab) tab.click();
            }
        });
    });
}

/**
 * Cloudflare Turnstile Callback Handlers
 */
window.onTurnstileSuccess = function (token) {
    const errorEl = document.getElementById('turnstile-error');
    if (errorEl) errorEl.style.display = 'none';
};

window.onTurnstileExpired = function () {
    const errorEl = document.getElementById('turnstile-error');
    if (errorEl) {
        errorEl.textContent = 'Security challenge expired. Please complete the verification again.';
        errorEl.style.display = 'block';
    }
};

window.onTurnstileError = function () {
    const errorEl = document.getElementById('turnstile-error');
    if (errorEl) {
        errorEl.textContent = 'Unable to connect to Cloudflare Turnstile. Please check your internet connection.';
        errorEl.style.display = 'block';
    }
};
