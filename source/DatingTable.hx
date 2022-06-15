package;

import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxObject;

import flixel.util.FlxTimer;


enum DatingTableState 
{
	PRE_QUESTION;
	QUESTION;
	POST_QUESTION;
	ANSWER;
	POST_ANSWER;
	REACTION;
	DATE_OVER;
}


class DatingTable extends FlxGroup
{
	private static var PEOPLE_COLOURS:Array<Int> = [
	0xFFDDDDFF,
	0xFFAAAAEE,
	0xFF5555BB,
	0xFF8888CC,
	0xFF333388,
	0xFF9999AA,
	];


	private static var SPEECH_COLOURS:Array<Int> = [
	0xFF111111,
	0xFF222222,
	0xFF333333,
	0xFF444444,
	0xFF555555,	
	0xFF666666,
	0xFF777777,	
	0xFF888888,
	0xFF999999,
	0xFFAAAAAA,
	0xFFBBBBBB,
	];

	private var QUESTIONS:Array<Array<String>>;
	private var REACTIONS_POSITIVE:Array<String>;
	private var REACTIONS_NEGATIVE:Array<String>;

	private var inputEnabled:Bool = false;
	public var dateIsOver:Bool = false;

	private var questionIndex:Int = 0;

	private var topDater:FlxSprite;
	private var table:FlxSprite;
	private var bottomDater:FlxSprite;

	private var topText:FlxText;
	private var topTextBG:FlxSprite;
	private var topTextTail:FlxSprite;

	private var bottomText:FlxText;
	private var bottomTextBG:FlxSprite;
	private var bottomTextTail:FlxSprite;

	private var topSpeechColour:Int;
	private var bottomSpeechColour:Int;

	private var timer:FlxTimer;

	private var tableState:DatingTableState;

	public var y:Float;

	public var good:Int = 0;
	public var bad:Int = 0;

	public function new (X:Float, Y:Float, InputEnabled:Bool = false):Void
	{
		super();

		QUESTIONS = [
		["DO YOU LIKE FLY FISHING?","YES.","NO."],
		["WHAT COLOUR HAIR DO YOU LIKE BEST?","BLONDE.","BRUNETTE.","RED."],
		["DO YOU HAVE A UNIVERSITY DEGREE?","YES.","NO."],
		["WHERE WOULD YOU GO ON YOUR DREAM DATE?","THE PARK.","THE MUSEUM.","THE MOVIES."],
		["DO YOU LIKE THE WAY I LOOK?","YES.","NOT REALLY."],
		["ARE YOU INTO CHEST HAIR?","YES.","NO.","HELL NO."],
		["DO YOU LOVE MATERIAL THINGS?","ALL OF THEM.","NO."],
		["CAN CRIMINALS REALLY BE REHABILITATED?","YES.","NO."],
		["WHO'S YOUR FAVOURITE ACTOR?","JOHN TRAVOLTA.","JODIE FOSTER."],
		["WHAT'S YOUR FAVOURITE COLOUR?","RED.","WHITE.","BLUE."],
		["DO YOU THINK LIFE HAS ANY MEANING?","YES.","NO.","YES AND NO."],
		["IS THERE AN AFTERLIFE?","YES.","NO.","HELL NO."],
		["DO YOU HAVE ANY PETS?","YES.","NO."],
		["WOULD YOU DESCRIBE YOURSELF AS A PEOPLE PERSON?","YES.","NO.","UMMMM..."],
		["DO YOU BELIEVE IN MIRACLES?","YES.","NOT REALLY."],
		["CAN I GET AN AMEN?","AMEN.","NO."],
		["ARE YOU A VEGETARIAN?","YES.","NO.","KIND OF."],
		["CAN YOU LIP-SYNCH TO VANILLA ICE SONGS?","OF COURSE.","OF COURSE NOT."],
		];

		REACTIONS_POSITIVE = [
		"OH GOOD.",
		"I THINK I LOVE YOU.",
		"PHEW.",
		"THAT'S NICE.",
		"LOVELY.",
		"GREAT.",
		"THAT'S LUCKY.",
		"YOU'RE JUST LIKE ME.",
		"WONDERFUL.",
		"PERFECT.",
		"JUST WHAT I WANTED TO HEAR.",
		"I THINK WE WERE MADE FOR EACH OTHER.",
		];

		REACTIONS_NEGATIVE = [
		"OH.",
		"HMM.",
		"WHATEVER.",
		"OH NO.",
		"YUCK.",
		"THAT'S A SHAME.",
		"OH WELL.",
		"UGH.",
		"THAT'S DISAPPOINTING.",
		"OH DEAR.",
		"THAT'S REALLY UNAPPEALING.",
		"I DON'T LIKE THAT ABOUT YOU.",
		"SERIOUSLY?",
		"OH COME ON.",
		"WELL, THIS WILL BE OVER SOON ANYWAY.",
		];


		y = Y;
		inputEnabled = InputEnabled;

		PEOPLE_COLOURS.sort(Helpers.randomSort);
		QUESTIONS.sort(Helpers.randomSort);
		SPEECH_COLOURS.sort(Helpers.randomSort);

		topDater = new FlxSprite(X,Y);
		topDater.loadGraphic(GameAssets.SHARED_PERSON,false,false,7,9,true);
		topDater.replaceColor(0xFF000000,PEOPLE_COLOURS[0]);
		Helpers.setupSprite(topDater,16);

		table = new FlxSprite(X - 16 * 1,Y + 16 * 5);
		table.loadGraphic(GameAssets.MINUTE_TABLE,false,false,9,5,true);
		Helpers.setupSprite(table,16);

		bottomDater = new FlxSprite(X + 8,Y + 16 * 2);
		bottomDater.loadGraphic(GameAssets.SHARED_PERSON,false,false,7,9,true);
		bottomDater.replaceColor(0xFF000000,PEOPLE_COLOURS[1]);		
		Helpers.setupSprite(bottomDater,16);

		if (inputEnabled)
		{
			topSpeechColour = 0xFF333333;
		}
		else
		{
			topSpeechColour = SPEECH_COLOURS[Math.floor(Math.random() * SPEECH_COLOURS.length)];
		}
		topText = new FlxText(topDater.x,topDater.y - 4*16,200,"");
		topText.setFormat(null,14,0xFFFFFFFF,"left");
		topText.visible = false;

		topTextBG = new FlxSprite(0,0);
		topTextBG.visible = false;

		topTextTail = new FlxSprite(topDater.x + topDater.width/2 + 2*8,topDater.y - 8);
		topTextTail.loadGraphic(GameAssets.MINUTE_BALLOON_TAIL_LEFT,false,true,6,3,true);
		topTextTail.replaceColor(0xFF000000,topSpeechColour);
		Helpers.setupSprite(topTextTail,8);
		topTextTail.visible = false;

		if (inputEnabled)
		{
			bottomSpeechColour = 0xFF000000;
		}
		else
		{
			bottomSpeechColour = SPEECH_COLOURS[Math.floor(Math.random() * SPEECH_COLOURS.length)];
		}

		bottomText = new FlxText(bottomDater.x - 4*16,0,200,"");
		bottomText.setFormat(null,14,0xFFFFFFFF,"left");
		bottomText.visible = false;

		bottomTextBG = new FlxSprite(0,0);
		bottomTextBG.visible = false;

		bottomTextTail = new FlxSprite(bottomDater.x - 8,bottomDater.y - 8);
		bottomTextTail.loadGraphic(GameAssets.MINUTE_BALLOON_TAIL,false,true,6,3,true);
		bottomTextTail.replaceColor(0xFF000000,bottomSpeechColour);
		Helpers.setupSprite(bottomTextTail,8);
		bottomTextTail.visible = false;

		if (!inputEnabled)
		{
			bottomText.alpha = 0.5;
			bottomTextBG.alpha = 0.5;
			bottomTextTail.alpha = 0.5;

			topText.alpha = 0.5;
			topTextBG.alpha = 0.5;
			topTextTail.alpha = 0.5;
		}

		add(topDater);
		add(table);
		add(bottomDater);

		add(topTextTail);
		add(topTextBG);
		add(topText);

		add(bottomTextTail);
		add(bottomTextBG);
		add(bottomText);

		timer = FlxTimer.start(Math.random() * 2 + 1, askQuestion);

		tableState = PRE_QUESTION;
	}


	private function askQuestion(t:FlxTimer):Void
	{
		if (inputEnabled) GameAssets.ACKNOWLEDGE_SOUND.play();

		questionIndex = (questionIndex + 1) % QUESTIONS.length;
		topText.text = QUESTIONS[questionIndex][0];
		topText.visible = true;
		topText.drawFrame(true);

		topTextBG.makeGraphic(Std.int(topText.width + 16),Std.int(topText.height + 16),topSpeechColour);
		topTextBG.x = topText.x - 8;
		topTextBG.y = topTextTail.y - topTextBG.height;
		topTextBG.visible = true;

		topText.y = topTextBG.y + 8;

		topTextTail.visible = true;

		timer = FlxTimer.start(1,finishQuestion);

		tableState = QUESTION;
	}


	private function finishQuestion(t:FlxTimer):Void
	{
		topText.visible = false;
		topTextBG.visible = false;
		topTextTail.visible = false;

		if (inputEnabled)
		{
			timer = FlxTimer.start(Math.random() * 2 + 1,tooSlow);
		}
		else
		{
			timer = FlxTimer.start(Math.random() * 1,answerQuestion);	
		}

		tableState = POST_QUESTION;
	}


	private function tooSlow(t:FlxTimer):Void
	{

		topText.text = "IT'S CALLED 'SPEED' DATING.";

		if (inputEnabled) GameAssets.INCORRECT_SOUND.play();

		bad++;

		topText.visible = true;
		topText.drawFrame(true);

		topTextBG.makeGraphic(Std.int(topText.width + 16),Std.int(topText.height + 16),topSpeechColour);
		topTextBG.x = topText.x - 8;
		topTextBG.y = topTextTail.y - topTextBG.height;
		topTextBG.visible = true;

		topText.y = topTextBG.y + 8;

		topTextTail.visible = true;

		timer = FlxTimer.start(1,finishReaction);

		tableState = REACTION;		
	}


	private function answerQuestion(t:FlxTimer):Void
	{
		var answerIndex = Math.floor(Math.random() * (QUESTIONS[questionIndex].length - 1)) + 1;
		bottomText.text = QUESTIONS[questionIndex][answerIndex];

		bottomText.visible = true;
		bottomText.drawFrame(true);

		bottomTextBG.makeGraphic(Std.int(bottomText.width + 16),Std.int(bottomText.height + 16),bottomSpeechColour);
		bottomTextBG.x = bottomText.x - 8;
		bottomTextBG.y = bottomTextTail.y - bottomTextBG.height;
		bottomTextBG.visible = true;

		bottomText.y = bottomTextBG.y + 8;

		bottomTextTail.visible = true;

		timer = FlxTimer.start(1,finishAnswer);

		tableState = ANSWER;
	}


	private function finishAnswer(t:FlxTimer):Void
	{
		bottomText.visible = false;
		bottomTextBG.visible = false;
		bottomTextTail.visible = false;

		timer = FlxTimer.start(Math.random() * 1,reactToAnswer);	

		tableState = POST_ANSWER;
	}


	private function reactToAnswer(t:FlxTimer):Void
	{
		if (Math.random() > 0.5)
		{
			if (inputEnabled) GameAssets.CORRECT_SOUND.play();
			good++;
			topText.text = REACTIONS_POSITIVE[Math.floor(Math.random() * REACTIONS_POSITIVE.length)];
		}
		else
		{
			if (inputEnabled) GameAssets.INCORRECT_SOUND.play();
			bad++;
			topText.text = REACTIONS_NEGATIVE[Math.floor(Math.random() * REACTIONS_NEGATIVE.length)];
		}
		topText.visible = true;
		topText.drawFrame(true);

		topTextBG.makeGraphic(Std.int(topText.width + 16),Std.int(topText.height + 16),topSpeechColour);
		topTextBG.x = topText.x - 8;
		topTextBG.y = topTextTail.y - topTextBG.height;
		topTextBG.visible = true;

		topText.y = topTextBG.y + 8;

		topTextTail.visible = true;

		timer = FlxTimer.start(1,finishReaction);

		tableState = REACTION;
	}	


	private function finishReaction(t:FlxTimer):Void
	{
		topText.visible = false;
		topTextBG.visible = false;
		topTextTail.visible = false;

		timer = FlxTimer.start(Math.random() * 1,askQuestion);	

		tableState = PRE_QUESTION;
	}


	public function getOptions():String
	{
		var options:String = "";

		if (tableState == POST_QUESTION && !dateIsOver)
		{
			if (QUESTIONS[questionIndex].length > 1)
			{
				options += "(A) " + QUESTIONS[questionIndex][1] + "  ";	
			}
			if (QUESTIONS[questionIndex].length > 2)
			{
				options += "(B) " + QUESTIONS[questionIndex][2] + "  ";	
			}
			if (QUESTIONS[questionIndex].length > 3)
			{
				options += "(C) " + QUESTIONS[questionIndex][3] + "  ";	
			}
			if (QUESTIONS[questionIndex].length > 4)
			{
				options += "(D) " + QUESTIONS[questionIndex][4] + "  ";	
			}		
		}

		return options;

	}


	private function handleInput():Void
	{
		if (dateIsOver) return;
		if (tableState != POST_QUESTION) return;

		bottomText.text = "";

		if (FlxG.keys.pressed.A && QUESTIONS[questionIndex].length > 1)
		{
			bottomText.text = QUESTIONS[questionIndex][1];
		}
		else if (FlxG.keys.pressed.B && QUESTIONS[questionIndex].length > 2)
		{
			bottomText.text = QUESTIONS[questionIndex][2];
		}
		else if (FlxG.keys.pressed.C && QUESTIONS[questionIndex].length > 3)
		{
			bottomText.text = QUESTIONS[questionIndex][3];
		}
		else if (FlxG.keys.pressed.D && QUESTIONS[questionIndex].length > 4)
		{
			bottomText.text = QUESTIONS[questionIndex][4];
		}

		if (bottomText.text == "") return;

		if (inputEnabled) GameAssets.ACKNOWLEDGE_SOUND.play();


		bottomText.visible = true;
		bottomText.drawFrame(true);

		bottomTextBG.makeGraphic(Std.int(bottomText.width + 16),Std.int(bottomText.height + 16),bottomSpeechColour);
		bottomTextBG.x = bottomText.x - 8;
		bottomTextBG.y = bottomTextTail.y - bottomTextBG.height;
		bottomTextBG.visible = true;

		bottomText.y = bottomTextBG.y + 8;

		bottomTextTail.visible = true;

		timer.abort();
		timer = FlxTimer.start(1,finishAnswer);

		tableState = ANSWER;
	}


	public function dateOver():Void
	{		
		if (dateIsOver) return;

		timer.abort();

		tableState = DATE_OVER;

		dateIsOver = true;

		bottomText.visible = false;
		bottomTextBG.visible = false;
		bottomTextTail.visible = false;

		topText.visible = false;
		topTextBG.visible = false;
		topTextTail.visible = false;

		timer = FlxTimer.start(Math.random() * 0.5,dateResult);
	}


	private function dateResult(t:FlxTimer):Void
	{
		timer.abort();
		
		remove(topText);
		topText = new FlxText(32,32,FlxG.width - 2*32,"");
		topText.setFormat(null,56,0xFFFFFFFF,"center");
		if (good/(good + bad) > 0.5)
		{
			topText.text = "YES!!!";
			if (inputEnabled) GameAssets.CORRECT_SOUND.play();
		}
		else
		{
			topText.text = "NO!!!";
			if (inputEnabled) GameAssets.INCORRECT_SOUND.play();
		}
		topText.visible = true;
		add(topText);

		topText.drawFrame(true);

		topTextBG.makeGraphic(Std.int(topText.width + 16),Std.int(topText.height + 16),topSpeechColour);
		topTextBG.x = topText.x - 8;
		topTextBG.y = topTextTail.y - topTextBG.height;
		topTextBG.visible = true;

		topText.y = topTextBG.y + 8;

		topTextTail.visible = true;	

		// topText.flicker(2);
	}


	override public function destroy():Void
	{
		topText.destroy();
		topTextBG.destroy();
		topTextTail.destroy();

		bottomText.destroy();
		bottomTextBG.destroy();
		bottomTextTail.destroy();

		super.destroy();
	}


	override public function update():Void
	{
		super.update();

		handleInput();
	}

}