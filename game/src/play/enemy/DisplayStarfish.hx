package play.enemy;

import resources.Resources;

class DisplayStarfish implements IDisplay {
	private var bod = Resources.images.get(Resources.STARFISH_BODY);
	private var ball = Resources.images.get(Resources.STARFISH_BALL);

	public function new() {
	}
	public function init(hb:math.AABB, ho:math.Vec2, bb:math.AABB, bo:math.Vec2) {
		hb.set(0, 0, 80, 80);
		ho.set(-40, -40);

		bb.set(0, 0, 128, 128);
		bo.set(-64, -64);
	}
	public function draw(p:math.Vec2, c:js.html.CanvasRenderingContext2D, e:Enemy) {
		if(e.phase == 0){
			var incr = (Math.PI * 2) / 5;
			for(i in 0...5){
				var a = incr * i - Math.PI * 0.5;
				var xx = Math.cos(a) * 55;
				var yy = Math.sin(a) * 55;

				Main.context.drawImage(ball, p.x + xx - 15, p.y + yy - 15);
			}
		}

		Main.context.drawImage(bod, p.x-55, p.y-55);
	}
}