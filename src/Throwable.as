package
{
	import org.flixel.*;
	
	public class Throwable extends FlxSprite
	{
		[Embed(source="data/box.png")] private var ImgBox:Class;
		
		private var held:Boolean;
		private var accel:Number; //original acceleration
		private var dr:Number; //original drag
		
		private var _follow:Boolean;
		private var _launch:Boolean;
		
		private var _target_x_position:Number;
		private var _target_y_position:Number;
		private var _target_velocity:FlxPoint;
		private var _target_facing:uint;

		
		//not sure if this default will work or not.
		public function Throwable(x:Number, y:Number, image:Class = null, width:Number = 30, height:Number = 30)
		{
			if (image == null)
				image = ImgBox;
			
			super(x,y,image)
				
			acceleration.y = accel = 840;
			drag.x = dr = 1000;
			
			_launch = false;
			
		}
		
		override public function update():void
		{
			if (dead) exists = false;
			
			if(_follow){
				this.acceleration.y = 0;
				
				this.y = _target_y_position;
				//if (_target_facing == RIGHT) 
					//this.x = _target_x_position + 15;
				//else
					//this.x = _target_x_position - 15;
				
				this.velocity = _target_velocity;
				this.solid = false; 
				held = true;
			}
			
			if(_launch){
				//this.acceleration.y = accel;
				if(_target_facing == RIGHT){
					this.velocity.x += 5000;
				}
				if(_target_facing == LEFT){
					this.velocity.x -= 5000;	
				}	
				this.solid = true;
			}
			
			
			
			
			super.update();
		}
		
		public function follow_player(p:Player):void{
			_follow = true;
			_target_x_position = p.x;
			_target_y_position = p.y;
			_target_velocity = p.velocity;
			_target_facing = p.facing;
			
		}
		
		public function launch():void{
			_follow = false;
			_launch = true;
			_target_velocity.x = _target_velocity.y = 0;
			
		}
		
		
		override public function render():void
		{
			super.render();
		}
	}
}