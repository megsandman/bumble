$(document).ready(function() {
  // toggle heart 'off' and 'on' on 'wishlist/:user_id'
  $('.wishlist-outer').on('click', '.wl-heart', function(e) {
    e.preventDefault();
    var urlArray = $(this).attr('href').split("/");
    var userId = parseInt(urlArray.pop());
    var productId = $(this).closest('.product-box').attr('id');
    var self = this;

    $.ajax({
      url: "/products/" + productId + "/users/" + userId,
      type: "post"
    }).done(function(server_data){
      // console.log("yes");
      if ($(self).children('.full').length != 0) {
        $(self).empty();
        htmlToAdd = "<img src=\"/imgs/heart-empty.png\" class=\"empty\" id=\'" + userId + "\'>";
        $(htmlToAdd).appendTo(self);
      }
      else if ($(self).children('.empty').length != 0) {
        $(self).empty();
        htmlToAdd = "<img src=\"/imgs/heart-filled.png\" class=\"full\" id=\'" + userId + "\'>";
        $(htmlToAdd).appendTo(self);
      }
    }).fail(function(){
      console.log("no")
    })
  })

  // approve button on '/product/import'
  $('#import-table').on('click', '.import-approve', function(e) {
    e.preventDefault();
    var productId = $(this).attr('id')
    var self = this

    $.ajax({
      url: "/product/import/" + productId + "/approve",
      type: "post"
    }).done(function(server_data){
      element_to_remove = $(self).closest('tr');
      $(element_to_remove).remove();
    }).fail(function(){
      console.log("no");
    })
  })

  // approve button on '/product/import'
  $('#import-table').on('click', '.import-delete', function(e){
    e.preventDefault();
    var productId = $(this).attr('id')
    var self = this

    $.ajax({
      url: "/product/import/" + productId + "/delete",
      type: "post"
    }).done(function(server_data){
      element_to_remove = $(self).closest('tr');
      $(element_to_remove).remove();
      console.log(element_to_remove)
    }).fail(function(){
      console.log("no");
    })
  })

  // swipe on like
  // $('.wl-like-buttons').on('click', function(e){
  //   e.preventDefault();
  //   var productId = $(this).attr('id')
  //   // console.log(productId)

  //   $.ajax({
  //     url: "/products/" + productId,
  //     type: "post"
  //   }).done(function(server_data){
  //     // $('img').animate({ "left": "+=50px" }, "slow" )
  //      $('img').hide('slide',{direction:'right'},1000);
  //     // $('.wl-like-buttons').animate({top:'-=150'}, 1000)
  //   }).fail(function(){
  //     console.log("no");
  //   })

  // });




})
