// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.


import "@hotwired/turbo-rails"
import "bootstrap"
import "@popperjs/core"

require("@rails/activestorage").start()
//require("trix")
//require("@rails/actiontext")
require("local-time").start()
require("@rails/ujs").start()
import "controllers"

document.addEventListener("turbo:load", () => {
  // Enable tooltips
  var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
  var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl)
  })

  // Enable popovers
  var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'))
  var popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
    return new bootstrap.Popover(popoverTriggerEl)
  })

  // ✅ Enable dropdown toggles
  document.querySelectorAll('[data-bs-toggle="dropdown"]').forEach(dropdownToggleEl => {
    new bootstrap.Dropdown(dropdownToggleEl);
  });
})


