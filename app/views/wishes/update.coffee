  # $("#wishes").append("<li><%= @wish.title %></li>")
  $("#wishes").html("<%=j render @wishlist %>")
  # partial: 'items_list', locals: { items: @selected }
