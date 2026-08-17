package play.enemy;

class ActionCloud implements IAction{
	public function new(){}

	public function init(e:Enemy) {
		e.vel.set(-128, 0);
		e.health = 3;
	}

	public function update(p:PlayScreen, s:Float, e:Enemy) {
		if(e.timer <= 0){
			switch(e.phase){
				case 0: 
					e.timer = 0.75;
					e.phase = 1;
					e.signal = 0.75;
				case 1: 
					e.timer = 0.5;
					e.phase = 2;
					e.attack = 0.5;
				case 2: 
					e.timer = 5;
					e.phase = 0;
			}
		}
	}
}