# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.

# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.

# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.

# Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.

# = require jquery
# = require jquery_ujs
# = require bootstrap-sprockets
# = require jquery.barrating.min.js
# = require turbolinks
# = require_tree .

buildBar = (number=10) ->
  $ratingView = $('.bar-rating')
  priority = parseInt $ratingView.attr('data-score')

  $tmp = $('<div>').attr('class', 'bar-priority').append('<select>')
  
  for num in [1..number]
    $option = $ '<option>',
      text: num
      value: num
      selected: if num is priority then true else false

    $tmp.find('select').append $option

  $ratingView.html $tmp
  $ratingView.find('select').barrating('show', {readonly:true})

init = ->
  buildBar()

  # form: select priority
  $('.form-group .bar-priority').show()
  $('.form-group .bar-priority select').barrating 'show',
    # showValues: true
    showSelectedRating: false
    onSelect: (value, txt) -> $('.form-group #wish_priority').val value

  $('.form-group #wish_priority').change ->
    val = $(@).val()
    $(".form-group .bar-priority [data-rating-value='#{val}']").click()

  # $('.star-rating').raty
  #   path: '/assets/lib/images'
  #   readOnly: true
  #   numberMax: 10
  #   number: 10
  #   score: ->
  #     $(@).attr 'data-score'

$(document).ready init
$(document).on 'page:load', init
