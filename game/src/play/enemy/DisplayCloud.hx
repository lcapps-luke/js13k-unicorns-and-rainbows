package play.enemy;

import js.html.CanvasRenderingContext2D;
import math.AABB;
import math.Vec2;

class DisplayCloud implements IDisplay{
	public function new(){}
	public function init(hb:AABB, ho:Vec2, bb:AABB, bo:Vec2) {
		hb.set(0, 0, 16, 1080);
		ho.set(-8, 0);

		bb.set(0, 0, 256, 96);
		bo.set(-128, -48);
	}

	public function draw(p:Vec2, c:CanvasRenderingContext2D, e:Enemy) {
		Main.context.fillStyle = "#666";
		Main.context.fillRect(e.bound.x, e.bound.y, e.bound.w, e.bound.h);

		if(e.attack > 0){
			Main.context.fillStyle = "#FF0";
			Main.context.fillRect(e.hit.x, e.hit.y, e.hit.w, e.hit.h);
		}
	}
}