package play.enemy;

class ActionSimple implements IAction {
	public function new(){}

	public function init(e:Enemy) {
		e.vel.set(-200, 0);
		e.health = 3;
	}

	public function update(p:PlayScreen, s:Float, e:Enemy) {
		e.attack = 1;
	}
}