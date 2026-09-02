package play.enemy;

class Enemy extends AbstractObject{
	private var display:IDisplay;
	private var action:IAction;
	public var health(default, set):Int;

	public var signal:Float = 0;
	public var attack:Float = 0;
	public var phase:Int = 0;
	public var timer:Float = 0;
	public var iTimer:Float = 0;

	public var score:Int = 1;

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
		if(signal > 0){
			signal -= s;
		}
		if(attack > 0){
			attack -= s;
		}
		if(timer > 0){
			timer -= s;
		}
		if(iTimer > 0){
			iTimer -= s;
		}

		super.update(s);

		display.draw(pos, Main.context, this);

		screen.playerBullets.each(b -> {
			if(b.hit.overlaps(bound)){
				hurt();
				b.alive = false;
			}
		});

		if(bound.x + bound.w < 0){
			alive = false;
		}
	}

	function set_health(value:Int):Int {
		alive = value > 0;
		return health = value;
	}

	public function canHit(){
		return attack > 0;
	}

	public function hurt() {
		if(iTimer > 0){
			return;
		}
		
		iTimer = 0.1;
		health--;

		if(!alive){
			this.screen.onEnemyKill(this);	
		}
	}
}