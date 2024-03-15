// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"

document.addEventListener('turbo:load', () => {
  const element = document.getElementById('search-results-bottom');
  if (element) {
    element.scrollIntoView({ behavior: 'smooth' });
  }
});
