package ui.layout
{
	/**
	 * 打开Fla，修改->文档 
	 * 这里指的是这些属性
	 * 
	 * 尺寸 ___  
	 *
	 */ 
	public class FlaDocumentSetting
	{		
		/**
		 * 修改->文档 尺寸
		 */ 
		private var _Width:int;		
		
		/**
		 * 修改->文档 尺寸
		 */ 
		private var _Height:int;				
		
		/**
		 * LoadBar元件宽
		 */ 
		private var _LoadBarWidth:int;
		private var _LoadBarWidthOffest:int;
		
		/**
		 * LoadBar元件高
		 */ 
		private var _LoadBarHeight:int;
		private var _LoadBarHeightOffest:int;
		
		public function FlaDocumentSetting(w:int,h:int,barW:int,barH:int,barWOffest:int,barHOffest:int)
		{
			_Width = w;
			_Height = h;
			
			_LoadBarWidth = barW;
			_LoadBarHeight = barH;
			
			_LoadBarWidthOffest = barWOffest;
			_LoadBarHeightOffest = barHOffest;
			
		}
		
		

		/**
		 * 修改->文档 尺寸
		 */ 
		public function get Width_():int
		{
			return _Width;
		}
		
		/**
		 * 修改->文档 尺寸
		 */ 
		public function get Height_():int
		{		
			return _Height;			
		}
		
		/**
		 * LoadBar元件宽
		 */ 
		public function get LoadBarWidth_():int
		{
			return _LoadBarWidth;
		}
		
		/**
		 * LoadBar元件高
		 */
		public function get LoadBarHeight_():int
		{
			return _LoadBarHeight;
		}
		
		public function get LoadBarHeightOffest_():int
		{
			return _LoadBarHeightOffest;
		}
		
		public function get LoadBarWidthOffest_():int
		{
			return _LoadBarWidthOffest;
		}
		
	}
}