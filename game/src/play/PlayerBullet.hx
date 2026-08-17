package play;

class PlayerBullet extends AbstractObject{

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
		pos.set(x, y);
	}

	override function update(s:Float) {
		super.update(s);

		Main.context.fillStyle = "#FFF";
		Main.context.fillRect(bound.x, bound.y, bound.w, bound.h);

		if(pos.x > Main.canvas.width + 16){
			alive = false;
		}
	}
}