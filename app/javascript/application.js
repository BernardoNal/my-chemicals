// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"

document.addEventListener('turbo:load', () => {
  const element = document.getElementById('search-results-bottom');
  const element2 = document.getElementById('search_query');
  console.log(element2.value)
  if (element && element2.value != '') {

    element.scrollIntoView({ behavior: 'smooth' });
  }
});
