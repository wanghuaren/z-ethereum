package ui.base.shejiao
{
	import com.greensock.TweenMax;
	
	import common.config.GameIni;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	
	import ui.frame.UIMovieClip;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.*;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import ui.frame.UIActMap;
	import ui.frame.UIWindow;
	import ui.base.mainStage.UI_index;
	import ui.base.zudui.ZuDui;
	import ui.base.npc.NpcShop;

	import ui.base.shejiao.haoyou.HaoYou;
	import ui.base.shejiao.zhenying.ZhenYing;

	/**
	 * 社交
	 * @author andy
	 * @date   2011-12-13
	 */
	public final class SheJiao extends UIWindow {

		private static var _instance:SheJiao;
		public static function getInstance():SheJiao{
			if(_instance==null)
				_instance=new SheJiao();
			return _instance;
		}
		
		public static function hasInstance():Boolean
		{
			return _instance==null?false:true;
		}
		
		public function SheJiao() {
			super(getLink("win_she_jiao"));
		}

		override protected function init():void {
			super.init();
			setPosition();
			Lang.addTip(mc["btnHaoYou"],"shejiao_haoyou");
			Lang.addTip(mc["btnZuDui"],"shejiao_zudui");

		}
		
		public function setPosition():void{
			if(SheJiao.getInstance().isOpen){
				var p:Point = new Point();
				p.x = UI_index.indexMC_mrb["mc_index_menu"]["btnSheJiao"].x;
				p.y = UI_index.indexMC_mrb["mc_index_menu"]["btnSheJiao"].y;
				p = UI_index.indexMC_mrb["mc_index_menu"].localToGlobal(p);
				this.x=p.x;
				this.y=p.y-mc.height-10;
				p = null;
			}
		}

		override public function mcHandler(target:Object):void {
			switch(target.name) {
				case "btnHaoYou":
					//好友
					HaoYou.getInstance().open(true);
					break;
				case "btnZuDui":
					//组队
					ZuDui.instance.open(true);
					break;
				case "btnBangPai":
					//帮派
					break;
				case "btnZhenYing":
					//阵营
//					ZhenYing.instance().open(true);
					break;

			}
			flash.utils.setTimeout(winClose,500);
		}
	}
}
