import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="select-storages"
export default class extends Controller {
  static targets = ["farms", "storages", "carts"];

  updateStorages() {
    const farmId = this.farmsTarget.value;
    const url = `/farms/${farmId}/storages`;

    this.cartsTarget.innerHTML = "<h2 class='my-4'>Meus Produtos:</h2><p>Selecione uma fazenda e um estoque</p>";

    if (farmId) {
      fetch(url, {
        method: 'GET',
        headers: { "Accept": "application/json" }
      })
      .then(response => response.json())
      .then((data) => {
        this.populateStoragesDropdown(data);
        const placeholderOption = this.farmsTarget.querySelector('option[value=""]');
        if (placeholderOption) {
          placeholderOption.disabled = true; // Disable farm placeholder now
        }
      })
      .catch(error => {
        console.error("Error fetching storages:", error);
      });
    }
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
        const placeholderOption = this.storagesTarget.querySelector('option[value=""]');
        if (placeholderOption) {
          placeholderOption.disabled = true; // Disable storages placeholder now
        }
      })
      .catch(error => {
        console.error('Error fetching carts:', error);
      });
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
}
