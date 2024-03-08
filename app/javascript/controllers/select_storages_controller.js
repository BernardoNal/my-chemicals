import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="select-storages"
export default class extends Controller {
  static targets = ["farms", "storages", "carts"];

  updateStorages() {
    const farmId = this.farmsTarget.value;
    const url = `/farms/${farmId}/storages`;

    if (!farmId) {
      this.resetStoragesDropdown();
      return;
    }

    fetch(url, {
      method: 'GET',
      headers: { "Accept": "application/json" }
    })
    .then(response => response.json())
    .then((data) => {
      this.populateStoragesDropdown(data);
    })

  }

  updateCarts(e) {
    const farmId = this.farmsTarget.value;
    const storageId = e.target.value;
    const url = `/farms/${farmId}/storages/${storageId}/carts`;
    if (storageId) {
      fetch(url, {
        method: 'GET',
        headers: { "Accept": "text/plain" }
      })
      .then(response => response.text())
      .then((data) => {
        this.cartsTarget.innerHTML = data;
      })
    } else {
      this.cartsTarget.innerHTML = "<h2 class='my-4'>Meus Produtos:</h2><p>Selecione o estoque</p>"
    }
  }

  populateStoragesDropdown(data) {
    let options = `<option value="">Select a Storage</option>`;

    data.forEach(storage => {
      options += `<option value="${storage.id}">${storage.name}</option>`;
    });

    this.storagesTarget.innerHTML = options;
    this.storagesTarget.disabled = false;

  }

  resetStoragesDropdown() {
    this.storagesTarget.innerHTML = '<option value="" disabled selected>Select a Storage</option>';
    this.storagesTarget.disabled = true;
  }
}
