package;

import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.FlxG;

class MilleniumBassist extends FlxSprite
{
	private var BEAT_FRAME:Int = 4;
	private var BAR_FRAME:Int = 16;
	private var currentFrames:Int = 0;

	private var noteProbability:Float = 0.8;

	private var aNote:FlxSound;
	private var bNote:FlxSound;
	private var dNote:FlxSound;
	private var eNote:FlxSound;
	private var fNote:FlxSound;

	private var userControlled:Bool = false;
	private var stopped:Bool = false;

	public function new (X:Float,Y:Float,UserControlled:Bool = false):Void
	{
		super(X,Y);

		userControlled = UserControlled;

		loadGraphic(GameAssets.MILLENIUM_GUITAR,true,false,8,9,true);
		replaceColor(0xFFFFFFFF,0xFFEECCFF);
		animation.add("idle",[0,0],10,true);
		animation.add("playing",[1,2,1,2,3,4,1,2,3,4,3,4,1,2,3,4,3,4,3,4],5,true);
		Helpers.setupSprite(this,8);
		animation.frameIndex = 0;
		animation.play("idle");

		aNote = new FlxSound();
		aNote.loadEmbedded(GameAssets.BASS_A,true);
		bNote = new FlxSound();
		bNote.loadEmbedded(GameAssets.BASS_B,true);
		dNote = new FlxSound();
		dNote.loadEmbedded(GameAssets.BASS_D,true);
		eNote = new FlxSound();
		eNote.loadEmbedded(GameAssets.BASS_E,true);
		fNote = new FlxSound();
		fNote.loadEmbedded(GameAssets.BASS_F,true);

		stopped = true;
	}

	override public function destroy():Void
	{
		aNote.stop();
		aNote.destroy();

		bNote.stop();
		bNote.destroy();

		dNote.stop();
		dNote.destroy();

		eNote.stop();
		eNote.destroy();

		fNote.stop();
		fNote.destroy();

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

		aNote.stop();
		bNote.stop();
		dNote.stop();
		eNote.stop();
		fNote.stop();

		animation.play("idle");
	}


	public function start():Void
	{
		stopped = false;
	}


	private function handleInput():Void
	{
		FlxG.keys.pressed.ONE ? aNote.play() : aNote.stop();
		FlxG.keys.pressed.TWO ? bNote.play() : bNote.stop();
		FlxG.keys.pressed.THREE ? dNote.play() : dNote.stop();
		FlxG.keys.pressed.FOUR ? eNote.play() : eNote.stop();
		FlxG.keys.pressed.FIVE ? fNote.play() : fNote.stop();

	}

	private function handleMusic():Void
	{
		currentFrames++;
		if (currentFrames % BEAT_FRAME == 0)
		{
			// Decide whether to play a note
			if (Math.random() < noteProbability)
			{
				var r:Float = Math.random();
				if (r < 0.2) aNote.play();
				else if (r < 0.4) bNote.play();
				else if (r < 0.6) dNote.play();
				else if (r < 0.8) eNote.play();
				else fNote.play();

				noteProbability += 0.1;
			}
			else
			{
				// Reduce note probability, as we didn't play one here
				noteProbability = Math.max(0.01,noteProbability - 0.1);
			}

			// Decide whether to stop a note
			if (aNote.playing && Math.random() < 0.8) aNote.stop();
			if (bNote.playing && Math.random() < 0.8) bNote.stop();
			if (dNote.playing && Math.random() < 0.8) dNote.stop();
			if (eNote.playing && Math.random() < 0.8) eNote.stop();
			if (fNote.playing && Math.random() < 0.8) fNote.stop();
		}

		if (currentFrames == BAR_FRAME)
		{
			currentFrames = 0;
		}
	}

	private function handleAnimation():Void
	{
		if (aNote.playing || bNote.playing || dNote.playing || eNote.playing || fNote.playing)
		{
			animation.play("playing");
		}
		else
		{
			animation.play("idle");
		}

	}
}