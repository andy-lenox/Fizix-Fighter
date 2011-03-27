package
{
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		[Embed(source="data/space.jpg")] private var ImgBackground:Class;
		[Embed(source = "data/sagan_life.png")] private var ImgSaganHead:Class;
		[Embed(source = "data/newton_life.png")] private var ImgNewtonHead:Class;
		[Embed(source = "data/sagan_sprite.png")] private var ImgSagan:Class;
		[Embed(source = "data/newton_sprite.png")] private var ImgNewton:Class;
		[Embed(source = "data/ground.png")] private var ImgGround:Class;
		[Embed(source = "data/platform.png")] private var ImgPlatform:Class;
		[Embed(source = "data/Space_Station_V.png")] private var ImgStation:Class;
		[Embed(source="data/Night.mp3")] private var SndMusic:Class;
		
		protected var _char_selection:int;
		static public var char_selection:int;
		
		static public const CHAR_SAGAN:int = 0;
		static public const CHAR_NEWTON:int = 1;
		
		
		public var static:FlxGroup = new FlxGroup();
		public var blocks:FlxGroup = new FlxGroup();
		public var bullets1:FlxGroup = new FlxGroup();
		public var bullets2:FlxGroup = new FlxGroup();
		public var giblets:FlxEmitter = new FlxEmitter();
		public var player1:Player;
		public var player2:Player;
		public var p1headsprite1:FlxSprite;
		public var p1headsprite2:FlxSprite;
		public var p1headsprite3:FlxSprite;
		public var p2headsprite1:FlxSprite;
		public var p2headsprite2:FlxSprite;
		public var p2headsprite3:FlxSprite;
		public var p1head2:Boolean = true;
		public var p1head3:Boolean = true;
		public var p2head2:Boolean = true;
		public var p2head3:Boolean = true;
		public var t1:FlxText;
		public var t2:FlxText;
		public var box:Throwable;
		public var box2:Throwable;
		private var sf:StarField = new StarField();
		
		override public function create():void
		{
			_char_selection = PlayState.char_selection;
			FlxG.play(SndMusic);
			
			var background:FlxSprite = new FlxSprite(0,0,ImgBackground);
			background.scrollFactor.x = background.scrollFactor.y = 0;
			add(background);
			add(sf);
			
			var station:FlxSprite = new FlxSprite(30, 150, ImgStation);
			station.scrollFactor.x = 0.5;
			station.scrollFactor.y = 0.5;
			add(station);
			
			for (var i:Number = 0; i < 32; i++)
			{
				bullets1.add(new Bullet());
				bullets2.add(new Bullet());
			}
			add(bullets1);
			add(bullets2);
			
			var ground:FlxSprite = new FlxSprite(0,FlxG.height - 30);
			ground.loadGraphic(ImgGround);
			ground.fixed = true;
			static.add(ground);
			add(ground);
			
			var platform:FlxSprite = new FlxSprite(100, FlxG.height - 100, ImgPlatform);
			static.add(platform);
			platform.fixed = true;
			add(platform);
			
			var platform2:FlxSprite = new FlxSprite(700, FlxG.height - 100, ImgPlatform);
			platform2.fixed = true;
			static.add(platform2);
			add(platform2);
			
			box = new Throwable(FlxG.width/2, FlxG.height/2 - 100);
			blocks.add(box);
			add(box);
			
			box2 = new Throwable(FlxG.width/2+100, FlxG.height/2 - 100);
			blocks.add(box2);
			add(box2);
			
			player1 = new Player(FlxU.random() * 400 + 20, 350, bullets1.members, giblets, "A", "D", "W", "E", "Q");
			if(_char_selection == CHAR_SAGAN)
				player1.loadGraphic(ImgSagan, true, true, 30, 39);
			else if (_char_selection == CHAR_NEWTON)
				player1.loadGraphic(ImgNewton, true, true, 30, 39);
			FlxG.follow(player1, 2);
			
			player2 = new Player(FlxU.random() * 400 + 500, 350, bullets2.members, giblets, "J", "L", "I", "O", "U");
			player2.loadGraphic(ImgSagan,true,true,30,39);
			
			add(player1);
			add(player2);
			
			defaultGroup.remove(t1);
			t1 = new FlxText(10,60,150,"P1:"+player1.health+"%");
			t1.size = 24;
			t1.alignment = "center";
			t1.scrollFactor.x = t1.scrollFactor.y = 0;
			add(t1);
			
			defaultGroup.remove(t2);
			t2 = new FlxText(800,60,150,"P2:"+player2.health+"%");
			t2.size = 24;
			t2.alignment = "center";
			t2.scrollFactor.x = t2.scrollFactor.y = 0;
			add(t2);
			
			if (_char_selection == CHAR_SAGAN)
			{
				p1headsprite1 = new FlxSprite(50, 30, ImgSaganHead);
				p1headsprite2 = new FlxSprite(80, 30, ImgSaganHead);
				p1headsprite3 = new FlxSprite(110, 30, ImgSaganHead);
			}
			else if(_char_selection == CHAR_NEWTON)
			{
				p1headsprite1 = new FlxSprite(50, 30, ImgNewtonHead);
				p1headsprite2 = new FlxSprite(80, 30, ImgNewtonHead);
				p1headsprite3 = new FlxSprite(110, 30, ImgNewtonHead);
			}
			p1headsprite1.scrollFactor.x = p1headsprite1.scrollFactor.y = 0
			p1headsprite2.scrollFactor.x = p1headsprite2.scrollFactor.y = 0
			p1headsprite3.scrollFactor.x = p1headsprite3.scrollFactor.y = 0
			add(p1headsprite1);
			add(p1headsprite2);
			add(p1headsprite3);
			
			p2headsprite1 = new FlxSprite(836, 30, ImgSaganHead); // for now, just assume
			p2headsprite2 = new FlxSprite(866, 30, ImgSaganHead);
			p2headsprite3 = new FlxSprite(896, 30, ImgSaganHead);
			p2headsprite1.scrollFactor.x = p2headsprite1.scrollFactor.y = 0
			p2headsprite2.scrollFactor.x = p2headsprite2.scrollFactor.y = 0
			p2headsprite3.scrollFactor.x = p2headsprite3.scrollFactor.y = 0
			add(p2headsprite1);
			add(p2headsprite2);
			add(p2headsprite3);
			
		}
		
		override public function update():void
		{
			FlxU.collide(static, static);
			FlxU.collide(blocks, static);
			FlxU.collide(blocks, blocks);
			FlxU.collide(blocks, player2);
			FlxU.collide(player1, player2);
			FlxU.collide(static, player1);
			FlxU.collide(static, player2);
			FlxU.collide(player1, player2);
			
			if (FlxU.collide(bullets2, player1))
				player1.hurt(int(FlxU.random()*20));
			if (FlxU.collide(bullets1, player2))
				player2.hurt(int(FlxU.random()*20));
			
			//grabbing
			for (var i:int = 0 ; i < blocks.members.length ; i++){
				if (FlxU.collide(blocks.members[i],player1))
					if (!player1.holding) player1.pickup(blocks.members[i]);
				if (FlxU.collide(blocks.members[i],player2))
					if (!player1.holding) player2.pickup(blocks.members[i]);
			}
	
			
			if ((p1head3) && (player1.lives == 2))
			{
				defaultGroup.remove(p1headsprite3);
				p1head3 = false;
			}
			if ((p1head2) && (player1.lives == 1))
			{
				defaultGroup.remove(p1headsprite2);
				p1head2 = false;
			}
			
			if ((p2head3) && (player2.lives == 2))
			{
				defaultGroup.remove(p2headsprite3);
				p2head3 = false;
			}
			if ((p2head2) && (player2.lives == 1))
			{
				defaultGroup.remove(p2headsprite2);
				p2head2 = false;
			}
			
			t1.text = "P1:"+player1.health+"%";
			t2.text = "P2:"+player2.health+"%";
			
			super.update();
		}
	}
}