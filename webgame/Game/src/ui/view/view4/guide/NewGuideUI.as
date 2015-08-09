package ui.view.view4.guide
{
	import common.config.GameIni;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import ui.frame.ImageUtils;
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;


	/**
	 * 新手引导UI显示 。 一种固定功能介绍的UI指引，游戏过程中第一次打开该功能窗口的时候触发。
	 * @author steven guo
	 *
	 */
	public class NewGuideUI extends UIWindow
	{
		private　var icon_name:String;
		private static var m_instance:NewGuideUI;

		public function NewGuideUI(DO:DisplayObject=null, arrayData:Object=null, layer:int=1, addLayer:Boolean=true)
		{
			super(getLink("win_guest_guide"));
		}

		override protected function init():void
		{
			super.init();
			try
			{
				mc["btnClose"].visible=false;
			}
			catch (e:Error)
			{
				trace("NewGuideUI 严重错误!!!!!" + e.message);
			}
			replace();
		}

		public static function getInstance():NewGuideUI
		{
			UIMovieClip.currentObjName=null;
			if (null == m_instance)
			{
				m_instance=new NewGuideUI();

			}

			return m_instance;
		}

		override public function open(must:Boolean=false, type:Boolean=true):void
		{
			super.open(must, type);

		}

		/**
		 * 更改UI的编号
		 * @param filename  UI 需要加载的图片名字
		 *
		 */
		public function setUI(filename:String):void
		{
			if (null != mc && null != mc["uil"])
			{
				icon_name=filename;
//				mc["uil"].source=GameIni.GAMESERVERS + "pubres/guide/" + filename + ".jpg";
				ImageUtils.replaceImage(mc,mc["uil"],GameIni.GAMESERVERS + "pubres/guide/" + filename + ".jpg");
			}
		}

		override public function winClose():void
		{
			super.winClose();
			switch(icon_name){
				case "yunlong":
			
					break;
			}
		}


		private var m_gPoint:Point; //全局坐标
		private var m_lPoint:Point; //本地坐标

		private function replace():void
		{

			if (null == m_gPoint)
			{
				m_gPoint=new Point();

			}

			if (null == m_lPoint)
			{
				m_lPoint=new Point();
			}

			if (null != this && null != this.parent && null != this.stage)
			{
				m_gPoint.x=10;
				m_gPoint.y=(this.stage.stageHeight - this.height) >> 1;

				m_lPoint=this.parent.globalToLocal(m_gPoint);

				this.x=m_lPoint.x;
				this.y=m_lPoint.y;
			}


		}
	}
}



