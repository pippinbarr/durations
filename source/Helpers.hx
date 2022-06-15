package;

import flixel.FlxSprite;

class Helpers
{

	public static function randomSort(X:Dynamic,Y:Dynamic):Int
	{
		var r:Float = Math.random();
		if (r < 0.33) return 1;
		else if (r < 0.66) return 0;
		else return -1;

	}


	public static function setupSprite(S:FlxSprite,Scale:Float):Void
	{
		S.antialiasing = false;

		S.origin.x = 0;
		S.origin.y = 0;

		S.scale.x = S.scale.y = Scale;

		S.width *= Scale;
		S.height *= Scale;
	}

}