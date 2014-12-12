(function () {
    // Initialize namespace (or use existing one if present)
    window.canvasfn = window.canvasfn || {};

    //Add function  to the namespace

	//add and update text on canvas
	canvasfn.addTextToCanvas = function(canvas_text_value, canvas_text_id, canvas) {
		canvas_text=new fabric.Text(canvas_text_value, {
			top:Math.floor(Math.random()*350+1),
			left:Math.floor(Math.random()*250+1),
			fill:'#ff0000',
			lockUniScaling: true,
			});
		canvas_text.set('ObjectId', canvas_text_id);
		canvas.add(canvas_text);
	};

	canvasfn.UpdateTextOnCanvas = function(canvas_text_id, canvas_text_value, canvas) {
		canvas_item = canvas.getObjectById(canvas_text_id);
		canvas_item.set({ text: canvas_text_value });
		canvas.renderAll();
	};

	//add image on canvas
	canvasfn.addImageToCanvasFromURL = function(span, canvas) {
		canvas_image_id = span.attr('id');//получаем ид изображения из ид span скрытого элемента
		image_url = span.html(); //получаем url оригинала изображения
		fabric.Image.fromURL(image_url, function(oImg) {
		  oImg.set('top', Math.floor(Math.random()*350+1));
		  oImg.set('left', Math.floor(Math.random()*250+1));
		  oImg.set('ObjectId', canvas_image_id);
		  canvas.add(oImg);
		});
	};

	//remove object fron canvas
	canvasfn.RemoveObjectFromCanvas = function(canvas_object_id, canvas) {
		canvas_object = canvas.getObjectById(canvas_object_id);
		canvas.remove(canvas_object);
		canvas.renderAll();
	};	
	
})();