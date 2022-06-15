package;

import flixel.FlxGame;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.system.FlxSound;


import flash.Lib;
import flash.events.Event;

class ProjectClass extends FlxGame
{	
	
	public static var focused:Bool = true;
	private var focus:FlxSprite;

	public function new()
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		var ratioX:Float = stageWidth / 640;
		var ratioY:Float = stageHeight / 480;
		var ratio:Float = Math.min(ratioX, ratioY);

		super(Math.ceil(stageWidth / ratio), Math.ceil(stageHeight / ratio), MenuState, ratio, 30, 30, true);

		GameAssets.CORRECT_SOUND = new FlxSound();
		GameAssets.CORRECT_SOUND.loadEmbedded("assets/mp3/shared/correct.mp3");
		GameAssets.INCORRECT_SOUND = new FlxSound();
		GameAssets.INCORRECT_SOUND.loadEmbedded("assets/mp3/shared/incorrect.mp3");
		GameAssets.ACKNOWLEDGE_SOUND = new FlxSound();
		GameAssets.ACKNOWLEDGE_SOUND.loadEmbedded("assets/mp3/shared/acknowledge.mp3");
		GameAssets.TAP_SOUND = new FlxSound();
		GameAssets.TAP_SOUND.loadEmbedded("assets/mp3/shared/typewriter_key.mp3");


		// FlxG.sound.keyMute = null;
		// FlxG.sound.keyVolumeDown = null;
		// FlxG.sound.keyVolumeUp = null;
		FlxG.sound.volume = 1;
		FlxG.sound.muted = false;
	}


	override public function onFocusLost(e:Event = null):Void
	{
		focused = false;
	}


	override public function onFocus(e:Event = null):Void
	{
		focused = true;
	}
}
