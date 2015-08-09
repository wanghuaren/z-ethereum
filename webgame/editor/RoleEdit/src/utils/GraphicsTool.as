package utils
{
	import com.bommie.def.ResDef;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;

	public class GraphicsTool
	{
		private static var _instance:GraphicsTool;

		public static function get instance():GraphicsTool
		{
			if (_instance == null)
				_instance=new GraphicsTool();
			return _instance;
		}

		private var _aureole:Image;

		public function get aureole():Image
		{
			if (_aureole == null)
			{
				_aureole=getball();
			}
			return _aureole;
		}
		private var _roleHitBall:Sprite;

		public function get roleHitBall():Sprite
		{
			if (_roleHitBall == null)
			{
				_roleHitBall=new Sprite
				_roleHitBall.addChild(getball());
				var txtHP:TextField=new TextField(0,0,"99999/99999");
				roleHitBall.addChild(txtHP);
				roleHitBall.touchGroup=true;
				txtHP.height=24;
				txtHP.width=txtHP.textBounds.width;
				txtHP.x=-txtHP.width/ 2;
				txtHP.y=10;
			}
			return _roleHitBall;
		}

		private function getball():Image
		{
			var m_sprite:Image=new Image(Texture.fromColor(10, 10, 0xffff0000));
			return m_sprite;
		}
	}
}
