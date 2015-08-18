(function($){
    $(function(){

        // Plugin initialization
        $('.button-collapse').sideNav();
        $('select').material_select();
        //$('select').not('.disabled').material_select();
        $('.tooltipped').tooltip({delay: 50});

    }); // end of document ready
})(jQuery); // end of jQuery name space
