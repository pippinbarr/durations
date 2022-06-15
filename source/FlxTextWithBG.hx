package;


import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;


class FlxTextWithBG extends FlxGroup
{
	private var _x:Float;
	private var _y:Float;
	private var _alpha:Float;

	public var x(get_x,set_x):Float;
	public var y(get_y,set_y):Float;
	public var alpha(get_alpha,set_alpha):Float;

	public var width:Float;
	public var height:Float;

	public var text:FlxText;
	public var bg:FlxSprite;

	private var size:Int;
	private var align:String;
	private var color:UInt;
	private var bgColor:UInt;

	public function new(X:Float,Y:Float,W:Float,T:String,S:Int,A:String,TextColor:UInt,BGColor:UInt)
	{
		super();

		_x = X;
		_y = Y;
		_alpha = 1;
		bgColor = BGColor;
		color = TextColor;
		size = S;
		align = A;

		text = new FlxText(X,Y,Std.int(W),T,S);
		text.alignment = A;
		text.color = TextColor;
		text.moves = true;

		width = text.width;
		height = text.height;

		bg = new FlxSprite(text.x,text.y);
		bg.makeGraphic(Std.int(width),Std.int(height),BGColor);


		add(bg);
		add(text);
	}


	public function get_x():Float
	{
		return _x;
	}

	public function set_x(value:Float):Float
	{
		_x = value;
		setAll("x",_x);
		return value;
	}

	public function get_y():Float
	{
		return _y;
	}

	public function set_y(value:Float):Float
	{
		_y = value;
		setAll("y",_y);
		return value;
	}

	public function get_alpha():Float
	{
		return _alpha;
	}

	public function set_alpha(value:Float):Float
	{
		_alpha = value;
		setAll("alpha",_alpha);
		return value;
	}



	public function setText(S:String):Void
	{
		remove(text);
		text = new FlxText(this.x,this.y,Std.int(this.width),S,this.size);
		text.alignment = align;
		text.color = color;
		text.moves = true;
		add(text);

		width = text.width;
		height = text.height;

		remove(bg);
		bg = new FlxSprite(text.x,text.y);
		bg.makeGraphic(Std.int(width),Std.int(height),bgColor);
		add(bg);


	}
}