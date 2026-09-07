package play;

import js.html.ImageElement;
import js.html.audio.AudioBufferSourceNode;
import js.lib.Math;
import math.AABB;
import math.Vec2;
import play.enemy.Enemy;
import resources.Resources;

class Player extends AbstractObject{
	private static inline var SPEED:Float = 1500;
	private static inline var FOCUS_SPEED:Float = 500;
	private static inline var SHOOT_DELAY:Float = .2;
	private static inline var TAIL_SPEED:Float = 3;
	private static inline var TAIL_ANGLE_MAX:Float = 3.14 * 0.4;
	private static inline var TAIL_ANGLE_MIN:Float = -3.14 * 0.4;
	private static inline var MOUTH_ANGLE_MAX:Float = 0.2 * 3.14;
	private static inline var BULLET_GAP:Float = 48;
	private static inline var DOUGHNUT_ANGLE:Float = 0.1 * 3.14;
	public static inline var BEAM_TIMER_MAX:Int = 5;
	private var cd:Vec2;

	@:native("fc")
	private var shootCooldown:Float = 0;

	@:native("sb")
	private var spBody:ImageElement;
	@:native("sml")
	private var spMouthL:Sprite;
	@:native("smu")
	private var spMouthU:Sprite;
	@:native("sl")
	private var spLeg:Sprite;
	@:native("st")
	private var spTail:Sprite;
	@:native("tl")
	private var legTimer:Float = 0;
	@:native("tt")
	private var tailAngle:Float = 0;
	private var mouthAngle:Float = 0;

	private var beamBox = new AABB(0, 0, 1920, 32);
	public var beamTimer(default, set):Float = 0;
	public var doughnuts:Int = 0;
	private var nutSpr:Sprite;
	private var nutPos = [5, 55, 10, 66, 14, 76];
	public var iTimer:Float = 0;

	public var lazerPlaying:Bool = false;
	public var lazerLoop:AudioBufferSourceNode = null;

	public function new(screen:PlayScreen){
		super(screen);

		pos.set(100, 720);
		hit.set(0, 0, 65, 77);
		hitOffset.set(-41, -36);
		bound.set(0, 0, 128, 128);
		boundOffset.set(-64, -64);

		cd = new Vec2();

		spBody = Resources.images.get(Resources.UNI_BODY);
		spMouthL = new Sprite(Resources.images.get(Resources.UNI_MOUTH_LOW), 14, 20);
		spMouthU = new Sprite(Resources.images.get(Resources.UNI_MOUTH_UP), 12, 18);
		spLeg = new Sprite(Resources.images.get(Resources.UNI_LEG), 5, 5);
		spTail = new Sprite(Resources.images.get(Resources.UNI_TAIL), 83, 15);
		nutSpr = new Sprite(Resources.images.get(Resources.DOUGHNUT), 25, 10);
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

		if(Ctrl.moveTouchChange.x != 0 || Ctrl.moveTouchChange.y != 0){
			vel.add(Ctrl.moveTouchChange.mul(1/s).mul(1.5));
		}

		if(Ctrl.fire && shootCooldown <= 0){
			var q = doughnuts + 1;
			var yy = pos.y - (q * BULLET_GAP) / 2;
			for(i in 0...q){
				screen.playerBullets.recycle(() -> new PlayerBullet(screen)).init(pos.x, yy);
				yy += BULLET_GAP;
			}

			Sound.shoot();
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

		var spd = TAIL_SPEED * s;
		if(vel.y > 5){
			tailAngle += spd * Math.abs(vel.y / 2000.0);
		}else if(vel.y < -5){
			tailAngle -= spd * Math.abs(vel.y / 2000.0);
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
		spLeg.draw(Main.context, pos.x-8, pos.y+94, getLegAngle(-Math.PI * .1, Math.PI * .1, 1));
		spLeg.draw(Main.context, pos.x-102, pos.y+94, getLegAngle(Math.PI * .3, Math.PI * .4, 1));
		Main.context.filter = "brightness(100%)"; 

		spTail.draw(Main.context, pos.x-104, pos.y+51, tailAngle);

		// main
		Main.context.drawImage(spBody, pos.x-115, pos.y-110);
		spMouthU.draw(Main.context, pos.x + 37, pos.y+7, -mouthAngle);
		spMouthL.draw(Main.context, pos.x+19, pos.y+35, mouthAngle * .3);

		// front
		spLeg.draw(Main.context, pos.x-9, pos.y+94, getLegAngle(-Math.PI * .1, Math.PI * .1, 0));
		spLeg.draw(Main.context, pos.x-102, pos.y+94, getLegAngle(Math.PI * .3, Math.PI * .4, 0));

		// doughnuts
		var dx = pos.x + 5;
		var dy = pos.y - 55;
		for(i in 0...doughnuts){
			nutSpr.draw(Main.context, dx, dy, DOUGHNUT_ANGLE);
			dx += 8;
			dy -= 16;
		}

		var beam = Ctrl.rainbow && beamTimer >= 0;
		var beamHitX:Float = 1920;
		var hitEnemy:Enemy = null;
		if(beam){
			beamBox.x = pos.x + 76;
			beamBox.y = pos.y;
			beamBox.w = 1920 - beamBox.x;
			beamTimer -= s;

			if(!lazerPlaying){
				lazerPlaying = true;
				Sound.lazerStart().addEventListener("ended", e -> {
					lazerLoop = Sound.lazerLoop();
					lazerLoop.loop = true;
				});
			}
		}else{
			if(lazerLoop != null){
				lazerLoop.stop();
				lazerLoop = null;
			}
			lazerPlaying = false;
		}
		
		screen.enemies.each(e -> {
			if(e.attack > 0 && e.hit.overlaps(hit)){
				hurt();
			}

			if(beam && beamBox.overlaps(e.bound)){
				if(e.bound.x < beamHitX){
					hitEnemy = e;
					beamHitX = e.bound.x;
				}
			}
		});
		screen.enemyBullets.each(e -> {
			if(e.hit.overlaps(hit)){
				hurt();
				e.alive = false;
			}
		});
		screen.doughnuts.each(d -> {
			if(d.cooldown <= 0 && d.bound.overlaps(bound)){
				d.alive = false;
				doughnuts++;
				screen.score += d.score;
				Sound.doughnut();
			}
		});

		if(beam){
			beamBox.w = beamHitX - beamBox.x;
			
			Main.context.fillStyle = Resources.rainbowGradient(0, beamBox.y, 0, beamBox.b);
			Main.context.fillRect(beamBox.x, beamBox.y, beamBox.w, beamBox.h);

			if(hitEnemy != null){
				hitEnemy.hurt(2);
			}

			if(mouthAngle < MOUTH_ANGLE_MAX){
				mouthAngle += MOUTH_ANGLE_MAX * s * 5;
			}
		}else{
			if(mouthAngle > 0){
				mouthAngle -= MOUTH_ANGLE_MAX * s * 5;
			}
			if (mouthAngle < 0){
				mouthAngle = 0;
			}
		}

		if(iTimer > 0){
			iTimer -= s;
		}

	}

	private function getLegAngle(min:Float, max:Float, offset:Float) {
		var p = Math.sin(legTimer + offset);
		return min + (max - min) * p;
	}

	private function hurt(){
		if(iTimer > 0){
			return;
		}

		Sound.hit();
		
		if(doughnuts == 0){
			//TODO gameover
			screen.gameover = true;
			alive = false;
		}

		for(i in 0... doughnuts){
			screen.spawnDoughnut(pos.x, pos.y, true);
		}
		doughnuts = 0;
		iTimer = 1.5;
	}

	function set_beamTimer(value:Float):Float {
		beamTimer = value;
		if(beamTimer > BEAM_TIMER_MAX){
			beamTimer = BEAM_TIMER_MAX;
		}
		return beamTimer;
	}
}