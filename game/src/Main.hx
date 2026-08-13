package;

import js.Browser;
import js.html.CanvasRenderingContext2D;
import js.html.CanvasElement;


class Main{
	@:native("ca")
	public static var canvas(default, null):CanvasElement;

	@:native("c")
	public static var context(default, null):CanvasRenderingContext2D;

	@:native("l")
	public static var lastFrame:Float = 0;

	public static function main(){
		canvas = cast Browser.document.getElementById("c");
		context = canvas.getContext2d();

		Browser.window.onresize = onResize;
		onResize();

		// set initial screen

		Browser.window.requestAnimationFrame(update);
	}

	private static function update(s:Float){
		var d = s - lastFrame;

		// update screen

		lastFrame = s;
		Browser.window.requestAnimationFrame(update);
	}

	private static function onResize(){
		var w = Browser.window.innerWidth;
		var h = Browser.window.innerHeight;

		var cl = (w - canvas.clientWidth) / 2;
		canvas.style.top = '0px';
		canvas.style.left = '${cl}px';
	}
}