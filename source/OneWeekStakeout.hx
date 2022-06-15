package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxBasic;
import flixel.text.FlxText;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.system.FlxSound;

import flixel.util.FlxTimer;
import flixel.util.FlxPoint;

import flixel.tweens.misc.VarTween;
import flixel.tweens.FlxTween;

import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.text.TextFormat;
import flash.net.FileReference;



enum WeekState
{

}

enum WeekTargetState
{
	INSIDE;
	INSIDE_TO_DOOR;
	DOOR_TO_PAVEMENT;
	PAVEMENT_TO_OFFSCREEN;
	OFFSCREEN_TO_FENCE_OPENING;
	FENCE_OPENING_TO_DOOR;
	IN_CAR;
	AWAY;
}



class OneWeekStakeout extends BaseState
{
	private var INSIDER:Int = 1;
	private var PASSERBY:Int = 2;
	private var CAR:Int = 3;
	private var SUSPECT:Int = 4;
	private var CAR_SUSPECT:Int = 5;

	private static var CAMERA_SPEED:Float = 150;

	private var targetState:WeekTargetState;

	private var targetMustChange:Bool = false;

	private var camera:FlxSprite;
	private var cameraCamera:FlxCamera;

	private var photos:Int = 0;
	private var evidence:Int = 0;

	private var target:WeekSprite;
	private var door:WeekSprite;
	private var house_bg:WeekSprite;
	private var fence:WeekSprite;
	private var windows:FlxGroup;

	private var passersbyTimer:FlxTimer;
	private var insidersTimer:FlxTimer;
	private var carsTimer:FlxTimer;

	private var carSound:FlxSound;

	private var camTest:WeekSprite;

	private var timeOfDay:Int = 9;

	private var offShiftScreen:FlxGroup;
	private var offShiftText:FlxText;

	private var redundancyWarningTimer:FlxTimer;
	private var redundancyWarning:Bool = false;

	private var notInFrameWarningTimer:FlxTimer;
	private var notInFrameWarning:Bool = false;


	private var darkness:FlxSprite;

	private static var passerColours:Array<Int> = [
	0xFFDDDDFF,
	0xFFAAAAEE,
	0xFF5555BB,
	0xFF8888CC,
	0xFF333388,
	0xFF9999AA,
	];

	private static var carColours:Array<Int> = [
	0xFFFFDDFF,
	0xFFEEAAAA,
	0xFF55BB55,
	0xFFCC88CC,
	0xFF338888,
	0xFF99AAAA,
	];

	override public function create():Void
	{



		duration = 604800;
		// duration = 1 * 20;




		carSound = new FlxSound();
		carSound.loadEmbedded(GameAssets.WEEK_CAR_SOUND,true);

		var bg:WeekSprite = new WeekSprite(0,0,0,GameAssets.WEEK_BG);
		Helpers.setupSprite(bg,8);

		camera = new FlxSprite(0,0);
		camera.loadGraphic(GameAssets.WEEK_CAMERA);
		Helpers.setupSprite(camera,8);
		camera.x = FlxG.width/2 - camera.width/2;
		camera.y = FlxG.height/2 - camera.height/2;

		cameraCamera = new FlxCamera(Std.int(camera.x + 7*8),Std.int(camera.y) + 4*8,13*8,Std.int(9*8),2);
		cameraCamera.focusOn(new FlxPoint(cameraCamera.x + cameraCamera.width/2,cameraCamera.y + cameraCamera.height/2));
		FlxG.cameras.add(cameraCamera);

		fence = new WeekSprite(0,256,96,GameAssets.WEEK_FENCE);
		Helpers.setupSprite(fence,8);
		fence.sortID = Std.int(fence.y + fence.height);

		var house:WeekSprite = new WeekSprite(0,8*8,8*8,GameAssets.WEEK_HOUSE);
		Helpers.setupSprite(house,8);
		house.sortID = Std.int(house.y + house.height);
		// house.alpha = 0.5;

		house_bg = new WeekSprite(7*8,8*8,8*8,GameAssets.WEEK_HOUSE_BG);
		Helpers.setupSprite(house_bg,8);
		house_bg.sortID = house.sortID - 1000;

		windows = new FlxGroup();

		var w1:FlxSprite = new FlxSprite(house_bg.x + 5*8,house_bg.y + 14*8);
		w1.makeGraphic(8*8,8*8,0xFFFF0000);
		// Helpers.setupSprite(w1,8);
		windows.add(w1);
		var w2:FlxSprite = new FlxSprite(w1.x + w1.width + 2*8,w1.y);
		w2.makeGraphic(8*8,8*8,0xFFFF0000);
		// Helpers.setupSprite(w2,8);
		windows.add(w2);
		var w3:FlxSprite = new FlxSprite(w2.x + w2.width + 19*8,w1.y);
		w3.makeGraphic(8*8,8*8,0xFFFF0000);
		// Helpers.setupSprite(w3,8);
		windows.add(w3);
		var w4:FlxSprite = new FlxSprite(w3.x + w3.width + 2*8,w1.y);
		w4.makeGraphic(8*8,8*8,0xFFFF0000);
		// Helpers.setupSprite(w4,8);
		windows.add(w4);

		door = new WeekSprite(36*8,22*8,22*8,GameAssets.WEEK_DOOR);
		Helpers.setupSprite(door,8);
		door.sortID = Std.int(door.y + door.height);
		// door.visible = true;

		target = new WeekSprite(0,0,0);
		target.loadGraphic(GameAssets.SHARED_PERSON,false,false,7,9,true);
		Helpers.setupSprite(target,8);
		target.x = house_bg.x + 50;
		target.y = house_bg.y + house_bg.height - 8 - target.height;
		target.sortID = Std.int(target.y + target.height);
		target.replaceColor(0xFF000000,0xFFFF0000);

		targetState = INSIDE;


		add(bg);
		add(cameraCamera);

		super.create();


		darkness = new FlxSprite(0,0);
		darkness.makeGraphic(FlxG.width,FlxG.height,0xFF000000);
		darkness.alpha = 0.0;

		fg.add(darkness);


		display.add(house_bg);
		display.add(house);
		display.add(door);
		display.add(fence);
		display.add(target);

		fg.add(camera);
		// fg.add(windows);

		gameOverText.text = "STAKEOUT OVER.";
		if (Math.random() > 0.5)
		{
			instructions.text = "PHOTOGRAPH THE MAN IN RED WITH [ARROW KEYS] and [SPACE].\nHE IS A PERSON OF INTEREST IN " + getCaseType() + ".";
		}
		else
		{
			instructions.text = "PHOTOGRAPH THE WOMAN IN RED WITH [ARROW KEYS] and [SPACE].\nSHE IS A PERSON OF INTEREST IN " + getCaseType() + ".";
		}

		instructions.y = 8;

		statistics.text = "PHOTOGRAPHS: 0    EVIDENCE: 0";

		thisState = OneWeekStakeout;

		// passersbyTimer = new FlxTimer();
		// carsTimer = new FlxTimer();
		// insidersTimer = new FlxTimer();
		redundancyWarningTimer = FlxTimer.recycle();
		notInFrameWarningTimer = FlxTimer.recycle();

		// sendInsider(null);
		sendPasserBy(null);
		sendCar(null);

		camTest = new WeekSprite(0,0,0);
		camTest.makeGraphic(cameraCamera.width,cameraCamera.height,0xFFFF0000);
		camTest.x = cameraCamera.x + cameraCamera.width;
		camTest.y = cameraCamera.y + cameraCamera.height;
		// camTest.visible = true;

		// ui.add(camTest);


		offShiftScreen = new FlxGroup();

		var black:FlxSprite = new FlxSprite(0,0);
		black.makeGraphic(FlxG.width,FlxG.height,0xFF000000);
		offShiftScreen.add(black);

		offShiftText = new FlxText(0,0,FlxG.width,"OFF SHIFT",24);
		offShiftText.setFormat(null,24,0xFFFFFFFF,"center");
		offShiftText.x = 0;
		offShiftText.y = FlxG.height / 2 - offShiftText.height / 2;
		offShiftScreen.add(offShiftText);

		offShiftScreen.visible = false;

		fg.add(offShiftScreen);
	}


	private function getCaseType():String
	{
		var r:Float = Math.random();

		if (r < 0.1) return "AN ADULTERY CASE";
		else if (r < 0.2) return "A TERRORISM INVESTIGATION";
		else if (r < 0.3) return "A MONEY LAUNDERING INVESTIGATION";
		else if (r < 0.4) return "A RICO INVESTIGATION";
		else if (r < 0.5) return "A KIDNAPPING CASE";
		else if (r < 0.6) return "AN ELECTIONEERING INVESTIGATION";
		else if (r < 0.7) return "A MATCH-FIXING CASE";
		else if (r < 0.8) return "A PYRAMID SCHEME INVESTIGATION";
		else if (r < 0.9) return "A RACKETEERING CASE";
		else return "A CELEBRITY SCANDAL";
	}


	private function sendPasserBy(t:FlxTimer):Void
	{
		var passerby:WeekSprite = cast(display.recycle(WeekSprite),WeekSprite);
		passerby.revive();
		passerby.ID = PASSERBY;

		passerby.loadGraphic(GameAssets.SHARED_PERSON,false,false,7,9,true);
		passerby.replaceColor(0xFF000000,passerColours[Math.floor(Math.random() * passerColours.length)]);
		Helpers.setupSprite(passerby,8);

		if (Math.random() > 0.5)
		{
			passerby.x = -50;
			passerby.y = 260;
			passerby.velocity.x = 100;
		}
		else
		{
			passerby.x = FlxG.width;
			passerby.y = 240;
			passerby.velocity.x = -100;	
		}

		passerby.sortID = Std.int(passerby.y + passerby.height);

		if (timeOfDay >= 5 && timeOfDay < 8)
		{
			FlxTimer.start(Math.random() * 20 + 20,sendPasserBy);			
		}
		else if (timeOfDay >= 8 && timeOfDay < 11)
		{
			FlxTimer.start(Math.random() * 20 + 20,sendPasserBy);			
		}
		else if (timeOfDay >= 11 && timeOfDay < 17)
		{
			FlxTimer.start(Math.random() * 10 + 20,sendPasserBy);			
		}	
		else if (timeOfDay >= 17 && timeOfDay < 19)
		{
			FlxTimer.start(Math.random() * 20 + 20,sendPasserBy);			
		}
		else if (timeOfDay >= 19 && timeOfDay < 22)
		{
			FlxTimer.start(Math.random() * 10 + 5,sendPasserBy);			
		}	
		else
		{
			FlxTimer.start(Math.random() * 60 + 60,sendPasserBy);						
		}
	}


	private function updateTimeOfDay():Void
	{

		// startHour = 10;

		var timeInHours:Int = Std.int(startHour + (timer.time - timer.timeLeft) / 60 / 60);
		var timeOfDayInHours = timeInHours % 24;

		timeOfDay = timeOfDayInHours;

		if (timeOfDay < 9 || timeOfDay > 20)
		// if (true)
		{
			var hoursToShift:Int = 0;
			if (timeOfDay < 9)
			{
				hoursToShift = 9 - timeOfDay;
			}
			else if (timeOfDay > 20)
			{
				hoursToShift = 9 + (24 - timeOfDay);
			}
			offShiftText.text = "YOU'RE OFF FOR THE NIGHT.\n";
			offShiftText.text += "COME BACK IN ";
			offShiftText.text += "" + hoursToShift;
			if (hoursToShift > 1)
			{
				offShiftText.text += " HOURS.";
			}
			else
			{
				offShiftText.text += " HOUR.";
			}
			offShiftScreen.visible = true;
			instructions.visible = false;
			statistics.visible = false;
			cameraCamera.visible = false;

			carSound.stop();
		}
		else
		{
			cameraCamera.visible = !focusGroup.visible;
			instructions.visible = true;
			statistics.visible = true;

			offShiftScreen.visible = false;

			if (timeOfDay == 17)
			{
				darkness.alpha = 0.2;
			}
			else if (timeOfDay == 18)
			{
				darkness.alpha = 0.4;
			}
			else if (timeOfDay == 19)
			{
				darkness.alpha = 0.6;
			}
			else if (timeOfDay == 20)
			{
				darkness.alpha = 0.8;
			}
		}
	}



	private function sendCar(t:FlxTimer):Void
	{

		// Don't send a car onto the screen if the target is in one.
		if (targetState == IN_CAR)
		{
			FlxTimer.start(Math.random() * 5 + 1,sendCar);
			return;
		}

		var car:WeekSprite = cast(display.recycle(WeekSprite),WeekSprite);
		car.revive();	

		car.ID = CAR;

		car.loadGraphic(GameAssets.WEEK_CAR,false,true,28,13,true);
		car.replaceColor(0xFF000000,passerColours[Math.floor(Math.random() * passerColours.length)]);
		car.replaceColor(0xFFFFFFFF,carColours[Math.floor(Math.random() * carColours.length)]);
		Helpers.setupSprite(car,8);

		if (Math.random() > 0.5)
		{
			car.facing = FlxObject.RIGHT;
			car.x = -car.width;
			car.y = 320;
			car.velocity.x = 200;
		}
		else
		{
			car.facing = FlxObject.LEFT;
			car.x = FlxG.width;
			car.y = 280;
			car.velocity.x = -200;	
		}

		car.sortID = Std.int(car.y + car.height);

		if (timeOfDay >= 5 && timeOfDay < 8)
		{
			FlxTimer.start(Math.random() * 30 + 30,sendCar);			
		}
		else if (timeOfDay >= 8 && timeOfDay < 11)
		{
			FlxTimer.start(Math.random() * 5 + 2,sendCar);			
		}
		else if (timeOfDay >= 11 && timeOfDay < 17)
		{
			FlxTimer.start(Math.random() * 30 + 20,sendCar);			
		}	
		else if (timeOfDay >= 17 && timeOfDay < 19)
		{
			FlxTimer.start(Math.random() * 5 + 2,sendCar);			
		}
		else if (timeOfDay >= 19 && timeOfDay < 22)
		{
			FlxTimer.start(Math.random() * 30 + 20,sendCar);			
		}	
		else
		{
			FlxTimer.start(Math.random() * 60 + 60,sendCar);						
		}
	}


	private function sendInsider(t:FlxTimer):Void
	{
		var insider:WeekSprite = cast(display.recycle(WeekSprite),WeekSprite);
		insider.revive();

		insider.ID = INSIDER;

		insider.loadGraphic(GameAssets.SHARED_PERSON,false,false,7,9,true);
		insider.replaceColor(0xFF000000,passerColours[Math.floor(Math.random() * passerColours.length)]);
		Helpers.setupSprite(insider,8);
		if (Math.random() > 0.5)
		{
			insider.x = 80;
			insider.y = 180;
			insider.velocity.x = 100;
		}
		else
		{
			insider.x = FlxG.width - 80;
			insider.y = 180;
			insider.velocity.x = -100;	
		}

		insider.sortID = Std.int(insider.y + insider.height);

		FlxTimer.start(Math.random() * 10 + 1,sendInsider);
	}



	private function updateStatistics():Void
	{
		if (redundancyWarning)
		{
			statistics.text = "WE'VE SEEN THAT. WAIT UNTIL THE SUBJECT DOES SOMETHING ELSE.";
		}
		else if (notInFrameWarning)
		{
			statistics.text = "THAT PHOTO'S NO GOOD.";
		}
		else
		{
			statistics.text = "PHOTOS: " + photos + "    EVIDENCE: " + evidence + "    TIME: " + timeOfDay + ":00";
		}
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

		display.sort("sortID");

		switch (state)
		{
			case PLAY:
			updateStatistics();
			updateCameraPosition();
			updateSprites();
			updateTarget();
			updateTimeOfDay();
			updateEnding();
			updateCarSounds();

			case WIN:

			case LOSE:

			case GAME_OVER:
			offShiftScreen.visible = false;
			cameraCamera.visible = false;
		}
	}



	private function updateCarSounds():Void
	{
		var carThere:Bool = false;
		for (i in 0...display.members.length)
		{
			var w:WeekSprite = cast(display.members[i],WeekSprite);
			if (w == null || !w.alive) continue;

			if (w.ID == CAR)
			{
				carThere = true;
				break;
			}
		}

		if (carThere && !offShiftScreen.visible)
		{
			carSound.play();
		}
		else
		{
			carSound.stop();
		}

		carSound.volume = 0.2;
	}

	private function updateEnding():Void
	{
		if (timer.timeLeft < 5)
		{
			state = WIN;
			carSound.stop();
			offShiftScreen.visible = true;
			cameraCamera.visible = false;
			instructions.visible = false;
			statistics.visible = false;

			if (evidence > 0)
			{
				offShiftText.text = "THAT'S IT FOR THIS STAKE-OUT.\nTHANKS TO YOUR HELP\nWE'VE GOT A STRONG CASE.";
				GameAssets.CORRECT_SOUND.play();
			}
			else
			{
				offShiftText.text = "THAT'S IT FOR THIS STAKE-OUT.\nTHANKS FOR NOTHING.\nYOU'RE FIRED.";				
				GameAssets.INCORRECT_SOUND.play();
			}
		}
	}


	private function updateTarget():Void
	{
		target.sortID = Std.int(target.y + target.height);

		switch (targetState)
		{
			case INSIDE:
			handleTargetInside();

			case INSIDE_TO_DOOR:
			if (target.x + target.width/2 > door.x + door.width/2 + 4)
			{
				target.velocity.x = -50;
			}
			else if (target.x + target.width/2 < door.x + door.width/2 - 4)
			{
				target.velocity.x = 50;
			}
			else
			{
				target.velocity.x = 0;
				target.velocity.y = 50;
				targetState = DOOR_TO_PAVEMENT;
				door.visible = false;
			}

			case DOOR_TO_PAVEMENT:
			if (target.y + target.height > house_bg.y + house_bg.height)
			{
				door.visible = true;
			}

			if (target.y >= 230)
			{
				target.velocity.y = 0;
				if (Math.random() > 0.5)
				{
					target.velocity.x = 50;
				}
				else
				{
					target.velocity.x = -50;
				}
				targetState = PAVEMENT_TO_OFFSCREEN;
			}

			case PAVEMENT_TO_OFFSCREEN:
			if (target.velocity.x < 0 && target.x + target.width < 0)
			{
				target.velocity.x = 0;
				targetState = AWAY;
			}
			else if (target.velocity.x > 0 && target.x > FlxG.width)
			{
				target.velocity.x = 0;
				targetState = AWAY;
			}

			case OFFSCREEN_TO_FENCE_OPENING:
			if (target.velocity.x < 0 && target.x + target.width/2 <= door.x + door.width/2 + 4)
			{
				target.velocity.x = 0;
				target.velocity.y = -50;
				targetState = FENCE_OPENING_TO_DOOR;
			}
			else if (target.velocity.x > 0 && target.x + target.width/2 >= door.x + door.width/2 - 4)
			{
				target.velocity.x = 0;
				target.velocity.y = -50;
				targetState = FENCE_OPENING_TO_DOOR;
			}

			case FENCE_OPENING_TO_DOOR:
			if (target.y + target.height <= door.y + door.height + 16)
			{
				door.visible = false;
			}

			if (target.y + target.height <= house_bg.y + house_bg.height - 16)
			{
				target.velocity.y = 0;
				door.visible = true;
				targetState = INSIDE;
			}

			case IN_CAR:
			if (target.velocity.x > 0 && target.x > FlxG.width)
			{
				target.velocity.x = 0;
				targetState = AWAY;
			}
			else if (target.velocity.x < 0 && target.x + target.width < 0)
			{
				target.velocity.x = 0;
				targetState = AWAY;
			}

			case AWAY:
			if (Math.random() < 0.000001)
			// if (true)
			{
				if (Math.random() < 0.7)
				// if (Math.random() > 0.5)
				{
					// ON FOOT
					target.loadGraphic(GameAssets.SHARED_PERSON,false,false,7,9,true);
					target.replaceColor(0xFF000000,0xFFFF0000);
					Helpers.setupSprite(target,8);
					if (Math.random() < 0.5)
					{
						target.x = 0 - target.width;
						target.y = 230;
						target.velocity.x = 50;
						targetState = OFFSCREEN_TO_FENCE_OPENING;
					}
					else
					{
						target.x = FlxG.width;
						target.y = 230;
						target.velocity.x = -50;
						targetState = OFFSCREEN_TO_FENCE_OPENING;
					}
				}
				else
				{
					// CAR
					target.loadGraphic(GameAssets.WEEK_CAR,false,true,28,13,true);
					target.replaceColor(0xFFFFFFFF,0xFFDDDDDD);
					target.replaceColor(0xFF000000,0xFFFF0000);
					Helpers.setupSprite(target,8);

					if (Math.random() > 0.5)
					{
						target.facing = FlxObject.RIGHT;
						target.x = 0 - target.width * 4;
						target.velocity.x = 200;
						target.y = 320;
					}
					else
					{
						target.facing = FlxObject.LEFT;
						target.x = FlxG.width + target.width * 3;
						target.velocity.x = -200;
						target.y = 280;
					}

					targetState = IN_CAR;
				}
			}
		}

		if (target.velocity.x != 0 || target.velocity.y != 0) targetMustChange = false;
	}


	private function handleTargetInside():Void
	{
		if (target.velocity.x == 0)
		{
			if (Math.random() < 0.0005)
			// if (true)
			{
				if (Math.random() < 0.5)
				{
					target.velocity.x = -50;
				}
				else
				{
					target.velocity.x = 50;
				}
			}
		}
		else
		{
			if (target.velocity.x > 0 && target.x >= house_bg.x + house_bg.width - target.width)
			{
				target.velocity.x = -50;
			}
			else if (target.velocity.x < 0 && target.x <= house_bg.x + 16)
			{
				target.velocity.x = 50;
			}
		}

		if (Math.random() < 0.001)
		{
			target.velocity.x = 0;
		}

		if (Math.random() < 0.001)
		{
			target.visible = false;
		}

		if (Math.random() < 0.00001)
		{
			target.visible = true;
			targetMustChange = false;
		}

		if (Math.random() < 0.0000025)
		// if (true)
		{
			target.visible = true;
			targetMustChange = false;
			targetState = INSIDE_TO_DOOR;
		}

		if (target.velocity.x != 0 || target.velocity.y != 0) targetMustChange = false;
	}


	private function updateCameraPosition():Void
	{
		if (camera.x < 0) camera.x = 0;
		if (camera.x + camera.width > FlxG.width) camera.x = FlxG.width - camera.width;
		if (camera.y < 0 + 6*8) camera.y = 0 + 6*8;
		if (camera.y + camera.height > FlxG.height - 6*8) camera.y = FlxG.height - 6*8 - camera.height;

		cameraCamera.x = Std.int(camera.x + 7*8);
		cameraCamera.y = Std.int(camera.y + 4*8);
		cameraCamera.focusOn(new FlxPoint(Std.int(cameraCamera.x + cameraCamera.width),Std.int(cameraCamera.y + cameraCamera.height)));

		camTest.x = cameraCamera.x + cameraCamera.width/2;
		camTest.y = cameraCamera.y + cameraCamera.height/2;

	}


	private function updateSprites():Void
	{
		for (i in 0...display.members.length)
		{
			var s:WeekSprite = cast(display.members[i],WeekSprite);

			if (s == null || !s.active) continue;
			if (s.ID != CAR && s.ID != PASSERBY && s.ID != INSIDER) continue;

			if (s.velocity.x > 0 && s.x > FlxG.width) s.kill();
			else if (s.velocity.x < 0 && s.x + s.width < 0) s.kill();
		}
	}


	override private function handleInput():Void
	{
		super.handleInput();

		if (FlxG.keys.pressed.LEFT)
		{
			camera.velocity.x = -CAMERA_SPEED;
		}
		else if (FlxG.keys.pressed.RIGHT)
		{
			camera.velocity.x = CAMERA_SPEED;
		}
		else
		{
			camera.velocity.x = 0;
		}

		if (FlxG.keys.pressed.UP)
		{
			camera.velocity.y = -CAMERA_SPEED;
		}
		else if (FlxG.keys.pressed.DOWN)
		{
			camera.velocity.y = CAMERA_SPEED;
		}
		else
		{
			camera.velocity.y = 0;
		}

		if (FlxG.keys.justPressed.SPACE)
		{
			FlxG.camera.flash(0xFFFFFFFF,0.2);

			photos++;


			if (!target.visible) 
			{
				GameAssets.INCORRECT_SOUND.play();

				notInFrameWarning = true;
				redundancyWarning = false;

				redundancyWarningTimer.abort();
				notInFrameWarningTimer.abort();

				notInFrameWarningTimer = FlxTimer.start(2,notInFrameWarningTimerFinished);							
				return;
			}


			if (targetState != INSIDE && camTest.overlapsPoint(new FlxPoint(target.x + target.width/2,target.y + target.height/2),true,cameraCamera))
			{
				if (targetMustChange)
				{
					GameAssets.INCORRECT_SOUND.play();
					redundancyWarning = true;
					notInFrameWarning = false;

					redundancyWarningTimer.abort();
					notInFrameWarningTimer.abort();

					redundancyWarningTimer = FlxTimer.start(2,redundancyWarningTimerFinished);
				}
				else
				{
					evidence++;
					GameAssets.CORRECT_SOUND.play();	
					targetMustChange = true;			
				}
			}
			else if (targetState == INSIDE && 
				camTest.overlapsPoint(new FlxPoint(target.x + target.width/2,target.y + target.height/2),false,cameraCamera) &&
				target.overlaps(windows,false,cameraCamera))
			{
				if (targetMustChange)
				{
					GameAssets.INCORRECT_SOUND.play();
					redundancyWarning = true;
					notInFrameWarning = false;

					redundancyWarningTimer.abort();
					notInFrameWarningTimer.abort();

					redundancyWarningTimer = FlxTimer.start(2,redundancyWarningTimerFinished);
				}
				else
				{
					evidence++;
					GameAssets.CORRECT_SOUND.play();
					targetMustChange = true;			
				}
			}
			else
			{
				notInFrameWarning = true;
				redundancyWarning = false;

				redundancyWarningTimer.abort();
				notInFrameWarningTimer.abort();

				notInFrameWarningTimer = FlxTimer.start(2,notInFrameWarningTimerFinished);							
				GameAssets.INCORRECT_SOUND.play();
			}
		}
	}


	override private function handleFocus():Void
	{
		super.handleFocus();

		if (ProjectClass.focused) 
		{
			if (!gameOverText.visible && !offShiftText.visible)
			{
				cameraCamera.visible = true;
			}
		}
		else 
		{
			cameraCamera.visible = false;
		}
	}



	private function redundancyWarningTimerFinished(t:FlxTimer):Void
	{
		redundancyWarning = false;
	}


	private function notInFrameWarningTimerFinished(t:FlxTimer):Void
	{
		notInFrameWarning = false;
	}

}