$(document).ready(function(){
  height = $('#show_blog_post').height();
  $('#show_blog_post').height(height);
  $('#next_prev_article a:not(".home")').click(function(){
    url = this.href + ".js";
    nav_url = $(this).attr('data-nav-url');
    $('#show_blog_post, #next_prev_article').fadeOut();
    $.ajax({
      url: url,
      success: function(data) {
        $('#show_blog_post').html(data).fadeIn().height('auto');
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