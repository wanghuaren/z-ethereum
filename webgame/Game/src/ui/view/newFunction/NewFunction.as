package ui.view.newFunction
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_Interface_ClewResModel;
	import common.utils.clock.GameClock;
	
	import engine.event.DispatchEvent;
	import engine.load.GamelibS;
	
	import fl.controls.Button;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	
	import scene.music.GameMusic;
	import scene.music.WaveURL;
	
	import ui.base.beibao.BeiBao;
	import ui.base.renwu.MissionMain;
	import ui.base.renwu.renwuEvent;
	import ui.frame.ImageUtils;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.FileManager;
	import world.WorldEvent;

	/**
	 *	功能开启
	 *  2013-06-24 andy
	 */
	public class NewFunction extends UIWindow
	{
		private var item:Pub_Interface_ClewResModel;

		public function NewFunction()
		{
			super(getLink(WindowName.win_can_use));
		}
		private static var _instance:NewFunction=null;

		public static function instance():NewFunction
		{
			if (null == _instance)
			{
				_instance=new NewFunction();
			}
			return _instance;
		}

		/**
		 *
		 */
		public function setData(v:Pub_Interface_ClewResModel):void
		{
			item=v;
			super.open();
		}

		// 面板初始化
		override protected function init():void
		{
			GameMusic.playWave(WaveURL.ui_new_function);
			super.init();
			if (item == null)
				return;
			mc["txt_desc"].text=item.para1;
//			mc["uil"].source=FileManager.instance.getFunIconById(item.res_id);
			ImageUtils.replaceImage(mc,mc["uil"],FileManager.instance.getFunIconById(item.res_id));
			GameClock.instance.addEventListener(WorldEvent.CLOCK_FIVE_SECOND, timerHandler);
		}

		private function timerHandler(te:TextEvent):void
		{
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, timerHandler);
			super.winClose();
		}

		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			switch (target.name)
			{
				case "":
					break;
			}
		}

		// 窗口关闭事件
		override protected function windowClose():void
		{
			super.windowClose();
			if (item.show_index >= 0 && item.show_index < 200)
			{
			}
			else if (item.show_index >= 200 && item.show_index < 300)
			{
				//只是预告，什么都不做
				playEffect();
			}
			mc["txt_desc"].text="";
			mc["uil"].unload();
		}

		private function playEffect():void
		{
			switch (item.ui_name)
			{
				case "win_booth": //开启摆摊功能
					break;
				//case "btn_jian_ding"://开启鉴定引导
				//break;
				case "btn_chong_xing": //开启冲星引导
					break;
				case "btn_chuan_cheng": //开启传承引导
					break;
				default:
					break;
			}
		}
	}
}
