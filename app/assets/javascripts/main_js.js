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
        "First key and second key need to be seperated by a hyphen ('-'). Example: 3-5. The first key must be relatively prime to 26.";
      closeEnigmaKey();
      openDefaultKey();
    } else if (this.value == "enigma") {
      cipher_hint.innerHTML =
        "Please insert a randomize sequence of all the alphabets characters with length 26 and unique. For each character in input will be mapped to the corresponding index in alphabet. Example: ZXC.., Mapping would be like A => Z, B => X, C => C";
      closeDefaultKey();
      openEnigmaKey();
    } else {
      cipher_hint.innerHTML = " ";
      closeEnigmaKey();
      openDefaultKey();
    }
    location.reload;
  });
});

function closePopup() {
  popup.style.display = "none";
  location.reload();
}

var blackoverlay = document.getElementById("black-overlay");
var popup = document.getElementById("popup");
var download = document.getElementById("download")
var filenameDownload = ''

blackoverlay.addEventListener("click", closePopup);
download.addEventListener("click", function () {
  fetch("/cryptool/download") 
    .then(response => {
      if (!response.ok){
        throw new Error("Bad Response Detected")
      }

      var contentDisposition = response.headers.get('content-disposition');
      var filename = '';
      if (contentDisposition && contentDisposition.indexOf('attachment') !== -1) {
        var filenameRegex = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/;
        var matches = filenameRegex.exec(contentDisposition);
        if (matches != null && matches[1]) {
          filename = matches[1].replace(/['"]/g, '');
        }
        filenameDownload = filename
        // filename = filename.replace(/\.[^/.]+$/, ""); // Remove extension
      }
      return response.blob()
    })
    .then(blob => {
      var url = window.URL.createObjectURL(blob);
      var link = document.createElement('a')
      link.href = url
      link.download = filenameDownload
      
      document.body.appendChild(link)
      link.click()

      link.remove()
      window.URL.revokeObjectURL(url);
    })
    .catch(error => {
      console.error(error)
    })
})

