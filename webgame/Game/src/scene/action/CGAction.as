package scene.action
{
	public class CGAction
	{
		private  var _cgBegin:Boolean;
		
		public function CGAction()
		{
			_cgBegin = false;
		}	
		
		public function get cgBegin():Boolean
		{
			return _cgBegin;
		}

		public function set cgBegin(value:Boolean):void
		{
			_cgBegin = value;
		}

	}
}