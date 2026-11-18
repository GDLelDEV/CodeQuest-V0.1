  </main>
</div>
<script src="<?= e(url('assets/js/main.js')) ?>"></script>
<?php foreach (($js ?? []) as $arquivo_js): ?>
<script src="<?= e(url('assets/js/' . $arquivo_js)) ?>"></script>
<?php endforeach; ?>
</body>
</html>
