package engine.support
{
	public interface IFunc
	{
		/**
		 * GetId
		 * 
		 */
		function get Id():int;
		
		function GetId():int;
		
		function GetFunc():Function;
		
		function GetDesc():String;
		
		function Destory():void;
		
		function GetDeleteTag():Boolean;
		
		function SetDeleteTag(value:Boolean):void;
	}
}