package play.enemy;

class Enemy extends AbstractObject{
	private var display:IDisplay;
	private var action:IAction;
	public var health(default, set):Int;

	public var hitFlash:Float = 0;
	public var signal:Float = 0;
	public var attack:Float = 0;
	public var phase:Int = 0;
	public var timer:Float = 0;

	public function new(screen:PlayScreen){
		super(screen);
	}

	public function init(x:Float, y:Float, display:IDisplay, action:IAction){
		reset();

		this.display = display;
		this.action = action;

		pos.set(x, y);

		display.init(hit, hitOffset, bound, boundOffset);
		action.init(this);
	}

	override public function update(s:Float) {
		action.update(screen, s, this);
		if(hitFlash > 0){
			hitFlash -= s*3;
		}
		if(signal > 0){
			signal -= s;
		}
		if(attack > 0){
			attack -= s;
		}
		if(timer > 0){
			timer -= s;
		}

		super.update(s);

		display.draw(pos, Main.context, this);

		screen.playerBullets.each(b -> {
			if(b.hit.overlaps(bound)){
				hitFlash = 1;
				health--;
				b.alive = false;
			}
		});
	}

	function set_health(value:Int):Int {
		alive = value > 0;
		return health = value;
	}

	public function canHit(){
		return attack > 0;
	}
}