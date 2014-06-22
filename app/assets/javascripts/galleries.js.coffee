# Nanogallery

initNanoGallery = () ->
  $("#nanoGallery").nanoGallery
    thumbnailWidth: 200
    thumbnailHeight: 200
    colorScheme: 'light'
    colorSchemeViewer: 'light'
    thumbnailLabel:
      display: false

jQuery -> initNanoGallery()


jQuery ->
  $('#new_image').fileupload
    dataType: 'script'
  #.bind 'fileuploaddone', () -> initNanoGallery()