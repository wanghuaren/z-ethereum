package ui.base.vip
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_SkillResModel;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	
	import engine.event.DispatchEvent;
	
	import flash.net.*;
	
	import netc.Data;
	import netc.dataset.MyCharacterSet;
	
	import nets.packets.PacketSCGetGift;
	
	import ui.frame.ImageUtils;
	import ui.frame.UIWindow;
	
	import world.FileManager;
	
	
	public class VipPet extends UIWindow 
	{
		private static var _instance:VipPet;
		
		public static function getInstance():VipPet{
			if(_instance==null)
				_instance=new VipPet();
			return _instance;
		}
		
		public function VipPet()
		{
			super(getLink("win_vip_pet"));
		}
		
		override protected function init():void 
		{
			super.init();
			
			sysAddEvent(Data.myKing, MyCharacterSet.VIP_UPDATE, vipUp);			
			sysAddEvent(Data.myKing, MyCharacterSet.GIFT_UPD, giftUpd);		
			
			//sysAddEvent(Data.huoBan, HuoBanSet.COUNT_UPDATE_PET,countUpd);
			
			
			this.uiRegister(PacketSCGetGift.id,scGetGift);
			
			refreshContent();			
		}
		
		public function scGetGift(p:PacketSCGetGift):void
		{
			
			if (super.showResult(p))
			{
				
			}
			else
			{
				
			}
			
		}
		
		//30200010	鬼将	
		//30200011	龙女	
		//30200007	大鹏明王
		
		//现在龙女被要求删除
		public static function getPetList():Array
		{
			
			return  null;
		
		}
		
		public function refreshContent():void
		{
			//技能Tips
			//curPetId=HuoBanSet.PET_ID_START + type;
			
			
			
			var petList:Array = VipPet.getPetList();
						
			var skillList:Array = [
			
				//mc["mc_skill6"],
				mc["mc_skill8"],
				mc["mc_skill9"]
				
			];
			
			var jLen:int = skillList.length;
			for(var j:int=0;j<jLen;j++)
			{
				var arrSkill:Array=XmlManager.localres.getPetSkillXml.getResPath2(petList[j]) as Array;
				
				if(arrSkill != null && 
					arrSkill.length >= 4)
				{
					var skillRes:Pub_SkillResModel=XmlManager.localres.getSkillXml.getResPath(arrSkill[3].skill_id) as Pub_SkillResModel;
					
					if(skillRes!=null){
						//mc["mc_skill"].data=skillRes;
						//mc["mc_skill"].task_id=0;					
						
						skillList[j].data=skillRes;
						skillList[j].task_id=0;
						
						var icon:String=FileManager.instance.getSkillIconSById(skillRes.icon);
						//mc["mc_skill"]["uil"].source=icon;
						//CtrlFactory.getUIShow().addTip(mc["mc_skill"]);
						
//						skillList[j]["uil"].source=icon;
						ImageUtils.replaceImage(skillList[j],skillList[j]["uil"],icon);
						CtrlFactory.getUIShow().addTip(skillList[j]);
						
					}
				
				}
			}
			
			
			//
			var my_vip:int = Data.myKing.Vip;
			
			if(my_vip >= 9)
			{
				//mc["btnVipTo6"].visible = false;
				mc["btnVipTo8"].visible = false;
				mc["btnVipTo9"].visible = false;
				
			}else if(my_vip >= 8 && my_vip < 9)
			{
				//mc["btnVipTo6"].visible = false;
				mc["btnVipTo8"].visible = false;
				mc["btnVipTo9"].visible = true;
				
			}else if(my_vip >= 6 && my_vip < 8)
			{
				//mc["btnVipTo6"].visible = false;
				mc["btnVipTo8"].visible = true;
				mc["btnVipTo9"].visible = true;
				
			}else
			{
				//mc["btnVipTo6"].visible = true;
				mc["btnVipTo8"].visible = true;
				mc["btnVipTo9"].visible = true;
				
			}
			
			//--------------------------------------------------------------------------
			
			//var value:int = DataCenter.myKing.GiftStatus;
			
			//扩展礼包
			//var vip_list:Array = BitUtil.convertToBinaryArr(value);
			
			//var vip6_arrShenJiang:int = vip_list[16+6-1];
			//var vip8_arrShenJiang:int = vip_list[16+8-1];
			//var vip9_arrShenJiang:int = vip_list[16+9-1];
			
			//var vip6_arrShenJiang:int = 0;
			var vip8_arrShenJiang:int = 0;
			var vip9_arrShenJiang:int = 0;
		
			//获得当前伙伴数据
			//var petData0:PacketSCPetData2 =DataCenter.huoBan.getPetById(petList[0]);
			//var petData1:PacketSCPetData2 =Data.huoBan.getPetById(petList[0]);//1]);
			//var petData2:PacketSCPetData2 =Data.huoBan.getPetById(petList[1]);//2]);
			
			//if (null != petData0 && 1 == petData0.PetState){	}else{vip6_arrShenJiang = 1;}
			//if (null != petData1 && 1 == petData1.PetState){	}else{vip8_arrShenJiang = 1;}
			//if (null != petData2 && 1 == petData2.PetState){	}else{vip9_arrShenJiang = 1;}
			
			var isCanLin:Boolean = false;
			
			//可领且未领
			//if(1 == vip6_arrShenJiang)
			//{
			//	
			//	StringUtils.setEnable(mc["btnVipLq6"]);
				
			//}else
			//{
			//	StringUtils.setUnEnable(mc["btnVipLq6"]);
				
			//}
			
			//可领且未领
			if(1 == vip8_arrShenJiang)
			{
				
				//isCanLin = true;
				StringUtils.setEnable(mc["btnVipLq8"]);
				
			}else
			{
				StringUtils.setUnEnable(mc["btnVipLq8"]);
				
			}
			
			//
			//可领且未领
			if(1 == vip9_arrShenJiang)
			{
				
				//isCanLin = true;
				
				StringUtils.setEnable(mc["btnVipLq9"]);
				
			}else
			{
				StringUtils.setUnEnable(mc["btnVipLq9"]);
				
			}			
			
			
		}
		
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			//reset			
			
			super.mcHandler(target);
			
			var target_name:String = target.name;
			var target_parent_name:String;
			
			switch (target_name)
			{				
				//case "btnVipTo6":			
				//	Vip.getInstance().vipUp(6);
				//	break;
				
				case "btnVipTo8":			
					Vip.getInstance().vipUp(8);
					break;
				
				case "btnVipTo9":			
					Vip.getInstance().vipUp(9);
					break;
				
				//case "btnVipLq6":
										
					//这里的11指cbtnX
					
				//	break;
				
				case "btnVipLq8":
					
					/*var cs8:PacketCSGetGift = new PacketCSGetGift();
					cs8.viplevel = 8;
					cs8.extend = 1;
					
					this.uiSend(cs8);*/
					
					//这里的10指cbtnX

					
					break;
				
				case "btnVipLq9":
					
					/*var cs9:PacketCSGetGift = new PacketCSGetGift();
					cs9.viplevel = 9;
					cs9.extend = 1;
					
					this.uiSend(cs9);*/
					
				
					
					break;
				
			}
			
			
		}
		
		public function vipUp(e:DispatchEvent):void
		{
			
			refreshContent();
			
		}
		
		public function giftUpd(e:DispatchEvent):void
		{
			refreshContent();
		}
		
		public function countUpd(e:DispatchEvent):void
		{
			refreshContent();
		}
		
		
		
	}
}