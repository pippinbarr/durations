package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.FlxG;

import flixel.util.FlxTimer;

import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.text.TextFormat;


enum State 
{
	PLAY;
	WIN;
	LOSE;
	GAME_OVER;
}


class BaseState extends FlxState
{
	private var duration:Float = 0;

	private var thisState:Dynamic;

	private var state:State;
	private var timer:FlxTimer;
	private var startHour:Int;

	private var instructions:FlxText;
	private var statistics:FlxText;

	private var gameOverText:FlxText;
	private var gameOverInstructionsText:FlxText;
	private var gameOverGroup:FlxGroup;

	private var display:FlxGroup;
	private var fg:FlxGroup;
	private var ui:FlxGroup;

	private var focusGroup:FlxGroup;


	override public function create():Void
	{
		FlxG.cameras.bgColor = 0xFFFFFFFF;
		FlxG.camera.antialiasing = false;
		FlxG.mouse.hide();

		display = new FlxGroup();

		fg = new FlxGroup();

		ui = new FlxGroup();
		var ui_bg:FlxSprite = new FlxSprite(0,0,GameAssets.SHARED_UI_BG);
		Helpers.setupSprite(ui_bg,8);
		ui.add(ui_bg);

		instructions = new FlxText(0,18,FlxG.width,"");
		instructions.setFormat(null,14,0xFFFFFFFF,"center");
		ui.add(instructions);

		statistics = new FlxText(0,FlxG.height - 36,FlxG.width,"");
		statistics.setFormat(null,14,0xFFFFFFFF,"center");
		ui.add(statistics);


		gameOverGroup = new FlxGroup();
		var gameOverBG:FlxSprite = new FlxSprite(0,0);
		gameOverBG.makeGraphic(FlxG.width,FlxG.height,0xFF000000);
		gameOverGroup.add(gameOverBG);
		gameOverText = new FlxText(0,0,FlxG.width,"GAME OVER");
		gameOverText.setFormat(null,FlxG.height/15,0xFFFFFFFF,"center");
		gameOverText.y = FlxG.height / 2 - gameOverText.height / 2;
		gameOverGroup.add(gameOverText);
		gameOverInstructionsText = new FlxText(0,360,FlxG.width,"");
		gameOverInstructionsText.setFormat(null,18,0xFFFFFFFF,"center");
		gameOverInstructionsText.text = "PRESS [SPACE] TO RETURN TO THE MENU";
		gameOverGroup.add(gameOverInstructionsText);
		gameOverGroup.visible = false;
		
		add(display);
		add(fg);
		add(ui);
		add(gameOverGroup);

		timer = FlxTimer.start(duration,timerFinished);

		startHour = Date.now().getHours();

		state = PLAY;

		FlxG.sound.volume = 1;
		FlxG.sound.muted = false;


		focusGroup = new FlxGroup();
		var focusBG:FlxSprite = new FlxSprite(0,0);
		focusBG.makeGraphic(FlxG.width,FlxG.height,0xAA000000);
		focusGroup.add(focusBG);
		var focusText:FlxText = new FlxText(0,0,FlxG.width,"CLICK HERE");
		focusText.setFormat(null,180,0xFFFFFFFF,"center");
		focusText.y = 0;
		focusGroup.add(focusText);

		add(focusGroup);

		if (ProjectClass.focused) focusGroup.visible = false;
	}


	private function timerFinished(t:FlxTimer):Void
	{
		state = GAME_OVER;
		gameOverGroup.visible = true;
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
			handleInput();

			case WIN:

			case LOSE:

			case GAME_OVER:
			handleGameOverInput();
		}

		handleFocus();
	}	


	private function handleFocus():Void
	{
		if (ProjectClass.focused) 
		{
			focusGroup.visible = false;
			FlxG.mouse.hide();
		}
		else 
		{
			focusGroup.visible = true;		
			FlxG.mouse.show();
		}
	}


	private function handleInput():Void
	{
		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(new MenuState());			
		}
	}


	private function handleGameOverInput():Void
	{
		if (FlxG.keys.justPressed.SPACE)
		{
			FlxG.switchState(new MenuState());
		}
	}
}