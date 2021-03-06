$(document).on('turbolinks:load', function() {
  try {
    if ($('.devise-custom').length) {

      $('form').find('input, textarea').on('keyup blur focus', function (e) {
        var $this = $(this)[0],
            label = $('label[for="' + $this.id + '"]')[0],
            newClass = function() {
              if ($this.type === 'checkbox') {
                return ''
              } else {
                return 'active highlight'
              }
            }

      	  if (e.type === 'keyup' && $this.type !== 'checkbox') {
      			if ($this.value === '' || $this.type === 'checkbox') {
                label.className = "";
              } else {
                label.className = 'active highlight';
              }
          } else if (e.type === 'blur' && $this.type !== 'checkbox') {
          	if( $this.value === '' ) {
          		label.className = "";
      			} else {
              try {
        		    label.className = "active";
              } catch (e) {
                // console.log('Logging');
                // console.log(e);
              }
      			}
          } else if (e.type === 'focus') {

            if( $this.value === '' && $this.type !== 'checkbox') {
          		label.className = "active";
      			}
            else if( $this.value !== '' ) {
              try {
        		    label.className = newClass();
              } catch (e) {
                // console.log('Logging');
                // console.log(e);
              }
      			}
          }

      });
    }
  } catch (e) {
    console.log('Logging');
    console.log(e);
  }
});
