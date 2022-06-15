package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.FlxG;

import flixel.util.FlxTimer;

import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.text.TextFormat;


class OneMinuteSpeedDate extends BaseState
{
	private var playerDateTable:DatingTable;

	private var daters:FlxGroup;


	private static var daterColours:Array<Int> = [
	0xFFDDDDFF,
	0xFFAAAAEE,
	0xFF5555BB,
	0xFF8888CC,
	0xFF333388,
	0xFF9999AA,
	];

	override public function create():Void
	{

		

		duration = 60;
		// duration = 60;


		var bg:FlxSprite = new FlxSprite(0,0,GameAssets.MINUTE_BG);
		// bg.setOriginToCorner();
		Helpers.setupSprite(bg,8);
		add(bg);

		super.create();

		var leftMargin:Int = 4 * 16;
		var spacing:Int = 5*16;

		playerDateTable = new DatingTable(leftMargin + 200,16*16 - 8,true);

		var t:DatingTable;
		daters = new FlxGroup();
		for (i in 0...3)
		{
			if (i % 2 == 0)
			{
				t = new DatingTable(leftMargin + i*(200),4*16 - 8);
			}
			else
			{
				t = new DatingTable(leftMargin + i*(200),4*16);
			}
			display.add(t);
			daters.add(t);
		}
		for (i in 0...3)
		{
			if (i == 1) continue;

			t = new DatingTable(leftMargin + i*(200),16*16 - 16);
			display.add(t);
			daters.add(t);
		}

		display.add(playerDateTable);

		instructions.text = "";
		statistics.text = "YOUR DATEABILITY: 0%";
		gameOverText.text = "DATE OVER.";
		thisState = OneMinuteSpeedDate;
	}


	override private function timerFinished(t:FlxTimer):Void
	{
		super.timerFinished(t);
	}


	override public function destroy():Void
	{
		daters.destroy();
		playerDateTable.destroy();

		super.destroy();
	}

	override public function update():Void
	{
		super.update();

		switch (state)
		{
			case PLAY:
			display.sort();

			statistics.text = "YOUR DATEABILITY: " + Math.floor(100 * playerDateTable.good / (playerDateTable.good + playerDateTable.bad)) + "%";

			if (timer.timeLeft <= 2 && !playerDateTable.dateIsOver)
			{
				playerDateTable.dateOver();
				state = GAME_OVER;
			}

			instructions.text = playerDateTable.getOptions();
			
			case WIN:

			case LOSE:

			case GAME_OVER:
		}
	}

}