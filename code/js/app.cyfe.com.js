// Generated by CoffeeScript 1.8.0
var WidgetFormatter;

WidgetFormatter = {
  addGlobalStyle: function(css) {
    var head, style;
    head = $(document).find("head")[0];
    if (!head) {
      console.log("no head");
      return;
    }
    console.log("addGlobalStyle");
    style = document.createElement('style');
    style.type = 'text/css';
    style.innerHTML = css;
    return head.appendChild(style);
  },
  format: function(formatColumn) {
    var data;
    console.log("Formatting " + formatColumn);
    data = $(document).find("table#table_content tr:gt(0)");
    return data.heatcolor(function() {
      var $tds, num, value;
      $tds = $(this).find('td');
      value = $tds.eq(formatColumn - 1).text().replace(/,/g, '');
      num = parseFloat(value);
      if (isNaN(num)) {
        return 0;
      } else {
        return num;
      }
    }, {
      elementFunction: function() {
        return $(this).find("td:nth-child(" + formatColumn + ") > div");
      },
      lightness: 0,
      colorStyle: 'greentored'
    });
  },
  findFormatableColumns: function() {
    var columns, thirdCol;
    thirdCol = $(document).find("table#table_content tr:nth-child(3)");
    if (thirdCol.length > 0) {
      columns = [];
      thirdCol.find('td').each(function(index) {
        var num;
        num = parseInt($(this).text().replace(/,/g, ''));
        if (num === 0 || !isNaN(num)) {
          WidgetFormatter.format(index + 1);
          return columns.push(index + 1);
        }
      });
      return columns;
    }
  }
};

if (window.self === window.top) {
  $(document).ready(function() {
    $("#dashboard-container .widget .widget-head").css("background", "#333");
    return console.log("Initiate");
  });
}
