package play.enemy;

import js.html.CanvasRenderingContext2D;
import js.html.ImageElement;
import math.AABB;
import math.Vec2;
import resources.Resources;

class DisplayMud implements IDisplay {
	private var i:ImageElement;
	public function new(){
		i = Resources.images.get(Resources.MUD);
	}
	public function init(hb:AABB, ho:Vec2, bb:AABB, bo:Vec2) {
		hb.set(0, 0, 73, 74);
		ho.set(-30, -35);

		bb.set(0, 0, 146, 96);
		bo.set(-48, -48);
	}

	public function draw(x:Float, y:Float, c:CanvasRenderingContext2D, e:Enemy) {
		Main.context.drawImage(i, e.bound.x, e.bound.y);
	}
}