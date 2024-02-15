document.addEventListener("DOMContentLoaded", function () {
  var audio = document.getElementById("music");
  audio.volume = 0.2; 
  audio.addEventListener("canplaythrough", function () {
    audio.play(); 
  });
});

document.addEventListener("turbo:load", function () {
  var inputTypeSelect = document.getElementById("encrypted_file_input_type");
  var textInput = document.getElementById("text_input");
  var textInputLabel = document.getElementById("text_input_label");
  var fileInput = document.getElementById("file_input");
  var fileInputLabel = document.getElementById("file_input_label");

  inputTypeSelect.addEventListener("change", function () {
    if (this.value === "Text") {
      textInput.style.display = "block";
      textInputLabel.style.display = "block";
      fileInput.style.display = "none";
      fileInputLabel.style.display = "none";
    } else {
      textInput.style.display = "none";
      textInputLabel.style.display = "none";
      fileInput.style.display = "block";
      fileInputLabel.style.display = "block";
    }
  });

  if (inputTypeSelect) {
    inputTypeSelect.dispatchEvent(new Event("change"));
  }
});
