package;

import openfl.Assets;
import flash.geom.Rectangle;
import flash.net.SharedObject;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

import flixel.text.FlxText;

import flixel.group.FlxGroup;

import flixel.util.FlxMath;
import flixel.util.FlxTimer;

class MenuState extends FlxState
{

	private static var MENU_ITEM_STARTING_Y:Int = 160;
	private static var MENU_ITEM_VERTICAL_SPACING:Int = 24;

	private static var gameNames:Array<String> =
	[
	"ONE SECOND TYPING TUTOR",
	"ONE MINUTE\nSPEED DATE",
	"ONE HOUR TO WRITE A NOVELLA",
	"ONE DAY EXERGAME",
	"ONE WEEK\nSTAKE-OUT",
	"ONE MONTH MAZE",
	"ONE YEAR\nFINITE RUNNER",
	"ONE DECADE AT THE SLOT MACHINE",
	"ONE HUNDRED YEARS OF SOLITARY",
	"ONE MILLENIUM AVANT-GARDE BAND",
	];

	private static var releaseStrings:Array<String> =
	[
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	""
	];


	private var menuItems:FlxGroup;

	#if KICKSTARTER
	private static var gameStates:Array<Dynamic> = 
	[
	OneSecondTypingTutor,
	OneMinuteSpeedDate,
	OneHourNovella,
	OneDayExergame,
	OneWeekStakeout,
	OneMonthMaze,
	OneYearRunner,
	OneDecadeSlotMachine,
	OneHundredYearsOfSolitary,
	OneMilleniumAvantGardeBand,
	];
	#else
	private static var gameStates:Array<Dynamic> = 
	[
	OneSecondTypingTutor,
	OneMinuteSpeedDate,
	OneHourNovella,
	OneDayExergame,
	OneWeekStakeout,
	OneMonthMaze,
	OneYearRunner,
	OneDecadeSlotMachine,
	OneHundredYearsOfSolitary,
	OneMilleniumAvantGardeBand,
	];
	#end

	// private var menuPointer:FlxText;

	private var selectedGameIndex:Int = 0;

	private var focusGroup:FlxGroup;

	private var timer:FlxTimer;

	private var menuText:MenuText;
	private var dateText:MenuText;
	private var instructionsText:MenuText;

	override public function create():Void
	{
		super.create();

		FlxG.camera.bgColor = 0xFF333333;
		FlxG.mouse.hide();
		

		selectedGameIndex = gameNames.length - 1;


		var menuTitleText:FlxText = new FlxText(0,0,FlxG.width,"DURATIONS");
		menuTitleText.setFormat(null,74,0xFFFFFFFF,"center");
		add(menuTitleText);





		menuText = new MenuText(FlxG.width/8,FlxG.height/2,Std.int(FlxG.width - 2*FlxG.width/8),"");
		menuText.setFormat(null,40,0xFFFFFFFF,"center");
		menuText.updateFrame();
		add(menuText);

		dateText = new MenuText(FlxG.width/8,FlxG.height/2,Std.int(FlxG.width - 2*FlxG.width/8),"");
		dateText.setFormat(null,18,0xFFFFFFFF,"center");
		dateText.updateFrame();
		add(dateText);


		menuText.visible = false;
		menuText.text = gameNames[selectedGameIndex];
		menuText.updateFrame();
		menuText.y = FlxG.height/2 - menuText.height/2;

		dateText.visible = false;
		dateText.text = releaseStrings[selectedGameIndex];
		dateText.updateFrame();
		dateText.y = menuText.y + menuText.height + FlxG.height/20;


		instructionsText = new MenuText(FlxG.width/8,FlxG.height - FlxG.height/10,Std.int(FlxG.width - 2*FlxG.width/8),"PRESS [SPACE] TO PLAY CURRENTLY DISPLAYED GAME");
		instructionsText.setFormat(null,12,0xFFFFFFFF,"center");
		instructionsText.updateFrame();
		add(instructionsText);



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

		timer = FlxTimer.start(1,timerFinished);


		GameAssets.TAP_SOUND.play();
	}


	private function timerFinished(t:FlxTimer):Void
	{
		// FlxG.bgColor = 0xFF000000 + Math.floor(Math.random() * 0x00FFFFFF);
		GameAssets.TAP_SOUND.play();

		if (menuText.visible)
		{
			menuText.visible = false;
			dateText.visible = false;
		}
		else
		{
			selectedGameIndex = (selectedGameIndex + 1) % gameNames.length;

			menuText.visible = true;
			menuText.text = gameNames[selectedGameIndex];
			menuText.updateFrame();
			menuText.y = FlxG.height/2 - menuText.height/2;

			dateText.visible = true;
			dateText.text = releaseStrings[selectedGameIndex];
			dateText.updateFrame();
			dateText.y = menuText.y + menuText.height + FlxG.height/20;

			if (gameStates[selectedGameIndex] == null)
			{
				menuText.color = 0xFF666666;
				dateText.color = 0xFF666666;
			}
			else
			{
				menuText.color = (0xFFFFFFFF);
				dateText.visible = false;
			}


		}


		timer = FlxTimer.start(1,timerFinished);
	}


	override public function destroy():Void
	{
		super.destroy();
	}



	override public function update():Void
	{

		super.update();



		handleInput();

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
		// if (FlxG.keys.justPressed("DOWN"))
		// {
		// 	selectedGameIndex++;
		// 	if (selectedGameIndex == gameStates.length)
		// 	{
		// 		selectedGameIndex = 0;
		// 	}
		// }
		// else if (FlxG.keys.justPressed("UP"))
		// {
		// 	selectedGameIndex--;
		// 	if (selectedGameIndex == -1)
		// 	{
		// 		selectedGameIndex = gameStates.length - 1;
		// 	}
		// }
		// else if (FlxG.keys.justPressed("ENTER"))
		// {
		// 	if (gameStates[selectedGameIndex] != null)
		// 	{
		// 		FlxG.switchState(Type.createInstance(gameStates[selectedGameIndex],[]));
		// 	}
		// }

		if (FlxG.keys.justPressed.SPACE)
		{
			if (gameStates[selectedGameIndex] != null && menuText.visible)
			{
				GameAssets.CORRECT_SOUND.play();
				FlxG.switchState(Type.createInstance(gameStates[selectedGameIndex],[]));
			}
			else
			{
				GameAssets.INCORRECT_SOUND.play();
			}
		}

		// menuPointer.y = MENU_ITEM_STARTING_Y + selectedGameIndex*MENU_ITEM_VERTICAL_SPACING;
	}
}