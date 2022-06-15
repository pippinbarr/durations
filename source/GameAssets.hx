package;

import flixel.system.FlxSound;

class GameAssets
{
	public static var RES_480P:Int = 0;
	public static var RES_720P:Int = 1;
	public static var RES_960P:Int = 2;
	public static var RES_1920P:Int = 3;

	public static var resolution:Int = RES_960P;
	public static var scale:Float = 1.0;

	// SHARED //

	public static var SHARED_UI_BG:String = "assets/png/shared/ui_bg.png";
	public static var SHARED_PERSON:String = "assets/png/shared/person.png";

	public static var CORRECT_SOUND:FlxSound;
	public static var INCORRECT_SOUND:FlxSound;
	public static var ACKNOWLEDGE_SOUND:FlxSound;
	public static var TAP_SOUND:FlxSound;


	// ONE SECOND //

	public static var SECOND_BLACKBOARD:String = "assets/png/second/blackboard.png";
	public static var SECOND_BG:String = "assets/png/second/bg.png";
	public static var SECOND_TUTOR:String = "assets/png/second/tutor.png";
	public static var SECOND_TICK:String = "assets/png/second/tick.png";
	public static var SECOND_CROSS:String = "assets/png/second/cross.png";

	// ONE MINUTE //

	public static var MINUTE_BG:String = "assets/png/minute/bg.png";
	public static var MINUTE_TABLE:String = "assets/png/minute/table.png";
	public static var MINUTE_BALLOON_TAIL:String = "assets/png/minute/balloon_tail.png";
	public static var MINUTE_BALLOON_TAIL_LEFT:String = "assets/png/minute/balloon_tail_left.png";

	// ONE HOUR //

	public static var HOUR_BG:String = "assets/png/hour/bg.png";
	public static var HOUR_DESK:String = "assets/png/hour/desk.png";

	// ONE DAY //

	public static var DAY_BG:String = "assets/png/day/bg.png";
	public static var DAY_SITUP:String = "assets/png/day/situp.png";
	public static var DAY_PUSHUP:String = "assets/png/day/pushup.png";
	public static var DAY_PULLUP:String = "assets/png/day/pullup.png";
	public static var DAY_PULLUP_BAR:String = "assets/png/day/pullup_bar.png";
	public static var DAY_CYCLE:String = "assets/png/day/cycle.png";
	public static var DAY_SHOWER:String = "assets/png/day/shower.png";

	// ONE WEEK //

	public static var WEEK_BG:String = "assets/png/week/bg.png";
	public static var WEEK_CAMERA:String = "assets/png/week/camera.png";
	public static var WEEK_FENCE:String = "assets/png/week/fence.png";
	public static var WEEK_CAR:String = "assets/png/week/car.png";
	public static var WEEK_HOUSE:String = "assets/png/week/house.png";
	public static var WEEK_HOUSE_BG:String = "assets/png/week/house_bg.png";
	public static var WEEK_DOOR:String = "assets/png/week/door.png";
	public static var WEEK_CAR_SOUND:String = "assets/mp3/week/car.mp3";

	// ONE MONTH //

	public static var MONTH_MAZE:String = "assets/png/month/maze.png";
	public static var MONTH_PERSON:String = "assets/png/month/maze_person.png";

	// ONE YEAR //

	public static var YEAR_RUNNER:String = "assets/png/year/runner.png";
	public static var YEAR_FALLER:String = "assets/png/year/faller.png";
	public static var YEAR_GROUND:String = "assets/png/year/ground.png";
	public static var YEAR_COIN:String = "assets/png/year/coin.png";
	public static var YEAR_BUILDINGS:String = "assets/png/year/buildings.png";
	public static var YEAR_SKY:String = "assets/png/year/sky.png";
	public static var YEAR_WALL:String = "assets/png/year/wall.png";

	// ONE DECADE //

	public static var DECADE_SLOT_MACHINE:String = "assets/png/decade/slot_machine_body.png";
	public static var DECADE_SLOT_MACHINE_LIGHTS:String = "assets/png/decade/slot_machine_lights.png";
	public static var DECADE_SLOT_MACHINE_PICTURES:String = "assets/png/decade/slot_machine_pictures.png";

	// ONE CENTURY //

	public static var CENTURY_CELL:String = "assets/png/century/cell_bg.png";
	public static var CENTURY_DOOR:String = "assets/png/century/cell_door.png";
	public static var CENTURY_BED:String = "assets/png/century/bed2.png";
	public static var CENTURY_DESK_AND_CHAIR:String = "assets/png/century/desk_and_chair.png";
	public static var CENTURY_TOILET:String = "assets/png/century/toilet2.png";
	public static var CENTURY_SINK:String = "assets/png/century/sink.png";

	// ONE MILLENIUM //

	public static var MILLENIUM_BG:String = "assets/png/millenium/bg.png";
	public static var MILLENIUM_CURTAIN:String = "assets/png/millenium/curtain.png";
	public static var MILLENIUM_AUDIENCE:String = "assets/png/millenium/audience_member.png";
	public static var MILLENIUM_GUITAR:String = "assets/png/millenium/guitar.png";
	public static var MILLENIUM_KEYBOARD:String = "assets/png/millenium/keyboard.png";
	public static var MILLENIUM_DRUMS:String = "assets/png/millenium/drums.png";

	public static var BASS_A:String = "assets/mp3/millenium/bass_a.mp3";
	public static var BASS_B:String = "assets/mp3/millenium/bass_b.mp3";
	public static var BASS_D:String = "assets/mp3/millenium/bass_d.mp3";
	public static var BASS_E:String = "assets/mp3/millenium/bass_e.mp3";
	public static var BASS_F:String = "assets/mp3/millenium/bass_f.mp3";

	public static var GUITAR_A:String = "assets/mp3/millenium/guitar_a.mp3";
	public static var GUITAR_B:String = "assets/mp3/millenium/guitar_b.mp3";
	public static var GUITAR_D:String = "assets/mp3/millenium/guitar_d.mp3";
	public static var GUITAR_E:String = "assets/mp3/millenium/guitar_e.mp3";
	public static var GUITAR_F:String = "assets/mp3/millenium/guitar_f.mp3";

	public static var KEYBOARD_A:String = "assets/mp3/millenium/keyboard_a.mp3";
	public static var KEYBOARD_B:String = "assets/mp3/millenium/keyboard_b.mp3";
	public static var KEYBOARD_D:String = "assets/mp3/millenium/keyboard_d.mp3";
	public static var KEYBOARD_E:String = "assets/mp3/millenium/keyboard_e.mp3";
	public static var KEYBOARD_F:String = "assets/mp3/millenium/keyboard_f.mp3";

	public static var DRUM_KICK:String = "assets/mp3/millenium/kick.mp3";
	public static var DRUM_SNARE:String = "assets/mp3/millenium/snare.mp3";
	public static var DRUM_HIHAT:String = "assets/mp3/millenium/hihat.mp3";
	public static var DRUM_SPLASH:String = "assets/mp3/millenium/splash.mp3";



}