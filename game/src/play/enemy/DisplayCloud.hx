package play.enemy;

import js.html.CanvasRenderingContext2D;
import js.html.ImageElement;
import math.AABB;
import math.Vec2;
import resources.Resources;

class DisplayCloud implements IDisplay{
	
	private var s:ImageElement;
	private var l:ImageElement;
	public function new(){
		s = Resources.images.get(Resources.CLOUD);
		l = Resources.images.get(Resources.LIGHTNING);
	}
	public function init(hb:AABB, ho:Vec2, bb:AABB, bo:Vec2) {
		hb.set(0, 0, 16, 1080);
		ho.set(-8, 0);

		bb.set(0, 0, 256, 96);
		bo.set(-128, -48);
	}

	public function draw(x:Float, y:Float, c:CanvasRenderingContext2D, e:Enemy) {
		if(e.attack > 0){
			Main.context.drawImage(l, e.hit.x - 22, e.hit.y);
		}

		Main.context.drawImage(s, e.bound.x, e.bound.y);

		
	}
}