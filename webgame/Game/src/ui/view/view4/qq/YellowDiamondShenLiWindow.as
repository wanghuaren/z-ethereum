package ui.view.view4.qq
{
	import common.config.GameIni;
	import common.managers.Lang;
	import common.utils.AsToJs;
	
	import flash.display.DisplayObject;
	import flash.net.URLRequest;
	
	import model.qq.YellowDiamond;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	

	
	/**
	 * 黄钻神力 
	 * @author steven guo
	 * 
	 */	
	public class YellowDiamondShenLiWindow extends UIWindow
	{
		private static const url_yellowDiamond:String = "http://pay.qq.com/qzone/index.shtml?aid=game100666653.op";
		private static const url_yellowDiamondYear:String = "http://pay.qq.com/qzone/index.shtml?aid=game100666653.op&paytime=year";
		
		private static var m_instance:YellowDiamondShenLiWindow;
		
		private var m_model:YellowDiamond = null;
		
		public function YellowDiamondShenLiWindow()
		{
			var _url:String = null;
			
			if(GameIni.PF_3366 == GameIni.pf())
			{
				_url = WindowName.win_lan_zuan_ShenLi;
			}
			else
			{
				_url = WindowName.win_huang_zuan_ShenLi;
			}
			
			super(getLink(_url));
			
			m_model = YellowDiamond.getInstance();
		}
		
		public static function getInstance():YellowDiamondShenLiWindow
		{
			if (null == m_instance)
			{
				m_instance= new YellowDiamondShenLiWindow();
			}
			
			return m_instance;
		}
		
		
		override protected function init():void 
		{
			super.init();
			
			_repaint();
		}
		
		
		override public function winClose():void
		{
			super.winClose();
		}
		
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			
			var target_name:String = target.name;
			switch(target_name)
			{
				case "btnKTHZ":
					//flash.net.navigateToURL(new URLRequest(url_yellowDiamond),"_blank");
					AsToJs.callJS("openvip");
					break;
				case "btnXFHZ":
					//flash.net.navigateToURL(new URLRequest(url_yellowDiamond),"_blank");
					AsToJs.callJS("openvip");
					break;
				default:
					break;
			}
			
		}
		
		private function _repaint():void
		{
			var _arrLang:Array = Lang.getLabelArr("arrQQ_YD_ShenLi_ShuXing");
			
			var _length:int = _arrLang.length;
			if(_length > 5)
			{
				_length = 5;
			}
			
			for(var i:int = 0; i < _length ; ++i)
			{

				mc['tf_shuxing_'+i].htmlText = _arrLang[i];
			}
			
			var _desc:String =  Lang.getLabel("40081_QQ_YD_ShenLi_desc");

			mc['tf_desc'].htmlText =_desc;
		}
		
	}
	
	
}








