package play;

class PlayScreen implements IScreen{
	private var player:Player;
	
	public function new(){
		player = new Player();
	}
	

	public function update(s:Float) {
		player.update(s);
	}
}