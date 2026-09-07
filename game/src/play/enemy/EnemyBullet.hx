package play.enemy;

import resources.Resources;

class EnemyBullet extends AbstractObject{
	private var spr = Resources.images.get(Resources.STARFISH_BALL);
	public function new(screen:PlayScreen){
		super(screen);
		bound.set(0, 0, 32, 32);
		boundOffset.set(-15, -15);
		hit.set(0, 0, 22, 22);
		hitOffset.set(-11, -11);
	}

	public function init(x:Float, y:Float, speed:Float, direction:Float){
		reset();

		pos.set(x, y);
		vel.setLenDir(speed, direction);
	}

	override public function update(s:Float) {
		super.update(s);

		if(!Main.size.overlaps(bound)){
			alive = false;
		}

		Main.context.drawImage(spr, bound.x, bound.y);
	}
}