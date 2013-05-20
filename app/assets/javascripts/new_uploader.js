//
//$(document).ready(function(){
//    window.URL = window.URL || window.webkitURL;
//
//    var fileInput = document.getElementById("fileInput"),
//        fileLink = document.getElementById("fileLink"),
//        fileList = document.getElementById("fileList");
//
//    // Инфа о выбранных файлах
//    var countInfo = $("#info-count");
//    var sizeInfo = $("#info-size");
//
//    // Счетчик всех выбранных файлов и их размера
//    var imgCount = 0;
//    var imgSize = 0;
//
//    //переназначение клика по ссылке на Input
//    fileLink.addEventListener("click", function (e) {
//      if (fileInput) {
//        fileInput.click();
//      }
//      e.preventDefault(); // prevent navigation to "#"
//    }, false);
//
//    //следим за изменением #fileInput
//    $("#fileInput").change(function () {
//      var files = this.files;
//      if (!files.length) { //если файлов нет
//        fileList.innerHTML = "<p>No files selected!</p>";
//      } else {
//        for (var i = 0; i < files.length; i++) {
//          var file = files[i];
//          var imageType = /image.*/;
//          if (!file.type.match(imageType)) { //если загрузили изображение
//            continue;
//          }
//          //--------------------------------------
//          var li = document.createElement("li");//создаем элемент списка
//          fileList.appendChild(li);
//
//          //добавляем картинку
//          var upload = $('<div/>').addClass('upload').appendTo(li);
//          var img = document.createElement("img");
//          img.src = window.URL.createObjectURL(file);//создаем ссылку на img
//          img.width = 100;
//          img.classList.add("docfile");
//          img.file = file;
//          img.id = 'order_documents_attributes__docfile'
//          img.name = 'order[documents_attributes][][docfile]'
//          img.onLoad = function(e) {
//            window.URL.revokeObjectURL(this.src);
//          }
//          upload.append(img)
//
//          //select tag print_format
//            var print_format = $('<div/>').addClass('print_format').appendTo(li);
//            var sel_pf = $('<select>').attr('name','order[documents_attributes][][print_format]').attr('id','order_documents_attributes__print_format').appendTo(print_format);
//            for (var print_format_i in gon.print_format_array) {
//                 sel_pf.append($("<option>").attr('value', print_format_i).text(gon.print_format_array[print_format_i]));
//            };
//
//          //select tag paper type
//            var paper_type = $('<div/>').addClass('paper_type').appendTo(li);
//            var sel_pt = $('<select>').attr('name', 'order[documents_attributes][][paper_type]').attr('id','order_documents_attributes__paper_type').appendTo(paper_type);
//            for (var paper_type_i in gon.paper_type_array) {
//                 sel_pt.append($("<option>").attr('value', paper_type_i).text(gon.paper_type_array[paper_type_i]));
//            };
//
//            //select tag margins
//            var margins = $('<div/>').addClass('margins').appendTo(li);
//            var sel_m = $('<select>').attr('name','order[documents_attributes][][margins]').attr('id','order_documents_attributes__margins').appendTo(margins);
//            for (var margins_i in gon.margins_array) {
//                 sel_m.append($("<option>").attr('value', margins_i).text(gon.margins_array[margins_i]));
//            };
//
//            //input type text quantity
//            var quantity = $('<div/>').addClass('quantity').appendTo(li);
//            $('<input>').attr('name','order[documents_attributes][][quantity]').attr('type','text').attr('value','1').attr('id','order_documents_attributes__quantity').appendTo(quantity);
//
//            //input type textarea user_comment
//            var user_comment = $('<div/>').addClass('user_comment').appendTo(li);
//            $('<textarea/>').attr('name','order[documents_attributes][][user_comment]').attr('rows','20').attr('cols','40').attr('id','order_documents_attributes__user_comment').appendTo(user_comment);
//
//
//          //обновление информации о загруженных файлах-------------------------------------------------------------------
//          imgSize += file.size;
//          imgCount++;
//          updateInfo();
//        }
//      }
//
//    })
//
//
//    $("#upload-all").click(function () {
//      var imgs = $(".docfile");
//      for (var i = 0; i < imgs.length; i++) {
//        new FileUpload(imgs[i], imgs[i].file);
//      }
//    });
//
//    function FileUpload(img, file) {
//      var reader = new FileReader();
//      var xhr = new_xhr_request();//readyState property set to 0
//
//      //progress bar
//      var progressBar = $('<div/>').addClass('progress').insertAfter(img);
//      //update progress bar
//      xhr.addEventListener("progress", updateProgress, false);
//      function updateProgress(evt) {
//        if (evt.lengthComputable) {
//              progressBar.css('width', (evt.loaded / evt.total) * 100 + "px");
//              }
//          else {
//          // No data to calculate on
//          }
//      }
//
//      // File uploaded
//      xhr.addEventListener("load", transferComplete, false);
//      function transferComplete(evt) {
//        $('<p>Файл загружен</p>').insertAfter(progressBar);
//      }
//
//      xhr.open("POST", "/create_order");//readyState property set to 1
//
//      // Set appropriate headers
//      // xhr.setRequestHeader("Content-Type", "multipart/form-data");
//      xhr.setRequestHeader("X-File-Name", file.name);
//      xhr.setRequestHeader("X-File-Size", file.size);
//      xhr.setRequestHeader("X-File-Type", file.type);
//      xhr.overrideMimeType('text/plain; charset=x-user-defined-binary');
//
//      reader.onload = function(evt) {
//        xhr.sendAsBinary(evt.target.result);//readyState property set to 2
//      };
//      reader.readAsBinaryString(file);
//
//    }
//
//    //Обработка создания xhr
//    function new_xhr_request(){
//        var request = false;
//        try {
//          request = new XMLHttpRequest();
//        } catch (trymicrosoft) { //если не получилось, пробуем запрос по правилам MCS
//          try {
//            request = new ActiveXObject("Msxml2.XMLHTTP");
//          } catch (othermicrosoft) {//если не получилось, пробуем более старые версии MCS
//            try {
//              request = new ActiveXObject("Microsoft.XMLHTTP");
//            } catch (failed) {
//              request = false;
//            }
//          }
//        }
//
//        if (!request){//если ничего не получилось
//          alert("Ваш браузер устарел и не может загрузить выбранные Вами файлы. Пожалуйста, установите более новую версию.");
//        }
//        else {
//          return request
//        }
//    }
//
//    // Вывод инфы о выбранных файлах
//    function updateInfo() {
//        countInfo.text( (imgCount == 0) ? 'Изображений не выбрано' : ('Изображений выбрано: '+imgCount));
//        sizeInfo.text( (imgSize == 0) ? '-' : Math.round(imgSize / 1024));
//    }
//
//
//})
//
