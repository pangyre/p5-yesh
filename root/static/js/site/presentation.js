jQuery(function($){
   var aCache = {};
   $("#content p a[href]").each(function(){
       if ( aCache[$(this).attr("href")] == true ) return;
       aCache[$(this).attr("href")] = true;
       $(this).css({fontWeight:"bold"});
    });
});
