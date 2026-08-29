package play;

import js.html.ImageElement;

class Particle extends AbstractObject {
	private var img:ImageElement;
	public var filter:String;

	public function new(screen:PlayScreen){
		super(screen);
	}

	public function init(img:ImageElement, w:Float, h:Float){
		reset();
		this.img = img;

		bound.w = w;
		bound.h = h;
	}

	override function update(s:Float) {
		super.update(s);

		if(!bound.overlaps(Main.size)){
			alive = false;
		}

		var f = Main.context.filter;
		Main.context.filter = filter;
		Main.context.drawImage(img, pos.x, pos.y);
		Main.context.filter = f;
	}
}