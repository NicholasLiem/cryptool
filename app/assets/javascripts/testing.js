document.addEventListener("turbo:load", function() {
  var inputTypeSelect = document.getElementById('encrypted_file_input_type');
  var textInput = document.getElementById('text_input');
  var fileInput = document.getElementById('file_input');

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
