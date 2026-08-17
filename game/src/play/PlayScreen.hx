package play;

class PlayScreen implements IScreen{
	public var player(default, null):Player;
	public var playerBullets(default, null):ObjArray<PlayerBullet>;
	
	public function new(){
		player = new Player(this);
		playerBullets = new ObjArray<PlayerBullet>();
	}
	
	public function update(s:Float) {
		player.update(s);
		playerBullets.update(s);
	}
}