package
{
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		[Embed(source = "data/DSOOF.mp3")] private var SndOof:Class;
		[Embed(source = "data/DSPLPAIN.mp3")] private var SndPain1:Class;
		[Embed(source = "data/DSPOPAIN.mp3")] private var SndPain2:Class;
		[Embed(source = "data/DSPDIEHI.mp3")] private var SndDeath1:Class;
		[Embed(source = "data/DSPLDETH.mp3")] private var SndDeath2:Class;
		
		
		private var jumpPower:int;
		private var bullets:Array;
		private var curBullet:uint;
		private var bulletVel:int;
		private var up:Boolean;
		private var down:Boolean;
		private var restart:Number;
		private var gibs:FlxEmitter;
		public var leftStr:String, rightStr:String, upStr:String, attStr:String, grabStr:String;
		public var lives:Number;
		public var holding:Boolean;
		public var held_object:Throwable;
		public var _hit:Boolean;
		public var _hit_right:Boolean;
		public var _hit_left:Boolean;
		
		public function Player(X:int,Y:int,Bullets:Array,Gibs:FlxEmitter,inLeft:String,inRight:String,inUp:String,inAtt:String,inGrab:String)
		{
			health = 0;
			leftStr = inLeft;
			rightStr = inRight;
			upStr = inUp;
			attStr = inAtt;
			grabStr = inGrab;
			lives = 3;
			
			holding = false;
			held_object = null;
			
			super(X,Y);
			//load graphic commented out so we can do different chars.
			//loadGraphic(ImgSagan, true, true, 30, 39);
			restart = 0;
			
			//bounding box tweaks
			width = 30;
			height = 39;
			offset.x = 1;
			offset.y = 1;
			
			//basic player physics
			var runSpeed:uint = 210;
			drag.x = runSpeed*8;
			acceleration.y = 840;
			jumpPower = 420;
			maxVelocity.x = runSpeed;
			maxVelocity.y = jumpPower;
			
			//animations
			addAnimation("idle", [0]);
			addAnimation("run", [1, 0, 2, 0], 6);
			addAnimation("jump", [3]);
			
			//bullet stuff
			bullets = Bullets;
			curBullet = 0;
			bulletVel = 360;
			
			//Gibs emitted upon death
			gibs = Gibs;
		}
		
		override public function update():void
		{
			//game restart timer
			if(dead)
			{
				restart += FlxG.elapsed;
				//if(_restart > 2)
				//(FlxG.state as PlayState).reload = true;
				return;
			}
			
			
			//MOVEMENT
			acceleration.x = 0;
			if(FlxG.keys.pressed(leftStr))
			{
				facing = LEFT;
				acceleration.x -= drag.x;
			}
			else if(FlxG.keys.pressed(rightStr))
			{
				facing = RIGHT;
				acceleration.x += drag.x;
			}
			
			if(FlxG.keys.justPressed(upStr) && !velocity.y)
			{
				velocity.y = -jumpPower;
				//FlxG.play(SndJump);
			}
			
			//if (FlxG.keys.justPressed(_grabStr))
			
			// LOL SELF HURTING CODE
			if ((FlxG.keys.justPressed("Z")) && (leftStr == "A"))
				hurt(26);
			
			// LOL SUICIDE
			if ((FlxG.keys.justPressed("X")) && (leftStr == "A"))
				kill();
			
			//AIMING
			up = false;
			down = false;
			if(FlxG.keys.UP) up = true;
			else if(FlxG.keys.DOWN && velocity.y) down = true;
			
			//ANIMATION
			if(velocity.y != 0)
			{
				if(up) play("jump_up");
				else if(down) play("jump_down");
				else play("jump");
			}
			else if(velocity.x == 0)
			{
				if(up) play("idle_up");
				else play("idle");
			}
			else
			{
				if(up) play("run_up");
				else play("run");
			}
			
			//SHOOTING
			if(FlxG.keys.justPressed(attStr))
			{
				var bXVel:int = 0;
				var bYVel:int = 0;
				var bX:int = x;
				var bY:int = y;
				if(up)
				{
					bY -= bullets[curBullet].height - 4;
					bYVel = -bulletVel;
				}
				else if(down)
				{
					bY += height - 4;
					bYVel = bulletVel;
					velocity.y -= 36;
				}
				if(facing == RIGHT)
				{
					bX += width - 4;
					bXVel = bulletVel;
				}
				else
				{
					bX -= bullets[curBullet].width - 4;
					bXVel = -bulletVel;
				}
				bullets[curBullet].shoot(bX,bY,bXVel,bYVel);
				if(++curBullet >= bullets.length)
					curBullet = 0;
			}
			
			if(this._hit){
				velocity.y = -health * 3;
				if(_hit_right) velocity.x = -100 * health;
				else if(_hit_left) velocity.x = 100 * health;
				_hit = false;
				_hit_right = false;
				_hit_left = false;
			}
			
			
			FlxG.log(held_object);
			//carrying
			if(held_object != null){
				if(FlxG.keys.justPressed(grabStr)){
					if(holding){
						holding = false;
						held_object.launch();
						held_object == null;
					}
					else{
						holding = true;
						held_object.follow_player(this);
					}
				}		
			}
			
			if ((this.x < -300 || (this.x + this.width)  > FlxG.width + 300)
				||  (this.y < 0 || (this.y + this.height) > FlxG.height))
				kill();
			
			//UPDATE POSITION AND ANIMATION
			super.update();
		}
		
		override public function hitBottom(Contact:FlxObject,Velocity:Number):void
		{
			if(velocity.y > 210)
				FlxG.play(SndOof);
			onFloor = true;
			return super.hitBottom(Contact,Velocity);
		}
		override public function hitRight(Contact:FlxObject,Velocity:Number):void
		{
			_hit_right = true;
			super.hitRight(Contact,Velocity)
		}
		
		override public function hitLeft(Contact:FlxObject,Velocity:Number):void
		{
			_hit_left = true;
			super.hitLeft(Contact,Velocity)
		}
		
		public function pickup(box:Throwable):void
		{
			if (!holding)
				held_object = box;
		}
		
		override public function hurt(Damage:Number):void
		{
			health += Damage;
			if (int(FlxU.random()+0.5) == 1)
				FlxG.play(SndPain1);
			else
				FlxG.play(SndPain2);
			flicker(1.3);
			this._hit = true;
		}
		
		override public function kill():void
		{
			health = 0;
			x = FlxU.random() * 500 + 250;
			y = 350;
			lives--;
			if (lives == 0)
				FlxG.state = new CharSelectState();
			if (int(FlxU.random()+0.5) == 1)
				FlxG.play(SndDeath1);
			else
				FlxG.play(SndDeath2);
			flicker(-1);
			FlxG.quake.start(0.005,0.35);
			FlxG.flash.start(0xffd8eba2,0.35);
			if(gibs != null)
			{
				gibs.at(this);
				gibs.start(true,0,50);
			}
			
		}
	}
}