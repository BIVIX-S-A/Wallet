window.addEventListener('load', () => {
  setTimeout(() => {
    const screen = document.getElementById('boot-screen');
    screen.style.opacity = 0;

    setTimeout(() => {
      window.location.href = "/check_session";
    }, 500);
  }, 2000); 
});