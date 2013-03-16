$(document).ready(function(){
    window.URL = window.URL || window.webkitURL;

    var fileSelect = document.getElementById("fileSelect"),
        fileElem = document.getElementById("fileElem"),
        fileList = document.getElementById("fileList");

    fileSelect.addEventListener("click", function (e) {
      if (fileElem) {
        fileElem.click();
      }
      e.preventDefault(); // prevent navigation to "#"
    }, false);

    fileElem.addEventListener("change", handleFiles(files), false);

    function handleFiles(files) {
      if (!files.length) {
        fileList.innerHTML = "<p>No files selected!</p>";
      } else {
        var list = document.createElement("ul");
        for (var i = 0; i < files.length; i++) {
          var li = document.createElement("li");
          list.appendChild(li);

          var img = document.createElement("img");
          img.src = window.URL.createObjectURL(files[i]);
          img.height = 60;
          img.onload = function(e) {
            window.URL.revokeObjectURL(this.src);
          }
          li.appendChild(img);

          var info = document.createElement("span");
          info.innerHTML = files[i].name + ": " + files[i].size + " bytes";
          li.appendChild(info);
        }
        fileList.appendChild(list);
      }
    }


})
