//= require ace-rails-ap
//= require ace/theme-dreamweaver
//= require ace/mode-liquid

define('ace/mode/emu_conditional', function(require, exports, module) {
  var oop = require("ace/lib/oop");
  var LiquidMode = require("ace/mode/liquid").Mode;
  var EmuHighlightRules = require("ace/mode/emu_conditional_highlight_rules").EmuConditionalHighlightRules;
  var MatchingBraceOutdent = require("ace/mode/matching_brace_outdent").MatchingBraceOutdent;
  var HtmlCompletions = require("ace/mode/html_completions").HtmlCompletions;
  var LiquidBehaviour = require("ace/mode/behaviour/liquid").LiquidBehaviour;
  var Mode = function() {
    this.HighlightRules = EmuHighlightRules;
    this.$outdent = new MatchingBraceOutdent();
    this.$behaviour = new LiquidBehaviour();
    this.$completer = new HtmlCompletions();
  };
  oop.inherits(Mode, LiquidMode);
  exports.Mode = Mode;
});

define('ace/mode/emu_payload', function(require, exports, module) {
  var oop = require("ace/lib/oop");
  var LiquidMode = require("ace/mode/liquid").Mode;
  var EmuHighlightRules = require("ace/mode/emu_payload_highlight_rules").EmuPayloadHighlightRules;
  var MatchingBraceOutdent = require("ace/mode/matching_brace_outdent").MatchingBraceOutdent;
  var HtmlCompletions = require("ace/mode/html_completions").HtmlCompletions;
  var LiquidBehaviour = require("ace/mode/behaviour/liquid").LiquidBehaviour;
  var Mode = function() {
    this.HighlightRules = EmuHighlightRules;
    this.$outdent = new MatchingBraceOutdent();
    this.$behaviour = new LiquidBehaviour();
    this.$completer = new HtmlCompletions();
  };
  oop.inherits(Mode, LiquidMode);
  exports.Mode = Mode;
});

define('ace/mode/emu_conditional_highlight_rules', function(require, exports, module) {
  var oop = require("ace/lib/oop");
  var LiquidHighlightRules = require("ace/mode/liquid_highlight_rules").LiquidHighlightRules;
  var EmuConditionalHighlightRules = function() {

    LiquidHighlightRules.call(this);

    var functions = (
      // Standard Filters
      "date|capitalize|downcase|upcase|first|last|join|sort|map|size|escape|" +
      "escape_once|strip_html|strip_newlines|newline_to_br|replace|replace_first|" +
      "truncate|truncatewords|prepend|append|minus|plus|times|divided_by|split"
    );

    var keywords = (
      // Standard Tags
      "capture|endcapture|case|endcase|when|comment|endcomment|" +
      "cycle|for|endfor|in|reversed|if|endif|else|elsif|include|endinclude|unless|endunless|" +
      // Commonly used tags
      "style|text|image|widget|plugin|marker|endmarker|tablerow|endtablerow|" + 
      // EMU specifics
      // Global
      "alert_name|search_name|search_query|endpoint_name|raw_events|raw_event_count|current_timestamp|" +
      // Conditional
      "event|event_index|event_score"
      //"actionable_events|actionable_event_count"
    );

    // common standard block tags that require to be closed with an end[block] token
    var blocks = 'for|if|case|capture|unless|tablerow|marker|comment';

    var builtinVariables = 'forloop|tablerowloop';

    var definitions = ("assign");

    var keywordMapper = this.createKeywordMapper({
      "variable.language": builtinVariables,
      "keyword": keywords,
      "keyword.block": blocks,
      "support.function": functions,
      "keyword.definition": definitions
    }, "identifier");

    // add liquid start tags to the HTML start tags
    for (var rule in this.$rules) {
      this.$rules[rule].unshift({
        token : "variable",
        regex : "{%",
        push : "liquid-start"
      }, {
        token : "variable",
        regex : "{{",
        push : "liquid-start"
      });
    }

    this.addRules({
      "liquid-start" : [
        {
          token: "variable",
          regex: "}}",
          next: "pop"
        }, {
          token: "variable",
          regex: "%}",
          next: "pop"
        }, {
          token : "string", // single line
          regex : '["](?:(?:\\\\.)|(?:[^"\\\\]))*?["]'
        }, {
          token : "string", // single line
          regex : "['](?:(?:\\\\.)|(?:[^'\\\\]))*?[']"
        }, {
          token : "constant.numeric", // hex
          regex : "0[xX][0-9a-fA-F]+\\b"
        }, {
          token : "constant.numeric", // float
          regex : "[+-]?\\d+(?:(?:\\.\\d*)?(?:[eE][+-]?\\d+)?)?\\b"
        }, {
          token : "constant.language.boolean",
          regex : "(?:true|false)\\b"
        }, {
          token : keywordMapper,
          regex : "[a-zA-Z_$][a-zA-Z0-9_$]*\\b"
        }, {
          token : "keyword.operator",
          regex : "/|\\*|\\-|\\+|=|!=|\\?\\:"
        }, {
          token : "paren.lparen",
          regex : /[\[\({]/
        }, {
          token : "paren.rparen",
          regex : /[\])}]/
        }, {
          token : "text",
          regex : "\\s+"
      }]
    });
    this.normalizeRules();
  }

  oop.inherits(EmuConditionalHighlightRules, LiquidHighlightRules);
  exports.EmuConditionalHighlightRules = EmuConditionalHighlightRules;
});

define('ace/mode/emu_payload_highlight_rules', function(require, exports, module) {
  var oop = require("ace/lib/oop");
  var LiquidHighlightRules = require("ace/mode/liquid_highlight_rules").LiquidHighlightRules;
  var EmuPayloadHighlightRules = function() {

    LiquidHighlightRules.call(this);

    var functions = (
      // Standard Filters
      "date|capitalize|downcase|upcase|first|last|join|sort|map|size|escape|" +
      "escape_once|strip_html|strip_newlines|newline_to_br|replace|replace_first|" +
      "truncate|truncatewords|prepend|append|minus|plus|times|divided_by|split"
    );

    var keywords = (
      // Standard Tags
      "capture|endcapture|case|endcase|when|comment|endcomment|" +
      "slack|endslack|trello|endtrello|email|endemail|cycle|for|endfor|in|reversed|if|endif|else|elsif|include|endinclude|unless|endunless|" +
      // Commonly used tags
      "style|text|image|widget|plugin|marker|endmarker|tablerow|endtablerow|" + 
      // EMU specifics
      // Global
      "alert_name|search_name|search_query|endpoint_name|raw_events|raw_event_count|current_timestamp|" +
      // Conditional
      //"event|event_index|event_score"
      "actionable_events|actionable_event_count"
    );

    // common standard block tags that require to be closed with an end[block] token
    var blocks = 'for|if|case|capture|unless|tablerow|marker|comment|slack|trello|email';

    var builtinVariables = 'forloop|tablerowloop';

    var definitions = ("assign");

    var keywordMapper = this.createKeywordMapper({
      "variable.language": builtinVariables,
      "keyword": keywords,
      "keyword.block": blocks,
      "support.function": functions,
      "keyword.definition": definitions
    }, "identifier");

    // add liquid start tags to the HTML start tags
    for (var rule in this.$rules) {
      this.$rules[rule].unshift({
        token : "variable",
        regex : "{%",
        push : "liquid-start"
      }, {
        token : "variable",
        regex : "{{",
        push : "liquid-start"
      });
    }

    this.addRules({
      "liquid-start" : [
        {
          token: "variable",
          regex: "}}",
          next: "pop"
        }, {
          token: "variable",
          regex: "%}",
          next: "pop"
        }, {
          token : "string", // single line
          regex : '["](?:(?:\\\\.)|(?:[^"\\\\]))*?["]'
        }, {
          token : "string", // single line
          regex : "['](?:(?:\\\\.)|(?:[^'\\\\]))*?[']"
        }, {
          token : "constant.numeric", // hex
          regex : "0[xX][0-9a-fA-F]+\\b"
        }, {
          token : "constant.numeric", // float
          regex : "[+-]?\\d+(?:(?:\\.\\d*)?(?:[eE][+-]?\\d+)?)?\\b"
        }, {
          token : "constant.language.boolean",
          regex : "(?:true|false)\\b"
        }, {
          token : keywordMapper,
          regex : "[a-zA-Z_$][a-zA-Z0-9_$]*\\b"
        }, {
          token : "keyword.operator",
          regex : "/|\\*|\\-|\\+|=|!=|\\?\\:"
        }, {
          token : "paren.lparen",
          regex : /[\[\({]/
        }, {
          token : "paren.rparen",
          regex : /[\])}]/
        }, {
          token : "text",
          regex : "\\s+"
      }]
    });
    this.normalizeRules();
  }

  oop.inherits(EmuPayloadHighlightRules, LiquidHighlightRules);
  exports.EmuPayloadHighlightRules = EmuPayloadHighlightRules;
});