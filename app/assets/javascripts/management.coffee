# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

if window.location.pathname == '/student_manager'
  # Wait for document to load before looking for elements
  console.log('Page loaded so had the script')
  $(document).ready ->
    # When Edit Exp button is clicked
    $(document).on 'click', '.expBtn', ->
      clickedBtnId = $(this).attr('id')
      modal = document.getElementById('expModal-' + clickedBtnId)
      modal.style.display = 'block'
      # When the user clicks anywhere outside of the modal, close it

      window.onclick = (event) ->
        if event.target == modal
          modal.style.display = 'none'
        return

      $(document).on 'click', '.closeModal', ->
        modal.style.display = 'none'
        return
      return
    return

# ---
# generated by js2coffee 2.2.0
