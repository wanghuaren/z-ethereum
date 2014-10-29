package com.bellaxu.util
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.ui.ContextMenu;

	/**
	 * 舞台通用方法
	 * @author BellaXu
	 * Created on 2014.4.27
	 */
	public final class StageUtil
	{
		public static var stage:Stage = null;
		
		/**
		 * 舞台宽
		 */
		public static function get stageWidth():uint
		{
			return stage.stageWidth;
		}
		
		/**
		 * 舞台高
		 */
		public static function get stageHeight():uint
		{
			return stage.stageHeight;
		}
		
		public static function set frameRate(value:uint):void
		{
			stage.frameRate = value;
		}
		
		/**
		 * 帧频
		 */
		public static function get frameRate():uint
		{
			return stage.frameRate;
		}
		
		/**
		 * 舞台鼠标X坐标
		 */
		public static function get mouseX():int
		{
			return stage.mouseX;
		}
		
		/**
		 * 舞台鼠标Y坐标
		 */
		public static function get mouseY():int
		{
			return stage.mouseY;
		}
		
		/**
		 * 获取舞台焦点
		 */
		public static function get focus():InteractiveObject
		{
			return stage.focus;
		}
		
		/**
		 * 设置焦点
		 */
		public static function set focus(value:InteractiveObject):void
		{
			if(!value)
			{
				stage.focus = stage;
				return;
			}
			stage.focus = value;
		}
		
		/**
		 * 注册监听
		 */
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			removeEventListener(type, listener);
			stage.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * 移除监听
		 */
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			stage.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * 派stage事件
		 */
		public static function dispatchEvent(event:Event):void
		{
			stage.dispatchEvent(event);
		}
		
		public static function getChildByName(name:String):DisplayObject
		{
			return stage.getChildByName(name);
		}
		
		/**
		 * 同stage.addChild(child)
		 */
		public static function addChild(child:DisplayObject):DisplayObject
		{
			return stage.addChild(child);
		}
		
		/**
		 * 同stage.addChildAt(child，index)
		 */
		public static function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return stage.addChildAt(child, index);
		}
		
		/**
		 * 同stage.removeChild(child)
		 */
		public static function removeChild(child:DisplayObject):DisplayObject
		{
			return stage.removeChild(child);
		}
		
		/**
		 * 同stage.removeChildAt(index)
		 */
		public static function removeChildAt(index:int):DisplayObject
		{
			return stage.removeChildAt(index);
		}
		
		/**
		 * 同stage.contains(child)
		 */
		public static function contains(child:DisplayObject):Boolean
		{
			return stage.contains(child);
		}
		
		/**
		 * 同stage.numChildren
		 */
		public static function get numChildren():uint
		{
			return stage.numChildren;
		}
	}
}