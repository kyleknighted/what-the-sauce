ImagesRouter = Backbone.Router.extend(
  routes:
    ":image_id": "main"

  main: (image_id) ->
    Session.set "image_id", image_id

  setImage: (image_id) ->
    @navigate(image_id, true)
)

Router = new ImagesRouter

Meteor.startup ->
  Backbone.history.start pushState: true

Template.imageList.images = ->
  Images.find({},
    sort:
      name: 1
  )

Template.imageList.events =
  'click #new-image': (e) ->
    url = $('#new-image-url').val()
    $('#new-image-url').val('')
    name = $('#new-image-name').val()
    $('#new-image-name').val('')
    if name
      Images.insert(
        url: url
        name: name
      )

Template.image.events =
  'click #delete-image': (e) ->
    Images.remove(@_id)
  'click #edit-image': (e) ->
    Router.setImage(@_id)

Template.image.selected = ->
  if Session.equals("image_id", @_id) then "selected" else ""

Template.imageView.selectedImage = ->
  image_id = Session.get("image_id")
  Images.findOne(
    _id: image_id
  )

Template.imageView.events =
  'keyup #edit-image-url': (e) ->
    data = $set: url: $('#edit-image-url').val()
    Images.update(@_id, data)

Template.imageView.events =
  'keyup #edit-image-name': (e) ->
    data = $set: name: $('#edit-image-name').val()
    Images.update(@_id, data)



############################################
## Client JavaScript Stuffs
############################################

$ ->
  image = ''
  $(".copy-image-url").live "click", (e) ->
    e.preventDefault()
    image = $(this)
    sauce = $(this).attr('href')
    $(this).replaceWith('<textarea id="image-wrap-sauce">' + sauce + '</textarea>')
    $('#image-wrap-sauce').select()

  $(".image textarea").live "keydown", (e) ->
    console.log image
    if (e.ctrlKey && e.keyCode == 67 || e.metaKey && !e.ctrlKey && e.keyCode == 67)
      $(this).replaceWith(image)