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


class OneDecadeSlotMachine extends BaseState
{
	private var played:Bool = false;
	private var machineFinished:Bool = false;

	private var machine:FlxSprite;
	private var lights:FlxSprite;

	private var leftPicture1:FlxSprite;
	private var leftPicture2:FlxSprite;
	private var middlePicture1:FlxSprite;
	private var middlePicture2:FlxSprite;
	private var rightPicture1:FlxSprite;
	private var rightPicture2:FlxSprite;

	private var totalFrames:Int = 0;


	override public function create():Void
	{




		duration = 315569088;
		// duration = 1 * 20;





		super.create();


		machine = new FlxSprite(0,0);
		machine.loadGraphic(GameAssets.DECADE_SLOT_MACHINE,true,false,80,60);
		machine.animation.add("pulldown",[0,1,2,3,4],5,false);
		machine.animation.add("release",[5,6],5,false);
		Helpers.setupSprite(machine,8);

		lights = new FlxSprite(21*8,11*8);
		lights.loadGraphic(GameAssets.DECADE_SLOT_MACHINE_LIGHTS,true,false,38,8);
		lights.animation.add("flashing",[0,1],10,true);
		Helpers.setupSprite(lights,8);
		lights.animation.play("flashing");

		leftPicture1 = new FlxSprite();
		leftPicture1.loadGraphic(GameAssets.DECADE_SLOT_MACHINE_PICTURES,true,false,12,12);
		Helpers.setupSprite(leftPicture1,8);
		leftPicture1.x = 20*8;
		leftPicture1.y = 25*8;
		leftPicture1.animation.frameIndex = Math.floor(Math.random() * leftPicture1.frames);

		leftPicture2 = new FlxSprite();
		leftPicture2.loadGraphic(GameAssets.DECADE_SLOT_MACHINE_PICTURES,true,false,12,12);
		Helpers.setupSprite(leftPicture2,8);
		leftPicture2.x = 20*8;
		leftPicture2.y = leftPicture1.y - leftPicture2.height;
		leftPicture2.animation.frameIndex = Math.floor(Math.random() * leftPicture2.frames);


		middlePicture1 = new FlxSprite();
		middlePicture1.loadGraphic(GameAssets.DECADE_SLOT_MACHINE_PICTURES,true,false,12,12);
		Helpers.setupSprite(middlePicture1,8);
		middlePicture1.x = leftPicture1.x + leftPicture1.width;
		middlePicture1.y = 25*8;
		middlePicture1.animation.frameIndex = Math.floor(Math.random() * middlePicture1.frames);

		middlePicture2 = new FlxSprite();
		middlePicture2.loadGraphic(GameAssets.DECADE_SLOT_MACHINE_PICTURES,true,false,12,12);
		Helpers.setupSprite(middlePicture2,8);
		middlePicture2.x = middlePicture1.x;
		middlePicture2.y = middlePicture1.y - middlePicture2.height;
		middlePicture2.animation.frameIndex = Math.floor(Math.random() * middlePicture2.frames);


		rightPicture1 = new FlxSprite();
		rightPicture1.loadGraphic(GameAssets.DECADE_SLOT_MACHINE_PICTURES,true,false,12,12);
		Helpers.setupSprite(rightPicture1,8);
		rightPicture1.x = middlePicture1.x + middlePicture1.width;
		rightPicture1.y = 25*8;
		rightPicture1.animation.frameIndex = Math.floor(Math.random() * rightPicture1.frames);

		rightPicture2 = new FlxSprite();
		rightPicture2.loadGraphic(GameAssets.DECADE_SLOT_MACHINE_PICTURES,true,false,12,12);
		Helpers.setupSprite(rightPicture2,8);
		rightPicture2.x = rightPicture1.x;
		rightPicture2.y = rightPicture1.y - rightPicture2.height;
		rightPicture2.animation.frameIndex = Math.floor(Math.random() * rightPicture2.frames);

		display.add(leftPicture1);
		display.add(leftPicture2);
		display.add(middlePicture1);
		display.add(middlePicture2);
		display.add(rightPicture1);
		display.add(rightPicture2);
		display.add(machine);
		display.add(lights);

		FlxG.camera.bgColor = 0xFFFFFFFF;

		instructions.text = "" +
		"PRESS THE [SPACE BAR] TO PULL THE LEVER.";
		thisState = OneDecadeSlotMachine;

		statistics.text = "MONEY: $1";

		gameOverText.text = "GAMBLING OVER";
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
			totalFrames++;
			if (totalFrames == 1000) totalFrames = 0;
			updatePictures();
			handleEnding();

			case WIN:

			case LOSE:

			case GAME_OVER:
		}
	}	


	private function updatePictures():Void
	{
		if (leftPicture1.velocity.y != 0 && leftPicture1.y > 37*8)
		{
			leftPicture1.y = leftPicture2.y  - leftPicture1.height;
			var next:Int = leftPicture1.animation.frameIndex;
			while (next == leftPicture1.animation.frameIndex || next == leftPicture2.animation.frameIndex)
			{
				next = Math.floor(Math.random() * leftPicture1.frames);
			}
			leftPicture1.animation.frameIndex = next;
		}

		if (leftPicture2.velocity.y != 0 && leftPicture2.y > 37*8)
		{
			leftPicture2.y = leftPicture1.y  - leftPicture2.height;
			var next:Int = leftPicture2.animation.frameIndex;
			while (next == leftPicture2.animation.frameIndex || next == leftPicture1.animation.frameIndex)
			{
				next = Math.floor(Math.random() * leftPicture2.frames);
			}
			leftPicture2.animation.frameIndex = next;		
		}

		if (middlePicture1.velocity.y != 0 && middlePicture1.y > 37*8)
		{
			middlePicture1.y = middlePicture2.y  - middlePicture1.height;
			var next:Int = middlePicture1.animation.frameIndex;
			while (next == middlePicture1.animation.frameIndex || next == middlePicture2.animation.frameIndex)
			{
				next = Math.floor(Math.random() * middlePicture1.frames);
			}
			middlePicture1.animation.frameIndex = next;
		}

		if (middlePicture2.velocity.y != 0 && middlePicture2.y > 37*8)
		{
			middlePicture2.y = middlePicture1.y  - middlePicture2.height;
			var next:Int = middlePicture2.animation.frameIndex;
			while (next == middlePicture2.animation.frameIndex || next == middlePicture1.animation.frameIndex)
			{
				next = Math.floor(Math.random() * middlePicture2.frames);
			}
			middlePicture2.animation.frameIndex = next;		
		}


		if (rightPicture1.velocity.y != 0 && rightPicture1.y > 37*8)
		{
			rightPicture1.y = rightPicture2.y  - rightPicture1.height;
			var next:Int = rightPicture1.animation.frameIndex;
			while (next == rightPicture1.animation.frameIndex || next == rightPicture2.animation.frameIndex)
			{
				next = Math.floor(Math.random() * rightPicture1.frames);
			}
			rightPicture1.animation.frameIndex = next;
		}

		if (rightPicture2.velocity.y != 0 && rightPicture2.y > 37*8)
		{
			rightPicture2.y = rightPicture1.y  - rightPicture2.height;
			var next:Int = rightPicture2.animation.frameIndex;
			while (next == rightPicture2.animation.frameIndex || next == rightPicture1.animation.frameIndex)
			{
				next = Math.floor(Math.random() * rightPicture2.frames);
			}
			rightPicture2.animation.frameIndex = next;		
		}

		if (leftPicture1.velocity.y != 0 ||
			middlePicture1.velocity.y != 0 ||
			rightPicture1.velocity.y != 0)
		{
			if (leftPicture1.velocity.y == 768)
			{
				GameAssets.TAP_SOUND.play();
			}
			else
			{
				var percentMaxSpeed:Float = leftPicture1.velocity.y / 768;
				var flipped:Float = 1 - percentMaxSpeed;
				var perFrame:Int = Math.floor(flipped * 10);
				if (totalFrames % perFrame == 0) GameAssets.TAP_SOUND.play();
			}
		}

	}


	private function handleEnding():Void
	{
		if (!played) return;
		if (timer.timeLeft > 8) return;

		var DECREASE:Int = 5;
		leftPicture1.velocity.y = Math.max(leftPicture1.velocity.y - DECREASE,0);
		leftPicture2.velocity.y = Math.max(leftPicture2.velocity.y - DECREASE,0);
		middlePicture1.velocity.y = Math.max(middlePicture1.velocity.y - DECREASE,0);
		middlePicture2.velocity.y = Math.max(middlePicture2.velocity.y - DECREASE,0);
		rightPicture1.velocity.y = Math.max(rightPicture1.velocity.y - DECREASE,0);
		rightPicture2.velocity.y = Math.max(rightPicture2.velocity.y - DECREASE,0);

		if (leftPicture1.velocity.y == 0 &&
			middlePicture1.velocity.y == 0 &&
			rightPicture1.velocity.y == 0 &&
			played &&
			!machineFinished)
		{
			machineFinished = true;
			instructions.text = "";
			setWinnings();
		}
	}


	private function setWinnings():Void
	{
		var r:Float = Math.random();
		var v:Int = 0;

		if (r < 0.1)
		{
			v = 10;
		}
		else if (r < 0.2)
		{
			v = 20;
		}
		else if (r < 0.3)
		{
			v = 25;
		}
		else if (r < 0.4)
		{
			v = 40;
		}
		else if (r < 0.5)
		{
			v = 50;
		}
		else if (r < 0.6)
		{
			v = 100;
		}

		if (v > 0) GameAssets.CORRECT_SOUND.play();
		else GameAssets.INCORRECT_SOUND.play();

		statistics.text = "MONEY: $" + v;
	}


	override public function handleInput():Void
	{
		super.handleInput();

		if (FlxG.keys.justPressed.SPACE && machine.animation.frameIndex == 0)
		{
			machine.animation.play("pulldown");
			played = true;
			statistics.text = "MONEY: $0";
		}

		if (machine.animation.frameIndex == 4)
		{
			leftPicture1.velocity.y = 768;
			leftPicture2.velocity.y = 768;		
			middlePicture1.velocity.y = 640;
			middlePicture2.velocity.y = 640;		
			rightPicture1.velocity.y = 512;
			rightPicture2.velocity.y = 512;	
			machine.animation.play("release");
		}

		if (machine.animation.frameIndex == 6)
		{
			instructions.text = "";
		}
	}


}