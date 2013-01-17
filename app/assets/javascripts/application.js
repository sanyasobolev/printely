// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require ckeditor/ckeditor
//= require_tree
//
// обработчик slide-панели

//$(function() {
//    $("#slide_image").carouFredSel({
//        width: "100%",
//        align: "center",
//        cookie: true,
//	auto : {
//            pauseDuration: 15000
//        },
//        items: {
//            visible: 1
//        },
//        pagination : {
//            container	: "#slide_img_pag",
//            easing: "swing",
//            duration	: 800
//	}
//    });
//});

$(function() {
	$(window).bind('resize.x', function() {
		$('#slide_image').carouFredSel({
			circular: true,
			items: 1,
			width: $(window).width(),
                        cookie: true,
                        auto : {
                            pauseDuration: 15000
                        },
			pagination: {
				container: '#slide_img_pag'
			}
		});
	}).trigger('resize.x');
});

//$(function() {
//    $("#slide_background").carouFredSel({
//        width: "100%",
//        height: "300px",
//        cookie: true,
//	auto : {
//            pauseDuration: 15000
//        },
//        scroll: {
//            fx			: "crossfade",
//            easing		: "swing",
//            duration	: 500
//	}
//    });
//});




