package com.bellaxu.mgr
{
	import com.bellaxu.def.CursorDef;
	import com.bellaxu.def.ResPathDef;
	import com.bellaxu.res.ResTool;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;
	
	import scene.manager.MouseManager;

	/**
	 * 鼠标管理
	 * @author BellaXu
	 */
	public class CursorMgr
	{
		public static function init():void
		{
			registCursor(CursorDef.CHAT, 4); //对话
			registCursor(CursorDef.PICKUP, 2); //采集
			registCursor(CursorDef.DONATE); //捐献
			registCursor(CursorDef.DESTROY); //销毁
			registCursor(CursorDef.SPLIT); //拆分
			registCursor(CursorDef.BUY); //购买
			registCursor(CursorDef.ATTACK); //攻击
			registCursor(CursorDef.BATCH); //批量
			registCursor(CursorDef.SELL); //卖出
		}
		
		private static function registCursor(type:String, bmdLength:int = 0):void
		{
			var m_CursorData:MouseCursorData = new MouseCursorData();
			var data:Vector.<BitmapData> = new <BitmapData>[];
			if(bmdLength == 0)
			{
				data.push(ResTool.getBmd(ResPathDef.GAME_CORE, type));
			}
			else
			{
				for(var i:int = 0;i < bmdLength;i++)
				{
					data.push(ResTool.getBmd(ResPathDef.GAME_CORE, type + i));
				}
			}
			m_CursorData.data = data;
			m_CursorData.frameRate = data.length;
			m_CursorData.hotSpot = new Point(0, 0);
			Mouse.registerCursor(type, m_CursorData);
		}

		public static function set currentCursor(value:String):void
		{
			if (Mouse.cursor == value)
				return;
			//项目转换修改 Mouse.cursor = value == CursorDef.DEFAULT ? MouseCursor.AUTO : value;
			MouseManager.instance.currentCursor= (value == CursorDef.DEFAULT ? MouseCursor.AUTO : value);
		}
		
		public static function get currentCursor():String
		{
			return Mouse.cursor == MouseCursor.AUTO ? CursorDef.DEFAULT : Mouse.cursor;
		}
	}
}
