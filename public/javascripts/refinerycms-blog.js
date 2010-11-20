$(document).ready(function(){
  height = $('#show_blog_post').height();
  $('#show_blog_post').height(height);
  $('#next_prev_article a:not(".home")').live('click',function(){
    url = this.href + ".js";
    nav_url = $(this).attr('data-nav-url');
    $('#blog_post, #next_prev_article').fadeOut();
    $.ajax({
      url: url,
      success: function(data) {
        $('#blog_post').html(data).fadeIn()
        $('#show_blog_post').animate({
          height: 'auto'
        });
        $.ajax({
          url: nav_url,
          success: function(data) {
            $('#next_prev_article').html(data).fadeIn();
          }
        })
      }
    });
    return false;
  })
})