package ui.view.view2.NewMap
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_NpcResModel;
	import common.config.xmlres.server.Pub_SeekResModel;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TextEvent;
	
	import common.config.GameIni;
	
	import engine.load.GamelibS;
	
	import netc.Data;
	
	import engine.support.IPacket;
	import nets.packets.PacketCSAutoSeek;
	import nets.packets.PacketCSNpcSeek;
	import nets.packets.PacketSCNpcSeek;
	
	import scene.action.PathAction;
	import scene.event.KingActionEnum;
	import scene.event.MapDataEvent;
	import scene.gprs.GameSceneGprs;
	import scene.manager.SceneManager;
	import scene.utils.MapData;
	
	import ui.view.UIMessage;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.base.renwu.Renwu;

	/**
	 * npc寻路
	 * @author suhang 
	 * @2011－10－28
	 * @2011-01-18 andy 修改
	 */
	public class GameAutoPath 
	{
		private static var _instance:GameAutoPath;
		public static function getInstance():GameAutoPath{
			if(_instance==null)
				_instance=new GameAutoPath();
			return _instance;
		}
		
		public function GameAutoPath()
		{

		}
		
		
		
		
		/**
		 * 自动寻路
		 * @param seek_id 寻路id
		 */
		public static function seek(seek_id:int):void{
		var te:TextEvent=new TextEvent(TextEvent.LINK);
			te.text="1@"+seek_id;
			Renwu.textLinkListener_(te);
		}
		/**
		 *	点击传 andy 2012-09-09
		 *  @param seek_id 
		 */
		public static function chuan(seek_id:int):void{
			var te:TextEvent=new TextEvent(TextEvent.LINK);
			te.text="2@"+seek_id;
			Renwu.textLinkListener_(te);
		} 
	}
}