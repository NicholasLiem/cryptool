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
  var default_key = document.getElementsByName("default_cipher_key");
  var enigma_key = document.getElementsByName("enigma_cipher_key");
  var cipher_hint = document.getElementById("hint");

  closeDefaultKey = () => {
    for (var i = 0; i < default_key.length; i++) {
      default_key[i].style.display = "none";
    }
  };
  openDefaultKey = () => {
    for (var i = 0; i < default_key.length; i++) {
      default_key[i].style.display = "block";
    }
  };
  closeEnigmaKey = () => {
    for (var i = 0; i < enigma_key.length; i++) {
      enigma_key[i].style.display = "none";
    }
  };
  openEnigmaKey = () => {
    for (var i = 0; i < enigma_key.length; i++) {
      enigma_key[i].style.display = "block";
    }
  };

  algorithmSelect.addEventListener("change", function () {
    if (this.value === "affine") {
      cipher_hint.innerHTML =
        "First key and second key need to be seperated by a hyphen ('-'). Example: 2-5";
      closeEnigmaKey();
      openDefaultKey();
    } else if (this.value == "enigma") {
      cipher_hint.innerHTML = 
        "Please insert a randomize sequence of all the alphabets characters. Example: BFWASDMN...";
      closeDefaultKey();
      openEnigmaKey();
    } else {
      cipher_hint.innerHTML = " ";
      closeEnigmaKey();
      openDefaultKey();
    }
  });
});

var blackoverlay = document.getElementById("black-overlay");
var popup = document.getElementById("popup");
function closePopup() {
  popup.style.display = "none";
  location.reload();
}
blackoverlay.addEventListener("click", closePopup);
