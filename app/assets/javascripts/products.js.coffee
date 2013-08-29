# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('#product_category').autocomplete
    source: ['Accessories', 'Auxilary', 'Cookware', 'Garden Tools', 'Kitchen Tool Sets & Accessories',
             'Gadgets', 'Flatware', 'Gift Boxes - Single Items', 'Individual Wood Blocks / Trays',
             'Gift Boxes - Sets', 'Homemaker Pieces', 'Specialty Knives', 'Sporting / Hunting Knives',
             'Kitchen Cutlery Sets', 'B-Block', 'Gift Sets w/ FREE Gift Box', 'Table Knife Sets']
