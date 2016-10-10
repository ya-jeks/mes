$(document).ready ->
  $('a.plan-tasks').click (e) ->
    $("form#checkedTasks").attr('method', 'get')
    $("form#checkedTasks").attr('action', '/plans/new')
    $("form#checkedTasks").submit()

  $('a.destroy-tasks').click (e) ->
    $("form#checkedTasks").attr('method', 'post')
    $("form#checkedTasks").attr('action', '/tasks/mass_destroy')
    $("form#checkedTasks").submit()

  $('.task-id').webuiPopover()
  $('input[class="daterange"]').daterangepicker()

  init_picker = ->
    start = moment().subtract(1, 'week') # TODO Read dates from report
    end = moment()

    $('#reportrange').on 'apply.daterangepicker', (ev, picker) ->
      window.location = "/reports?start_date=#{picker.startDate.format('DD.MM.YYYY')}&end_date=#{picker.endDate.format('DD.MM.YYYY')}"

    $('#reportrange').daterangepicker {
      locale:
        format: 'DD.MM.YYYY'
        cancelLabel: 'Отмена'
        applyLabel: 'Выбрать'
        customRangeLabel: 'Свой интервал'

      startDate: start
      endDate: end
      ranges:
        'Сегодня': [
          moment()
          moment()
        ]
        'Вчера': [
          moment().subtract(1, 'days')
          moment().subtract(1, 'days')
        ]
        'Эта неделя': [
          moment().startOf('week')
          moment().endOf('week')
        ]
        'Этот месяц': [
          moment().startOf('month')
          moment().endOf('month')
        ]
        'Прошлый месяц': [
          moment().subtract(1, 'month').startOf('month')
          moment().subtract(1, 'month').endOf('month')
        ]
    }

  init_picker()
