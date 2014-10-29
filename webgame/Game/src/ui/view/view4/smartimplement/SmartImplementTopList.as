package ui.view.view4.smartimplement
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_AchievementResModel;
	import common.config.xmlres.server.Pub_Limit_TimesResModel;
	
	import engine.event.DispatchEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.packets2.PacketSCInstanceRank2;
	
	import nets.packets.PacketCSInstanceRank;
	import nets.packets.PacketSCInstanceRank;
	
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.component.ToolTip;
	
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.FileManager;
	import common.managers.Lang;
	
	/**
	 * 四神器排行
	 * @author Administrator
	 * 
	 */	
	public class SmartImplementTopList extends UIWindow
	{
		
		private static var _instance:SmartImplementTopList;			
		
		/**
		 * 	@param must 是否必须 
		 */
		public static function getInstance():SmartImplementTopList
		{
			if(_instance==null)
			{
				_instance=new SmartImplementTopList();
			}
			return _instance;
		}
		
		
		public function SmartImplementTopList()
		{			
//			super(getLink(WindowName.win_shenqi_list));
		}
		
		
		/** 
		 *副本标识,1表示四神器1,2表示四神器2,3表示四神器3,4表示四神器4,5表示魔天万界
		 */		                                   
		public  function get INSTANCE_ID():int
		{		
			return SmartImplementWindow.INSTANCE_ID;
		}
		
		//面板初始化
		override protected function init():void 
		{			
			//
			uiRegister(PacketSCInstanceRank.id,CInstanceRank);
			
		}		
		
		public function CInstanceRank(p:PacketSCInstanceRank2):void
		{		
			refresh();
		}
				
		public function refreshRank():void
		{			
			//
			var csIR:PacketCSInstanceRank = new PacketCSInstanceRank();
			csIR.instanceid = INSTANCE_ID;
			this.uiSend(csIR);
		}
		
		private function refresh():void
		{
			if(null == mc)
			{
				return;
			}
			
			mc["mc_title"].gotoAndStop(INSTANCE_ID);
			
			//if(2 == (this.mc as MovieClip).currentFrame)
			//{
			
			//
			mc["txtShenQiMyInd"].text = "";
			//mc["list_info"]["txtShenQiMyFen"].text = "";
			
			for(var j:int=1;j<=10;j++)
			{
				// txt_ind     vip txt_player   txt_camp   txt_fen
				(mc["sq_item" + j.toString()]["txt_ind"] as TextField).htmlText = "";//j.toString();
				
				(mc["sq_item" + j.toString()]["vip"] as MovieClip).gotoAndStop(1);
				(mc["sq_item" + j.toString()]["vip"] as MovieClip).visible = false;
				
				(mc["sq_item" + j.toString()]["txt_player"] as TextField).text = "";
				
				//(mc["list_info"]["sq_item" + j.toString()]["txt_camp"] as TextField).text = "";
				
				(mc["sq_item" + j.toString()]["txt_boci"] as TextField).text = "";
			}		
			
			
			//
			var list:Vector.<PacketSCInstanceRank2> = Data.moTian.getInstanceRankList();
			
			var len:int = list.length;
			
			
			for(i=0;i<len;i++)
			{
				if(list[i].instanceid == INSTANCE_ID)
				{
					
					
					//  如果玩家在50名以外，您当前的排名显示为  榜上无名
					if(list[i].index != 0 &&
						list[i].index < 50)
					{
						mc["txtShenQiMyInd"].text = list[i].index.toString();			
					}else
					{
						mc["txtShenQiMyInd"].text =Lang.getLabel("40062_bang_shang_wu_ming");
					}
					
					//mc["txtJinMaMyFen"].text = DataCenter.huoDong.myJiFen.getCurPointByActId(ACT_ID);
					
					//set
					for(var k:int=0;k<list[i].arrItemlist.length;k++)
					{
						var k_x:int = k+1;
						
						(mc["sq_item" + k_x.toString()]["txt_ind"] as TextField).htmlText = getColor(k_x,k_x.toString());
						
						//var k_vip:int = list[i].arrItemlist[k].vip;
						
						//if(0 == k_vip)
						//{
						//	(mc["Mo_item" + k_x.toString()]["vip"] as MovieClip).visible = false;
						//}
						//else
						//{
						//	(mc["Mo_item" + k_x.toString()]["vip"] as MovieClip).visible = true;
						//	(mc["Mo_item" + k_x.toString()]["vip"] as MovieClip).gotoAndStop(k_vip);
						//}
						
						(mc["sq_item" + k_x.toString()]["txt_player"] as TextField).htmlText = getColor(k_x,list[i].arrItemlist[k].rolename);
						
						//(mc["Mo_item" + k_x.toString()]["txt_camp"] as TextField).htmlText = getColor(k_x,list[i].arrItemlist[k].camp_name());
						
						(mc["sq_item" + k_x.toString()]["txt_boci"] as TextField).htmlText = getColor(k_x,list[i].arrItemlist[k].shenQi_BoCi.toString());
						
					}
					
					break;
				}
			}
			
			//}
			
		}

		
		/**
		 * 排行前三颜色
		 */ 
		private function getColor(k_x:int,k_content:String):String
		{
			if(1 == k_x)
			{
				return  "<b><font color='#FF9B10'>" +k_content + "</font></b>";
				
			}else if(2 == k_x)
			{
				return  "<b><font color='#F74AFD'>" + k_content + "</font></b>";
				
			}else if(3 == k_x)
			{
				return  "<b><font color='#0AA3D9'>" + k_content + "</font></b>";
				
			}else
			{
				return  k_content;
			}
			
			return "";
		}
		
		
		override public function getID():int
		{
			return 1046;
		}
		
	}
}