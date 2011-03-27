package
{
	import org.flixel.*;
	[SWF(width="1040", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]
	
	public class FizixFighter extends FlxGame
	{
		public function FizixFighter()
		{
			super(1040,480,MenuState,1);
		}
	}
}
