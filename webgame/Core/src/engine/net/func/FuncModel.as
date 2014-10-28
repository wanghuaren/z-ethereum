package engine.net.func
{
	import flash.events.FullScreenEvent;
	import engine.support.IFunc;

	public class FuncModel implements IFunc
	{
		private var _fId:int;
		
		

		private var _fFunc:Function;		
		
		private var _fDesc:String;
		
		private var _fDeleteTag:Boolean;
		
		public function FuncModel(yoursFId:int,yoursFunc:Function,yoursDesc:String)
		{
			_fId = yoursFId;
			
//			if(null == yoursFunc)
//			{
//				throw new Error("yoursFunc function reference address is null?");
//			}
			
			_fFunc = yoursFunc;
			
			_fDesc = yoursDesc;
			
			_fDeleteTag = false;
		}

		public function get Id():int
		{
			return _fId;
		}
		
		public function GetId():int
		{
			return _fId;
		}
		
		public function GetFunc():Function
		{
			return _fFunc;
		}
		
		public function GetDesc():String
		{
			return _fDesc;		
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
			_fId = 0;
			_fFunc = null;
			_fDesc = null;
			_fDeleteTag = true;
			
		}

	}
}