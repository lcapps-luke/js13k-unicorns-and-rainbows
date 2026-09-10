package play.enemy;

class ActionSimple implements IAction {
	public static inline var SPEED:Float = 200;

	public function new(){}

	public function init(e:Enemy) {
		e.vel.set(-SPEED, 0);
		e.health = 3;
		e.score = 4;
	}

	public function update(p:PlayScreen, s:Float, e:Enemy) {
		e.attack = 1;
	}
}