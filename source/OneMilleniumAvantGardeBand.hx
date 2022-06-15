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



class OneMilleniumAvantGardeBand extends BaseState
{
	private var audience:FlxGroup;
	private var curtain:FlxSprite;

	private var guitarist:MilleniumGuitarist;
	private var bassist:MilleniumBassist;
	private var keyboardist:MilleniumKeyboardist;
	private var drummer:MilleniumDrummer;

	private var playerKeyboardist:Bool = false;
	private var playerGuitarist:Bool = false;
	private var playerBassist:Bool = false;
	private var playerDrummer:Bool = false;

	public static var showsOver:Bool = false;

	override public function create():Void
	{



		duration = 31556925993;
		// duration = 1 * 30;




		super.create();

		showsOver = false;

		thisState = OneMilleniumAvantGardeBand;

		FlxG.camera.bgColor = 0xFFFFFFCC;

		var bg:FlxSprite = new FlxSprite(0,0,GameAssets.MILLENIUM_BG);
		Helpers.setupSprite(bg,8);

		var r:Float = Math.random();
		if (r < 0.25)
		{
			playerKeyboardist = true;
		}
		else if (r < 0.5)
		{
			playerGuitarist = true;
		}
		else if (r < 0.75) 
		{
			playerDrummer = true;
		}
		else 
		{
			playerBassist = true;
		}

		keyboardist = new MilleniumKeyboardist(120,80,playerKeyboardist);
		guitarist = new MilleniumGuitarist(keyboardist.x + keyboardist.width + 40,120,playerGuitarist);
		drummer = new MilleniumDrummer(guitarist.x + guitarist.width + 40,80,playerDrummer);
		bassist = new MilleniumBassist(drummer.x + drummer.width + 40,120,playerBassist);

		curtain = new FlxSprite(0,0,GameAssets.MILLENIUM_CURTAIN);
		Helpers.setupSprite(curtain,8);

		audience = new FlxGroup();
		for (i in 0...10)
		{
			var a:MilleniumAudience = new MilleniumAudience(i * 8*8,224);
			audience.add(a.mover);
			audience.add(a);
		}
		for (i in 0...10)
		{
			var a:MilleniumAudience = new MilleniumAudience(8 + i * 8*8,224 + 4*8);
			audience.add(a.mover);
			audience.add(a);
		}
		for (i in 0...10)
		{
			var a:MilleniumAudience = new MilleniumAudience(i * 8*8,224 + 8*8);
			audience.add(a.mover);
			audience.add(a);
		}
		for (i in 0...10)
		{
			var a:MilleniumAudience = new MilleniumAudience(8 + i * 8*8,224 + 12*8);
			audience.add(a.mover);
			audience.add(a);
		}
		for (i in 0...10)
		{
			var a:MilleniumAudience = new MilleniumAudience(i * 8*8,224 + 16*8);
			audience.add(a.mover);
			audience.add(a);
		}

		display.add(bg);
		display.add(guitarist);
		display.add(bassist);
		display.add(keyboardist);
		display.add(drummer);
		display.add(audience);

		fg.add(curtain);

		var attendance:Int = 0;
		for (i in 0...audience.members.length)
		{
			var a:FlxSprite = cast(audience.members[i],FlxSprite);
			if (a == null || !a.active) continue;
			if (a.animation.frameIndex == 1) attendance++;
		}

		instructions.text = "";
		statistics.text = "ATTENDANCE: " + attendance;
		gameOverText.text = "SHOW'S OVER";
		gameOverInstructionsText.text = "PRESS [E] FOR AN ENCORE PERFORMANCE\n\n" + gameOverInstructionsText.text;

		curtain.velocity.y = -40;

	}


	override private function timerFinished(t:FlxTimer):Void
	{
		super.timerFinished(t);

		guitarist.stop();
		keyboardist.stop();
		bassist.stop();
		drummer.stop();
	}

	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{		
		super.update();

		if (curtain.y + curtain.height <= 0 && curtain.velocity.y < 0) 
		{
			guitarist.start();
			keyboardist.start();
			bassist.start();
			drummer.start();

			curtain.velocity.y = 0;

			if (playerKeyboardist)
			{
				instructions.text = "USE THE [1-5 KEYS] TO PLAY KEYBOARDS IN THE BAND.";
			}
			else if (playerGuitarist)
			{
				instructions.text = "USE THE [1-5 KEYS] TO PLAY GUITAR IN THE BAND.";
			}
			else if (playerDrummer) 
			{
				instructions.text = "USE THE [1-4 KEYS] TO PLAY DRUMS IN THE BAND.";
			}
			else 
			{
				instructions.text = "USE THE [1-5 KEYS] TO PLAY BASS IN THE BAND.";
			}
		}
		if (curtain.y >= 0 && curtain.velocity.y > 0) 
		{
			curtain.velocity.y = 0;
			guitarist.stop();
			bassist.stop();
			drummer.stop();
			keyboardist.stop();

			showsOver = true;

			instructions.text = "";
		}

		switch (state)
		{
			case PLAY:
			if (timer.timeLeft <= 10 && curtain.y < 0) 
			{
				curtain.velocity.y = 40;
			}

			audience.sort();
			var attendance:Int = 0;
			for (i in 0...audience.members.length)
			{
				var a:FlxSprite = cast(audience.members[i],FlxSprite);
				if (a == null || !a.active) continue;
				if (a.animation.frameIndex == 1) attendance++;
			}

			statistics.text = "ATTENDANCE: " + attendance;

			case WIN:

			case LOSE:

			case GAME_OVER:
		}
	}	


	override public function handleInput():Void
	{
		super.handleInput();
	}


	override public function handleGameOverInput():Void
	{
		super.handleGameOverInput();

		if (FlxG.keys.justPressed.E)
		{
			FlxG.switchState(new OneMilleniumAvantGardeBand());
		}
	}

}