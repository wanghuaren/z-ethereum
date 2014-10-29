package common.utils {

	import common.config.PubData;
	/**
	 * @author wanghuaren
	 */
	public final class CtrlFactory {
		//控制界面显示
		private static var uiShow:UIShow=null;
		//控制界面逻辑
		private static var uiCtrl:UICtrl=null;
		
		
		/*
		 * 主要控制界面显示
		 */
		public static function getUIShow():UIShow {
			if(uiShow==null) {
				uiShow=new UIShow();
			}
			return uiShow;
		}

		/*
		 * 主要控制界面逻辑
		 */
		public static function getUICtrl():UICtrl {
			if(uiCtrl==null) {
				uiCtrl=new UICtrl();
			}
			return uiCtrl;
		}

		

	

		
	}
}
