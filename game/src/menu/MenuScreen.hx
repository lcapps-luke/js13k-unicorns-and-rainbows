package menu;

import js.Browser;
import js.html.CanvasGradient;
import js.html.Console;
import play.PlayScreen;
import resources.Resources;

class MenuScreen implements IScreen{
	private var gradient:CanvasGradient;
	private static var loaded = false;
	private var delay:Float = 0.5;
	private var playHeld:Bool = false;

	private var topScore:Int = 0;

	public function new(){
		if(!loaded){
			Resources.load().then(i -> {
				loaded = true;
			}).catchError(e -> {
				Console.error(e);
			});
		}

		gradient = Resources.rainbowGradient(Main.canvas.width * 0.1, 0, Main.canvas.width * 0.9, 0);

		topScore = Std.parseInt(Browser.window.localStorage.getItem(Main.SCORE_DATA_KEY) ?? "0");
	}

	public function update(s:Float) {
		if(loaded){
			Main.context.drawImage(Resources.images.get(Resources.BG_SKY), 0, 0);
		}

		Main.context.fillStyle = gradient;
		var t = Browser.document.title;
		Main.context.font = "160px cursive";
		var m = Main.context.measureText(t);
		Main.context.fillText(t, Main.canvas.width / 2 - m.width / 2, Main.canvas.height * 0.20);

		if(topScore > 0){
			Main.context.fillStyle = "#fff";
			t = "Best Score: " + StringTools.lpad(Std.string(topScore), "0", 6);
			Main.context.font = "50px cursive";
			m = Main.context.measureText(t);
			Main.context.fillText(t, Main.canvas.width / 2 - m.width / 2, Main.canvas.height * 0.35);
		}

		if(delay > 0){
			delay -= s;
		}else if(loaded){
			Main.context.fillStyle = "#fff";
			var t = "Press [fire] to start";
			Main.context.font = "100px cursive";
			var m = Main.context.measureText(t);
			Main.context.fillText(t, Main.canvas.width / 2 - m.width / 2, Main.canvas.height * 0.6);

			if(Ctrl.fire && !playHeld){
				Main.screen = new PlayScreen();
			}
		}

		playHeld = Ctrl.fire;
	}
}