package play;

import menu.MenuScreen;
import play.enemy.ActionCloud;
import play.enemy.ActionSimple;
import play.enemy.ActionStarfish;
import play.enemy.DisplayCloud;
import play.enemy.DisplayMud;
import play.enemy.DisplayStarfish;
import play.enemy.Enemy;
import play.enemy.EnemyBullet;
import resources.Resources;

class PlayScreen implements IScreen{
	private static inline var STAR_TIMER_MIN = 3.0;
	private static inline var STAR_TIMER_MAX = 5.0;
	private static inline var STAR_SPEED_MIN = 30.0;
	private static inline var STAR_SPEED_MAX = 50.0;
	private static inline var STAR_TIME_PREFIL = 1920 / STAR_SPEED_MIN;
	private static inline var DOUGHNUT_QTY_MAX = 3;
	private static var DOUGHNUT_CHANCE = [0.2, 0.1, 0.05, 0];

	public var player(default, null):Player;
	public var playerBullets(default, null):ObjArray<PlayerBullet>;
	public var enemies(default, null):ObjArray<Enemy>;
	public var enemyBullets(default, null):ObjArray<EnemyBullet>;
	public var doughnuts(default, null):ObjArray<Doughnut>;

	private var spawnTimer = 3.0;

	private var dispCloud = new DisplayCloud();
	private var actCloud = new ActionCloud();
	private var dispMud = new DisplayMud();
	private var actSimple = new ActionSimple();
	private var dispStarfish = new DisplayStarfish();
	private var actStarfish = new ActionStarfish();

	public var gameover:Bool = false;
	private var gameoverTimer:Float = 3;

	private var bg = Resources.images.get("BG");
	private var bgCn = Resources.images.get(Resources.BG_CLOUD_NEAR);
	private var bgCnx = 0.0;
	private var bgCf = Resources.images.get(Resources.BG_CLOUD_FAR);
	private var bgCfx = 0.0;
	private var bgParticles = new ObjArray<Particle>();
	private var bgSTimer:Float = 0;

	public var score:Int = 0;
	
	public function new(){
		player = new Player(this);
		playerBullets = new ObjArray<PlayerBullet>();
		enemies = new ObjArray<Enemy>();
		enemyBullets = new ObjArray<EnemyBullet>();
		doughnuts = new ObjArray<Doughnut>();

		var st = 0.0;
		var sx = 0.0;
		while(st < STAR_TIME_PREFIL){
			var t = STAR_TIMER_MIN + Math.random() * STAR_TIMER_MAX;
			st += t;
			var p = bgParticles.recycle(() -> new Particle(this));
			p.init(Resources.images.get("BGS"), 20, 20);
			p.x = sx;
			p.y = Math.random() * 1080;

			var f = Math.random() > 0.5;
			p.vel.set(f ? -STAR_SPEED_MIN : -STAR_SPEED_MAX, 0);
			p.filter = f ? "brightness(50%)" : "brightness(70%)";

			sx -= p.vel.x * t;
		}
	}
	
	public function update(s:Float) {
		Main.context.drawImage(bg, 0, 0);
		
		bgSTimer -= s;
		if(bgSTimer < 0){
			bgSTimer = STAR_TIMER_MIN + Math.random() * STAR_TIMER_MAX;
			var p = bgParticles.recycle(() -> new Particle(this));
			p.init(Resources.images.get("BGS"), 20, 20);
			p.x = 1919;
			p.y = Math.random() * 1080;

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
		enemyBullets.update(s);
		doughnuts.update(s);

		spawnTimer -= s;
		if(spawnTimer < 0){
			spawnTimer = 1.5;
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

		// HUD
		Main.context.fillStyle = "#fff";
		Main.context.font = "bold 48px cursive";
		var txt = "SCORE: " + StringTools.lpad(Std.string(score), "0", 6);
		var txtWidth = Main.context.measureText(txt).width;
		Main.context.fillText(txt, 1920 - txtWidth - 50, 50);

		Main.context.fillStyle = Resources.rainbowGradient(660, 0, 1260, 0);
		Main.context.fillRect(660, 1020, 600 * (player.beamTimer / Player.BEAM_TIMER_MAX), 50);
		Main.context.strokeStyle = "#000";
		Main.context.lineWidth = 4;
		Main.context.strokeRect(660, 1020, 600, 50);
	}

	private function spawnEnemy(){
		var r = Math.random();

		var e:Enemy = enemies.recycle(() -> new Enemy(this));

		if(r > 0.3){
			e.init(1920 + 48, 100 + Math.random() * 900, dispMud, actSimple);
		}else if(r > 0.1){
			e.init(1920 + 128, Math.random() * 1080, dispStarfish, actStarfish);
		} else{
			e.init(1920 + 128, Math.random() * 16 + 48, dispCloud, actCloud);
		}
	}

	public function onEnemyKill(e:Enemy){
		var nutQty = player.doughnuts + doughnuts.alive;
		var chance = DOUGHNUT_CHANCE[nutQty];
		if(Math.random() < chance){
			spawnDoughnut(e.bound.centerX(), e.bound.centerY(), false);
		}

		score += e.score;
		player.beamTimer += 0.2;
	}

	public function spawnDoughnut(x:Float, y:Float, burst:Bool) {
		var n = doughnuts.recycle(() -> new Doughnut(this));
		n.init(x, y);
		if(burst){
			n.launch();
		}
	}
}
