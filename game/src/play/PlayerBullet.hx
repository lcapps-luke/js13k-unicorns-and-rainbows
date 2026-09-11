package play;

import js.html.ImageElement;
import resources.Resources;

class PlayerBullet extends AbstractObject{
	private var spr:ImageElement = Resources.images.get(Resources.PLAYER_BULLET);

	public function new(screen:PlayScreen){
		super(screen);
		
		vel.set(2000, 0);

		hit.set(0, 0, 32, 32);
		hitOffset.set(-16, -16);
		bound.set(0, 0, 32, 32);
		boundOffset.set(-16, -16);
	}

	public function init(x:Float, y:Float){
		reset();
		this.x = x;
		this.y = y;
	}

	override function update(s:Float) {
		super.update(s);

		Main.context.drawImage(spr, bound.x, bound.y);

		if(x > Main.canvas.width + 16){
			alive = false;
		}
	}
}