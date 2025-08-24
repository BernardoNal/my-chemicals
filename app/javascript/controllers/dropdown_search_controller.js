import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "results", "hidden"];
  static values = { url: String };

  connect() {
    console.log("dropdown-search connected", this.urlValue);
    this.index = -1; // índice para navegação por teclado
    this.currentItems = [];
    // fechar ao clicar fora
    this.outsideClickHandler = this.handleOutsideClick.bind(this);
    document.addEventListener("click", this.outsideClickHandler);
  }

  disconnect() {
    document.removeEventListener("click", this.outsideClickHandler);
  }

  handleOutsideClick(e) {
    if (!this.element.contains(e.target)) {
      this.clearResults();
    }
  }

  search() {
    const query = this.inputTarget.value.trim();
    if (query.length < 2) {
      this.clearResults();
      return;
    }

    fetch(`${this.urlValue}?q=${encodeURIComponent(query)}`)
      .then((res) => res.json())
      .then((data) => {
        this.currentItems = data || [];
        this.index = -1;
        if (!this.currentItems.length) {
          this.clearResults();
          return;
        }
        this.renderResults(this.currentItems);
      })
      .catch((err) => {
        console.error("search error", err);
        this.clearResults();
      });
  }

  renderResults(items) {
    // cria HTML dos itens; cada item terá tabindex para foco & ação de click
    this.resultsTarget.innerHTML = items
      .map((item, i) => {
        // escape básico de texto (evitar HTML injection)
        const text = String(item.product_name).replace(/</g, "&lt;").replace(/>/g, "&gt;");
        return `<div
                  role="option"
                  tabindex="0"
                  data-action="click->dropdown-search#select keydown->dropdown-search#itemKeydown"
                  data-id="${item.id}"
                  data-name="${text}"
                  data-index="${i}"
                  class="px-3 py-2 hover:bg-gray-100 cursor-pointer"
                >${text}</div>`;
      })
      .join("");
    this.resultsTarget.classList.remove("hidden");
  }

  clearResults() {
    this.resultsTarget.innerHTML = "";
    this.resultsTarget.classList.add("hidden");
    this.currentItems = [];
    this.index = -1;
  }

  select(event) {
    // garantir que event.currentTarget seja o item clicado
    const el = event.currentTarget;
    const id = el.dataset.id;
    const name = el.dataset.name;
    this.setSelection(id, name);
  }

  setSelection(id, name) {
    this.inputTarget.value = name;
    this.hiddenTarget.value = id;
    this.clearResults();
  }

  // teclado no input: arrows + enter + esc
  onKeydown(e) {
    if (this.resultsTarget.classList.contains("hidden")) return;

    const items = Array.from(this.resultsTarget.children);
    if (!items.length) return;

    if (e.key === "ArrowDown") {
      e.preventDefault();
      this.index = Math.min(this.index + 1, items.length - 1);
      items[this.index].focus();
    } else if (e.key === "ArrowUp") {
      e.preventDefault();
      this.index = Math.max(this.index - 1, 0);
      items[this.index].focus();
    } else if (e.key === "Escape") {
      this.clearResults();
    } else if (e.key === "Enter") {
      // se o input tiver foco e houver um índice selecionado, escolhe
      if (this.index >= 0 && items[this.index]) {
        e.preventDefault();
        items[this.index].click();
      }
    }
  }

  // teclado quando item tem foco (enter para selecionar)
  itemKeydown(e) {
    if (e.key === "Enter") {
      e.preventDefault();
      this.select(e);
    } else if (e.key === "ArrowDown" || e.key === "ArrowUp") {
      // delegar para onKeydown para manter index consistente
      this.onKeydown(e);
    } else if (e.key === "Escape") {
      this.inputTarget.focus();
      this.clearResults();
    }
  }
}
