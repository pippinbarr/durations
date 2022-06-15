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
import flash.net.FileReference;


class OneHourNovella extends BaseState
{
	private var page:FlxSprite;
	private var pages:FlxText;
	private var novella:Novella;
	
	override public function create():Void
	{



		duration = 3600;
		// duration = 1 * 10;



		var bg:FlxSprite = new FlxSprite(0,0,GameAssets.HOUR_BG);
		Helpers.setupSprite(bg,8);
		add(bg);

		page = new FlxSprite(8*25,8*8);
		page.makeGraphic(8*30,8*34,0xFFEEEEEE);
		add(page);

		pages = new FlxText(page.x + 8,page.y + 8,Std.int(page.width - 16),"1",10);
		pages.setFormat(null,10,0xFF111111,"center");
		add(pages);

		novella = new Novella(page.x + 16,page.y + 32,page.width - 32,page.height - 32);
		// novella = new Novella(page.x + 16,page.y + 32,page.width - 32,40);
		novella.setFormat(null,12,0xFF111111,"left");
		add(novella);
		novella.enable();

		var desk:FlxSprite = new FlxSprite(8*34,8*43,GameAssets.HOUR_DESK);
		Helpers.setupSprite(desk,8);
		add(desk);

		super.create();

		instructions.text = "WRITE A NOVELLA.";
		statistics.text = "WORDS: 0";
		gameOverText.text = "THE END.";
		gameOverInstructionsText.text = "PRESS [S] TO SAVE YOUR NOVELLA\n" + gameOverInstructionsText.text;
		thisState = OneHourNovella;
	}


	override private function timerFinished(t:FlxTimer):Void
	{
		super.timerFinished(t);

		GameAssets.CORRECT_SOUND.play();

		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,onGameOverKeyDown);
	}


	private function onGameOverKeyDown(e:KeyboardEvent):Void
	{
		var character:String = String.fromCharCode(e.charCode);
		character = character.toUpperCase();

		if (character == "S")
		{
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onGameOverKeyDown);
			var file:FileReference = new FileReference();
			file.save(novella.getFullText(),"Novella.txt");
		}
	}



	override public function destroy():Void
	{
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onGameOverKeyDown);

		super.destroy();
	}



	override public function update():Void
	{
		super.update();

		switch (state)
		{
			case PLAY:
			statistics.text = "WORDS: " + novella.wordCount();
			pages.text = "- " + novella.numPages() + " -";

			case WIN:

			case LOSE:

			case GAME_OVER:

		}
	}




}