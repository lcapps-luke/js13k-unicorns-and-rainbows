package resources;

import js.Browser;
import js.html.ImageElement;
import js.lib.Promise;

@:native("Res")
class Resources {
	public static inline var UNI_BODY = "b";
	public static inline var UNI_MOUTH_UP = "u";
	public static inline var UNI_MOUTH_LOW = "d";
	public static inline var UNI_LEG = "l";

	@:native("rq")
	public static var resourceQty:Int = 0;
	@:native("lq")
	public static var loadedQty:Int = 0;

	@:native("bg")
	public static var backgroundTile:ImageElement;

	@:native("i")
	public static var images:Map<String, ImageElement> = new Map();

	@:native("l")
	public static function load() {
		var loaders = [
			() -> loadImage(UNI_BODY, ResourceBuilder.buildImage("u-b.svg")),
			() -> loadImage(UNI_MOUTH_UP, ResourceBuilder.buildImage("u-mu.svg")),
			() -> loadImage(UNI_MOUTH_LOW, ResourceBuilder.buildImage("u-ml.svg")),
			() -> loadImage(UNI_LEG, ResourceBuilder.buildImage("u-l.svg"))
		];

		resourceQty = loaders.length;

		var p = Promise.resolve();

		for (l in loaders) {
			p = p.then((a) -> {
				loadedQty++;
				return l();
			});
		}

		return p;
	}

	public static function rainbowGradient(x1:Float, y1:Float, x2:Float, y2:Float){
		var gradient = Main.context.createLinearGradient(x1, y1, x2, y2);

		gradient.addColorStop(0, 'red');
		gradient.addColorStop(0.17, 'orange');
		gradient.addColorStop(0.33, 'yellow');
		gradient.addColorStop(0.5, 'green');
		gradient.addColorStop(0.67, 'blue');
		gradient.addColorStop(0.83, 'indigo');
		gradient.addColorStop(1, 'violet');

		return gradient;
	}


	private static function loadImage(name:String, data:String):Promise<Int> {
		return new Promise((resolve, reject) -> {
			var d = "data:image/svg+xml;base64," + Browser.window.btoa(data);
			var i:ImageElement = Browser.document.createImageElement();
			i.onload = () -> {
				images.set(name, i);
				resolve(1);
			};
			i.onerror = function(e) {
				reject(e);
			}
			i.setAttribute("src", d);
		});
	}

}