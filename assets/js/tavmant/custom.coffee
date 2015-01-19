$ ->
    unless window.parent.mercuryInstance?
        new Mercury.PageEditor()

        $ CONTENT_CONTAINER_SELECTOR
        .hide()

        $ "#mercury_iframe"
        .css "height", "inherit"

        $ "#mercury_iframe"
        .load ->
            @contentWindow.$ CONTENT_CONTAINER_SELECTOR
            .css "padding-top", "85px"

        Mercury.on "action", (event, options)->
            if options.action is "htmlEditor"
                setTimeout ->
                    CodeMirror.fromTextArea(
                        $(".mercury-display-pane-container")[0]
                        mode : "htmlmixed"
                    );

                    $ "#mercury_html_editor [type=submit]"
                    .one "click.codemirror", ->
                        $('.CodeMirror')[0]
                        .CodeMirror.save()
                ,
                    1000