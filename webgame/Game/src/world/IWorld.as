package world
{
	import flash.display.DisplayObject;

	public interface IWorld
	{
		/**
		 * 初始化部分，涉及缓存
		 */
		function init():void;
		/**
		 * 显示部分
		 * 底板
		 */
		function addChild(child:DisplayObject):DisplayObject;
		/**
		 * 全局从标
		 */
		function get mapx():Number;
		function get mapy():Number;
		function get svr_stop_mapx():Number;
		function get svr_stop_mapy():Number;
		/**
		 * 相对坐标，同时也是显示坐标
		 */
		function get x():Number;
		function get y():Number;
		function set x(value:Number):void;
		function set y(value:Number):void;
		function get depthPri():int;
		function set depthPri(value:int):void;
		function get visible():Boolean
		function set visible(value:Boolean):void
		function get mouseChildren():Boolean
		function set mouseChildren(value:Boolean):void
		function get mouseEnabled():Boolean
		function set mouseEnabled(value:Boolean):void
		function DelHitArea():void;
		function UpdHitArea():void;
		function set name(names:String):void;
		function get name():String;
		function set name2(names:String):void;
		function get name2():String;
	}
}
