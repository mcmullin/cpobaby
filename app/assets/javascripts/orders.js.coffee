# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('#order_date').datepicker({ dateFormat: "mm-dd-yy", minDate: new Date(1949, 1, 1), maxDate: "+1y" })
