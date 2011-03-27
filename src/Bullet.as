package
{
	import org.flixel.*;
	
	public class Bullet extends FlxSprite
	{
		[Embed(source="data/plasma.png")] private var ImgBullet:Class;
		[Embed(source="data/DSFIRXPL.mp3")] private var SndHit:Class;
		[Embed(source="data/DSPLASMA.mp3")] private var SndShoot:Class;
		
		public function Bullet()
		{
			super();
			loadGraphic(ImgBullet,true,true,20,20);
			width = 20;
			height = 20;
			offset.x = 1;
			offset.y = 1;
			exists = false;
			addAnimation("shot", [0, 1, 2, 1]);
		}
		
		override public function update():void
		{
			play("shot");
			if(dead && finished) exists = false;
			else super.update();
		}
		
		override public function render():void
		{
			super.render();
		}
		
		override public function hitLeft(Contact:FlxObject,Velocity:Number):void { kill(); }
		override public function hitRight(Contact:FlxObject,Velocity:Number):void { kill(); }
		override public function hitBottom(Contact:FlxObject,Velocity:Number):void { kill(); }
		override public function hitTop(Contact:FlxObject, Velocity:Number):void { kill(); }
		
		override public function kill():void
		{
			if (dead)
				return;
			velocity.x = 0;
			velocity.y = 0;
			FlxG.play(SndHit);
			dead = true;
			solid = false;
		}
		
		public function shoot(X:int, Y:int, VelocityX:int, VelocityY:int):void
		{
			FlxG.play(SndShoot);
			super.reset(X,Y);
			solid = true;
			velocity.x = VelocityX;
			velocity.y = VelocityY;
		}
	}
}