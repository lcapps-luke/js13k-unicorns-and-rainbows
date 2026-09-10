package play;

import math.AABB;
import math.Vec2;

abstract class AbstractObject{
	public var x(default, set):Float = 0;
	public var y(default, set):Float = 0;
	
	public var vel(default, null):Vec2;
	
	public var hit(default, null):AABB;
	private var hitOffset:Vec2;
	public var bound(default, null):AABB;
	private var boundOffset:Vec2;

	private var screen:PlayScreen;
	public var alive(default, null):Bool = true;

	public function new(screen:PlayScreen){
		this.screen = screen;
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
		x += vel.x * s;
		y += vel.y * s;
	}

	private function updateBox(box:AABB, off:Vec2){
		box.x = x + off.x;
		box.y = y + off.y;
	}

	function set_x(value:Float):Float {
		x = value;
		updateBox(hit, hitOffset);
		updateBox(bound, boundOffset);
		return value;
	}

	function set_y(value:Float):Float {
		y = value;
		updateBox(hit, hitOffset);
		updateBox(bound, boundOffset);
		return value;
	}
}