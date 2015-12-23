$(document).ready ->
  $('a.delCart').click (e) ->
    cartId = $(e.currentTarget).attr('id')
    data =
      'cart':
        'id': cartId
      'authenticity_token': $('input[name=authenticity_token]').attr('value')
      '_method': 'delete'
    $.post "/carts/#{cartId}", data, ->
      window.location.reload()
