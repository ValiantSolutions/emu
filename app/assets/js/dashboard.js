//= require_tree ./slimscroll
//= require ./clipboard.min

var getStats = function(url) {
  $.ajax({
    contentType: "application/json",
    dataType: "script",
    type: 'get',
    url: url,
    headers: { 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content') }
  });
  setTimeout(getStats.bind(null, url), 15000);
}

var getJumbotron = function(url) {
  $.ajax({
    contentType: "application/json",
    dataType: "script",
    type: 'get',
    url: url,
    headers: { 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content') }
  });
  setTimeout(getJumbotron.bind(null, url), 15000);
}