package;

import js.Browser;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import math.AABB;
import menu.MenuScreen;

@:native("M")
class Main{
	@:native("ca")
	public static var canvas(default, null):CanvasElement;

	@:native("c")
	public static var context(default, null):CanvasRenderingContext2D;

	@:native("l")
	private static var lastFrame:Float = 0;

	@:native("sc")
	public static var screen:IScreen;

	@:native("sz")
	public static var size = new AABB(0, 0, 1920, 1080);

	public static function main(){
		canvas = cast Browser.document.getElementById("c");
		context = canvas.getContext2d();

		Browser.window.onresize = onResize;
		onResize();

		Ctrl.init(Browser.window, canvas);

		screen = new MenuScreen();

		Browser.window.requestAnimationFrame(update);
	}

	@:native("u")
	private static function update(s:Float){
		var d = (s - lastFrame) / 1000;

		context.clearRect(0, 0, canvas.width, canvas.height);

		Ctrl.update();

		screen?.update(d);

		lastFrame = s;
		Browser.window.requestAnimationFrame(update);
	}

	@:native("r")
	private static function onResize(){
		var w = Browser.window.innerWidth;
		var h = Browser.window.innerHeight;

		var cl = (w - canvas.clientWidth) / 2;
		canvas.style.top = '0px';
		canvas.style.left = '${cl}px';
	}
}