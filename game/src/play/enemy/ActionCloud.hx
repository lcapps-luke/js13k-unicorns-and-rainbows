package play.enemy;

class ActionCloud implements IAction{
	public static inline var SPEED:Float = 128;

	public function new(){}

	public function init(e:Enemy) {
		e.vel.set(-SPEED, 0);
		e.health = 10;
		e.score = 13;
		e.phase = 0;
		e.timer = 2 + Math.random() * 3;
	}

	public function update(p:PlayScreen, s:Float, e:Enemy) {
		if(e.timer <= 0){
			switch(e.phase){
				case 0: // thunder
					e.timer = 0.75;
					e.phase = 1;
					e.signal = 0.75;
					Sound.thunder();
				case 1: // lightning
					e.timer = 0.5;
					e.phase = 2;
					e.attack = 0.5;
					Sound.lightning();
				case 2: 
					e.timer = 2 + Math.random() * 3;
					e.phase = 0;
			}
		}
	}
}