document.addEventListener("DOMContentLoaded", function () {
  var audio = document.getElementById("music");
  audio.volume = 0.2;
  audio.addEventListener("canplaythrough", function () {
    audio.play();
  });
});

document.addEventListener("DOMContentLoaded", function () {
  var inputTypeSelect = document.getElementById("input_type_select");
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
});

document.addEventListener("DOMContentLoaded", function () {
  var algorithmSelect = document.getElementById("algorithm-select");

  algorithmSelect.addEventListener("change", function () {
    console.log(this.value);
    if (this.value === "affine") {
      document.getElementById("hint").innerHTML =
        "First key and second key need to be seperated by a space (' '). Example: 2 5";
    } else {
      document.getElementById("hint").innerHTML = " ";
    }
  });
});

var blackoverlay = document.getElementById("black-overlay");
var popup = document.getElementById("popup");
function closePopup() {
  popup.style.display = "none";
  console.log("tutup");
}
blackoverlay.addEventListener("click", closePopup);

document.addEventListener("DOMContentLoaded", function () {
  var result = document.getElementById("result");
  var popup = document.getElementById("popup");
  var encrypt = document.getElementById('encrypt')
  var decrypt = document.getElementById('decrypt')
  function openPopup() {
    event.preventDefault()
    popup.style.display = "flex";
    console.log("buka");
  }
  function openPopupSubmit(){
    popup.style.display = "flex";
    console.log("buka");
  }
  result.addEventListener("click", openPopup);
});

// var popup = document.getElementById('popup')
// var encrypt = document.getElementById('encrypt')
// var decrypt = document.getElementById('decrypt')
// result.addEventListener("click", openPopup);
// encrypt.addEventListener("click", openPopup);
// decrypt.addEventListener("click", openPopup);

// function openPopup(){
//   popup.style.display = "flex";
// }
