// Generated by CoffeeScript 1.8.0
var FormatWidgets, WidgetFormatter, refreshInterval;

WidgetFormatter = {
  init: function(widgetID) {
    var $widgetID;
    $widgetID = "#" + widgetID + "-iframe";
    return this.addGlobalStyle($($widgetID), "div.widget-formatter { border-radius: 2px; color: #EEE; text-shadow: 0px 0px 2px rgba(0, 0, 0, 0.8); max-width: 50px; margin: 0 5px 0 5px; }");
  },
  addGlobalStyle: function(doc, css) {
    var head, style;
    head = doc.contents().find("head")[0];
    if (!head) {
      return;
    }
    style = document.createElement('style');
    style.type = 'text/css';
    style.innerHTML = css;
    return head.appendChild(style);
  },
  format: function(widgetID, formatColumn) {
    var data;
    data = $("#" + widgetID + "-iframe").contents().find("table#table_content tr:gt(0)");
    return data.heatcolor(function() {
      var $tds, value;
      $tds = $(this).find('td');
      value = $tds.eq(formatColumn - 1).text().replace(/,/g, '');
      return parseFloat(value);
    }, {
      elementFunction: function() {
        return $(this).find("td:nth-child(" + formatColumn + ") > div");
      },
      lightness: 0,
      colorStyle: 'greentored'
    });
  },
  find: function() {
    var widgets;
    widgets = [];
    $("div#dashboard-container div.widget").each(function() {
      var columns, iframe, thirdCol, widgetID;
      widgetID = $(this).attr('id');
      iframe = $("#" + widgetID + "-iframe").contents();
      thirdCol = iframe.find("table#table_content tr:nth-child(2)");
      if (thirdCol.length > 0) {
        columns = [];
        thirdCol.find('td').each(function(index) {
          var num;
          num = parseInt($(this).text().replace(/,/g, ''));
          if (num === 0 || !isNaN(num)) {
            return columns.push(index + 1);
          }
        });
        if (columns.length > 0) {
          return widgets.push({
            id: widgetID,
            columns: columns
          });
        }
      }
    });
    return widgets;
  }
};

FormatWidgets = {
  run: function(widgets) {
    var column, data, name, _results;
    _results = [];
    for (name in widgets) {
      data = widgets[name];
      WidgetFormatter.init(data.id);
      _results.push((function() {
        var _i, _len, _ref, _results1;
        _ref = data.columns;
        _results1 = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          column = _ref[_i];
          _results1.push(WidgetFormatter.format(data.id, column));
        }
        return _results1;
      })());
    }
    return _results;
  }
};

refreshInterval = setInterval(function() {
  var widgets;
  widgets = WidgetFormatter.find();
  return FormatWidgets.run(widgets);
}, 5000);

console.log("Initiate");
