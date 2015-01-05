$( document ).ready(function() {   
    setViewAllURL('test');
    $("#filters button").click(function(){
       setViewAllURL(this);
    });
});

function setViewAllURL(obj)
{
    if(typeof(obj) == 'object') {
        viewMoreUrl =  $(obj).attr("data-href");
    } else {
        viewMoreUrl =  $("#filters .is-checked").attr("data-href");
    }
    if(viewMoreUrl == '*') {
        $(".isotope-view-more").hide();
    } else {
        $(".isotope-view-more").show()
        $(".view-more").attr("href",viewMoreUrl);
    }
}
    