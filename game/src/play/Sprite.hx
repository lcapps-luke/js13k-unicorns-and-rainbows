package play;

import js.html.CanvasRenderingContext2D;
import js.html.ImageElement;
import math.Vec2;

class Sprite{
	public var imageElement(default, null):ImageElement;
	private var origin:Vec2;

	public function new(i:ImageElement, ox:Float, oy:Float){
		imageElement = i;
		origin = new Vec2(ox, oy);
	}

	public function draw(c:CanvasRenderingContext2D, x:Float, y:Float, a:Float){
		c.save();
		c.translate(x - origin.x, y - origin.y);
		c.rotate(a);trace(a);
		c.drawImage(imageElement, -origin.x, -origin.y);
		c.restore();
	}
}