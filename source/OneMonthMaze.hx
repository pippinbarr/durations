package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.FlxCamera;
import flixel.FlxG;

import flixel.util.FlxTimer;
import flixel.util.FlxCollision;

import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.text.TextFormat;


class OneMonthMaze extends BaseState
{
	private var maze:FlxSprite;
	private var avatar:FlxSprite;
	private var avatarDot:FlxSprite;
	private var avatarCamera:FlxCamera;

	override public function create():Void
	{



		duration = 2592000;
		// duration = 1 * 10;




		maze = new FlxSprite(0,FlxG.height,GameAssets.MONTH_MAZE);
		
		avatarDot = new FlxSprite(maze.x + 1,maze.y + 1);
		avatarDot.makeGraphic(1,1,0xFFFF0000);
		avatarDot.x = maze.x + Math.floor(maze.width / 2);
		avatarDot.y = maze.y + Math.floor(maze.height / 2);

		Helpers.setupSprite(maze,12);

		avatar = new FlxSprite(0,0,GameAssets.MONTH_PERSON);


		avatarDot.visible = true;

		super.create();

		FlxG.camera.bgColor = 0xFFCCCCFF;
		// FlxG.bgColor = 0xFFFF0000;

		display.add(maze);
		display.add(avatar);
		display.add(avatarDot);

		instructions.text = "NAVIGATE THE MAZE WITH THE [ARROW KEYS].";
		thisState = OneMonthMaze;

		statistics.text = "TIME SPENT IN MAZE: 0 MINUTES";

		gameOverText.text = "MAZE OVER";

		avatarCamera = new FlxCamera(0,6*8,FlxG.width,FlxG.height - 2*6*8);
		FlxG.cameras.add(avatarCamera);
		avatarCamera.follow(avatar);
		avatarCamera.setBounds(maze.x,maze.y,maze.width,maze.height);
	}


	override private function timerFinished(t:FlxTimer):Void
	{
		GameAssets.CORRECT_SOUND.play();

		FlxG.cameras.remove(avatarCamera);

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
			if (timer.timeLeft <= 2 && maze.visible)
			{
				maze.visible = false;
				GameAssets.CORRECT_SOUND.play();
				avatarCamera.follow(null);
			}

			case WIN:

			case LOSE:

			case GAME_OVER:
		}
	}	


	private function updateStatistics():Void
	{
		var totalSeconds = timer.time - timer.timeLeft;

		var days:Int = Std.int(totalSeconds / 60 / 60 / 24);
		var remainingSeconds = (totalSeconds - days*24*60*60);
		var hours:Int = Std.int(remainingSeconds / 60 / 60);
		var remainingSeconds = (totalSeconds - hours*60*60);
		var minutes:Int = Std.int(remainingSeconds / 60);
		var remainingSeconds = Std.int(totalSeconds - minutes*60);

		var dayString:String = (days != 1) ? "DAYS" : "DAY";
		var hourString:String = (hours != 1) ? "HOURS" : "HOUR";
		var minuteString:String = (minutes != 1) ? "MINUTES" : "MINUTE";
		var secondString:String = (remainingSeconds != 1) ? "SECONDS" : "SECOND";

		statistics.text = "TIME IN MAZE: " + days + " " + dayString + ", " + hours + " " + hourString +
		", " + minutes + " " + minuteString + ", AND " + remainingSeconds + " " + secondString;
	}


	override public function handleInput():Void
	{
		super.handleInput();


		if (FlxG.keys.pressed.UP)
		{
			if (!maze.visible || !FlxCollision.pixelPerfectPointCheck(Std.int(avatarDot.x),Std.int(avatarDot.y - 1),maze))
			{
				avatarDot.y -= 1;
				GameAssets.TAP_SOUND.play();
			}
		}
		else if (FlxG.keys.pressed.DOWN)
		{
			if (!maze.visible || !FlxCollision.pixelPerfectPointCheck(Std.int(avatarDot.x),Std.int(avatarDot.y + 1),maze))
			{
				avatarDot.y += 1;
				GameAssets.TAP_SOUND.play();
			}
		}

		if (FlxG.keys.pressed.LEFT)
		{
			if (!maze.visible || !FlxCollision.pixelPerfectPointCheck(Std.int(avatarDot.x - 1),Std.int(avatarDot.y),maze))
			{
				avatarDot.x -= 1;
				GameAssets.TAP_SOUND.play();
			}
		}
		else if (FlxG.keys.pressed.RIGHT)
		{
			if (!maze.visible || !FlxCollision.pixelPerfectPointCheck(Std.int(avatarDot.x + 1),Std.int(avatarDot.y),maze))
			{
				avatarDot.x += 1;
				GameAssets.TAP_SOUND.play();
			}
		}

		avatar.x = maze.x + ((avatarDot.x - maze.x) * 12) + 2;
		avatar.y = maze.y + ((avatarDot.y - maze.y) * 12) + 2;
	}
}