package;

import flixel.FlxSprite;
import flixel.FlxG;

import flixel.util.FlxTimer;

class MilleniumAudience extends FlxSprite
{
	private static var TIMER_AMOUNT:Float = 10000;
	private static var TIMER_MINIMUM:Float = 60;

	// private static var TIMER_AMOUNT:Float = 5;
	// private static var TIMER_MINIMUM:Float = 5;

	private static var SPEED:Float = 150;

	private var moverLeaving:Bool = false;

	public var mover:FlxSprite;
	private var timer:FlxTimer;

	public function new (X:Float,Y:Float):Void
	{
		super(X,Y);
		loadGraphic(GameAssets.MILLENIUM_AUDIENCE,true,false,7,9,false);
		replaceColor(0xFF000000,0xFF5577EE);
		Helpers.setupSprite(this,8);

		mover = new FlxSprite(X,Y);
		mover.loadGraphic(GameAssets.SHARED_PERSON,false,false,7,9,true);
		mover.replaceColor(0xFF000000,0xFF5577EE);
		Helpers.setupSprite(mover,8);

		if (Math.random() < 0.2)
		{
			animation.frameIndex = 0;
			if (X <= FlxG.width/2)
			{
				mover.x = -100;
			}
			else
			{
				mover.x = FlxG.width + 10;
			}
			mover.visible = true;
		}
		else
		{
			animation.frameIndex = 1;
			mover.visible = false;
		}

		mover.y = Y + height - mover.height - mover.height / 8;

		FlxTimer.start(Math.random() * TIMER_AMOUNT + TIMER_MINIMUM,timerFinished);
	}


	private function timerFinished(t:FlxTimer):Void
	{
		if (animation.frameIndex == 0 && !OneMilleniumAvantGardeBand.showsOver)
		{
			if (mover.x < 0)
			{
				mover.velocity.x = SPEED;
			}
			else if (mover.x >= FlxG.width)
			{
				mover.velocity.x = -SPEED;
			}
		}
		else if (animation.frameIndex == 1)
		{
			animation.frameIndex = 0;
			mover.x = x;
			mover.visible = true;

			if (x <= FlxG.width/2)
			{
				mover.velocity.x = -SPEED;
			}
			else
			{
				mover.velocity.x = SPEED;
			}

			moverLeaving = true;
		}
	}


	override public function update():Void
	{
		super.update();

		if (moverLeaving)
		{
			if ((mover.velocity.x < 0 && mover.x + mover.width < 0) ||
				(mover.velocity.x > 0 && mover.x > FlxG.width))
			{
				mover.velocity.x = 0;
				moverLeaving = false;
				FlxTimer.start(Math.random() * TIMER_AMOUNT + TIMER_MINIMUM,timerFinished);
			}
		}
		else if (!moverLeaving && !OneMilleniumAvantGardeBand.showsOver)
		{
			if ((mover.velocity.x < 0 && mover.x + mover.width/2 < x + width/2) ||
				(mover.velocity.x > 0 && mover.x + mover.width/2 > x + width/2))
			{
				mover.velocity.x = 0;
				mover.visible = false;
				animation.frameIndex = 1;
				FlxTimer.start(Math.random() * TIMER_AMOUNT + TIMER_MINIMUM,timerFinished);
			}
		}
	}
}
