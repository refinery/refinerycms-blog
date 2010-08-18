$(document).ready(function(){
  $('div#actions.multilist > ul:not(.search_list) li a[href$=' + window.location.pathname + ']')
    .parent().addClass('selected');

  $('div#actions.multilist > ul:not(.search_list) li > a').each(function(i,a){
    if ($(this).data('dialog-title') == null) {
      $(this).bind('click', function(){
        $(this).css('background-image', "url('/images/refinery/icons/ajax-loader.gif') !important");
      });
    }
  });

  $('ul.collapsible_menu').each(function(i, ul) {
    (first_li = $(this).children('li:first')).after(div=$("<div></div>"));
    if (($(this).children('li.selected')).length == 0) {
      div.hide();
    }
    $(this).children('li:not(:first)').appendTo(div);
    
    first_li.find('> a').click(function(e){
      $(this).parent().next('div').animate({
          opacity: 'toggle'
          , height: 'toggle'
        }, 250, $.proxy(function(){
          $(this).css('background-image', null);
        }, $(this))
      );
      e.preventDefault();
    });
  });

  $('.success_icon, .failure_icon').bind('click', function(e) {
    $.get($(this).attr('href'), $.proxy(function(data){
      $(this).css('background-image', null)
             .toggleClass('success_icon')
             .toggleClass('failure_icon');
    }, $(this)));
    e.preventDefault();
  });
});