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
//= require jquery
//= require materialize-sprockets
//= require activestorage
//= require turbolinks
//= require_tree .
var currDate = new Date()
$(document).ready(function () {
    // $(".dropdown-trigger").dropdown();
    // $("select").formSelect();
    $(".datepicker").datepicker({
        format: "mmmm dd, yyyy",
        defaultDate: new Date(currDate.getFullYear(), 1, 1),
        // setDefaultDate: new Date(2000,01,31),
        maxDate: currDate,
        yearRange: [currDate.getFullYear()-100, currDate.getFullYear()]
    });
})