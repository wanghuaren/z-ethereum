package view.view4.qq
{
	import flash.display.DisplayObject;
	import flash.net.URLRequest;
	
	import model.qq.YellowDiamond;
	
	import utils.StringUtils;
	
	import view.UIWindow;
	import view.WindowName;
	
	/**
	 * 0011816: 黄钻回馈礼包活动－客户端 
	 * @author steven guo
	 * 
	 */	
	public class YellowTuiJianWindow extends UIWindow
	{
		private static var m_instance:YellowTuiJianWindow;
		
		private var m_model:YellowDiamond = null;
		
		private var m_url:String = "http://qzs.qq.com/qzone/mall/app/meteor/act/index.html?rid=211";
		
		public function YellowTuiJianWindow()
		{
			super(getLink(WindowName.win_huangzuan_tuijian));
			
			m_model = YellowDiamond.getInstance();
		}
		
		public static function getInstance():YellowTuiJianWindow
		{
			if (null == m_instance)
			{
				m_instance= new YellowTuiJianWindow();
			}
			
			return m_instance;
		}
		
		override public function mcHandler(target:Object):void 
		{
			super.mcHandler(target);
			var name:String = target.name;
			
			switch(name)
			{
				case "btn_LiJiLingQu":
					flash.net.navigateToURL(new URLRequest(m_url),"_blank");
					break;
				case "btnLingQu":
					var _key:String =  StringUtils.trim( mc['txt_duihuanma'].text );
					//叶俊 说，这里要弄个双倍的字符串！
					_key += _key;
					m_model.requestCSExchangeCDKey(_key);
					break;
				default:
					break;
			}
			
		}
		
		
	}
	
}










