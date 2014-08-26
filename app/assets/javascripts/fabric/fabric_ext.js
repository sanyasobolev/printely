//find item by itemId
$(function() {
	fabric.Canvas.prototype.getItemById = function(itemId) {
	  var object = null,
	      objects = this.getObjects();

	  for (var i = 0, len = this.size(); i < len; i++) {
	    if (objects[i].itemId && objects[i].itemId === itemId) {
	      object = objects[i];
	      break;
	    }
	  }

	  return object;
	};
});
