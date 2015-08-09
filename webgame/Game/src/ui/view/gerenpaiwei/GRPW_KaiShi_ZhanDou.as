package ui.view.gerenpaiwei
{
	import common.managers.Lang;
	
	import flash.display.DisplayObject;
	
	import netc.packets2.StructSHMatchInfo2;
	
	import ui.frame.ImageUtils;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.FileManager;
	
	public class GRPW_KaiShi_ZhanDou extends UIWindow
	{
		private static var m_instance:GRPW_KaiShi_ZhanDou;
		
		public function GRPW_KaiShi_ZhanDou()
		{
			//TODO: implement function
			super(getLink(WindowName.win_GRPW_KaiShi_ZhanDou));
			canDrag = false;
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		
		public static function getInstance():GRPW_KaiShi_ZhanDou
		{
			if (null == m_instance)
			{
				m_instance= new GRPW_KaiShi_ZhanDou();
			}
			return m_instance;
		}
		
		
		
		override protected function init():void 
		{
			super.init();
			mc.y = 60;
		}
		
		private static const DUI_WU_RENSHU:int = 5;
		public function setData(teamL:Vector.<StructSHMatchInfo2>,teamR:Vector.<StructSHMatchInfo2>):void
		{
			var i:int = 0; 
			
			for(i = 0 ; i < DUI_WU_RENSHU ; ++i)
			{
				if(mc==null)return;
				if(i>=teamL.length)
				{
					mc['L_item_'+i]['uil'].source = null;
					mc['L_name_'+i].text = "";
//					mc['L_level_'+i].text = "";
				}
				else
				{
//					mc['L_item_'+i]['uil'].source = FileManager.instance.getHeadIconXById(teamL[i].icon);
					ImageUtils.replaceImage(mc['L_item_'+i],mc['L_item_'+i]["uil"],FileManager.instance.getHeadIconXById(teamL[i].icon));
					mc['L_name_'+i].text = teamL[i].name;
//					mc['L_level_'+i].text = teamL[i].level+Lang.getLabel("pub_ji");
				}
			}
			
			for(i = 0 ; i < DUI_WU_RENSHU ; ++i)
			{
				if(i>=teamR.length)
				{
					mc['R_item_'+i]['uil'].source = null;
					mc['R_name_'+i].text = "";
//					mc['R_level_'+i].text = "";
				}
				else
				{
//					mc['R_item_'+i]['uil'].source = FileManager.instance.getHeadIconXById(teamR[i].icon);
					ImageUtils.replaceImage(mc['R_item_'+i],mc['R_item_'+i]["uil"],FileManager.instance.getHeadIconXById(teamL[i].icon));
					mc['R_name_'+i].text = teamR[i].name;
//					mc['R_level_'+i].text = teamR[i].level+Lang.getLabel("pub_ji");
				}
			}
		}
		
		
	}
	
	
	
}








