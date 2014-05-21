/* Nanogallery */

$(document).ready(function () {
  $("#nanoGallery").nanoGallery({
    thumbnailWidth: 200,
    thumbnailHeight: 200,
    colorScheme: 'light',
    colorSchemeViewer: 'light',
    thumbnailLabel: {
      display: false
    }
  });
});

/* Nanogallery bootstrap-wysihtml5 */

$(document).ready(function(){

  $('.wysihtml5').each(function(i, elem) {
    $(elem).wysihtml5({
      "locale": "ru-RU",
      "font-styles": true, //Font styling, e.g. h1, h2, etc. Default true
      "emphasis": true, //Italics, bold, etc. Default true
      "lists": true, //(Un)ordered lists, e.g. Bullets, Numbers. Default true
      "html": false, //Button which allows you to edit the generated HTML. Default false
      "link": true, //Button to insert a link. Default true
      "image": false, //Button to insert an image. Default true,
      "color": false //Button to change color of font
    });
  });

});

// for turbolinks
$(document).on('page:load', function(){
  window['rangy'].initialized = false
});