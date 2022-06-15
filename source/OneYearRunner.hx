package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.FlxG;

import flixel.util.FlxTimer;
import flixel.util.FlxCollision;

import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.text.TextFormat;


class OneYearRunner extends BaseState
{
	private static var GROUND_SPEED:Int = 400;
	private static var BUILDING_SPEED:Int = 200;
	private static var SKY_SPEED:Int = 30;
	private static var JUMP_AMOUNT:Int = 300;

	private var GROUND_Y:Int;

	private var runner:FlxSprite;
	private var faller:FlxSprite;

	private var ground1:FlxSprite;
	private var ground2:FlxSprite;

	private var buildings1:FlxSprite;
	private var buildings2:FlxSprite;

	private var sky1:FlxSprite;
	private var sky2:FlxSprite;

	private var runnerIsGrounded:Bool = true;
	private var wall:Bool = false;

	private var coins:FlxGroup;


	private var score:Int = 0;

	override public function create():Void
	{




		duration = 31536000;
		// duration = 1 * 10;





		GROUND_Y = FlxG.height - 200;

		runner = new FlxSprite(50,208,GameAssets.YEAR_RUNNER);
		runner.loadGraphic(GameAssets.YEAR_RUNNER,true,false,4,9);
		runner.animation.add("running",[0,1,2,3,4,5],15,true);
		runner.animation.play("running");
		Helpers.setupSprite(runner,8);

		faller = new FlxSprite(50,208,GameAssets.YEAR_FALLER);
		faller.loadGraphic(GameAssets.YEAR_FALLER,true,false,9,9);
		faller.animation.add("falling",[0,1,2,3,4,5],15,false);		
		Helpers.setupSprite(faller,8);
		faller.visible = false;

		ground1 = new FlxSprite(0,GROUND_Y);
		ground1.loadGraphic(GameAssets.YEAR_GROUND,true,true,80,25);
		Helpers.setupSprite(ground1,8);
		ground1.animation.frameIndex = Std.int(Math.random() * ground1.frames);
		ground1.velocity.x = -GROUND_SPEED;

		ground2 = new FlxSprite(FlxG.width,GROUND_Y);
		ground2.loadGraphic(GameAssets.YEAR_GROUND,true,true,80,25);
		Helpers.setupSprite(ground2,8);
		ground2.animation.frameIndex = Std.int(Math.random() * ground2.frames);
		ground2.velocity.x = -GROUND_SPEED;

		buildings1 = new FlxSprite(0,0);
		buildings1.loadGraphic(GameAssets.YEAR_BUILDINGS,true,true,80,30);
		Helpers.setupSprite(buildings1,8);
		buildings1.animation.frameIndex = Std.int(Math.random() * buildings1.frames);
		buildings1.velocity.x = -BUILDING_SPEED;
		buildings1.y = ground1.y - buildings1.height;

		buildings2 = new FlxSprite(FlxG.width,0);
		buildings2.loadGraphic(GameAssets.YEAR_BUILDINGS,true,true,80,30);
		Helpers.setupSprite(buildings2,8);
		buildings2.animation.frameIndex = Std.int(Math.random() * buildings2.frames);
		buildings2.velocity.x = -BUILDING_SPEED;
		buildings2.y = ground1.y - buildings2.height;

		sky1 = new FlxSprite(0,0);
		sky1.loadGraphic(GameAssets.YEAR_SKY,true,true,80,30);
		Helpers.setupSprite(sky1,8);
		sky1.animation.frameIndex = Std.int(Math.random() * sky1.frames);
		sky1.velocity.x = -SKY_SPEED;

		sky2 = new FlxSprite(FlxG.width,0);
		sky2.loadGraphic(GameAssets.YEAR_SKY,true,true,80,30);
		Helpers.setupSprite(sky2,8);
		sky2.animation.frameIndex = Std.int(Math.random() * sky2.frames);
		sky2.velocity.x = -SKY_SPEED;

		coins = new FlxGroup();

		super.create();

		FlxG.camera.bgColor = 0xFFCCCCFF;

		display.add(sky1);
		display.add(sky2);
		display.add(buildings1);
		display.add(buildings2);
		display.add(ground1);
		display.add(ground2);
		display.add(coins);
		display.add(runner);
		display.add(faller);

		instructions.text = "RUN. COLLECT COINS.\nJUMP USING THE [SPACE BAR].";
		instructions.y = 4;
		thisState = OneYearRunner;

		statistics.text = "SCORE: 0";

		gameOverText.text = "RUN OVER";
	}


	override private function timerFinished(t:FlxTimer):Void
	{
		super.timerFinished(t);
	}

	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{		
		super.update();

		switch (state)
		{
			case PLAY:
			updateGround();
			updateBuildings();
			updateSky();
			updateStatistics();
			updateCoins();
			updateRunner();

			case WIN:

			case LOSE:

			case GAME_OVER:
		}
	}	


	private function updateStatistics():Void
	{
		statistics.text = "SCORE: " + score;
	}


	private function updateGround():Void
	{
		if (ground1.x + ground1.width <= 0)
		{
			if (timer.timeLeft > 10)
			{
				ground1.x = ground2.x + ground2.width;
			}
			else
			{
				ground1.loadGraphic(GameAssets.YEAR_WALL);
				Helpers.setupSprite(ground1,8);
				ground1.x = ground2.x + ground2.width;
				ground1.y = 0;
				wall = true;
			}
		}

		if (ground2.x + ground2.width <= 0)
		{
			if (timer.timeLeft > 10)
			{
				// ground2.x = FlxG.width + (ground2.x + ground2.width);
				ground2.x = ground1.x + ground1.width;
			}
			else
			{
				ground2.loadGraphic(GameAssets.YEAR_WALL);
				Helpers.setupSprite(ground2,8);
				ground2.x = ground1.x + ground1.width;
				ground2.y = 0;
				wall = true;
			}		
		}

		if (!faller.visible && (runner.overlapsAt(runner.x,runner.y - 10,ground1) || runner.overlapsAt(runner.x,runner.y-10,ground2)))
		{
			ground1.velocity.x = 0;
			ground2.velocity.x = 0;
			buildings1.velocity.x = 0;
			buildings2.velocity.x = 0;
			sky1.velocity.x = 0;
			sky2.velocity.x = 0;

			runner.animation.pause();
			runner.visible = false;

			faller.visible = true;
			faller.y = runner.y;
			// faller.x = runner.x;
			if (runner.overlapsAt(runner.x,runner.y - 10,ground1)) faller.x = ground1.x - faller.width;
			else faller.x = ground2.x - faller.width;

			GameAssets.INCORRECT_SOUND.play();

			if (runnerIsGrounded) faller.animation.play("falling");
		}
	}


	private function updateBuildings():Void
	{
		if (wall) return;
		if (buildings1.x + buildings1.width <= 0)
		{
			buildings1.x = FlxG.width + (buildings1.x + buildings1.width);
			buildings1.animation.frameIndex = Std.int(Math.random() * buildings1.frames);
			if (Math.random() > 0.5)
			{
				buildings1.facing = FlxObject.LEFT;
			}
			else
			{
				buildings1.facing = FlxObject.RIGHT;
			}
		}

		if (buildings2.x + buildings2.width <= 0)
		{
			buildings2.x = FlxG.width + (buildings2.x + buildings2.width);

			buildings2.animation.frameIndex = Std.int(Math.random() * buildings2.frames);
			if (Math.random() > 0.5)
			{
				buildings2.facing = FlxObject.LEFT;
			}
			else
			{
				buildings2.facing = FlxObject.RIGHT;
			}

		}

	}



	private function updateSky():Void
	{
		if (sky1.x + sky1.width <= 0)
		{
			// sky1.x = Std.int(FlxG.width + (sky1.x + sky1.width));
			sky1.x = Math.floor(sky2.x + sky2.width);
			sky1.animation.frameIndex = Std.int(Math.random() * sky1.frames);
			if (Math.random() > 0.5)
			{
				sky1.facing = FlxObject.LEFT;
			}
			else
			{
				sky1.facing = FlxObject.RIGHT;
			}
		}

		if (sky2.x + sky2.width <= 0)
		{
			// sky2.x = Std.int(FlxG.width + (sky2.x + sky2.width));

			sky2.x = Math.floor(sky1.x + sky1.width);
			sky2.animation.frameIndex = Std.int(Math.random() * sky2.frames);
			if (Math.random() > 0.5)
			{
				sky2.facing = FlxObject.LEFT;
			}
			else
			{
				sky2.facing = FlxObject.RIGHT;
			}

		}
	}

	private function updateCoins():Void
	{

		if (Math.random() > 0.9 && !wall)
		{
			var c:FlxSprite = cast(coins.recycle(FlxSprite),FlxSprite);
			c.revive();
			c.loadGraphic(GameAssets.YEAR_COIN);
			Helpers.setupSprite(c,8);
			c.x = FlxG.width;
			var r:Float = Math.random();

			if (r < 0.33)
			{
				c.y = 160;
			}
			else if (r < 0.66)
			{
				c.y = 120;
			}
			else
			{
				c.y = 200;
			}

			c.velocity.x = -GROUND_SPEED;

		}

		if (!runner.overlaps(coins)) return;

		for (i in 0...coins.members.length)
		{
			var coin:FlxSprite = cast(coins.members[i],FlxSprite);
			if (coin == null || !coin.active) return;

			if (runner.overlaps(coin))
			{
				coin.kill();
				score++;
				GameAssets.CORRECT_SOUND.play(true);
			}

			if (wall && (coin.overlaps(ground1) || coin.overlaps(ground2))) coin.kill();

		}



	}


	override public function handleInput():Void
	{
		super.handleInput();

		if (FlxG.keys.justPressed.SPACE && runnerIsGrounded && runner.visible)
		{
			runner.velocity.y = -JUMP_AMOUNT;
			runnerIsGrounded = false;
		}
	}


	private function updateRunner():Void
	{
		if (!faller.visible && !runnerIsGrounded)
		{
			runner.velocity.y += 20;

			if (runner.y + runner.height >= GROUND_Y + 2)
			{
				runner.velocity.y = 0;
				runner.y = GROUND_Y - runner.height;
				runnerIsGrounded = true;
			}
		}

		if (faller.visible && !runnerIsGrounded)
		{
			faller.velocity.y += 20;

			if (faller.y + faller.height >= GROUND_Y + 2)
			{
				faller.velocity.y = 0;
				faller.y = GROUND_Y - faller.height;
				runnerIsGrounded = true;

				faller.animation.play("falling");
			}
		}

	}
}