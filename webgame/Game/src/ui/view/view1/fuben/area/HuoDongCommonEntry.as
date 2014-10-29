/**
 * Copyright the company of XiHe, all rights reserved.
 */
package ui.view.view1.fuben.area
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_Action_DescResModel;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	
	import flash.display.MovieClip;
	
	import model.fuben.FuBenModel;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSOpenActTimeWaring;
	
	import ui.frame.ImageUtils;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view2.other.CBParam;
	
	import world.FileManager;
	
	/**
	 * @author liuaobo
	 * @create date 2013-7-30
	 */
	public class HuoDongCommonEntry extends UIWindow
	{
		public static var ActionId:int = 0;
		public static var HongHuangLianYu_ActionId:int=0;
		public static var GroupId:int = -1;
		private static var _instance:HuoDongCommonEntry = null;
		
		public static function getInstance():HuoDongCommonEntry{
			if (_instance == null){
				_instance = new HuoDongCommonEntry();
			}
			return _instance;
		}
		
		public function HuoDongCommonEntry()
		{
			super(getLink(WindowName.win_bang_pai_zhan));
		}
		
		//
		private var m:Pub_Action_DescResModel;
		
		override protected function init():void{
			super.init();
			var len:int = 5;
			var mcItem:MovieClip;
			m = XmlManager.localres.ActionDescXml.getResPath2(GroupId) as Pub_Action_DescResModel;
			if(m==null)
				return;
//			mc["uil"].source = FileManager.instance.getActionEntryIconById(m.res_id);
			ImageUtils.replaceImage(mc,mc["uil"],FileManager.instance.getActionEntryIconById(m.res_id));
			mc["tDesc"].htmlText = m.action_desc;
			if (GroupId == CBParam.BangPaiMiGong_ACTION_GROUP){
				mc["tCost"].htmlText = Lang.getLabel("20412_BangPaiMiGong_Cost");
			}else{
				mc["tCost"].htmlText = "";
			}
			var dropList:Vector.<Pub_DropResModel> = XmlManager.localres.getDropXml.getResPath2(m.show_prize) as Vector.<Pub_DropResModel>;
			var dataLen:int = dropList.length;
			var drop:Pub_DropResModel = null;
			var cell:StructBagCell2 = null;
			for (var i:int = 0;i<len;i++){
				mcItem = mc["pic"+i];
				if (i<dataLen){
					drop = dropList[i];
					cell = new StructBagCell2();
					cell.itemid = drop.drop_item_id;
					cell.num = drop.drop_num;
					Data.beiBao.fillCahceData(cell);
//					mcItem["uil"].source = cell.icon;
					ImageUtils.replaceImage(mcItem,mcItem["uil"],cell.icon);
					mcItem["r_num"].text = cell.num.toString();
					mcItem["mc_color"].gotoAndStop(cell.toolColor == 0 ? 1 : cell.toolColor);
					mcItem["data"] = cell;
					var mc_effect:MovieClip=mcItem["mc_color"].getChildByName("mc_effect") as MovieClip;
					if(mc_effect!=null){
						mc_effect.visible=cell.effect==1;
					}
					CtrlFactory.getUIShow().addTip(mcItem);
				}else{
					mcItem["data"] = null;
					mcItem.visible = false;
					CtrlFactory.getUIShow().removeTip(mcItem);
				}
			}
		}
		
		override public function mcHandler(target:Object):void{
			var target_name:String = target.name;
			switch(target_name)
			{
				case "btnJoin":
				{
					//TODO enter fb 
					this.handleActionJoin();
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
		private function handleActionJoin():void{
			switch(GroupId)
			{
				case CBParam.PKKing_ACTION_GROUP://PK之王
				{
					FuBenModel.getInstance().requestEnterPKKing();
					break;
				}
				case CBParam.BaoWeiHuangCheng_ACTION_GROUP://保卫皇城
				{
					var value:PacketCSOpenActTimeWaring = new PacketCSOpenActTimeWaring();
					value.act_id = m.action_id;
					value.seek_id = m.action_para1;
					uiSend(value); 
					break;
				}
				case CBParam.MonsterAttackCity_ACTION_GROUP:
				{	
					var value:PacketCSOpenActTimeWaring = new PacketCSOpenActTimeWaring();
					value.act_id = m.action_id;
					value.seek_id = m.action_para1;
					uiSend(value); 
					break;
				}	
				case CBParam.MonsterAttackCity1_ACTION_GROUP:
				{	
					var value:PacketCSOpenActTimeWaring = new PacketCSOpenActTimeWaring();
					value.act_id = m.action_id;
					value.seek_id = m.action_para1;
					uiSend(value); 
					break;
				}	
				case CBParam.HongHuangLianYu_ACTION_GROUP:
				{
					var value:PacketCSOpenActTimeWaring = new PacketCSOpenActTimeWaring();
					
					if(0 == HongHuangLianYu_ActionId){
						value.act_id = m.action_id;
					}
					else
					{
						value.act_id = HongHuangLianYu_ActionId;
					}
					
					value.seek_id = m.action_para1;
					uiSend(value);
					break;
				}
				case CBParam.MoBaiChengZhu_ACTION_GROUP:
				{
					var value:PacketCSOpenActTimeWaring = new PacketCSOpenActTimeWaring();
					
					if(0 == ActionId){
						value.act_id = m.action_id;
					}else
					{
						value.act_id = ActionId;
					}
					value.seek_id = m.action_para1;
					uiSend(value); 
					
					break;
				}
				case CBParam.HuangChengZhiZun_ACTION_GROUP://皇城至尊
				{
					//FuBenModel.getInstance().requestEnterYaoSaiZhengDuo(20100004);
//					var te:TextEvent=new TextEvent(TextEvent.LINK);
//					te.text="2@" + m.action_para1;
//					Renwu.textLinkListener_(te,false);
					
					var value:PacketCSOpenActTimeWaring = new PacketCSOpenActTimeWaring();
					value.act_id = m.action_id;
					value.seek_id = m.action_para1;
					uiSend(value); 
					
					break;
				}
				case CBParam.YaoSai_ACTION_GROUP://要塞争夺
				{
					FuBenModel.getInstance().requestEnterYaoSaiZhengDuo();
					
					break;
				}
				case CBParam.BangPaiZhan_ACTION_GROUP://帮派战
				{
					FuBenModel.getInstance().requestEnterBangPaiZhan(80005)
					break;
				}
				case CBParam.BangPaiMiGong_ACTION_GROUP://帮派迷宫
				{
					FuBenModel.getInstance().requestEnterBangPaiMiGong(80004);
					break;
				}
				case CBParam.TianMenZhen_ACTION_GROUP://天门阵
				{
					
					break;
				}
				case CBParam.PKKing_ACTION_GROUP://PK之王
				{
					
					break;
				}
				case CBParam.PKKing_ACTION_GROUP://PK之王
				{
					
					break;
				}
				case CBParam.BaZhuShengJian_ACTION_GROUP:
				{
										
//					var te:TextEvent=new TextEvent(TextEvent.LINK);
//					te.text="2@" + m.action_para1;
//					Renwu.textLinkListener_(te,false);
					
					var value:PacketCSOpenActTimeWaring = new PacketCSOpenActTimeWaring();
					value.act_id = m.action_id;
					value.seek_id = m.action_para1;
					uiSend(value);
					
					break;
				}
				case CBParam.JueZhanZhanChang_ACTION_GROUP:
				{
					
//					var te:TextEvent=new TextEvent(TextEvent.LINK);
//					te.text="2@" + m.action_para1;
//					Renwu.textLinkListener_(te,false);
					
					var value:PacketCSOpenActTimeWaring = new PacketCSOpenActTimeWaring();
					value.act_id = m.action_id;
					value.seek_id = m.action_para1;
					uiSend(value);
					
					
					
					break;
				}
				case CBParam.ShenLongTuTeng_ACTION_GROUP:
				{
					
					var value:PacketCSOpenActTimeWaring = new PacketCSOpenActTimeWaring();
					value.act_id = m.action_id;
					value.seek_id = m.action_para1;
					uiSend(value);
					break;
				}
				default:
				{
					break;
				}
					
				
			}
			
			this.winClose();
		}
		
	}
}