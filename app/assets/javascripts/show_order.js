$(document).ready(function(){
  $(".container_for_cost_order").hover(function(){
    $(".container_for_label_cost_order label").fadeIn();
  },
  function(){
      $(".container_for_label_cost_order label").fadeOut();
  });

  $(".container_for_status_order").hover(function(){
    $(".container_for_label_status_order label").fadeIn();
  },
  function(){
      $(".container_for_label_status_order label").fadeOut();
  });

  $(".container_for_created_at_order").hover(function(){
    $(".container_for_label_created_at_order label").fadeIn();
  },
  function(){
      $(".container_for_label_created_at_order label").fadeOut();
  });

});
