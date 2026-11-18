/* CodeQuest — aula.js: copiar código e evitar duplo clique ao concluir */
(function () {
  'use strict';

  document.querySelectorAll('[data-copiar]').forEach(function (btn) {
    btn.addEventListener('click', function () {
      var alvo = document.getElementById(btn.getAttribute('data-copiar'));
      if (!alvo) return;
      var texto = alvo.textContent;
      var ok = function () {
        btn.textContent = 'Copiado ✔';
        setTimeout(function () { btn.textContent = 'Copiar'; }, 1800);
      };
      if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(texto).then(ok);
      } else {
        var t = document.createElement('textarea');
        t.value = texto; document.body.appendChild(t); t.select();
        try { document.execCommand('copy'); ok(); } catch (e) {}
        document.body.removeChild(t);
      }
    });
  });

  var form = document.querySelector('.form-concluir');
  if (form) {
    form.addEventListener('submit', function () {
      var b = form.querySelector('button[type="submit"]');
      if (b) { b.disabled = true; b.textContent = 'Salvando...'; }
    });
  }
})();
