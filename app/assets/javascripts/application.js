// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
// require activestorage
//= require turbolinks
//= require_tree .

(function loading() {
  let shouldShowLoading,
      delay = 180,
      loading;

  function getLoading() {
    if (loading == undefined)
      loading = document.querySelector(".loading");
    return loading;
  };

  function show() {
    if (!shouldShowLoading) {
      shouldShowLoading = true;
      setTimeout(function () {
        if (shouldShowLoading) {
          getLoading().style["display"] = "block";
        }
      }, delay)
    }
  };

  function hide() {
    if (shouldShowLoading) {
      shouldShowLoading = false;
      getLoading().style["display"] = "none";
    }
  };

  function addEventListeners() {
    document.addEventListener("turbolinks:request-start", show);
    document.addEventListener("turbolinks:request-end", hide);
    window.addEventListener("submit", show);
  };

  function setup() {
    addEventListeners();
  };

  setup();
})();
