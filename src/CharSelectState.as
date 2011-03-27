package
{
	import flash.media.Camera;
	
	import org.flixel.*;
	import org.flixel.data.FlxQuake;
	
	public class CharSelectState extends FlxState
	{
		static public const CARL_SAGAN:int = 0;
		
		[Embed(source="data/select_sagan.png")] private var ImgSagan:Class;
		[Embed(source="data/select_newton.png")] private var ImgNewton:Class;
		[Embed(source="data/pwr.mp3")] private var SndPwr:Class;
		[Embed(source="data/explosion.mp3")] private var SndExplosion:Class;
		[Embed("data/VGMus1.mp3")] private var SndMusic:Class;
		
		private var emitter:FlxEmitter;
		private var sf:StarField = new StarField();
		
		override public function create():void
		{
			FlxG.mouse.show();
			FlxG.play(SndMusic);
			add(sf);
			
			var t:FlxText;
			t = new FlxText(0,10,FlxG.width,"Character Select");
			t.size = 24;
			t.alignment = "center";
			add(t);
			
			//Carl Sagan Button
			var buttonCorner:int = 150;
			var buttonWidth:int = 250;
			
			var char1:FlxButton;
			char1 = new FlxButton(buttonCorner,buttonCorner,chooseSagan);
			char1.loadGraphic(new FlxSprite(0,0,ImgSagan));
			add(char1);
			
			//Carl Sagan Text
			t = new FlxText(buttonCorner,buttonCorner+225,buttonWidth,"Carl Sagan");
			t.size = 24;
			t.alignment = "center";
			add(t);
			
			//Isaac Newton Button
			var char2:FlxButton;
			char2 = new FlxButton(buttonCorner+buttonWidth,buttonCorner,chooseNewton);
			char2.loadGraphic(new FlxSprite(0,0,ImgNewton));
			add(char2);
			
			//Isaac Newton Text
			t = new FlxText(buttonCorner+buttonWidth,buttonCorner+225,buttonWidth,"Isaac Newton");
			t.size = 24;
			t.alignment = "center";
			add(t);
			
			emitter = new FlxEmitter(FlxG.width/2,FlxG.height/2);
			var particles:int = 100;
			for(var i:int = 0; i < particles; i++)
			{
				var particle:FlxSprite = new FlxSprite();
				particle.createGraphic(8, 8, 0xffffffff);
				emitter.add(particle);
			}
			emitter.setSize(100,30);
			emitter.setYSpeed(-200,-20);
			emitter.setRotation(-720,720);
			emitter.gravity = 100
			add(emitter);
			
		}
		
		public function chooseSagan():void{
			
			emitter.at(new FlxObject(FlxG.mouse.x, FlxG.mouse.y));
			emitter.start(true,0,100);
			FlxG.play(SndPwr);
			FlxG.play(SndExplosion);
			PlayState.char_selection = PlayState.CHAR_SAGAN;
			FlxG.flash.start(0xFFFFFFFF,1,switchState);
		}
		
		public function chooseNewton():void{
			
			emitter.at(new FlxObject(FlxG.mouse.x, FlxG.mouse.y));
			emitter.start(true,0,100);
			FlxG.play(SndPwr);
			FlxG.play(SndExplosion);
			PlayState.char_selection = PlayState.CHAR_NEWTON;
			FlxG.flash.start(0xFFFFFFFF,1,switchState);
		}
		
		public function switchState():void{
			FlxG.state = new PlayState();
		}
		
	}
}
