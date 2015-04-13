
WidgetFormatter =
    init: (widgetID) ->
        $widgetID = "##{widgetID}-iframe"
        @addGlobalStyle $($widgetID), 
            "div.widget-formatter {
                border-radius: 2px;
                color: #EEE;
                text-shadow: 0px 0px 2px rgba(0, 0, 0, 0.8);
                max-width: 50px;
                margin: 0 5px 0 5px;
            }"


    addGlobalStyle: (doc, css) ->
        #$("#dw954383-iframe").contents().find("head")[0]
        head = doc.contents().find("head")[0]
        if not head
            return

        style = document.createElement 'style'
        style.type = 'text/css'
        style.innerHTML = css
        head.appendChild style

    format: (widgetID, formatColumn) ->
        data = $ "##{widgetID}-iframe"
            .contents()
            .find "table#table_content tr:gt(0)"

        data.heatcolor -> 
            $tds = $(this).find 'td'
            # Remove 1000-separator
            value = $tds.eq(formatColumn-1).text().replace /,/g, ''
            parseFloat value
            # if isNaN num
            #     console.log "Error w/ ##{formatColumn} '#{$tds.eq(formatColumn).text()}'"
            #     value
            # else
            #     console.log "Value is #{num} in ##{formatColumn} '#{$tds.eq(formatColumn).text()}'"
            #     num
        ,
            # Color the the div inside the same column/cell
            elementFunction: -> $(this).find "td:nth-child(#{formatColumn}) > div"
            lightness: 0
            colorStyle: 'greentored'

    find: () ->
        widgets = []
        #$ "div#dashboard-container div.widget#dw1056050"
        $ "div#dashboard-container div.widget"
        .each () ->
            widgetID = $(this).attr 'id'
            iframe = $ "##{widgetID}-iframe"
                .contents()
            # To format, it must be a table with at least 3 rows
            thirdCol = iframe
                .find "table#table_content tr:nth-child(2)"
            if thirdCol.length > 0
                columns = []
                thirdCol.find 'td'
                     .each (index) ->
                        num = parseInt $(this).text().replace /,/g, ''
                        if num is 0 or !isNaN num
                            #$(this).css 'border', '2px solid green'
                            columns.push index+1 

                if columns.length > 0
                    widgets.push
                        id: widgetID
                        columns: columns
        return widgets




FormatWidgets =
    run: (widgets) ->
        for name,data of widgets
            WidgetFormatter.init data.id
            for column in data.columns
                WidgetFormatter.format data.id, column

refreshInterval = setInterval ->
    widgets = WidgetFormatter.find()
    FormatWidgets.run(widgets)
    #clearInterval refreshInterval
, 5000
console.log "Initiate"

