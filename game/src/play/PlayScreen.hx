package play;

import menu.MenuScreen;
import play.enemy.ActionCloud;
import play.enemy.DisplayCloud;
import play.enemy.Enemy;

class PlayScreen implements IScreen{
	public var player(default, null):Player;
	public var playerBullets(default, null):ObjArray<PlayerBullet>;
	public var enemies(default, null):ObjArray<Enemy>;

	private var spawnTimer = 3.0;

	private var dispCloud = new DisplayCloud();
	private var actCloud = new ActionCloud();

	public var gameover:Bool = false;
	private var gameoverTimer:Float = 3;
	
	public function new(){
		player = new Player(this);
		playerBullets = new ObjArray<PlayerBullet>();
		enemies = new ObjArray<Enemy>();
	}
	
	public function update(s:Float) {
		if(player.alive){
			player.update(s);
		}
		playerBullets.update(s);
		enemies.update(s);

		spawnTimer -= s;
		if(spawnTimer < 0){
			spawnTimer = 3;

			spawnEnemy();
		}


		if(gameover){
			gameoverTimer -= s;
			if(gameoverTimer < 0){
				Main.screen = new MenuScreen();
			}
		}
	}

	private function spawnEnemy(){
		var e:Enemy = enemies.recycle(() -> new Enemy(this));
		e.init(1920 + 128, Math.random() * 16 + 48, dispCloud, actCloud);
	}
}