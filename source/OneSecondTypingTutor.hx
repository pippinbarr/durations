package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;

import flixel.text.FlxText;

import flixel.group.FlxGroup;

import flixel.util.FlxTimer;

import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.text.TextFormat;


class OneSecondTypingTutor extends BaseState
{
	private var word:FlxText;
	private var answer:FlxText;

	private var tick:FlxSprite;
	private var cross:FlxSprite;

	private var wordIndex:Int = 0;

	private static var WORDS:Array<String> = [
	"DEAD","DEATH","WEEP","SADDEN","CRY","MOURN",
	"MOAN","WRITHE","STARE","BLANK","DEADEN",
	"FALL","BLEAK","DESPAIR","FALLEN","SLIDE",
	"SLIP","GLOOM","NIGHT","DARK","GRIM","GREY",
	"DIRTY","FILTH","WILT",
	];


	override public function create():Void
	{



		duration = 1;



		var bg:FlxSprite = new FlxSprite(0,0,GameAssets.SECOND_BG);
		// bg.setOriginToCorner();
		Helpers.setupSprite(bg,8);
		add(bg);

		var tutor:FlxSprite = new FlxSprite(100,248,GameAssets.SECOND_TUTOR);
		// tutor.setOriginToCorner();
		Helpers.setupSprite(tutor,8);
		add(tutor);

		var blackboard:FlxSprite = new FlxSprite(260,120,GameAssets.SECOND_BLACKBOARD);
		// blackboard.setOriginToCorner();
		Helpers.setupSprite(blackboard,8);
		add(blackboard);

		var wordString:String = WORDS[Math.floor(Math.random() * WORDS.length)];

		word = new FlxText(0,0,FlxG.width,wordString);
		word.setFormat(null,Std.int(FlxG.height/15),0xFFFFFFFF,"left");
		word.x = 340;
		word.y = 160;
		add(word);

		answer = new FlxText(0,0,FlxG.width,"");
		answer.setFormat(null,Std.int(FlxG.height/15),0xFFFFFFFF,"left");
		answer.x = 340;
		answer.y = 200;
		add(answer);

		tick = new FlxSprite(280,answer.y,GameAssets.SECOND_TICK);
		// tick.setOriginToCorner();
		// tick.scale.x = tick.scale.y = 8;
		tick.visible = false;
		Helpers.setupSprite(tick,8);
		add(tick);

		cross = new FlxSprite(280,answer.y,GameAssets.SECOND_CROSS);
		// cross.setOriginToCorner();
		// cross.scale.x = cross.scale.y = 8;
		Helpers.setupSprite(cross,8);
		cross.visible = false;
		add(cross);
		
		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);

		super.create();

		instructions.text = "TYPE THE WORD ON THE BLACKBOARD";
		gameOverText.text = "LESSON OVER.";
		thisState = OneSecondTypingTutor;

	}


	override private function timerFinished(t:FlxTimer):Void
	{
		if (!tick.visible) 
		{
			cross.visible = true;
			GameAssets.INCORRECT_SOUND.play();
		}
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);

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

			case WIN:

			case LOSE:

			case GAME_OVER:
		}
	}	


	private function onKeyDown(e:KeyboardEvent):Void
	{
		var char:String = String.fromCharCode(e.charCode);
		var charUpper:String = String.fromCharCode(e.charCode).toUpperCase();

		answer.text += charUpper;

		var correct:String = word.text.charAt(wordIndex);
		var correctUpper:String = word.text.charAt(wordIndex).toUpperCase();

		GameAssets.TAP_SOUND.play();

		if (charUpper == correctUpper)
		{
			wordIndex++;
			if (wordIndex == word.text.length)
			{
				handleCorrect();
			}
		}
		else
		{
			handleIncorrect();
		}
	}


	private function handleCorrect():Void
	{
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);

		tick.visible = true;
		state = WIN;

		GameAssets.CORRECT_SOUND.play();

		// FlxG.camera.bgColor = 0xFF336633;
	}



	private function handleIncorrect():Void
	{
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);

		cross.visible = true;
		state = LOSE;

		GameAssets.INCORRECT_SOUND.play();

		// FlxG.camera.bgColor = 0xFF663333;
	}

}