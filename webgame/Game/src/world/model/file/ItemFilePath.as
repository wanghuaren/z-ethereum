package world.model.file
{
	public class ItemFilePath
	{
		/**
		 * .swf相对路径
		 * .xml相对路径
		 */ 
		public var swf_path0:String;
		public var xml_path0:String;
		
		public function ItemFilePath(s0:String="",x0:String="")
		{
			this.swf_path0 = s0;
			this.xml_path0 = x0;
			
		}
		
		/**
		 * 比较差异，决定是否重新加载
		 */ 
		public function compare(fresh:ItemFilePath):Array
		{
			var path_0_changed:Boolean = false;
		
			
			if(this.swf_path0  != fresh.swf_path0 ||
				this.xml_path0 != fresh.xml_path0)
			{
				path_0_changed = true;
				
			}			
			
			return [path_0_changed];
			
		}
		
		public function clone():ItemFilePath
		{
			return new ItemFilePath(swf_path0,xml_path0);
		}
		
	}
}