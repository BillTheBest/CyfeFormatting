
WidgetFormatter =

    addGlobalStyle: (css) ->
        #$("#dw954383-iframe").contents().find("head")[0]
        head = $(document).find("head")[0]
        if not head
            console.log "no head"
            return
        console.log "addGlobalStyle"

        style = document.createElement 'style'
        style.type = 'text/css'
        style.innerHTML = css
        head.appendChild style

    format: (formatColumn) ->
        console.log "Formatting #{formatColumn}"
        data = $ document
            .find "table#table_content tr:gt(0)"

        data.heatcolor -> 
            $tds = $(this).find 'td'
            # Remove 1000-separator
            value = $tds.eq(formatColumn-1).text().replace /,/g, ''
            num = parseFloat value
            return if isNaN num then 0 else num
        ,
            # Color the the div inside the same column/cell
            elementFunction: -> $(this).find "td:nth-child(#{formatColumn}) > div"
            lightness: 0
            colorStyle: 'greentored'

    findFormatableColumns: () ->
        # To format, there must be a table with at least 3 rows
        thirdCol = $ document
            .find "table#table_content tr:nth-child(3)"
        if thirdCol.length > 0
            columns = []
            thirdCol.find 'td'
                 .each (index) ->
                    num = parseInt $(this).text().replace /,/g, ''
                    if num is 0 or !isNaN num
                        #$(this).css 'border', '2px solid green'
                        WidgetFormatter.format index+1 
                        columns.push index+1 

            columns


if window.self is window.top
    $(document).ready () ->
        WidgetFormatter.addGlobalStyle "#dashboard-container .widget .widget-head {
                background: #333;
            }"
        console.log "Initiate"


