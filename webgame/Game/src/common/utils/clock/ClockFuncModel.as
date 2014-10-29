package common.utils.clock
{
	import common.support.IClock;	
	import common.support.IClock;
	
	public class ClockFuncModel implements IClock
	{
		private var _type:String;
		
		private var _fFunc:Function;		
				
		private var _fDeleteTag:Boolean;
		
		public function ClockFuncModel(yoursType:String,yoursFunc:Function)
		{
			_type = yoursType;
			
			if(null == yoursFunc)
			{
				throw new Error("yoursFunc function reference address is null?");
			}
			
			_fFunc = yoursFunc;
						
			_fDeleteTag = false;
		}
		
		public function GetType():String
		{
			return _type;
		}
		
		public function GetFunc():Function
		{
			return _fFunc;
		}		
		
		public function GetDeleteTag():Boolean
		{
			return _fDeleteTag;
		}
		
		public function SetDeleteTag(value:Boolean):void
		{
			_fDeleteTag = value;
		}
		
		public function Destory():void
		{
			_type = null;
			_fFunc = null;
			_fDeleteTag = true;
			
		}
		
	}
}