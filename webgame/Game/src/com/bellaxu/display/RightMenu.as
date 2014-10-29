package com.bellaxu.display
{
	import com.bellaxu.data.GameData;
	import com.bellaxu.def.ResPathDef;
	import com.bellaxu.res.ResTool;
	import com.bellaxu.struct.RightMenuItem;
	import com.bellaxu.util.JsUtil;
	
	import flash.display.InteractiveObject;
	import flash.ui.ContextMenu;

	public class RightMenu
	{
		private static var cm:ContextMenu = new ContextMenu();
		
		public static function regist(target:InteractiveObject):void
		{
			target.contextMenu = cm;
			cm.hideBuiltInItems();
			var cms:RightMenuItem;
			var Menu:Array = [ 
				{name: "chongzhi", str: "充值", link: GameData.url_pay}, 
				{name: "guanwang", str: "官网", link: GameData.url_home}, 
				{name: "luntan", str: "论坛", link: GameData.url_bbs}];
			for each (var s:* in Menu)
			{
				cms = new RightMenuItem(s.str, s, onSelect, false, true, true);
				cm.customItems.push(cms.getContextMenuItem());
			}
			cms = new RightMenuItem("收藏", null, onSelect, false, false, true);
			cm.customItems.push(cms.getContextMenuItem());
			cms = new RightMenuItem("version:胜者为王" + ResTool.getVer(ResPathDef.TIME_DAT), null, null, false, false, true);
			cm.customItems.push(cms.getContextMenuItem());
		}
		
		private static function onSelect(MenuData:Object):void
		{
			if (MenuData.name.indexOf("shoucang") != -1)
				JsUtil.addFavorite();
			else if (MenuData.link != "")
				JsUtil.navigateTo(MenuData.link);
		}
	}
}