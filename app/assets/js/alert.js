$( document ).ready(function() {
  'use strict'

  $('#new-alert-wizard').steps({
    headerTag: 'h3',
    bodyTag: 'section',
    autoFocus: false,
    titleTemplate: '<span class="number">#index#</span> <span class="title">#title#</span>',
    onStepChanging: function (event, currentIndex, newIndex) { 
      if(newIndex == 1 || newIndex == 4) { 
        var tipsToShow = 'conditional';
        if (newIndex == 4) { tipsToShow = 'payload' }
        var tipsUri = Routes.tips_permanents_path({show: tipsToShow});
        $.ajax({
          dataType: 'script',
          type: 'get',
          url: tipsUri,
          headers: { 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content') }}).done(function() {
            $("#off-canvas").addClass('wd-200').addClass('show');
            if(window.matchMedia('(max-width: 1280px)').matches) {
              $('.sidebarMenu').closest('.aside').addClass('minimize', 200);
            }
          });
      } else {
        $("#off-canvas").removeClass('show');
        $('.sidebarMenu').closest('.aside').removeClass('minimize');
      }
      return true; 
      },
    onFinished: function() {
      //console.log('finsihed');
      $('#new-alert-wizard-form').submit();
    }
  });

  $('#hash-radio input[type=radio]').change(function() {
    var guardValue = $(this).val();
    //console.log(guardValue);
    if(guardValue == "deduplicate_on_event_content") {
      $("#hash-field-taginput").slideDown();
    } else {
      $("#hash-field-taginput").slideUp();
    }
  });

  var tagTextbox = $('#permanent_deduplication_fields').tagsinput({
    confirmKeys: [13, 44, 32],
    trimValue: true
  });

  var $conditionalEditor = ace.edit("ace-alert-conditional");
  $conditionalEditor.setOptions({
    wrapBehavioursEnabled: true,
    highlightActiveLine: true,
    showPrintMargin: false,
    mode: 'ace/mode/emu_conditional'
  });

  var $payloadEditor = ace.edit("ace-alert-payload");
  $payloadEditor.setOptions({
    wrapBehavioursEnabled: true,
    highlightActiveLine: true,
    showPrintMargin: false,
    mode: 'ace/mode/emu_payload'
  });

  var alertConditionalTextArea = $('#permanent_conditional_attributes_body');
  //alertConditionalTextArea.val("");

  $conditionalEditor.getSession().on("change", function () {
    alertConditionalTextArea.val($conditionalEditor.getSession().getValue());
  });

  var alertPayloadTextArea = $('#permanent_payload_attributes_body');
  //alertPayloadTextArea.val("");
  
  $payloadEditor.getSession().on("change", function () {
    alertPayloadTextArea.val($payloadEditor.getSession().getValue());
  });

  $conditionalEditor.getSession().setValue(alertConditionalTextArea.val());
  $payloadEditor.getSession().setValue(alertPayloadTextArea.val());

  var guardValue = $("#permanent_deduplication_deduplicate_on_event_content");
  if(guardValue.prop("checked") == true) {
    $("#hash-field-taginput").slideDown();
  }

  var tagTextbox = $('#alert_hash_fields').tagsinput({
    confirmKeys: [13, 44, 32],
    trimValue: true
  });
});