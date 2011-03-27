package
{
	import org.flixel.*;

	public class MenuState extends FlxState
	{
		[Embed("data/collider_physics.jpg")] private var ImgBackground:Class;
		[Embed("data/VGMus1.mp3")] private var SndMusic:Class;
		
		override public function create():void
		{
			
			FlxG.play(SndMusic);
			
			var backgrond:FlxSprite = new FlxSprite(120,0,ImgBackground);
			add(backgrond);
			
			var t:FlxText;
			t = new FlxText(0,FlxG.height/2-10,FlxG.width,"Fizix Fighter");
			t.size = 45;
			t.alignment = "center";
			add(t);
			t = new FlxText(FlxG.width/2-50,FlxG.height-20,100,"click to play");
			t.alignment = "center";
			add(t);
			
			FlxG.mouse.show();
		}

		override public function update():void
		{
			super.update();

			if(FlxG.mouse.justPressed())
			{
				FlxG.mouse.hide();
				FlxG.state = new CharSelectState();
			}
		}
	}
}
