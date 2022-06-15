package;

import flixel.FlxSprite;


class WeekSprite extends FlxSprite
{
	
	public var sortID:Int;

	public function new (X:Float = 0, Y:Float = 0, SortID:Int = 0, S:Dynamic = null):Void
	{
		super(X,Y,S);

		sortID = SortID;
	}
}