$(document).ready ->
  $('a.plan-tasks').click (e) ->
    $("form#planForm").submit()
  $('a.destroy-tasks').click (e) ->
    $("form#destroyForm").submit()
