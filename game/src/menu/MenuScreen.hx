package menu;

import js.Browser;
import js.html.CanvasGradient;
import play.PlayScreen;
import resources.Resources;

class MenuScreen implements IScreen{
	private var gradient:CanvasGradient;
	private static var loaded = false;

	public function new(){
		if(!loaded){
			Resources.load().then(i -> {
				loaded = true;
				Main.screen = new PlayScreen();
			});
		}

		gradient = Resources.rainbowGradient(Main.canvas.width * 0.3, 0, Main.canvas.width * 0.7, 0);
	}

	public function update(s:Float) {
		Main.context.fillStyle = gradient;
		var t = Browser.document.title;
		Main.context.font = "80px cursive";
		var m = Main.context.measureText(t);
		Main.context.fillText(t, Main.canvas.width / 2 - m.width / 2, Main.canvas.height * 0.25);
	}
}