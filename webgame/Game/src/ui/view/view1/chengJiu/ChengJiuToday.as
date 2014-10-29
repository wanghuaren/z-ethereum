package ui.view.view1.chengJiu
{
	import ui.frame.UIWindow;
	
	import display.components.ScrollContent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import common.utils.CtrlFactory;
	
	//import world.WorldExportClassStr;

	public class ChengJiuToday extends UIWindow
	{
		//public const default_view_name:String = "窗体_成就与称号";
		public const default_item_render:String ="窗体_成就与称号_项";
		
		//public const default_item_render:String =WorldExportClassStr.ItemRender_AchievementAndRoleTitle;
		public const default_sub_view_name:String = "窗体_成就与称号_子窗体_今日成就";	
		//public const default_sub_view_name:String = WorldExportClassStr.Win_AchievementAndRoleTitle_SubView_TodayComplete;	
		
		
		// 视图对象
		public var view:Sprite;
		
		public var default_sub_view:Sprite;
		
		public var default_sub_view_spMC:Sprite;
		
		public function ChengJiuToday()
		{
			super(getLink(default_sub_view_name));
			
			default_sub_view = view=this.mc;			
			dfsdfdfds
		}
		
		public function setDataAndShowList(eDataSub:Array):void
		{
			
			CtrlFactory.getUICtrl().clearMC(default_sub_view_spMC);			
			
			default_sub_view_spMC=new Sprite();
			
			//
			CtrlFactory.getUIShow().showList(default_sub_view_spMC,getClass(default_item_render),eDataSub,pageSize,new Point(0,0),1,null,null,itemEvent);
			
			
			//
			(default_sub_view["sp"] as ScrollContent).source=default_sub_view_spMC;
		
		}
		
		override protected function itemEvent(sprite : Sprite,itemData : Object = null) : void {
			//条目事件
			if(sprite == null) return;
			sprite.mouseChildren = false;
			sprite.buttonMode = true;
			sprite.visible = true;
			sprite["data"] = itemData;
			sprite["selected"] = 0;
			
			//fux_chengJiu			
			if(sprite.hasOwnProperty("ar_state"))
			{
				(sprite["ar_state"] as MovieClip).gotoAndStop(sprite["data"]["ar_state"]);
				
			}			
			
			if(sprite.hasOwnProperty("bg")) {
				var num : int = sprite.numChildren;
				for(var i : int = 0;i < num;i++) {
					if(sprite.getChildAt(i).hasOwnProperty("mouseEnabled")) {
						((Object)(sprite.getChildAt(i))).mouseEnabled = false;
					}
				}
				sprite["bg"].gotoAndStop(1);
				sprite.addEventListener(MouseEvent.MOUSE_OVER, itemOverListener);
				sprite.addEventListener(MouseEvent.MOUSE_OUT, itemOutListener);
			}
			if(sprite.getChildByName("selectedMC") != null) {
				sprite.getChildByName("selectedMC").visible = false;
			}
			function itemOverListener(e : MouseEvent) : void {
				sprite["bg"].gotoAndStop(2);
			}
			function itemOutListener(e : MouseEvent) : void {
				if(sprite["selected"] == 0) {
					sprite["bg"].gotoAndStop(1);
				} else {
					sprite["bg"].gotoAndStop(3);
				}
			}
		}
	}
}