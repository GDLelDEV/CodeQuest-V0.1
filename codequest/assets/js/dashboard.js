/* CodeQuest — dashboard.js: anima barras de progresso e contadores */
(function () {
  'use strict';
  var reduzir = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  if (reduzir) return;

  // Barras: partem de 0 e crescem até o valor real (já vindo do servidor).
  document.querySelectorAll('.barra-fill[data-valor]').forEach(function (barra) {
    var alvo = barra.getAttribute('data-valor') + '%';
    barra.style.width = '0%';
    requestAnimationFrame(function () {
      requestAnimationFrame(function () { barra.style.width = alvo; });
    });
  });

  // Contadores: sobem de 0 até o número exibido.
  document.querySelectorAll('[data-contar]').forEach(function (el) {
    var alvo = parseInt(el.getAttribute('data-contar'), 10);
    if (isNaN(alvo) || alvo <= 0) return;
    var inicio = null, duracao = 900;
    function passo(t) {
      if (inicio === null) inicio = t;
      var p = Math.min((t - inicio) / duracao, 1);
      el.textContent = Math.round(alvo * (1 - Math.pow(1 - p, 3)));
      if (p < 1) requestAnimationFrame(passo);
    }
    requestAnimationFrame(passo);
  });
})();
