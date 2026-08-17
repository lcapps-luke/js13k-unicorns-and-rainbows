package play.enemy;

import js.html.CanvasRenderingContext2D;
import math.AABB;
import math.Vec2;

interface IDisplay{
	function init(hb:AABB, ho:Vec2, bb:AABB, bo:Vec2):Void;
	function draw(p:Vec2, c:CanvasRenderingContext2D, e:Enemy):Void;
}