document.addEventListener("turbolinks:load", function() {
    var inputTypeSelect = document.getElementById('input_type_select');
    var textInput = document.getElementById('text_input');
    var fileInput = document.getElementById('file_input');
    console.log("what the fk")
  
    inputTypeSelect.addEventListener('change', function() {
      if (this.value === 'Text') {
        textInput.style.display = 'block';
        fileInput.style.display = 'none';
      } else {
        textInput.style.display = 'none';
        fileInput.style.display = 'block';
      }
    });
  
    if (inputTypeSelect) {
      inputTypeSelect.dispatchEvent(new Event('change'));
    }
  });  
