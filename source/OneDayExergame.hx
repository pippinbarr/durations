package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.FlxG;

import flixel.util.FlxTimer;

import flixel.tweens.misc.VarTween;
import flixel.tweens.FlxTween;

import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.text.TextFormat;
import flash.net.FileReference;



enum DayState
{
	PUSHUPS;
	SITUPS;
	PULLUPS;
	CYCLE;
	SHOWER;
}


class OneDayExergame extends BaseState
{
	private static var MAX_UP_DELAY:Float = 0.15;
	private static var REST_DELAY:Float = 2.0;

	private static var PUSHUP_UP_FRAMES:Array<Int> = [1,2,3,4];
	private static var PUSHUP_DOWN_FRAMES:Array<Int> = [4,3,2,1];
	private static var PUSHUP_REST_FRAME:Int = 0;

	private static var SITUP_UP_FRAMES:Array<Int> = [1,2,3,4];
	private static var SITUP_DOWN_FRAMES:Array<Int> = [4,3,2,1];
	private static var SITUP_REST_FRAME:Int = 0;

	private static var PULLUP_UP_FRAMES:Array<Int> = [1,2,3,4];
	private static var PULLUP_DOWN_FRAMES:Array<Int> = [4,3,2,1];
	private static var PULLUP_REST_FRAME:Int = 0;

	private static var exercises:Array<DayState> = [PUSHUPS, SITUPS, PULLUPS, CYCLE];
	private var exerciseIndex:Int = 0;

	private var dayState:DayState;

	private var exercisesCompleted:Array<Int>;

	private var cycleTenMetersCompleted:Float = 0;
	private var previousCycleTenMetersCompleted:Float = 0;
	private var mileStone:Float = 100;

	private var PUSHUP_INDEX:Int = 0;
	private var SITUP_INDEX:Int = 1;
	private var PULLUP_INDEX:Int = 2;

	private var pushupSprite:FlxSprite;
	private var situpSprite:FlxSprite;
	private var pullupSprite:FlxSprite;
	private var pullupBarSprite:FlxSprite;
	private var cycleSprite:FlxSprite;
	private var showerSprite:FlxSprite;

	private var timeSinceLastUp:Float = 0;
	private var timeSinceLastCycle:Float = 0;
	private var lastCycleKeyWasLeft:Bool = false;
	private var timeSpentCycling:Float = 0;

	private var currentExerciseCompleted:Array<Bool>;


	private var lastAnimName:String;
	private var lastAnimFrame:UInt;
	private var lastAnimFrameIndex:UInt;

	private static var TWEEN_TIME:Float = 0.2;
	private static var TWEEN_PAUSE_TIME:Float = 0.5;
	private var tweenTimer:FlxTimer;
	private var currentTweenTarget:FlxTextWithBG;
	private var currentTweenInComplete:Bool = false;
	private var tweeningIn:Bool = false;
	private var tweeningOut:Bool = false;

	private var motivation:FlxTextWithBG;
	private var motivationTimer:FlxTimer;

	private var exerciseTimer:FlxTimer;

	private static var MOTIVATION_TIME:Float = 10;
	private static var MOTIVATION_MIN:Float = 5;

	private static var MOTIVATIONS:Array<String> = [
	"EYE OF THE TIGER!",
	"YOU GOT THIS!",
	"ALL DAY, BABY!",
	"NO RETREAT!",
	"NO SURRENDER!",
	"IT'S ALL YOU!",
	"PUMP IT UP!",
	"WORK IT!",
	"YES YES YES!",
	"THIS IS YOUR MOMENT!",
	"YOU GOTTA WORK!",
	"KEEP IT GOING!",
	"IT'S ON YOU!",
	"SWEAT!",
	"HARDER!",
	"FASTER!",
	"BE STRONG!",
	"KEEP IT UP!",
	"PUMP IT!",
	"THIS IS YOUR LIFE!",
	"WORK WORK WORK!",
	"FEEL THE BURN!",
	"GO GO GO!",
	"JUST DO IT!",
	"YOU'RE A CHAMP!",
	"PUMP IT!",
	"BOOM!",
	"YES YES YES!",
	"THAT'S IT!",
	"FEEL THE BURN!",
	];

	override public function create():Void
	{



		duration = 86400;
		// duration = 1 * 10;



		exercisesCompleted = [0,0,0];
		currentExerciseCompleted = [false,false,false];

		var bg:FlxSprite = new FlxSprite(0,0,GameAssets.DAY_BG);
		Helpers.setupSprite(bg,8);
		add(bg);

		pushupSprite = new FlxSprite(100,100);
		pushupSprite.loadGraphic(GameAssets.DAY_PUSHUP,true,false,10,5);
		Helpers.setupSprite(pushupSprite,32);
		pushupSprite.x = FlxG.width/2 - pushupSprite.width/2;
		pushupSprite.y = 220;
		pushupSprite.animation.add("pushup-up",PUSHUP_UP_FRAMES,5,false);
		pushupSprite.animation.add("pushup-down",PUSHUP_DOWN_FRAMES,3,false);
		pushupSprite.animation.callback = animationCallback;
		pushupSprite.animation.frameIndex = 1;
		pushupSprite.visible = false;

		pullupSprite = new FlxSprite(100,100);
		pullupSprite.loadGraphic(GameAssets.DAY_PULLUP,true,false,7,13);
		Helpers.setupSprite(pullupSprite,32);
		pullupSprite.x = FlxG.width/2 - pullupSprite.width/2;
		pullupSprite.y = 40;
		pullupSprite.animation.add("pullup-up",PULLUP_UP_FRAMES,5,false);
		pullupSprite.animation.add("pullup-down",PULLUP_DOWN_FRAMES,3,false);
		pullupSprite.animation.callback = animationCallback;
		pullupSprite.animation.frameIndex = 1;
		pullupSprite.visible = false;

		pullupBarSprite = new FlxSprite(0,pullupSprite.y,GameAssets.DAY_PULLUP_BAR);
		Helpers.setupSprite(pullupBarSprite,32);
		pullupBarSprite.x = 0;
		pullupBarSprite.y = pullupSprite.y + 32*2;

		situpSprite = new FlxSprite(100,100);
		situpSprite.loadGraphic(GameAssets.DAY_SITUP,true,false,9,6);
		Helpers.setupSprite(situpSprite,32);
		situpSprite.x = FlxG.width/2 - situpSprite.width/2;
		situpSprite.y = 220;
		situpSprite.animation.add("situp-up",SITUP_UP_FRAMES,5,false);
		situpSprite.animation.add("situp-down",SITUP_DOWN_FRAMES,3,false);
		situpSprite.animation.callback = animationCallback;
		situpSprite.animation.frameIndex = 1;
		situpSprite.visible = false;

		cycleSprite = new FlxSprite(100,100);
		cycleSprite.loadGraphic(GameAssets.DAY_CYCLE,true,false,7,11);
		Helpers.setupSprite(cycleSprite,32);
		cycleSprite.x = FlxG.width/2 - cycleSprite.width/2;
		cycleSprite.y = 60;
		cycleSprite.animation.add("cycle",[0,0,1,1,2,2,3,3,4,4],20,true);
		cycleSprite.visible = false;


		showerSprite = new FlxSprite(100,100);
		showerSprite.loadGraphic(GameAssets.DAY_SHOWER,true,false,7,14);
		Helpers.setupSprite(showerSprite,32);
		showerSprite.x = FlxG.width/2 - showerSprite.width/2;
		showerSprite.y = 40;
		showerSprite.animation.add("shower",[0,1],20,true);
		showerSprite.visible = false;
		showerSprite.animation.play("shower");


		super.create();

		display.add(pushupSprite);
		display.add(pullupBarSprite);
		display.add(pullupSprite);
		display.add(situpSprite);
		display.add(cycleSprite);
		display.add(showerSprite);

		startExercising();

		gameOverText.text = "EXERCISE OVER.";
		thisState = OneDayExergame;

		motivation = new FlxTextWithBG(-FlxG.width,FlxG.height/3,FlxG.width,"ALL DAY BABY!",36,"center",0xFFFFFFFF,0xFF000000);
		add(motivation);
		
		motivationTimer = FlxTimer.start(Math.random() * MOTIVATION_TIME + MOTIVATION_MIN,handleMotivation);
	}


	private function handleMotivation(t:FlxTimer):Void
	{
		motivation.setText(getRandomMotivation());
		motivation.x = -motivation.width;
		tweenIn(motivation,1);
		GameAssets.CORRECT_SOUND.play();
		motivationTimer = FlxTimer.start(Math.random() * MOTIVATION_TIME + MOTIVATION_MIN,handleMotivation);
	}


	private function getRandomMotivation():String
	{
		return (MOTIVATIONS[Math.floor(Math.random() * MOTIVATIONS.length)]);
	}


	private function startExercising():Void
	{
		nextExercise(null);
	}


	private function nextExercise(t:FlxTimer):Void
	{
		var next:DayState = exercises[exerciseIndex];
		switch (next)
		{
			case PUSHUPS:
			setupExercise(
				pushupSprite,
				"pushup-up",
				"pushup-down",
				"RAPIDLY TAP [UP] TO PUSH UP, RELEASE TO LOWER.",
				PUSHUPS,
				PUSHUP_INDEX);

			case PULLUPS:
			setupExercise(
				pullupSprite,
				"pullup-up",
				"pullup-down",
				"RAPIDLY TAP [UP] TO PULL UP, RELEASE TO LOWER.",
				PULLUPS,
				PULLUP_INDEX);

			case SITUPS:
			setupExercise(
				situpSprite,
				"situp-up",
				"situp-down",
				"RAPIDLY TAP [UP] TO SIT UP, RELEASE TO LOWER.",
				SITUPS,
				SITUP_INDEX);

			case CYCLE:
			setupCycle();

			case SHOWER:
		}
		exerciseIndex = (exerciseIndex + 1) % exercises.length;
		exerciseTimer = FlxTimer.start(1 * 10,nextExercise);
	}

	private function setupExercise(S:FlxSprite,UpAnim:String,DownAnim:String,Instructions:String,TheState:DayState,ExerciseIndex:Int):Void
	{
		pullupSprite.visible = false;
		pullupBarSprite.visible = false;
		situpSprite.visible = false;
		cycleSprite.visible = false;
		pushupSprite.visible = false;

		S.visible = true;	
		if (S == pullupSprite) pullupBarSprite.visible = true;

		S.animation.frameIndex = 1;

		timeSinceLastUp = MAX_UP_DELAY;

		lastAnimFrame = 0;
		lastAnimName = UpAnim;
		lastAnimFrameIndex = 1;

		currentExerciseCompleted[ExerciseIndex] = false;

		instructions.text = Instructions;

		dayState = TheState;

		updateStatistics();
	}


	private function setupCycle():Void
	{
		cycleSprite.animation.pause();

		pushupSprite.visible = false;
		pullupSprite.visible = false;
		pullupBarSprite.visible = false;		
		situpSprite.visible = false;

		cycleSprite.visible = true;

		instructions.text = "ALTERNATE [LEFT] AND [RIGHT] TO CYCLE.";
		dayState = CYCLE;

		updateStatistics();
	}	

	private function handleExerciseInput(S:FlxSprite,UpAnim:String,DownAnim:String,ExerciseIndex:Int):Void
	{
		timeSinceLastUp += FlxG.elapsed;

		if (FlxG.keys.justPressed.UP)
		{
			if (S.animation.frameIndex != 4)
			{
				if (lastAnimName == DownAnim)
				{
					S.animation.play(
						UpAnim,
						false,
						S.frames - 1 - lastAnimFrame);
				}
				else
				{
					S.animation.play(UpAnim);
				}
			}
			else if (!currentExerciseCompleted[ExerciseIndex])
			{
				GameAssets.ACKNOWLEDGE_SOUND.play();
				currentExerciseCompleted[ExerciseIndex] = true;
				exercisesCompleted[ExerciseIndex]++;
			}

			timeSinceLastUp = 0;
		}
		else
		{
			if (timeSinceLastUp >= MAX_UP_DELAY)
			{
				if (S.animation.frameIndex != 0 && S.animation.frameIndex != 1)
				{
					if (lastAnimName == UpAnim)
					{
						S.animation.play(
							DownAnim,
							false,
							S.frames - 1 - lastAnimFrame);
					}
					else
					{
						S.animation.play(DownAnim);
					}
				}
			}
			
		}

		if (S.animation.frameIndex == 1)
		{
			currentExerciseCompleted[ExerciseIndex] = false;
		}


		if (timeSinceLastUp >= REST_DELAY && S.animation.frameIndex == 1)
		{
			S.animation.frameIndex = 0;
		}
	}


	private function updateStatistics():Void
	{
		statistics.text = "PUSH-UPS: " + exercisesCompleted[PUSHUP_INDEX] + "   SIT-UPS: " + exercisesCompleted[SITUP_INDEX] + "   PULL-UPS: " + exercisesCompleted[PULLUP_INDEX] + "   CYCLED: " + Math.floor(cycleTenMetersCompleted)/100 + " KM";
	}


	override private function timerFinished(t:FlxTimer):Void
	{
		GameAssets.CORRECT_SOUND.play();
		
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
			updateStatistics();
			handleEnding();

			case WIN:

			case LOSE:

			case GAME_OVER:

		}
	}


	private function handleEnding():Void
	{
		if (timer.timeLeft < 5 && dayState != SHOWER)
		{
			motivationTimer.abort();
			exerciseTimer.abort();

			pullupBarSprite.visible = false;
			pullupSprite.visible = false;
			cycleSprite.visible = false;
			pushupSprite.visible = false;
			situpSprite.visible = false;
			showerSprite.visible = true;
			instructions.text = "LET THE WATER WASH OVER YOU.";
			dayState = SHOWER;
		}
	}


	private function animationCallback(Name:String, Frame:UInt, FrameIndex:UInt):Void
	{
		lastAnimName = Name;
		lastAnimFrame = Frame;
		lastAnimFrameIndex = FrameIndex;
	}


	override private function handleInput():Void
	{
		super.handleInput();

		switch (dayState)
		{
			case PUSHUPS:
			handleExerciseInput(pushupSprite,"pushup-up","pushup-down",PUSHUP_INDEX);

			case SITUPS:
			handleExerciseInput(situpSprite,"situp-up","situp-down",SITUP_INDEX);

			case PULLUPS:
			handleExerciseInput(pullupSprite,"pullup-up","pullup-down",PULLUP_INDEX);

			case CYCLE:
			handleCycleInput();

			case SHOWER:
		}
	}


	private function handleCycleInput():Void
	{
		timeSinceLastCycle += FlxG.elapsed;

		previousCycleTenMetersCompleted = cycleTenMetersCompleted;

		if (FlxG.keys.justPressed.LEFT && !lastCycleKeyWasLeft)
		{
			lastCycleKeyWasLeft = true;
			cycleSprite.animation.play("cycle");
			timeSinceLastCycle = 0;
			timeSpentCycling += FlxG.elapsed;
			cycleTenMetersCompleted = (timeSpentCycling / 60 / 60) * 3000;
		}
		else if (FlxG.keys.justPressed.RIGHT && lastCycleKeyWasLeft)
		{
			lastCycleKeyWasLeft = false;
			cycleSprite.animation.play("cycle");
			timeSinceLastCycle = 0;
			timeSpentCycling += FlxG.elapsed;
			cycleTenMetersCompleted = (timeSpentCycling / 60 / 60) * 3000;
		}
		else if (timeSinceLastCycle >= MAX_UP_DELAY)
		{
			cycleSprite.animation.frameIndex = cycleSprite.animation.frameIndex;
		}

		if (cycleTenMetersCompleted != previousCycleTenMetersCompleted &&
			cycleTenMetersCompleted > mileStone)
		{
			GameAssets.ACKNOWLEDGE_SOUND.play();
			mileStone += 100;
		}
	}


	private function tweenIn(O:FlxTextWithBG,T:Float):Void
	{
		currentTweenTarget = O;
		FlxTween.multiVar(currentTweenTarget, {x: 0}, TWEEN_TIME, {complete: tweenInComplete});
	}

	private function tweenInComplete(t:FlxTween):Void
	{
		FlxTween.multiVar(currentTweenTarget, {x: 0}, TWEEN_PAUSE_TIME, {complete: tweenPauseComplete});
	}

	private function tweenPauseComplete(t:FlxTween):Void
	{
		FlxTween.multiVar(currentTweenTarget, {x: FlxG.width}, TWEEN_TIME);
	}
}