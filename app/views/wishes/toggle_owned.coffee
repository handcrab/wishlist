if $("#wishes").length
  # index page
  $("#wishes").html("<%=j render @wishlist %>")
else
  # show page
  btn = $('.owned span')
  if btn.attr("class") is "glyphicon glyphicon-star-empty"
    btn.attr "class": "glyphicon glyphicon-star"
  else
    btn.attr "class": "glyphicon glyphicon-star-empty"

# partial: 'items_list', locals: { items: @selected }
