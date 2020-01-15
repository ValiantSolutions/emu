/*
 * This is a manifest file that'll be compiled into application.css, which will include all the files
 * listed below.
 *
 * Any CSS and SCSS file within this directory, lib/assets/stylesheets, or any plugin's
 * vendor/assets/stylesheets directory can be referenced here using a relative path.
 *
 * You're free to add application-wide styles to this file and they'll appear at the bottom of the
 * compiled file so the styles you add here take precedence over styles defined in any other CSS/SCSS
 * files in this directory. Styles in this file should be added after the last require_* statement.
 * It is generally better to create a new file per style scope.
 *
 */
//= require jquery3
//= require popper
//= require jquery-ui.min
//= require bootstrap-sprockets
//= require js-routes
//= require jquery_ujs
//= require data-confirm-modal
//= require perfect-scrollbar/perfect-scrollbar.min
//= require feather-icons/feather.min
//= require js.cookie-2.2.1.min
//= require chartkick
//= require Chart.bundle

//= require_tree ./global

Cookies.set('time_zone', Intl.DateTimeFormat().resolvedOptions().timeZone);