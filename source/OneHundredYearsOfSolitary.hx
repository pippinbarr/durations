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



class OneHundredYearsOfSolitary extends BaseState
{
	private static var AVATAR_SPEED:Float = 200;

	private var avatarCanMove:Bool = true;

	private var bookText:WomanInPrison;
	private var bookBG:FlxSprite;

	private var door:FlxSprite;
	private var cell:FlxSprite;
	private var topWall:FlxSprite;
	private var bottomWall:FlxSprite;
	private var leftWall:FlxSprite;
	private var rightWall:FlxSprite;

	private var avatar:FlxSprite;
	private var avatarCollision:FlxSprite;

	private var bed:FlxSprite;
	private var bedCollision:FlxSprite;
	private var bedTrigger:FlxSprite;

	private var desk:FlxSprite;
	private var deskCollision:FlxSprite;
	private var deskTrigger:FlxSprite;

	private var sink:FlxSprite;
	private var sinkCollision:FlxSprite;
	private var sinkTrigger:FlxSprite;

	private var toilet:FlxSprite;
	private var toiletCollision:FlxSprite;
	private var toiletTrigger:FlxSprite;

	private var collidables:FlxGroup;
	private var sortables:FlxGroup;

	private var sky:FlxSprite;


	override public function create():Void
	{





		duration = 3155690880;
		// duration = 1 * 20;

		



		super.create();

		FlxG.camera.bgColor = 0xFF5b97fb;


		collidables = new FlxGroup();
		collidables.visible = false;
		sortables = new FlxGroup();

		sky = new FlxSprite(0,0);
		sky.makeGraphic(FlxG.width,FlxG.height,0xFF6677FF);
		setSkyAlpha();

		door = new FlxSprite(100,100,GameAssets.CENTURY_DOOR);
		Helpers.setupSprite(door,8);
		door.x = 36*8;
		door.y = 49*8;

		cell = new FlxSprite(0,0,GameAssets.CENTURY_CELL);
		Helpers.setupSprite(cell,8);

		topWall = new FlxSprite(0,0);
		topWall.makeGraphic(FlxG.width,200,0xFFFF0000);
		collidables.add(topWall);

		bottomWall = new FlxSprite(0,392);
		bottomWall.makeGraphic(FlxG.width,40,0xFFFF0000);
		collidables.add(bottomWall);

		leftWall = new FlxSprite(0,0);
		leftWall.makeGraphic(216,FlxG.height,0xFFFF0000);
		collidables.add(leftWall);

		rightWall = new FlxSprite(440,0);
		rightWall.makeGraphic(216,FlxG.height,0xFFFF0000);
		collidables.add(rightWall);

		avatar = new FlxSprite(240,300);
		avatar.loadGraphic(GameAssets.SHARED_PERSON,false,false,7,9,true);
		avatar.replaceColor(0xFF000000,0xFF55DDFF);
		Helpers.setupSprite(avatar,8);
		avatar.offset.y += (avatar.height - 20);
		sortables.add(avatar);

		avatarCollision = new FlxSprite(avatar.x,avatar.y - 20);
		avatarCollision.makeGraphic(Std.int(avatar.width),20,0xFFFF0000);
		avatarCollision.visible = false;

		bed = new FlxSprite(352,220);
		bed.loadGraphic(GameAssets.CENTURY_BED,true,false,10,6);
		bed.replaceColor(0xFF000000,0xFF55DDFF);
		Helpers.setupSprite(bed,8);
		bed.offset.y += (bed.height - bed.height/4);
		sortables.add(bed);

		bedCollision = new FlxSprite(bed.x,bed.y);
		bedCollision.makeGraphic(Std.int(bed.width),Std.int(bed.height/4),0xFFFF0000);
		collidables.add(bedCollision);

		bedTrigger = new FlxSprite(bedCollision.x,bedCollision.y - 16);
		bedTrigger.makeGraphic(Std.int(bedCollision.width),Std.int(bedCollision.height) + 16*2);

		desk = new FlxSprite(352,348,GameAssets.CENTURY_DESK_AND_CHAIR);
		Helpers.setupSprite(desk,8);
		desk.offset.y += (desk.height - desk.height/4);
		sortables.add(desk);

		deskCollision = new FlxSprite(desk.x,desk.y);
		deskCollision.makeGraphic(Std.int(desk.width),Std.int(desk.height/4),0xFFFF0000);
		collidables.add(deskCollision);

		deskTrigger = new FlxSprite(deskCollision.x,deskCollision.y - 16);
		deskTrigger.makeGraphic(Std.int(deskCollision.width),Std.int(deskCollision.height) + 16*2);

		toilet = new FlxSprite(224,348);
		toilet.loadGraphic(GameAssets.CENTURY_TOILET,true,false,7,7);
		toilet.replaceColor(0xFF000000,0xFF55DDFF);
		Helpers.setupSprite(toilet,8);
		toilet.offset.y += (toilet.height - toilet.height/4);
		sortables.add(toilet);

		toiletCollision = new FlxSprite(toilet.x,toilet.y);
		toiletCollision.makeGraphic(Std.int(toilet.width),Std.int(toilet.height/4),0xFFFF0000);
		collidables.add(toiletCollision);

		toiletTrigger = new FlxSprite(toiletCollision.x,toiletCollision.y - 16);
		toiletTrigger.makeGraphic(Std.int(toiletCollision.width),Std.int(toiletCollision.height) + 16*2);

		sink = new FlxSprite(224,220,GameAssets.CENTURY_SINK);
		Helpers.setupSprite(sink,8);
		sink.offset.y += (sink.height - sink.height/4);
		sortables.add(sink);

		sinkCollision = new FlxSprite(sink.x,sink.y);
		sinkCollision.makeGraphic(Std.int(sink.width),Std.int(sink.height/4),0xFFFF0000);
		collidables.add(sinkCollision);

		sinkTrigger = new FlxSprite(sinkCollision.x,sinkCollision.y - 16);
		sinkTrigger.makeGraphic(Std.int(sinkCollision.width),Std.int(sinkCollision.height) + 16*2);

		display.add(sky);
		display.add(door);
		display.add(cell);
		display.add(sortables);
		display.add(collidables);
		display.add(avatarCollision);

		bookText = new WomanInPrison(80,64,390,34);
		bookText.setFormat(null,8,0xFF000000,"left");
		bookText.x = FlxG.width/2 - bookText.width/2;
		bookText.visible = false;

		bookBG = new FlxSprite(bookText.x - 20,bookText.y - 20);
		bookBG.makeGraphic(Std.int(bookText.width + 40),Std.int(FlxG.height),0xFFFFFFFF);
		bookBG.visible = false;

		fg.add(bookBG);
		fg.add(bookText);


		instructions.text = "" +
		"NOTHING";
		thisState = OneHundredYearsOfSolitary;


		statistics.text = "DAYS REMAINING: " + Math.floor(timer.timeLeft / 60 / 60 / 24);

		gameOverText.text = "SENTENCE OVER";
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
			statistics.text = "DAYS REMAINING: " + Math.floor(timer.timeLeft / 60 / 60 / 24);
			avatar.x = avatarCollision.x;
			avatar.y = avatarCollision.y;
			sortables.sort();
			handleCollisions();
			handleTriggers();
			setSkyAlpha();
			handleFreedom();

			case WIN:

			case LOSE:

			case GAME_OVER:
		}
	}	


	private function handleFreedom():Void
	{
		if (timer.timeLeft <= 5)
		{
			door.velocity.x = 10;
		}
	}


	private function setSkyAlpha():Void
	{
		var timeInHours:Int = Std.int(startHour + (timer.time - timer.timeLeft) / 60 / 60);
		var timeOfDayInHours = timeInHours % 24;

		switch (timeInHours)
		{
			case 24,0,1,2,3:
			sky.alpha = 0;

			case 23:
			sky.alpha = 0.3;

			case 22:
			sky.alpha = 0.4;

			case 21:
			sky.alpha = 0.5;

			case 20:
			sky.alpha = 0.6;

			case 19:
			sky.alpha = 0.7;

			case 18:
			sky.alpha = 0.8;

			case 17:
			sky.alpha = 0.9;

			case 4:
			sky.alpha = 0.3;

			case 5:
			sky.alpha = 0.5;

			case 6:
			sky.alpha = 0.75;

			case 7:
			sky.alpha = 0.9;

			case 8,9,10,11,12,13,14:
			sky.alpha = 1.0;
		}
	}


	private function handleCollisions():Void
	{
		if (avatarCollision.overlapsAt(avatarCollision.x + (avatarCollision.velocity.x * FlxG.elapsed),
			avatarCollision.y + (avatarCollision.velocity.y * FlxG.elapsed),
			collidables))
		{
			avatarCollision.velocity.x = 0;
			avatarCollision.velocity.y = 0;
		}
	}


	private function handleTriggers():Void
	{
		if (avatarCollision.overlaps(bedTrigger) && avatarCanMove)
		{
			instructions.text = "PRESS [SPACE] TO LIE DOWN ON THE BED.";
		}
		else if (avatarCollision.overlaps(sinkTrigger) && avatarCanMove)
		{
			instructions.text = "PRESS [SPACE] TO USE THE SINK.";
		}
		else if (avatarCollision.overlaps(toiletTrigger) && avatarCanMove)
		{
			instructions.text = "PRESS [SPACE] TO SIT ON THE TOILET.";
		}
		else if (avatarCollision.overlaps(deskTrigger) && avatarCanMove)
		{
			instructions.text = "PRESS [SPACE] TO SIT AT THE DESK AND READ A BOOK.";
		}
		else if (avatarCanMove)
		{
			instructions.text = "MOVE WITH THE [ARROW KEYS]";
		}
	}


	override public function handleInput():Void
	{
		super.handleInput();


		if (avatarCanMove)
		{
			if (FlxG.keys.pressed.LEFT)
			{
				avatarCollision.velocity.x = -AVATAR_SPEED;
			}
			else if (FlxG.keys.pressed.RIGHT)
			{
				avatarCollision.velocity.x = AVATAR_SPEED;
			}
			else
			{
				avatarCollision.velocity.x = 0;
			}

			if (FlxG.keys.pressed.UP)
			{
				avatarCollision.velocity.y = -AVATAR_SPEED;
			}
			else if (FlxG.keys.pressed.DOWN)
			{
				avatarCollision.velocity.y = AVATAR_SPEED;
			}
			else
			{
				avatarCollision.velocity.y = 0;
			}
		}


		if ((FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.DOWN) && bookText.visible)
		{
			bookText.nextPage();
		}
		else if ((FlxG.keys.justPressed.LEFT  || FlxG.keys.justPressed.UP) && bookText.visible)
		{
			bookText.previousPage();
		}


		if (FlxG.keys.justPressed.SPACE && avatarCollision.overlaps(deskTrigger))
		{
			avatar.visible = !avatar.visible;
			avatarCanMove = !avatarCanMove;
			bookBG.visible = !bookBG.visible;
			bookText.visible = !bookText.visible;

			if (bookText.visible)
			{
				instructions.text = "USE [ARROW KEYS] TO TURN PAGES AND [SPACE] TO CLOSE THE BOOK.";
			}
		}
		else if (FlxG.keys.justPressed.SPACE && avatarCollision.overlaps(toiletTrigger))
		{
			avatar.visible = !avatar.visible;
			avatarCanMove = !avatarCanMove;
			toilet.animation.frameIndex = (1 - toilet.animation.frameIndex);

			if (!avatar.visible)
			{
				instructions.text = "PRESS [SPACE] TO STAND UP.";
			}
		}
		else if (FlxG.keys.justPressed.SPACE && avatarCollision.overlaps(bedTrigger))
		{
			avatar.visible = !avatar.visible;
			avatarCanMove = !avatarCanMove;
			bed.animation.frameIndex = (1 - bed.animation.frameIndex);

			if (!avatar.visible)
			{
				instructions.text = "PRESS [SPACE] TO STAND UP.";
			}
		}
		else if (FlxG.keys.justPressed.SPACE && avatarCollision.overlaps(sinkTrigger))
		{
			avatarCanMove = !avatarCanMove;

			if (!avatarCanMove)
			{
				instructions.text = "PRESS [SPACE] TO STOP USING THE SINK.";
			}
		}
	}


}