document.addEventListener('DOMContentLoaded', function () {
  // 當前頁面導覽高亮
  const path = (location.pathname.split('/').pop() || 'index.html').toLowerCase();
  document.querySelectorAll('.nav-menu a').forEach(a => {
    const href = a.getAttribute('href');
    if (!href) return;
    const target = href.toLowerCase();
    if ((path === '' && target.endsWith('index.html')) || path === target) {
      a.classList.add('active');
    }
    if (path === 'index.html' && (target === '#' || target === './')) {
      a.classList.add('active');
    }
  });

  // 導航列滾動背景微調
  const navbar = document.querySelector('.navbar');
  function onScroll() {
    if (!navbar) return;
    if (window.scrollY > 80) {
      navbar.style.background = 'rgba(0,0,0,0.95)';
    } else {
      navbar.style.background = 'rgba(0,0,0,0.9)';
    }
  }
  window.addEventListener('scroll', onScroll, { passive: true });
  onScroll();

  // 同頁平滑捲動（僅對 hash 連結）
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      const targetId = this.getAttribute('href');
      if (targetId.length > 1) {
        const el = document.querySelector(targetId);
        if (el) {
          e.preventDefault();
          el.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
      }
    });
  });
});
