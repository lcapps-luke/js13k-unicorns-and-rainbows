package play;

import math.Vec2;

class Player extends AbstractObject{
	private static inline var SPEED:Float = 1500;
	private static inline var FOCUS_SPEED:Float = 500;
	private static inline var SHOOT_DELAY:Float = .2;
	private var cd:Vec2;

	private var shootCooldown:Float = 0;
	public var health(default, set):Int = 1;

	public function new(screen:PlayScreen){
		super(screen);

		pos.set(100, 720);
		hit.set(0, 0, 32, 32);
		hitOffset.set(-16, -16);
		bound.set(0, 0, 128, 128);
		boundOffset.set(-64, -64);

		cd = new Vec2();
	}

	override public function update(s:Float) {
		cd.set(0, 0);
		vel.set(0, 0);
		if(Ctrl.left){
			cd.x = -1;
		}else if(Ctrl.right){
			cd.x = 1;
		}
		if(Ctrl.up){
			cd.y = -1;
		}else if(Ctrl.down){
			cd.y = 1;
		}
		var md = cd.dir();
		if(cd.x != 0 || cd.y != 0){
			vel.setLenDir(Ctrl.focus ? FOCUS_SPEED : SPEED, md);
		}

		if(Ctrl.fire && shootCooldown <= 0){
			screen.playerBullets.recycle(() -> new PlayerBullet(screen)).init(pos.x, pos.y);
			shootCooldown = SHOOT_DELAY;
		}
		if(shootCooldown > 0){
			shootCooldown -= s;
		}

		super.update(s);

		if(pos.x < 64){
			pos.x = 64;
		}
		if(pos.x > Main.canvas.width - 64){
			pos.x = Main.canvas.width - 64;
		}
		if(pos.y < 64){
			pos.y = 64;
		}
		if(pos.y > Main.canvas.height - 64){
			pos.y = Main.canvas.height - 64;
		}

		updateBox(hit, hitOffset);
		updateBox(bound, boundOffset);

		Main.context.fillStyle = "#FFF";
		Main.context.fillRect(bound.x, bound.y, bound.w, bound.h);
		Main.context.fillStyle = "#000";
		Main.context.fillRect(hit.x, hit.y, hit.w, hit.h);

		screen.enemies.each(e -> {
			if(e.attack > 0 && e.hit.overlaps(hit)){
				hurt();
			}
		});
	}

	function set_health(value:Int):Int {
		alive = value > 0;
		return health = value;
	}

	private function hurt(){
		health--;
		if(health < 1){
			screen.gameover = true;
		}
	}
}