# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

Rails.application.config.assets.precompile += %w[
  datatable.js
  form-tags.js
  calendar.js
  charts.js
  off-canvas.js
  alerts.scss
  steps.js
  ace.js
  jquery-ui.min.js
  alert.js
  search.js
  debug-events.js
  schedule.js
  dashboard.js
  home.js
  clipboard.min.js
]