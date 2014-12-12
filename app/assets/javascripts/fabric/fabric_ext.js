//find Object by Id
$(function() {
	fabric.Canvas.prototype.getObjectById = function(ObjectId) {
	  var object = null,
	      objects = this.getObjects();

	  for (var i = 0, len = this.size(); i < len; i++) {
	    if (objects[i].ObjectId && objects[i].ObjectId === ObjectId) {
	      object = objects[i];
	      break;
	    }
	  }
	  return object;
	};
});

