package;

import org.flixel.FlxState;
import org.flixel.FlxSprite;
import org.flixel.FlxText;
import org.flixel.FlxObject;
import org.flixel.FlxGroup;
import org.flixel.FlxG;

import org.flixel.util.FlxTimer;

import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.text.TextFormat;


class OneMinuteOfYourTime extends BaseState
{

	private var responseUpdated:Bool = false;

	private static var story:Array<String> = [
	"ZARG WATCHES OVER ALL OF US.",
	"YOU SHOULD REALLY WEAR A SAUCEPAN ON YOUR HEAD, ZARG PREFERS IT.",
	"I SAY MY PRAYERS TO ZARG EVERY NIGHT.",
	"I CAN TELL YOU ARE A GOOD PERSON.",
	"YOU SHOULD COME TO OUR ORIENTATION SEMINAR.",
	"FOR A SMALL DONATION I CAN GIVE YOU THIS BOOKLET ALL ABOUT ZARG.",
	"I FORESEE A CONVERSION TO ZARGISM IN YOUR FUTURE.",
	"ZARG KNOWS ALL, ZARG SEES ALL.",
	"ZARG IS YOUR FRIEND, YOUR BEST FRIEND, EVEN WHEN YOU DON'T KNOW IT.",
	"ZARG SAVED MY LIFE.",
	"WITHOUT ZARG THE UNIVERSE WOULD CEASE TO EXIST.",
	"ZARG WANTS YOU TO BE HAPPY.",
	"IF YOU PRAY TO ZARG, ZARG WILL ANSWER.",
	"WE HAVE NO CHURCHES, JUST ZARG CENTERS.",
	"YOU SHOULD COME ALONG TO A ZARG CENTER THIS WEEKEND.",
	];

	private static var sympathies:Array<String> = [
	"SOUNDS INTERESTING...",
	"TELL ME MORE...",
	"UH-HUH?",
	"OKAY, I SEE...",
	"I'M WITH YOU...",
	"GOTCHA.",
	"SOUNDS GREAT.",
	"KEEP GOING...",
	"OH REALLY?",
	"TERRIFIC...."
	];

	private static var contempts:Array<String> = [
	"UH... YEAH, WHATEVER.",
	"ARE YOU CRAZY?",
	"WHERE DO YOU GET THIS STUFF FROM?",
	"HOW STUPID DO YOU THINK I AM?",
	"UH, REALLY? COME ON NOW...",
	"I DON'T BELIEVE THIS...",
	"GIVE ME A BREAK.",
	"LOOK I REALLY NEED TO GO... AWAY FROM YOU.",
	"OH PLEASE.",
	"KEEP IT TO YOURSELF WOULD YOU?"
	];

	// private static var upbeats:Array<String> = [
	// "STILL, YOU'RE DUE FOR SOME GOOD LUCK...",
	// "COULD BE WORSE...",
	// "YOU'LL TURN IT ALL AROUND...",
	// "EVERY CLOUD HAS A SILVER LINING YOU KNOW...",
	// "THINGS WILL GET BETTER, I JUST KNOW IT.",
	// "TRY NOT TO WORRY SO MUCH!",
	// "TURN THAT FROWN UPSIDE DOWN!",
	// "DON'T WORRY, BE HAPPY!",
	// "CAN I GET A SMILE?",
	// "CHIN UP, YOU'LL BE ALRIGHT."
	// ];

	// private static var downbeats:Array<String> = [
	// "OH GOD THAT'S DEPRESSING...",
	// "JESUS...",
	// "UGH, I FEEL REALLY DOWN NOW.",
	// "WOW, THAT'S REALLY GRIM.",
	// "OH MAN, I WAS HAVING SUCH A GOOD DAY BEFORE...",
	// "THAT'S A SAD STORY.",
	// "YOU'RE MAKING ME FEEL SAD.",
	// "THE WORLD REALLY IS A HARSH PLACE.",
	// "THAT'S A TOUGH BREAK.",
	// "OH DEAR. I'M FEELING REALLY BLUE.",
	// ];

	private var storyTimer:FlxTimer;
	private var storyIndex:Int = 0;
	
	private var storyText:FlxText;
	private var storyTextBG:FlxSprite;
	private var storyTextTail:FlxSprite;

	private var responseText:FlxText;
	private var responseTextBG:FlxSprite;
	private var responseTextTail:FlxSprite;

	private var player:FlxSprite;
	private var other:FlxSprite;

	private var passersby:FlxGroup;

	private static var passersByColours:Array<Int> = [
	0xFFDDDDFF,
	0xFFAAAAEE,
	0xFF5555BB,
	0xFF8888CC,
	0xFF333388,
	0xFF9999AA,
	];

	override public function create():Void
	{
		FlxG.volume = 0;


		duration = 1 * 60;

		var bg:FlxSprite = new FlxSprite(0,0,GameAssets.MINUTE_BG);
		bg.setOriginToCorner();
		bg.scale.x = bg.scale.y = 8;
		add(bg);

		story.sort(Helpers.randomSort);

		storyText = new FlxText(FlxG.width/2 + 48,80,200,"");
		storyText.setFormat(null,14,0xFFFFFFFF,"left");
		storyText.visible = false;

		storyTextBG = new FlxSprite(0,0);
		storyTextBG.visible = false;

		storyTextTail = new FlxSprite(360,184);
		storyTextTail.loadGraphic(GameAssets.BALLOON_TAIL_LEFT,false,true);
		storyTextTail.replaceColor(0xFF000000,0xFF444444);
		Helpers.setupSprite(storyTextTail);
		storyTextTail.visible = false;

		storyTimer = new FlxTimer();

		responseText = new FlxText(FlxG.width/2 - 200 - 48,120,200,"");
		responseText.setFormat(null,14,0xFFFFFFFF,"left");
		responseText.visible = false;

		responseTextBG = new FlxSprite(0,0);
		responseTextBG.visible = false;

		responseTextTail = new FlxSprite(232,224);
		responseTextTail.loadGraphic(GameAssets.BALLOON_TAIL,false,true);
		Helpers.setupSprite(responseTextTail);
		responseTextTail.facing = FlxObject.RIGHT;
		responseTextTail.visible = false;

		player = new FlxSprite(260,240);
		player.loadGraphic(GameAssets.SHARED_PERSON,false,false,0,0,true);
		player.replaceColor(0xFF000000,0xFF5555DD);
		Helpers.setupSprite(player);
		player.x = FlxG.width/2 - player.width;

		other = new FlxSprite(320,200);
		other.loadGraphic(GameAssets.SHARED_PERSON,false,false,0,0,true);
		other.replaceColor(0xFF000000,0xFF444466);
		Helpers.setupSprite(other);
		other.x = FlxG.width/2;

		passersby = new FlxGroup();

		for (i in 0...10)
		{
			var p:FlxSprite = new FlxSprite(0,0);
			p.loadGraphic(GameAssets.SHARED_PERSON,false,false,7,9,true);
			p.replaceColor(0xFF000000,passersByColours[Math.floor(Math.random() * passersby.length)]);
			Helpers.setupSprite(p);
			initPasserBy(p);
			passersby.add(p);
		}


		super.create();

		display.add(storyTextBG);
		display.add(storyText);
		display.add(storyTextTail);

		display.add(responseTextBG);
		display.add(responseText);
		display.add(responseTextTail);

		display.add(player);
		display.add(other);

		for (i in 0...passersby.members.length)
		{
			display.add(passersby.members[i]);
		}

		instructions.text = "RESPOND WITH ARROW KEYS";
		thisState = OneMinuteOfYourTime;

		storyTimer.start(1,1,handleStory);
	}


	private function handleStory(t:FlxTimer):Void
	{
		if (storyText.visible)
		{
			storyText.visible = false;
			storyTextBG.visible = false;
			storyTextTail.visible = false;

			storyTimer.start(1,1,handleStory);
		}
		else
		{
			storyText.text = story[storyIndex];
			storyText.drawFrame(true);
			storyIndex = (storyIndex + 1) % story.length;
			storyText.visible = true;

			storyTextBG.makeGraphic(Std.int(storyText.width + 16),Std.int(storyText.height + 16),0xFF444444);
			storyTextBG.x = storyText.x - 8;
			storyTextBG.y = storyText.y - 8;
			storyTextBG.visible = true;

			storyTextBG.x = storyText.x - 8;
			storyTextBG.y = storyTextTail.y - storyTextBG.height;
			storyTextBG.visible = true;

			storyText.y = storyTextBG.y + 8;

			storyTextTail.visible = true;

			storyTimer.start(0.15 * storyText.text.length,1,handleStory);
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


		switch (state)
		{
			case PLAY:
			display.sort();
			handlePassersBy();

			case WIN:

			case LOSE:

			case GAME_OVER:
		}
	}


	private function initPasserBy(P:FlxSprite):Void
	{
		if (Math.random() > 0.5)
		{
			P.x = Math.random() * -200 - 50;
		}
		else
		{
			P.x = FlxG.width + Math.random() * 200 + 50;
		}
		P.y = Math.random() * 100 + 250;

		if (P.x < 0)
		{
			P.velocity.x = Math.random() * 150 + 50;
		}
		else
		{
			P.velocity.x = Math.random() * -150 - 50;
		}		
	}


	private function handlePassersBy():Void
	{
		for (i in 0...passersby.members.length)
		{
			var p:FlxSprite = cast(passersby.members[i],FlxSprite);
			if (p == null || !p.active) continue;

			if (p.velocity.x > 0 && p.x > FlxG.width)
			{
				initPasserBy(p);
			}
			else if (p.velocity.x < 0 && p.x + p.width < 0)
			{
				initPasserBy(p);
			}
		}
	}


	override private function handleInput():Void
	{
		super.handleInput();

		// if (responding) return;

		// if (FlxG.keys.justPressed("LEFT"))
		// {

		// }

		if (!FlxG.keys.LEFT && !FlxG.keys.RIGHT && !FlxG.keys.UP && !FlxG.keys.DOWN)
		{
			responseText.visible = false;
			responseTextBG.visible = false;
			responseTextTail.visible = false;
			responseUpdated = false;
		}
		else if (responseText.visible == true)
		{

		}
		else if (FlxG.keys.LEFT)
		{
			responseText.text = sympathies[Math.floor(Math.random() * sympathies.length)];
			responseText.visible = true;
			responseUpdated = true;
		}
		else if (FlxG.keys.RIGHT)
		{			
			responseText.text = contempts[Math.floor(Math.random() * contempts.length)];
			responseText.visible = true;
			responseUpdated = true;
		}
		// else if (FlxG.keys.UP)
		// {			
		// 	responseText.text = upbeats[Math.floor(Math.random() * upbeats.length)];
		// 	responseText.visible = true;
		// 	responseUpdated = true;
		// }
		// else if (FlxG.keys.DOWN)
		// {			
		// 	responseText.text = downbeats[Math.floor(Math.random() * downbeats.length)];
		// 	responseText.visible = true;
		// 	responseUpdated = true;
		// }

		if (responseUpdated)
		{
			responseText.drawFrame(true);
			responseTextBG.makeGraphic(Std.int(responseText.width + 16),Std.int(responseText.height + 16),0xFF222222);
			responseTextBG.x = responseText.x - 8;
			responseTextBG.y = responseTextTail.y - responseTextBG.height;
			responseTextBG.visible = true;

			responseText.y = responseTextBG.y + 8;

			responseTextTail.visible = true;

			responseUpdated = false;
		}

	}	
}