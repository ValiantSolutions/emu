//= require_tree ./slimscroll

$(function(){
  'use strict'

  var debugEventConditional = ace.edit("debug-event-conditional");
  var debugEventPayload = ace.edit("debug-event-payload");

  debugEventConditional.setOptions({
    wrapBehavioursEnabled: true,
    highlightActiveLine: true,
    showPrintMargin: false,
    mode: 'ace/mode/emu_conditional'
  });

  debugEventPayload.setOptions({
    wrapBehavioursEnabled: true,
    highlightActiveLine: true,
    showPrintMargin: false,
    mode: 'ace/mode/emu_payload'
  });

  //debugEventConditional.getSession().setMode("ace/mode/emu_conditional");  
  //debugEventPayload.getSession().setMode("ace/mode/emu_payload");  

  // ------------------------
  var $queryTimer = null;
  var timer;
  var delay = 1000;

  var debugEventConditionalTextArea = $('#temporary_conditional_attributes_body');
  debugEventConditionalTextArea.val("");
  debugEventConditional.getSession().on("change", function () {
    debugEventConditionalTextArea.val(debugEventConditional.getSession().getValue());
  });

  var debugEventPayloadTextArea = $('#temporary_payload_attributes_body');
  debugEventPayloadTextArea.val("");
  debugEventPayload.getSession().on("change", function () {
    debugEventPayloadTextArea.val(debugEventPayload.getSession().getValue());
  });

  $.ajax({
    dataType: 'script',
    type: 'get',
    url: Routes.tips_permanents_path({show: 'all'}),
    headers: { 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content') }}).done(function() {
      $("#off-canvas").addClass('wd-200').addClass('show');
      if(window.matchMedia('(max-width: 1280px)').matches) {
        $('.sidebarMenu').closest('.aside').addClass('minimize', 200);
      }
    });

});

function submitTemplateForSyntaxCheck(template, parent) {
  $.ajax({
    contentType: "application/json",
    dataType: "json",
    type: 'post',
    url: Routes.check_syntax_debug_events_path(),
    data: JSON.stringify( { debug_event: { template: template }}),
    headers: { 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content') }
  }).done(
    function (response) {
      if(response.length == 0) {
        parent.addClass('alert-success').removeClass('alert-danger');
      } else {
        parent.addClass('alert-danger').removeClass('alert-success');
      }
    }
  );
  //console.log(template);
  //console.log(parent.attr('class'));
}

$(document).ready(function(){
  $("#action-expand").click( function(e){
    $("#integrations").slideToggle();
    
    var chevronStyle = $("#chevron-icon").attr('class') == 'feather feather-chevrons-down' ? 'chevrons-up' : 'chevrons-down';
    console.log('Actions <i id="chevron-icon" data-feather="' + chevronStyle + '"</i>');
    $("#action-expand").html('<a href="javascript://">Click for actions</a><i id="chevron-icon" data-feather="' + chevronStyle + '"></i>');
    feather.replace();
  });
});