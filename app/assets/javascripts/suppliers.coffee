$(document).ready ->
  $('.delSupplierModalBtn').click (e) ->
    $('input#supplierId').val(e.currentTarget.dataset.id)

  $('.delSupplierBtn').click (e) ->
    supplierId = $('input#supplierId').val()
    data = {
            'supplier':
              'id': supplierId
            'authenticity_token': $('input[name=authenticity_token]').attr('value')
            '_method': 'delete'
    }
    $.post "/suppliers/#{supplierId}", data, ->
      window.location.reload()