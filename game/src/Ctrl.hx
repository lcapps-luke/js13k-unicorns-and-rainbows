package;

import js.Browser;
import js.html.CanvasElement;
import js.html.Gamepad;
import js.html.KeyboardEvent;
import js.html.Touch;
import js.html.TouchEvent;
import js.html.Window;
import math.Vec2;

class Ctrl {
	private static var keys:Map<String, Bool>;
	private static var c:CanvasElement;

	@:native("l")
	public static var left(default, null):Bool = false;
	@:native("r")
	public static var right(default, null):Bool = false;
	@:native("u")
	public static var up(default, null):Bool = false;
	@:native("d")
	public static var down(default, null):Bool = false;

	@:native("fi")
	public static var fire(default, null):Bool = false;
	@:native("fo")
	public static var focus(default, null):Bool = false;
	@:native("ra")
	public static var rainbow(default, null):Bool = false;

	@:native("g")
	private static var gamepad:Gamepad = null;

	@:native("tl")
	private static var touchList = new Map<Int, Vec2>();
	private static var moveTouchId:Int = -1;
	private static var beamTouchId:Int = -1;
	private static var moveTouchLast:Vec2 = new Vec2(0, 0);
	public static var moveTouchChange(default, null):Vec2 = new Vec2(0, 0);

	@:native("ut")
	private static var usingTouchscreen:Bool = false;

	public static function init(w:Window, c:CanvasElement) {
		Ctrl.keys = new Map<String, Bool>();
		Ctrl.c = c;

		w.onkeydown = onKeyDown;
		w.onkeyup = onKeyUp;

		w.addEventListener("touchstart", onTouchStart, {
			passive: false
		});
		w.addEventListener("touchmove", onTouchMove, {
			passive: false
		});
		w.addEventListener("touchend", onTouchEnd, {
			passive: false
		});
		w.addEventListener("touchcancel", onTouchEnd, {
			passive: false
		});

		if (Browser.navigator.getGamepads != null) {
			var ng = Browser.navigator.getGamepads();
			if (ng.length > 0) {
				gamepad = ng[0];
			}
		}

		w.addEventListener("gamepadconnected", e -> {
			if (gamepad == null) {
				gamepad = e.gamepad;
			}
		});
	}

	@:native("okd")
	private static function onKeyDown(e:KeyboardEvent) {
		e.preventDefault();
		e.stopImmediatePropagation();
		keys.set(e.code, true);
	}

	@:native("oku")
	private static function onKeyUp(e:KeyboardEvent) {
		e.preventDefault();
		e.stopImmediatePropagation();
		keys.set(e.code, false);
	}


	@:native("ots")
	private static function onTouchStart(e:TouchEvent) {
		e.preventDefault();
		e.stopImmediatePropagation();

		for (t in e.changedTouches) {
			var xx = tpx(t);
			var yy = tpy(t);
			touchList[t.identifier] = new Vec2(xx, yy);

			if(moveTouchId == -1){
				moveTouchId = t.identifier;
				moveTouchLast.set(xx, yy);
			}
			else if(beamTouchId == -1){
				beamTouchId = t.identifier;
			}
		}

		if(!usingTouchscreen){
			usingTouchscreen = true;
		}
	}

	@:native("otm")
	private static function onTouchMove(e:TouchEvent) {
		e.preventDefault();
		e.stopImmediatePropagation();

		for (t in e.changedTouches) {
			var xx = tpx(t);
			var yy = tpy(t);

			touchList[t.identifier].set(xx, yy);
		}
	}

	@:native("ote")
	private static function onTouchEnd(e:TouchEvent) {
		e.preventDefault();
		e.stopImmediatePropagation();

		for (t in e.changedTouches) {
			touchList.remove(t.identifier);

			if (t.identifier == moveTouchId) {
				moveTouchId = -1;
			} else if (t.identifier == beamTouchId) {
				beamTouchId = -1;
			}
		}
	}

	private static function tpx(t:Touch):Float {
		return ((t.clientX - c.offsetLeft) / c.clientWidth) * c.width;
	}

	private static function tpy(t:Touch):Float {
		return ((t.clientY - c.offsetTop) / c.clientHeight) * c.height;
	}

	@:native("upd")
	public static function update() {
		left = checkKeys(["ArrowLeft", "KeyA"]) || checkButtons([14], [0, 2], f -> f < -0.3);
		right = checkKeys(["ArrowRight", "KeyD"]) || checkButtons([15], [0, 2], f -> f > 0.3);
		up = checkKeys(["ArrowUp", "KeyW"]) || checkButtons([12], [1, 3], f -> f < -0.3);
		down = checkKeys(["ArrowDown", "KeyS"]) || checkButtons([13], [1, 3], f -> f > 0.3);
		
		focus = checkKeys(["ShiftLeft", "Semicolon"]) || checkButtons([4, 2, 1], []);
		fire = checkKeys(["Space", "KeyK", "KeyZ"]) || checkButtons([5, 0], []) || moveTouchId != -1;
		rainbow = checkKeys(["KeyJ", "KeyX"]) || checkButtons([7, 6, 3], []) || beamTouchId != -1;

		moveTouchChange.set(0, 0);
		if (moveTouchId != -1) {
			var t = touchList[moveTouchId];
			if (t != null) {
				moveTouchChange.set(t.x - moveTouchLast.x, t.y - moveTouchLast.y);
				moveTouchLast.set(t.x, t.y);
			}
		}
	}

	@:native("ck")
	public static function checkKeys(kk:Array<String>) {
		for (k in kk) {
			if (keys.get(k)) {
				return true;
			}
		}
		return false;
	}

	@:native("cb")
	public static function checkButtons(b:Array<Int>, a:Array<Int>, c:Float->Bool = null) {
		if (gamepad != null) {
			for (i in b) {
				if (gamepad.buttons[i].pressed) {
					return true;
				}
			}

			for (i in a) {
				if (c(gamepad.axes[i])) {
					return true;
				}
			}
		}

		return false;
	}
}
