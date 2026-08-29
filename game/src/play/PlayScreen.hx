package play;

import menu.MenuScreen;
import play.enemy.ActionCloud;
import play.enemy.DisplayCloud;
import play.enemy.Enemy;
import resources.Resources;

class PlayScreen implements IScreen{
	private static inline var STAR_TIMER_MIN = 3.0;
	private static inline var STAR_TIMER_MAX = 5.0;
	private static inline var STAR_SPEED_MIN = 30.0;
	private static inline var STAR_SPEED_MAX = 50.0;
	private static inline var STAR_TIME_PREFIL = 1920 / STAR_SPEED_MIN;

	public var player(default, null):Player;
	public var playerBullets(default, null):ObjArray<PlayerBullet>;
	public var enemies(default, null):ObjArray<Enemy>;

	private var spawnTimer = 3.0;

	private var dispCloud = new DisplayCloud();
	private var actCloud = new ActionCloud();

	public var gameover:Bool = false;
	private var gameoverTimer:Float = 3;

	private var bg = Resources.images.get("BG");
	private var bgCn = Resources.images.get(Resources.BG_CLOUD_NEAR);
	private var bgCnx = 0.0;
	private var bgCf = Resources.images.get(Resources.BG_CLOUD_FAR);
	private var bgCfx = 0.0;
	private var bgParticles = new ObjArray<Particle>();
	private var bgSTimer:Float = 0;
	
	public function new(){
		player = new Player(this);
		playerBullets = new ObjArray<PlayerBullet>();
		enemies = new ObjArray<Enemy>();

		var st = 0.0;
		var sx = 0.0;
		while(st < STAR_TIME_PREFIL){
			var t = STAR_TIMER_MIN + Math.random() * STAR_TIMER_MAX;
			st += t;
			var p = bgParticles.recycle(() -> new Particle(this));
			p.init(Resources.images.get("BGS"), 20, 20);
			p.pos.set(sx, Math.random() * 1080);
			
			var f = Math.random() > 0.5;
			p.vel.set(f ? -STAR_SPEED_MIN : -STAR_SPEED_MAX, 0);
			p.filter = f ? "brightness(50%)" : "brightness(70%)";

			sx -= p.vel.x * t;
			trace('Spawned at $sx');
		}
	}
	
	public function update(s:Float) {
		Main.context.drawImage(bg, 0, 0);
		
		bgSTimer -= s;
		if(bgSTimer < 0){
			bgSTimer = STAR_TIMER_MIN + Math.random() * STAR_TIMER_MAX;
			var p = bgParticles.recycle(() -> new Particle(this));
			p.init(Resources.images.get("BGS"), 20, 20);
			p.pos.set(1919, Math.random() * 1080);
			
			var f = Math.random() > 0.5;
			p.vel.set(f ? -STAR_SPEED_MIN : -STAR_SPEED_MAX, 0);
			p.filter = f ? "brightness(50%)" : "brightness(70%)";
		}

		bgParticles.update(s);

		bgCnx -= 150 * s;
		if(bgCnx <= -1920){
			bgCnx += 1920;
		}

		bgCfx -= 80 * s;
		if(bgCfx <= -1920){
			bgCfx += 1920;
		}

		Main.context.drawImage(bgCf, bgCfx, 1080-250);
		Main.context.drawImage(bgCf, bgCfx + 1920, 1080-250);

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

		Main.context.drawImage(bgCn, bgCnx, 1080-170);
		Main.context.drawImage(bgCn, bgCnx + 1920, 1080-170);
	}

	private function spawnEnemy(){
		var e:Enemy = enemies.recycle(() -> new Enemy(this));
		e.init(1920 + 128, Math.random() * 16 + 48, dispCloud, actCloud);
	}
}
