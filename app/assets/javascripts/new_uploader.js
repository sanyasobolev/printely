$(document).ready(function(){
    window.URL = window.URL || window.webkitURL;

    var fileInput = document.getElementById("fileInput"),
        fileLink = document.getElementById("fileLink"),
        fileList = document.getElementById("fileList");

    // Инфа о выбранных файлах
    var countInfo = $("#info-count");
    var sizeInfo = $("#info-size");

    // Счетчик всех выбранных файлов и их размера
    var imgCount = 0;
    var imgSize = 0;

    //переназначение клика по ссылке на Input
    fileLink.addEventListener("click", function (e) {
      if (fileInput) {
        fileInput.click();
      }
      e.preventDefault(); // prevent navigation to "#"
    }, false);

    //следим за изменением #fileInput
    $("#fileInput").change(function () {
      var files = this.files;
      if (!files.length) { //если файлов нет
        fileList.innerHTML = "<p>No files selected!</p>";
      } else {
        var list = document.createElement("ul"); //создаем список

        for (var i = 0; i < files.length; i++) {
          var file = files[i];
          var imageType = /image.*/;
          if (!file.type.match(imageType)) { //если загрузили изображение
            continue;
          }
          //--------------------------------------
          var li = document.createElement("li");//создаем элемент списка
          list.appendChild(li);

          //добавляем картинку
          var img = document.createElement("img");
          img.src = window.URL.createObjectURL(file);//создаем ссылку на img
          img.width = 100;
          img.classList.add("docfile");
          img.file = file;
          img.onLoad = function(e) {
            window.URL.revokeObjectURL(this.src);
          }
          li.appendChild(img);

          //добавляем доп к каждому файлу
          var title = $('<div/>').text(file.name+' ').appendTo(li); //имя файла

          //select tag
            var arr = [
              {val : 1, text: 'One'},
              {val : 2, text: 'Two'},
              {val : 3, text: 'Three'}
            ];

            var sel = $('<select>').appendTo(li);
            $(arr).each(function() {
             sel.append($("<option>").attr('value',this.val).text(this.text));
            });

          //обновление информации о загруженных файлах
          imgSize += file.size;
          imgCount++;
          updateInfo();
        }
        fileList.appendChild(list);
      }

    })


    $("#upload-all").click(function () {
      var imgs = document.querySelectorAll(".docfile");
      for (var i = 0; i < imgs.length; i++) {
        new FileUpload(imgs[i], imgs[i].file);
      }
    });

    function FileUpload(img, file) {
      var reader = new FileReader();
      var xhr = new_xhr_request();//readyState property set to 0

      //progress bar
      var progressBar = $('<div/>').addClass('progress').insertAfter(img);
      //update progress bar
      xhr.addEventListener("progress", updateProgress, false);
      function updateProgress(evt) {
        if (evt.lengthComputable) {
              progressBar.css('width', (evt.loaded / evt.total) * 100 + "px");
              }
          else {
          // No data to calculate on
          }
      }

      // File uploaded
      xhr.addEventListener("load", transferComplete, false);
      function transferComplete(evt) {
        $('<p>Uploaded!</p>').insertAfter(progressBar);
      }

      xhr.open("POST", "/create_order");//readyState property set to 1

      // Set appropriate headers
      // xhr.setRequestHeader("Content-Type", "multipart/form-data");
      xhr.setRequestHeader("X-File-Name", file.name);
      xhr.setRequestHeader("X-File-Size", file.size);
      xhr.setRequestHeader("X-File-Type", file.type);
      xhr.overrideMimeType('text/plain; charset=x-user-defined-binary');

      reader.onload = function(evt) {
        xhr.sendAsBinary(evt.target.result);//readyState property set to 2
      };
      reader.readAsBinaryString(file);

    }

    //Обработка создания xhr
    function new_xhr_request(){
        var request = false;
        try {
          request = new XMLHttpRequest();
        } catch (trymicrosoft) { //если не получилось, пробуем запрос по правилам MCS
          try {
            request = new ActiveXObject("Msxml2.XMLHTTP");
          } catch (othermicrosoft) {//если не получилось, пробуем более старые версии MCS
            try {
              request = new ActiveXObject("Microsoft.XMLHTTP");
            } catch (failed) {
              request = false;
            }
          }
        }

        if (!request){//если ничего не получилось
          alert("Ваш браузер устарел и не может загрузить выбранные Вами файлы. Пожалуйста, установите более новую версию.");
        }
        else {
          return request
        }
    }

    // Вывод инфы о выбранных файлах
    function updateInfo() {
        countInfo.text( (imgCount == 0) ? 'Изображений не выбрано' : ('Изображений выбрано: '+imgCount));
        sizeInfo.text( (imgSize == 0) ? '-' : Math.round(imgSize / 1024));
    }


})

