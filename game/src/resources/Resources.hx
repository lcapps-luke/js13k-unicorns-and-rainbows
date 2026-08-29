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
	public static inline var UNI_TAIL = "t";
	public static inline var CLOUD = "c";
	public static inline var LIGHTNING = "i";
	public static inline var BG_CLOUD_NEAR = "n";
	public static inline var BG_CLOUD_FAR = "f";

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
			() -> loadSVG(UNI_BODY, ResourceBuilder.buildImage("uni-body.svg")),
			() -> loadSVG(UNI_MOUTH_UP, ResourceBuilder.buildImage("uni-mouth-upper.svg")),
			() -> loadSVG(UNI_MOUTH_LOW, ResourceBuilder.buildImage("uni-mouth-lower.svg")),
			() -> loadSVG(UNI_LEG, ResourceBuilder.buildImage("uni-leg.svg")),
			() -> loadSVG(UNI_TAIL, ResourceBuilder.buildImage("uni-tail.svg")),
			() -> loadSVG(CLOUD, ResourceBuilder.buildImage("cloud.svg")),
			() -> loadSVG(LIGHTNING, ResourceBuilder.buildImage("lightning.svg")),
			() -> loadSVG(BG_CLOUD_NEAR, ResourceBuilder.buildImage("bg_cloud_near.svg")),
			() -> loadSVG(BG_CLOUD_FAR, ResourceBuilder.buildImage("bg_cloud_far.svg")),
			() -> loadBg(),
			() -> loadStars()
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

	private static function loadSVG(name:String, data:String):Promise<Int> {
		return loadImage(name, "data:image/svg+xml;base64," + Browser.window.btoa(data));
	}

	private static function loadImage(name:String, url:String):Promise<Int> {
		return new Promise((resolve, reject) -> {
			var i:ImageElement = Browser.document.createImageElement();
			i.onload = () -> {
				images.set(name, i);
				resolve(1);
			};
			i.onerror = function(e) {
				reject(e);
			}
			i.setAttribute("src", url);
		});
	}

	private static function loadBg(){
		return new Promise((resolve, reject) -> {
			var gradient = Main.context.createLinearGradient(0, 0, 0, 1080);
			gradient.addColorStop(0.4, "#002");
			gradient.addColorStop(1, "#036");

			var c = createCanvas(1920, 1080);
			var con = c.getContext2d();
			con.fillStyle = gradient;
			con.fillRect(0, 0, 1920, 1080);

			loadImage("BG", c.toDataURL()).then(resolve, reject);
		});
	}

	private static function loadStars(){
		return new Promise((resolve, reject) -> {
			var c = createCanvas(20, 20);
			var con = c.getContext2d();
			con.strokeStyle = "#fff";
			con.lineWidth = 5;
			
			con.beginPath();
			con.moveTo(0, 10);
			con.lineTo(20, 10);
			con.stroke();

			con.beginPath();
			con.moveTo(10, 0);
			con.lineTo(10, 20);
			con.stroke();

			loadImage("BGS", c.toDataURL()).then(resolve, reject);
		});
	}

	private static function createCanvas(w:Int, h:Int){
		var c = Browser.document.createCanvasElement();
		c.width = w;
		c.height = h;
		return c;
	}

}