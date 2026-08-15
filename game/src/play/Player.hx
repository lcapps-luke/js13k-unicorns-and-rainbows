package play;

import math.AABB;
import math.Vec2;

class Player{
	private static inline var SPEED:Float = 1500;

	private var pos:Vec2;
	private var vel:Vec2;
	
	private var hit:AABB;
	private var hitOffset:Vec2;
	private var bound:AABB;
	private var boundOffset:Vec2;

	private var cd:Vec2;

	public function new(){
		pos = new Vec2(100, 720);
		vel = new Vec2();

		hit = new AABB(0, 0, 32, 32);
		hitOffset = new Vec2(-16, -16);

		bound = new AABB(0, 0, 128, 128);
		boundOffset = new Vec2(-64, -64);

		cd = new Vec2();
	}

	public function update(s:Float) {
		cd.set(0, 0);
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
			vel.setLenDir(SPEED, md);
		}

		pos.add(vel.mul(s));

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
	}

	private function updateBox(box:AABB, off:Vec2){
		box.x = pos.x + off.x;
		box.y = pos.y + off.y;
	}
}