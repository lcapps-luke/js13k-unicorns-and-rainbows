package play;

import js.html.ImageElement;
import resources.Resources;

class Doughnut extends AbstractObject{
	private static inline var LAUNCH_MIN = -0.1 * 3.14;
	private static inline var LAUNCH_MAX = 0.2 * 3.14;

	private var i:ImageElement;
	private var frc:Float = 0.3;
	private var acc:Float = 0;
	public var cooldown:Float = 0;

	public function new(screen:PlayScreen){
		super(screen);
		i = Resources.images.get(Resources.DOUGHNUT);

		bound.set(0, 0, 50, 20);
		boundOffset.set(-25, -10);
	}

	public override function update(s:Float){
		vel.y *= 1 - (frc*s);
		if(vel.x > -100 && acc > 0){
			vel.x -= acc * s;
		}else{
			acc = 0;
		}
		
		super.update(s);

		if(pos.y < 0 && vel.y < 0){
			vel.y = -vel.y;
			pos.y = 0;
		}
		if(pos.y > 1080 && vel.y > 0){
			vel.y = -vel.y;
			pos.y = 1080;
		}
		if(pos.x < 0){
			alive = false;
		}

		if(cooldown > 0){
			cooldown -= s;
		}

		Main.context.drawImage(i, bound.x, bound.y);
	}

	public function init(x:Float, y:Float) {
		reset();
		pos.set(x, y);
		vel.set(-100, 0);
		acc = 0;
		cooldown = 0;
	}

	public function launch() {
		vel.setLenDir(700, LAUNCH_MIN + Math.random() * LAUNCH_MAX);
		acc = 200;
		cooldown = 0.5;
	}
}