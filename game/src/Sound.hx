package;

class Sound {
	@:native("a")
	public static function shoot() {
		ZzFX.zzfx(0.5,.05,978,.01,.01,.01,0,2.6,28,15,256,.01,0,.3,16,0,0,.69,0,0,-1427);
	}

	@:native("b")
	public static function enemyHit() {
		ZzFX.zzfx(3.9,.05,47,0,.03,.005,4,.2,86,0,53,.01,.01,0,0,0,.39,.51,0,.15,0);
	}

	@:native("c")
	public static function enemyKill() {
		ZzFX.zzfx(2.2,.05,9,0,.16,.007,4,2.3,0,0,-157,.01,.04,0,12,0,.03,.51,0,0,0);
	}

	@:native("d")
	public static function thunder() {
		ZzFX.zzfx(1.8,.05,81,.01,.43,.01,4,3.1,0,0,0,0,0,0,6.1,.5,0,.68,.05,0,-1497);
	}

	@:native("e")
	public static function lightning() {
		ZzFX.zzfx(1,.05,434,.03,.05,.07,5,1.8,14,38,0,0,0,0,0,.3,0,.88,.06,0,0);
	}

	@:native("f")
	public static function hit() {
		ZzFX.zzfx(1.7,.05,148,0,.1,.32,0,.2,0,0,0,0,0,0,1.6,0,.43,.9,.11,0,-1055);
	}

	@:native("g")
	public static function doughnut() {
		ZzFX.zzfx(2.2,.05,596,.01,.02,.22,0,2.5,0,100,0,0,0,0,8.8,0,0,.85,.03,0,878);
	}

	@:native("h")
	public static function lazerStart() {
		return ZzFX.zzfx(1,.05,335,.29,0,.01,0,3.7,0,2,0,0,0,.3,41,0,0,.93,.27,0,0);
	}
	
	@:native("i")
	public static function lazerLoop() {
		return ZzFX.zzfx(1,0,335,0,1,0,0,3.7,0,0,0,0,0,.3,41,0,0,1,0,0,0);
	}
}
