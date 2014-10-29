package ui.view.view7
{
	import flash.display.DisplayObject;
	
	import netc.Data;
	
	import scene.action.ColorAction;
	import scene.action.hangup.GamePlugIns;
	import scene.action.hangup.HangupModel;
	
	import ui.base.mainStage.UI_index;
	import ui.base.vip.ChongZhi;
	import ui.base.vip.Vip;
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	import ui.frame.WindowModelClose;
	import ui.view.pay.WinFirstPay;
	import ui.view.view1.doubleExp.DoubleExp;
	import ui.view.view1.guaji.GamePlugInsWindow;
	import ui.view.view1.guaji.Guaji;
	import ui.view.view4.yunying.ZhiZunVIP;
	import ui.view.view4.yunying.ZhiZunVIPMain;

	
	public class UI_BtnCharacter  extends UIWindow
	{
		
		private static var _instance:UI_BtnCharacter;
		
		public static function get instance():UI_BtnCharacter
		{
			return _instance;
		}
		
		public static function setInstance(value:UI_BtnCharacter):void
		{
			_instance = value;
		}
		
		public function UI_BtnCharacter(DO:DisplayObject)
		{
			
			UIMovieClip.currentObjName=null;
			
			super(DO, null, 1, false);
			
		}
		
		
		override public function mcHandler(target:Object):void
		{
			//
			var target_name:String = target.name;
			
			//
			//if(target_name.indexOf('instance') == 0)
			//{
			ColorAction.ResetMouseByBangPai();				
			//}
			
			
			switch (target_name)
			{					
			
				case "btnZhiZunVip":
					//2013-09-27 策划说充值接口开关，不影响至尊VIP
//					if(WindowModelClose.isOpen(WindowModelClose.IS_PAY))
						//ZhiZunVIPMain.getInstance().open();
						ZhiZunVIPMain.getInstance().setType(1);
//					else
//						Vip.getInstance().pay();
					break;
				case "mc_shenWu_icon":
					//首充
					WinFirstPay.instance.open();
					break;
				
				default:"";
			}
			
			
			UI_index.instance.mcHandler(target);
			
		}
		
		override public function closeByESC():Boolean
		{
			return false;
		}
		
		
		
	}
	
	
	
	
	
	
	
	
	
}