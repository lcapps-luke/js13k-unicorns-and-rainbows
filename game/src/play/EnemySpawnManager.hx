package play;

import play.enemy.ActionCloud;
import play.enemy.ActionSimple;
import play.enemy.ActionStarfish;
import play.enemy.DisplayCloud;
import play.enemy.DisplayMud;
import play.enemy.DisplayStarfish;
import play.enemy.Enemy;

class EnemySpawnManager{
	private var nextWaveTimer:Float = 0;
	public var difficulty:Float = 1.1;
	private var screen:PlayScreen;

	private var dispCloud = new DisplayCloud();
	private var actCloud = new ActionCloud();
	private var dispMud = new DisplayMud();
	private var actSimple = new ActionSimple();
	private var dispStarfish = new DisplayStarfish();
	private var actStarfish = new ActionStarfish();

	private var mudDefinition:EnemyDefinition;
	private var cloudDefinition:EnemyDefinition;
	private var starfishDefinition:EnemyDefinition;

	private var enemyDefinitions:Array<EnemyDefinition>;

	public function new(screen:PlayScreen){
		this.screen = screen;

		mudDefinition = {init: initMud, difficulty: 1.0, cooldown: 0.0, timeToHalfScreen: 960 / ActionSimple.SPEED};
		cloudDefinition = {init: initCloud, difficulty: 6.0, cooldown: 0.0, timeToHalfScreen: 960 / ActionCloud.SPEED};
		starfishDefinition = {init: initStarfish, difficulty: 8.0, cooldown: 0.0, timeToHalfScreen: 960 / ActionStarfish.SPEED};

		enemyDefinitions = [
			mudDefinition,
			cloudDefinition,
			starfishDefinition
		];
	}

	public function update(s:Float):Void{
		for(def in enemyDefinitions){
			def.cooldown -= s;
		}
		
		nextWaveTimer -= s;
		if(nextWaveTimer <= 0 || screen.enemies.alive == 0){
			nextWaveTimer = spawnWave();
		}
	}

	private function spawnWave():Float{
		var remainingDifficulty = difficulty;

		var validSelections = enemyDefinitions.filter(function(def) return def.difficulty <= difficulty);
		var maxTimeToHalfScreen = 0.0;
		var spawned:Array<Enemy> = [];

		while(validSelections.length > 0){
			// 1. choose random enemy definition from valid selections
			var selectedDef = validSelections[Math.floor(Math.random() * validSelections.length)];

			// 2. decrement total difficulty of selected enemy
			remainingDifficulty -= selectedDef.difficulty;
			if(remainingDifficulty <= 0) break;

			// 3. update the maximum time to half screen
			if(selectedDef.timeToHalfScreen > maxTimeToHalfScreen){
				maxTimeToHalfScreen = selectedDef.timeToHalfScreen;
			}

			// 4. spawn the enemy
			var e = screen.enemies.recycle(() -> new Enemy(screen));
			selectedDef.init(e);
			
			// 5. check if new enemy overlaps with any existing enemies
			var overlap = findOverlap(e, spawned);
			var limit = 10; // Limit the number of attempts to resolve overlap
			while(overlap != null && limit > 0){
				// If it overlaps, push it back to the right side of the screen and continue

				// calculate bound overlap
				var overlapAmount = e.bound.x + e.bound.w - overlap.bound.x;
				e.x += overlapAmount;
				trace('Overlap detected, moving enemy to the right by ' + overlapAmount);
				trace('New enemy position: ' + e.x + ', Overlapping enemy position: ' + overlap.x);

				overlap = findOverlap(e, spawned);

				limit--;
			}
			spawned.push(e);

			validSelections = enemyDefinitions.filter((def) -> def.cooldown <= 0 && def.difficulty <= difficulty);
		}
		
		return maxTimeToHalfScreen; // Return the maximum time to half screen
	}

	private function findOverlap(e:Enemy, spawned:Array<Enemy>):Null<Enemy>{
		for(existing in spawned){
			if(e.bound.overlaps(existing.bound)){
				return existing;
			}
		}
		return null;
	}

	private inline function initMud(e:Enemy){
		e.init(1920 + 48, 100 + Math.random() * 900, dispMud, actSimple);
	}
	private inline function initCloud(e:Enemy){
		e.init(1920 + 128, Math.random() * 16 + 48, dispCloud, actCloud);
		cloudDefinition.cooldown = 256 / ActionCloud.SPEED;
	}
	private inline function initStarfish(e:Enemy){
		e.init(1920 + 128, Math.random() * 900, dispStarfish, actStarfish);
	}
}

typedef EnemyDefinition = {
	var init:Enemy->Void;
	var difficulty:Float;
	var cooldown:Float;
	var timeToHalfScreen:Float;
}