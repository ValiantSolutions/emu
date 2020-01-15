
//= require ./cron-scheduler/jqCron
//= require ./cron-scheduler/jqCron.en
//= require_tree ./rangeslider

$('#schedule-generator').jqCron({
  no_reset_button: true, 
  bind_to: $('#schedule_cron'),
  default_period: 'hour',
  default_value: '*/15 * * * *',
  enabled_minute: true,
  enabled_year: false,
  multiple_time_hours: true,
  multiple_time_minutes: true,
  multiple_dom: false,
  multiple_month: false,
  multiple_mins: true,
  multiple_dow: true,
  bind_method: {
    set: function ($element, value) {
      $element.val(value);
    }
  }
});


$(document).on('click touchstart', function(e){
  e.stopPropagation();

  // closing of sidebar menu when clicking outside of it
  if(!$(e.target).closest('.jqCron-selector-list').length) {
    var offCanvas = $(e.target).closest('jqCron-selector-list').length;
    if(!offCanvas) {
      $('.jqCron-selector-list').fadeOut();
      //$(".aside-menu-link").closest('.aside').removeClass('minimize');
    }
  }
});