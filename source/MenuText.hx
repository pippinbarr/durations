package;


import flixel.text.FlxText;

import flash.text.TextFormat;


class MenuText extends FlxText
{

	private var currentHighlightIndex:Int = 0;



	public function nextHighlight():Void
	{
		// _textField.setTextFormat(dtfCopy());

		// var tf:TextFormat = dtfCopy();
		var tf:TextFormat = new TextFormat();
		tf.color = 0xFF00FF;


		currentHighlightIndex = Math.floor(Math.random() * text.length);
		while (text.charAt(currentHighlightIndex) == " ")
		{
			currentHighlightIndex = Math.floor(Math.random() * text.length);
		}

		setColorForRange(0xAAAAAA,currentHighlightIndex,currentHighlightIndex+1);

		// currentHighlightIndex = (currentHighlightIndex + 1) % text.length;
	}

	public function updateFrame():Void
	{
		calcFrame();
	}


	public function setColorForRange(Color:Int=0xffffff,Start:Int=-1,End:Int=-1):Int
	{
		var format:TextFormat = dtfCopy();
		format.color = Color;
		_textField.defaultTextFormat = format;
		_textField.setTextFormat(format,Start,End);
		_regen = true;
		calcFrame();
		return Color;
	}
}