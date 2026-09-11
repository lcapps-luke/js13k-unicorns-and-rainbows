package play.enemy;

class ActionStarfish implements IAction {
	public static inline var SPEED:Float = 200;
	
	public function new(){}

	public function init(e:Enemy) {
		e.vel.set(-SPEED, 0);
		e.health = 5;
		e.score = 8;
		e.timer = (500 / SPEED) + Math.random() * (900 / SPEED); // Between 500 and 900 pixels
		e.phase = 0;
	}

	public function update(p:PlayScreen, s:Float, e:Enemy) {
		e.attack = 1;

		if(e.phase == 0 && e.timer <= 0){

			var incr = (Math.PI * 2) / 5;
			for(i in 0...5){
				var a = incr * i - Math.PI * 0.5;
				var xx = Math.cos(a) * 55;
				var yy = Math.sin(a) * 55;

				var b:EnemyBullet = p.enemyBullets.recycle(() -> new EnemyBullet(p));
				b.init(e.x + xx, e.y + yy, 500, a);
			}

			e.phase = 1;
			Sound.starfishShoot();
		}
	}
}