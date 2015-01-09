$(function(){
    if (window.parent.mercuryInstance == null) {
        new Mercury.PageEditor();
        $("#page").hide();
        $("#mercury_iframe").css("height", "inherit");
        $("#mercury_iframe").load(function(){
            this.contentWindow.$("#page").css("padding-top", "85px");
        });
        Mercury.on("action", function(event, options){
            if (options.action === "htmlEditor") {
                setTimeout(function(){
                    CodeMirror.fromTextArea(
                        $(".mercury-display-pane-container")[0],
                        {mode : "htmlmixed"}
                    );

                    $("#mercury_html_editor [type=submit]").one(
                        "click.codemirror",
                        function(){
                            $('.CodeMirror')[0].CodeMirror.save();
                        }
                    );
                }, 1000);
            }
        });
    }
});