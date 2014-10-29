package ui.layout
{
	public class LoadXJpgInfo
	{
		private var _Width:int;		
		
		private var _Height:int;				
		
		public function LoadXJpgInfo(w:int,h:int)
		{
			_Width = w;
			_Height = h;
		}
		
		public function get Width_():int
		{
			return _Width;
		}
		
		public function get Height_():int
		{		
			return _Height;			
		}
		
	}
}