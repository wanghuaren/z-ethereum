package ui.view.view4.qq
{
	import common.managers.Lang;
	
	import flash.net.URLRequest;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view1.ExchangeCDKey;
	import ui.view.view2.mrfl_qiandao.DuiHuanLiBao_CDKey;
	import ui.view.zhenbaoge.ZhenBaoGeWin;

	/**
	 *@author WangHuaren
	 *2014-6-6_上午11:52:54
	 **/
	public class QQEveryDayRaffle extends UIWindow
	{
		public function QQEveryDayRaffle()
		{
			super(getLink(WindowName.win_chou_jiang_song_li, "qq_yellow"));
		}
		private static var _instance:QQEveryDayRaffle=null;

		public static function get instance():QQEveryDayRaffle
		{
			if (_instance == null)
			{
				_instance=new QQEveryDayRaffle();
			}
			return _instance;
		}

		override protected function init():void
		{
			super.init();
		}

		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			switch (target.name)
			{
				case "act_desc":
					ZhenBaoGeWin.getInstance().open();
					break;
				case "btnExchange":
					ExchangeCDKey.instance.open(true);
					break;
				case "btnStart":
					flash.net.navigateToURL(new URLRequest(Lang.getLabel("QQ_Raffle_url")), "_blank");
					break;
			}
		}

		override public function open(must:Boolean=false, type:Boolean=true):void
		{
			super.open(must, type);
		}

		override public function winClose():void
		{
			super.winClose();
		}
	}
}
