import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="select-storages"
export default class extends Controller {
  static targets = ["farms", "storages", "carts"];

  updateStorages() {

    const farmId = this.farmsTarget.value;
    const url = `/farms/${farmId}/storages`;

    fetch(url, {
      method: 'GET',
      headers: { "Accept": "application/json" }
    })
    .then(response => response.json())
    .then((data) => {
      this.populateStoragesDropdown(data);
    })

  }

  updateCarts() {
    const farmId = this.farmsTarget.value;
    const storageId = this.storagesTarget.value;
    const url = `/farms/${farmId}/storages/${storageId}/carts`;


    fetch(url, {
      method: 'GET',
      headers: { "Accept": "text/plain" }
    })
    .then(response => response.text())
    .then((data) => {
      console.log(data);
      this.cartsTarget.innerHTML = data;
      // this.populateCarts(data);
    })
  }

  populateStoragesDropdown(data) {
    let options = `<option value="">Select a Storage</option>`;

    data.forEach(storage => {
      options += `<option value="${storage.id}">${storage.name}</option>`;
    });

    this.storagesTarget.innerHTML = options;

    this.storagesTarget.disabled = false;
  }

  populateCarts(data) {
    const itemsHtml = data.map(cart => {
      return `<li>${cart.cart_chemical.product_name}</li>`;
    }).join('');

    this.cartsTarget.innerHTML = `<ul>${itemsHtml}</ul>`;
  }
}
