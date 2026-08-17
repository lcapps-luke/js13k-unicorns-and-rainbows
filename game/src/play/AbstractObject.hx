package play;

import math.AABB;
import math.Vec2;

abstract class AbstractObject{
	public var pos(default, null):Vec2;
	public var vel(default, null):Vec2;
	
	public var hit(default, null):AABB;
	private var hitOffset:Vec2;
	public var bound(default, null):AABB;
	private var boundOffset:Vec2;

	private var screen:PlayScreen;
	public var alive(default, null):Bool = true;

	public function new(screen:PlayScreen){
		this.screen = screen;
		pos = new Vec2(0);
		vel = new Vec2();

		hit = new AABB();
		hitOffset = new Vec2();

		bound = new AABB();
		boundOffset = new Vec2();
	}

	public function reset(){
		alive = true;
	}

	public function update(s:Float){
		pos.add(vel.clone().mul(s));

		updateBox(hit, hitOffset);
		updateBox(bound, boundOffset);
	}

	private function updateBox(box:AABB, off:Vec2){
		box.x = pos.x + off.x;
		box.y = pos.y + off.y;
	}
}