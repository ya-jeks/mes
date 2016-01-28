$(document).ready ->
  $('a.plan-tasks').click (e) ->
    $("form#checkedTasks").attr('method', 'get')
    $("form#checkedTasks").attr('action', '/plans/new')
    $("form#checkedTasks").submit()

  $('a.destroy-tasks').click (e) ->
    $("form#checkedTasks").attr('method', 'post')
    $("form#checkedTasks").attr('action', '/tasks/mass_destroy')
    $("form#checkedTasks").submit()
