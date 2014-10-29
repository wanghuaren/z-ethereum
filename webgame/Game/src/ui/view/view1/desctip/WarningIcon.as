package ui.view.view1.desctip{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_Action_DescResModel;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import engine.load.GamelibS;
	
	import scene.event.MapDataEvent;
	import scene.manager.SceneManager;
	import scene.utils.MapData;
	
	import world.WorldEvent;

	/**
	 * @author sh
	 * 消息提示按钮
	 */
	//public class WarningIcon extends MovieClip{
	public final class WarningIcon extends Sprite{
		//邮件
//		public static var xinxi:int =1;
//		//奖励
//		public static var jiangli:int =2;
//		//感叹号
//		public static var caozuo:int =3;
		
		/**
		 *	参数 
		 */
		public var sn:Object;
		/**
		 *	信息类型 
		 *  1.邮件    打开提示框
		 *  2.奖励    打开提示框，直接执行回调函数
		 *  3.感叹号  打开提示框，点击确定执行回调行数，取消则不执行
		 *  4.感叹号  打开提示框
		 *  5.感叹号  过期物品
		 *  6.感叹号  打开指定面板
		 *  7.分享
		 *  11.交易
		 */
		public var leixing:int=1;
		/**
		 *	活动Id 
		 */
		public var action_id:int=0;
		private var _trig_del_Map:Boolean = false;
		
		/**
		 * 切换到指定地图则删除自已
		 */
		public function get trig_del_Map():Boolean
		{
			return _trig_del_Map;
		}

		/**
		 * @private
		 */
		public function set trig_del_Map(value:Boolean):void
		{		
			//
			_trig_del_Map = value;
			
			if(value)
			{
				SceneManager.RemoveEventListener(WorldEvent.MapDataComplete, _onMapDataComplete);
				SceneManager.AddEventListener(WorldEvent.MapDataComplete, _onMapDataComplete);
				
			}else
			{
				SceneManager.RemoveEventListener(WorldEvent.MapDataComplete, _onMapDataComplete);
			
			}
		}
		

		/**
		 *	回调函数 
		 */
		public var Func:Function =null;
		public var msg:String;
		private var instance:MovieClip =null;

		public function WarningIcon():void{
			instance=GamelibS.getswflink("game_index","WarningIcon") as MovieClip;
		
			if(instance==null)return;
				
			//instance.mouseEnabled = false;
			//instance.mouseChildren = false;
			instance.tabChildren = false;
			this.addChild(instance);
			
			
		}
		
		private function _onMapDataComplete(we:WorldEvent):void
		{
						if(trig_del_Map)
			{
				var pad:Pub_Action_DescResModel = XmlManager.localres.ActionDescXml.getResPath(this.action_id) as Pub_Action_DescResModel;
				
				if(null != pad &&
				   "" != pad.WarningIcon_trigDel_Map_Id)
				{
					var trigDelMapList:Array = pad.WarningIcon_trigDel_Map_Id.split(",");
						
					var curMap:String = SceneManager.instance.currentMapId.toString();
					
										
					var len:int = trigDelMapList.length;					
						
					for(var i:int=0;i<len;i++)
					{
						if(curMap == trigDelMapList[i])
						{
							if(null != this.parent)
							{
								this.parent.removeChild(this);
							}
								
							break;
						}
							
					}//end for
				}//end if
				
			}
		
		}

		public function setIcon(warningIcon:int):void{
			leixing = warningIcon;
			if(instance==null)return;
			instance.gotoAndStop(warningIcon);
		}
	}
}
