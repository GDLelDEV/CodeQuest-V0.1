/* CodeQuest — main.js: menu lateral, alertas, senha e animações de entrada */
(function () {
  'use strict';

  // ----- Menu lateral (celular/tablet) -----
  var sidebar = document.getElementById('sidebar');
  var overlay = document.getElementById('overlay');
  var btn = document.getElementById('menuBtn');

  function alternarMenu(abrir) {
    if (!sidebar) return;
    sidebar.classList.toggle('aberta', abrir);
    if (overlay) overlay.classList.toggle('visivel', abrir);
    if (btn) btn.setAttribute('aria-expanded', String(abrir));
  }
  if (btn) btn.addEventListener('click', function () { alternarMenu(!sidebar.classList.contains('aberta')); });
  if (overlay) overlay.addEventListener('click', function () { alternarMenu(false); });
  document.addEventListener('keydown', function (e) { if (e.key === 'Escape') alternarMenu(false); });

  // ----- Fechar alertas -----
  document.addEventListener('click', function (e) {
    var fechar = e.target.closest('.alerta-fechar');
    if (fechar) fechar.parentElement.remove();
  });

  // ----- Mostrar/ocultar senha -----
  document.querySelectorAll('[data-toggle-senha]').forEach(function (b) {
    b.addEventListener('click', function () {
      var campo = document.getElementById(b.getAttribute('data-toggle-senha'));
      if (!campo) return;
      var mostrar = campo.type === 'password';
      campo.type = mostrar ? 'text' : 'password';
      b.setAttribute('aria-label', mostrar ? 'Ocultar senha' : 'Mostrar senha');
    });
  });

  // ----- Aviso imediato de confirmação de senha (a validação real é no servidor) -----
  var senha = document.getElementById('senha');
  var conf = document.getElementById('confirmar_senha');
  var aviso = document.getElementById('avisoSenha');
  if (senha && conf && aviso) {
    var checar = function () { aviso.hidden = conf.value === '' || conf.value === senha.value; };
    conf.addEventListener('input', checar);
    senha.addEventListener('input', checar);
  }

  // ----- Animação de entrada ao rolar a landing -----
  var itens = document.querySelectorAll('.revelar');
  if ('IntersectionObserver' in window && itens.length) {
    var obs = new IntersectionObserver(function (entradas) {
      entradas.forEach(function (en) {
        if (en.isIntersecting) { en.target.classList.add('visivel'); obs.unobserve(en.target); }
      });
    }, { threshold: 0.12 });
    itens.forEach(function (el) { obs.observe(el); });
  } else {
    itens.forEach(function (el) { el.classList.add('visivel'); });
  }
})();
