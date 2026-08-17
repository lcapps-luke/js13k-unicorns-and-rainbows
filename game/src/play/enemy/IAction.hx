package play.enemy;

interface IAction{
	function init(e:Enemy):Void;
	function update(p:PlayScreen, s:Float, e:Enemy):Void;
}