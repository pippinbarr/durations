package;


import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

import flixel.text.FlxText;
import flixel.FlxG;


class Novella extends FlxText
{
	private static var VALID_CHARACTERS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890().,;:'\"!@#$%^&*-_=+<>?[]{}\\|/~` ";
	private static var DISPLAY_TEXT_LENGTH:Int = 24 * 2;

	private var entered:Bool = false;
	private var enabled:Bool = false;

	private var maxHeight:Float;

	private var novella:Array<String>;
	private var currentPage:Int = 0;

	public function new(X:Float,Y:Float,Width:Float,MaxHeight:Float)
	{			
		super(X,Y,Std.int(Width),"",true);
		maxHeight = MaxHeight;
		novella = [""];
	}


	public override function update():Void 
	{
		super.update();		
	}

	public function enable():Void
	{
		enabled = true;
		text = "";
		entered = false;
		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
	}


	public function reenable():Void
	{
		enabled = true;
		entered = false;
		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
	}


	public function disable():Void
	{
		enabled = false;
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
	}


	private function onKeyDown(e:KeyboardEvent):Void
	{
		if (!enabled) 
		{
			return;
		}

		GameAssets.TAP_SOUND.play();

		if (e.keyCode == Keyboard.ENTER)
		{
			novella[currentPage] += "\n";
		}
		else if (e.keyCode == Keyboard.BACKSPACE) 
		{
			if (novella[currentPage].length == 0 && currentPage > 0)
			{
				novella.pop();
			}
			else
			{
				novella[currentPage] = novella[currentPage].substring(0,novella[currentPage].length - 1);
			}
		}
		else 
		{	
			var character:String = String.fromCharCode(e.charCode);
			character = character.toUpperCase();
			if (VALID_CHARACTERS.indexOf(character) != -1)
			{
				novella[currentPage] += character;
			}
		}
		currentPage = novella.length - 1;
		text = novella[currentPage];
		calcFrame();

		if (height > maxHeight)
		{
			handlePageTurns();
		}

		currentPage = novella.length - 1;
		text = novella[currentPage];
		calcFrame();
	}

	private function handlePageTurns():Void
	{
		var lastSpace:Int = novella[currentPage].lastIndexOf(" ");
		var lastReturn:Int = novella[currentPage].lastIndexOf("\n");

		var index:Int = Math.floor(Math.max(lastSpace,lastReturn));

		if (index != -1)
		{
			var carryString:String = novella[currentPage].substring(index+1,text.length);
			novella[currentPage] = novella[currentPage].substring(0,index);
			novella.push(carryString);
		}
		else
		{
			var lastCharacter:String = novella[currentPage].substr(novella[currentPage].length-1);
			novella[currentPage] = novella[currentPage].substring(0,novella[currentPage].length-1);
			if (lastCharacter != " " && lastCharacter != "\n")
			{
				novella.push(lastCharacter);
			}
			else
			{
				novella.push("");
			}
		}
	}

	public function wordCount():Int
	{
		var r:EReg = ~/\w+/g;
		var fullText:String = novella.join(" ");
		var spaceSplit:Array<String> = r.split(fullText);
		var words:Int = 0;
		for (i in 0...spaceSplit.length)
		{
			if (spaceSplit[i].length > 0) words++;
		}
		return words;
	}


	public function numPages():Int
	{
		return novella.length;
	}

	public function getFullText():String
	{
		return novella.join(" ");
	}

	public override function destroy():Void 
	{
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);

		super.destroy();
	}
}
