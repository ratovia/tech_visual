$(function(){
  if ($('.shift-slick_container')[0]) {
    $('.shift-slick_container').slick({
      arrow: true,
      dots: true,
      infinite: false,
      speed: 300,
      slidesToShow: 1,
    })
  }
})
