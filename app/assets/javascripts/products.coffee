$(document).ready ->
  $(document).on 'mouseenter', '.iffytip', ->
    $this = $(this)
    if @offsetWidth < @scrollWidth and !$this.attr('title')
      $this.tooltip
        title: $this.text()
        placement: 'bottom'
      $this.tooltip 'show'
      return

  $('a.variant').click (e) ->
    targetId = "form##{e.currentTarget.dataset.target}"
    $(targetId).submit()

  $('.qtyinput').on 'keyup mouseup', (el)->
    $('.total_sum').html(parseFloat($(el.currentTarget).val())*parseFloat($('.price').html())+' руб.')

  $('#presetSelect').change (e) ->
    $('#presetForm').submit()