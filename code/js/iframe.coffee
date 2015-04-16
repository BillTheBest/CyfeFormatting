if window.self isnt window.top
    console.log "Initiate iframe"
    frame_loaded = ->
        console.log "frame_loaded"

        WidgetFormatter.addGlobalStyle "div.widget-formatter {
                    border-radius: 2px;
                    color: #EEE;
                    text-shadow: 0px 0px 2px rgba(0, 0, 0, 0.8);
                    max-width: 50px;
                    margin: 0 5px 0 5px;
                }"

        setTimeout ->
            WidgetFormatter.findFormatableColumns()
            WidgetFormatter.sortTables()
        , 5000  


    $(window).load () ->
        frame_loaded()


          

