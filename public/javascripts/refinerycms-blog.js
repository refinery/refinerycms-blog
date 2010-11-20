$(document).ready(function(){
  $('#next_prev_article a:not(".home")').live('click',function(){
    url = this.href + ".js";
    nav_url = $(this).attr('data-nav-url');
    $('#show_blog_post').fadeOut();
    $.ajax({
      url: url,
      success: function(data) {
        $('#show_blog_post').html(data).fadeIn();
      }
    });
    return false;
  })
})