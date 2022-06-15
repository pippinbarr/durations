package;

import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.FlxG;

class MilleniumDrummer extends FlxSprite
{
	private var BEAT_FRAME:Int = 4;
	private var BAR_FRAME:Int = 16;
	private var currentFrames:Int = 0;

	private var drumProbability:Float = 0.8;

	private var kick:FlxSound;
	private var snare:FlxSound;
	private var hihat:FlxSound;
	private var splash:FlxSound;

	private var userControlled:Bool = false;
	private var stopped:Bool = false;

	public function new (X:Float,Y:Float,UserControlled:Bool = false):Void
	{
		super(X,Y);

		userControlled = UserControlled;

		loadGraphic(GameAssets.MILLENIUM_DRUMS,true,false,11,10,true);
		replaceColor(0xFFFFFFFF,0xFFEECCFF);
		animation.add("idle",[0,0],10,true);
		animation.add("playing",[1,2,4,3,2,4,3,1,3,2,4,2,3,1],5,true);
		Helpers.setupSprite(this,8);
		animation.frameIndex = 0;
		animation.play("idle");

		kick = new FlxSound();
		kick.loadEmbedded(GameAssets.DRUM_KICK,false);
		snare = new FlxSound();
		snare.loadEmbedded(GameAssets.DRUM_SNARE,false);
		hihat = new FlxSound();
		hihat.loadEmbedded(GameAssets.DRUM_HIHAT,false);
		splash = new FlxSound();
		splash.loadEmbedded(GameAssets.DRUM_SPLASH,false);

		stopped = true;
	}

	override public function destroy():Void
	{
		kick.stop();
		kick.destroy();

		snare.stop();
		snare.destroy();

		hihat.stop();
		hihat.destroy();

		splash.stop();
		splash.destroy();

		super.destroy();
	}

	override public function update():Void
	{
		super.update();

		if (stopped) return;

		if (userControlled)
		{
			handleInput();
		}
		else
		{
			handleMusic();
		}
		handleAnimation();
	}



	public function stop():Void
	{
		stopped = true;

		kick.stop();
		snare.stop();
		hihat.stop();
		splash.stop();

		animation.play("idle");
	}


	public function start():Void
	{
		stopped = false;
	}


	private function handleInput():Void
	{
		FlxG.keys.justPressed.ONE ? kick.play(true) : null;
		FlxG.keys.justPressed.TWO ? snare.play(true) : null;
		FlxG.keys.justPressed.THREE ? hihat.play(true) : null;
		FlxG.keys.justPressed.FOUR ? splash.play(true) : null;
	}

	private function handleMusic():Void
	{
		currentFrames++;
		if (currentFrames % BEAT_FRAME == 0)
		{
			// Decide whether to play a note
			if (Math.random() < drumProbability)
			{
				var r:Float = Math.random();
				if (r < 0.25) kick.play();
				else if (r < 0.5) snare.play();
				else if (r < 0.75) hihat.play();
				else if (r < 1.0) splash.play();

				drumProbability += 0.05;
			}
			else
			{
				// Reduce note probability, as we didn't play one here
				drumProbability = Math.max(0.05,drumProbability - 0.2);
			}
		}

		if (currentFrames == BAR_FRAME)
		{
			currentFrames = 0;
		}
	}

	private function handleAnimation():Void
	{
		if (kick.playing || snare.playing || hihat.playing || splash.playing)
		{
			animation.play("playing");
		}
		else
		{
			animation.play("idle");
		}
	}
}