package play;

import js.html.ImageElement;
import math.Vec2;
import resources.Resources;

class Player extends AbstractObject{
	private static inline var SPEED:Float = 1500;
	private static inline var FOCUS_SPEED:Float = 500;
	private static inline var SHOOT_DELAY:Float = .2;
	private static inline var TAIL_SPEED:Float = 3;
	private static inline var TAIL_ANGLE_MAX:Float = 3.14 * 0.4;
	private static inline var TAIL_ANGLE_MIN:Float = -3.14 * 0.4;
	private var cd:Vec2;

	@:native("fc")
	private var shootCooldown:Float = 0;
	@:native("h")
	public var health(default, set):Int = 1;

	@:native("sb")
	private var spBody:ImageElement;
	@:native("sml")
	private var spMouthL:ImageElement;
	@:native("smu")
	private var spMouthU:ImageElement;
	@:native("sl")
	private var spLeg:Sprite;
	@:native("st")
	private var spTail:Sprite;
	@:native("tl")
	private var legTimer:Float = 0;
	@:native("tt")
	private var tailAngle:Float = 0;

	public function new(screen:PlayScreen){
		super(screen);

		pos.set(100, 720);
		hit.set(0, 0, 32, 32);
		hitOffset.set(-16, -16);
		bound.set(0, 0, 128, 128);
		boundOffset.set(-64, -64);

		cd = new Vec2();

		spBody = Resources.images.get(Resources.UNI_BODY);
		spMouthL = Resources.images.get(Resources.UNI_MOUTH_LOW);
		spMouthU = Resources.images.get(Resources.UNI_MOUTH_UP);
		spLeg = new Sprite(Resources.images.get(Resources.UNI_LEG), 5, 5);
		spTail = new Sprite(Resources.images.get(Resources.UNI_TAIL), 83, 15);
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
			vel.x = 0;
		}
		if(pos.x > Main.canvas.width - 64){
			pos.x = Main.canvas.width - 64;
			vel.x = 0;
		}
		if(pos.y < 64){
			pos.y = 64;
			vel.y = 0;
		}
		if(pos.y > Main.canvas.height - 64){
			pos.y = Main.canvas.height - 64;
			vel.y = 0;
		}

		updateBox(hit, hitOffset);
		updateBox(bound, boundOffset);

		//Main.context.fillStyle = "#555";
		//Main.context.fillRect(bound.x, bound.y, bound.w, bound.h);
		//Main.context.fillStyle = "#000";
		//Main.context.fillRect(hit.x, hit.y, hit.w, hit.h);

		var spd = TAIL_SPEED * s;
		if(vel.y > 5){
			tailAngle += spd;
		}else if(vel.y < -5){
			tailAngle -= spd;
		}else if(tailAngle != 0){
			if(Math.abs(tailAngle) < spd){
				tailAngle = 0;
			}else{
				tailAngle = tailAngle > 0 ? (tailAngle - spd) : (tailAngle + spd);
			}
		}
		if(tailAngle > TAIL_ANGLE_MAX){
			tailAngle = TAIL_ANGLE_MAX;
		}
		if(tailAngle < TAIL_ANGLE_MIN){
			tailAngle = TAIL_ANGLE_MIN;
		}

		legTimer += Math.PI * s;
		// behind
		Main.context.filter = "brightness(90%)"; 
		spLeg.draw(Main.context, pos.x-115+105, pos.y-110+200, getLegAngle(-Math.PI * .1, Math.PI * .1, 1));
		spLeg.draw(Main.context, pos.x-115+15, pos.y-110+200, getLegAngle(Math.PI * .3, Math.PI * .4, 1));
		Main.context.filter = "brightness(100%)"; 

		spTail.draw(Main.context, pos.x-115+95, pos.y-110+175, tailAngle);

		// main
		Main.context.drawImage(spBody, pos.x-115, pos.y-110);
		Main.context.drawImage(spMouthU, pos.x-115+139, pos.y-110+99);
		Main.context.drawImage(spMouthL, pos.x-115+119, pos.y-110+126);

		// front
		spLeg.draw(Main.context, pos.x-115+105, pos.y-110+200, getLegAngle(-Math.PI * .1, Math.PI * .1, 0));
		spLeg.draw(Main.context, pos.x-115+15, pos.y-110+200, getLegAngle(Math.PI * .3, Math.PI * .4, 0));
		
		screen.enemies.each(e -> {
			if(e.attack > 0 && e.hit.overlaps(hit)){
				hurt();
			}
		});
	}

	private function getLegAngle(min:Float, max:Float, offset:Float) {
		var p = Math.sin(legTimer + offset);
		return min + (max - min) * p;
	}

	function set_health(value:Int):Int {
		alive = value > 0;
		return health = value;
	}

	private function hurt(){
		health--;
		if(health < 1){
			//TODO gameover
			screen.gameover = true;
		}
	}
}