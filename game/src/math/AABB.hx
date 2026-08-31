package math;

class AABB{
	public var x:Float;
	public var y:Float;
	public var w:Float;
	public var h:Float;

	public var b(get, null):Float;
	public var r(get, null):Float;

	public function new(x:Float = 0, y:Float = 0, w:Float = 0, h:Float = 0){
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
	}

	public function set(x:Float = 0, y:Float = 0, w:Float = 0, h:Float = 0) {
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
	}

	public function overlaps(o:AABB):Bool{
		return !(
			r < o.x ||
			x > o.r ||
			b < o.y ||
			y > o.b
		);
	}

	public function centerX() {
		return r / 2;
	}
	public function centerY() {
		return b / 2;
	}

	public function contains(ox, oy) {
		return !(
			ox < x ||
			ox > r ||
			oy < y ||
			oy > b
		);
	}

	@:native("mx")
	public function moveContactX(o:AABB, m:Float):Float {
		return moveContact(x, r, o.x, o.r, m);
	}

	@:native("my")
	public function moveContactY(o:AABB, m:Float):Float {
		return moveContact(y, b, o.y, o.b, m);
	}

	@:native("mc")
	private static function moveContact(l:Float, h:Float, ol:Float, oh:Float, m:Float):Float {
		var d:Float = (m > 0 ? ol - h : oh - l) * 0.9;
		return m > 0 ? Math.min(Math.abs(d), Math.abs(m)) : -Math.min(Math.abs(d), Math.abs(m));
	}

	function get_b():Float {
		return y + h;
	}

	function get_r():Float {
		return x + w;
	}
}