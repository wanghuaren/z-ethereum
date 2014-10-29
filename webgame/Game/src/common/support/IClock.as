package common.support
{
	public interface IClock
	{
		/**
		 * GetId
		 * 
		 */
		function GetType():String;
		
		function GetFunc():Function;
		
		function Destory():void;
		
		function GetDeleteTag():Boolean;
		
		function SetDeleteTag(value:Boolean):void;
	}
}