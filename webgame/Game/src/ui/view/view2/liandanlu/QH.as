package ui.view.view2.liandanlu
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_Equip_Strong_2ResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	
	import engine.event.DispatchEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import model.guest.NewGuestModel;
	
	import netc.Data;
	import netc.dataset.BeiBaoSet;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSEquipStrong;
	import nets.packets.PacketSCEquipStrong;
	import nets.packets.PacketSCEquipStrongBuyStar;
	
	import scene.music.GameMusic;
	import scene.music.WaveURL;
	
	import ui.base.npc.NpcBuy;
	import ui.base.npc.NpcShop;
	import ui.frame.ItemManager;
	import ui.frame.UIPanel;
	import ui.frame.WindowName;

	/**
	 *	强化【装备 原强化】
	 *  andy 2013－04－11 
	 */
	public class QH extends UIPanel
	{
		public static const MAX_STRONG_LEVEL:int=12;
		private var curData:StructBagCell2;
		private var selectItem:MovieClip;
		//2013-08-08 热卖物品 11800113
		public var arrHotSell:Array=[11900001,11900002,11900003,11900004];
		
		private static var _instance:QH;
		public static function instance():QH{
			if(_instance==null){
				_instance=new QH();
			}
			return _instance;
		}
		
		public function QH(){
			super(this.getLink(WindowName.win_qh));
		}
		override public function init():void{
			mcHandler({name:"ebtn1"});
			super.init();
//			mc["mc_effect_qianghua1"].addFrameScript(mc["mc_effect_qianghua1"].totalFrames-1,strongEffectPlayEnd);
//			mc["mc_effect_qianghua2"].addFrameScript(mc["mc_effect_qianghua2"].totalFrames-1,strongEffectPlayEnd);
			curData=null;
			Lang.addTip(mc["btnDesc"],"10170_qh",150);
			mc["txt_star"].mouseEnabled=false;

			super.sysAddEvent(mc, MouseEvent.MOUSE_OVER, overHandle);
			super.sysAddEvent(mc, MouseEvent.MOUSE_OUT, overHandle);
			
			Data.beiBao.addEventListener(BeiBaoSet.BAG_ADD,bagAddHandler);
			showStones(mc["sp_stone"]);
			NewGuestModel.getInstance().handleNewGuestEvent(1005,1,mc);
		}	
		/**
		 *	鼠标悬浮
		 */
		private function overHandle(me:MouseEvent):void
		{
			var target:Object=me.target;
			var name:String=target.name;
			switch (me.type)
			{
				case MouseEvent.MOUSE_OVER:
					if (name == "btnTaoZhuang")
					{
						
					}
					else
					{
						
					}
					break;
				case MouseEvent.MOUSE_OUT:
					if (name == "btnTaoZhuang")
					{
						
					}
					
					break;
				default:
					break;
			}
			
		}
		override public function mcDoubleClickHandler(target:Object):void{
			var name:String=target.name;
		}	
		override public function mcHandler(target:Object):void{
			var name:String=target.name;
			//super.mcHandler(target);

			
			if(name.indexOf("ebtn")==0){
				var who:int=int(name.replace("ebtn",""));
				LianDanLu.instance().showEquip(who);
				super.initBtnSelected(target,2);
				return;
			}
			if(name.indexOf("item")==0){
				selectItem=target as MovieClip;
				curData=target.data;
				
				clickItem();
				return;
			}
			
			switch(name){
				case "btnQiangHua":
					equipStrong();
					break;
				case "btnBuyStone":
					NpcBuy.instance().setType(4, target.parent["mc_icon"].data,true,NpcShop.PUB_SHOP_BUY_ID);
					break;
				case "mc_check":
					mc["mc_check"].selected=!mc["mc_check"].selected;
					showOdd();
					break;
				default:
					break;
			}
		}
		
		private function bagAddHandler(e:DispatchEvent):void {
			var itemId:int=int(e.getInfo.itemid);
			if(this.arrHotSell.indexOf(itemId)>=0&&LianDanLu.instance().type==1){
				showStones(mc["sp_stone"]);
				if(curData!=null){
					clickItem();
				}
			}	
		}
		private function resfreshStone():void{
			
		}
		
		/**
		 *	选中装备 
		 */
		private var strongXml:Pub_Equip_Strong_2ResModel;
		public function clickItem():void{
			if(curData==null)return;
			ItemManager.instance().setToolTipByData(mc["mc_result"],curData,1);
			

			//2012-11-20 多少级
			LianDanLu.instance().showStar(mc["txt_star"],curData.equip_strongLevel);
			//模板最大值
			var strong_max:int=curData.equip_strongLevelMax;
			for(i=1;i<=MAX_STRONG_LEVEL;i++){
				child=mc["zuan"+(i)];
				if(child==null)continue;
				if(i<=strong_max){
					child.visible=true;
					if(i<=curData.equip_strongLevel){
						child.gotoAndStop(2);
						//Lang.addTip(child,"zuan1_liandanlu",120);
					}else{
						child.gotoAndStop(1);
						//Lang.removeTip(child);
					}
				}else{
					child.visible=false;
				}
			}
			
			//战斗力
			mc["txt_zhanDouLi"].text=curData.equip_fightValue;
			
			//模板最大值
			var used_max:int=curData.equip_strongLevelMax;
			if(curData.equip_strongLevel<=used_max){
				var bag:StructBagCell2=ItemManager.instance().getBagCell(10015);
				bag.itemid=curData.itemid;
				Data.beiBao.fillCahceData(bag);
				bag.equip_strongLevel=curData.equip_strongLevelMax;
				bag.pos=0;
				bag.equip_fightValue=LianDanLu.instance().getEquipFightValue(bag);
				
				mc["mc_resultNew"]["arrBags"]=[curData,bag];
				ItemManager.instance().setToolTipByData(mc["mc_resultNew"],bag,1);
				mc["txt_star_next"].htmlText=bag.equip_strongLevel;
			}else{
				//最大
				ItemManager.instance().removeToolTip(mc["mc_resultNew"]);
			}
			
			//消耗银两
			strongXml=XmlManager.localres.getEquipSrongXml.getResPath2(curData.strongId,curData.equip_strongLevel+1) as Pub_Equip_Strong_2ResModel ;
			//成功几率
			showOdd();
			if(strongXml!=null&&curData.equip_strongLevel<used_max){
				mc["txt_yin_liang"].htmlText=LianDanLu.instance().isEnoughCoin(strongXml.cost_coin1,1);
				mc["txt_yuan_bao"].htmlText=LianDanLu.instance().isEnoughCoin(strongXml.cost_coin3,3)+Lang.getLabel("pub_yuan_bao");
				mc["txt_need_tool"].htmlText=LianDanLu.instance().showToolEnough(strongXml.need_tool,strongXml.num,true);
			}else{
				mc["txt_yin_liang"].htmlText="";
				mc["txt_yuan_bao"].htmlText="0";
				mc["txt_need_tool"].htmlText="";
				mc["txt_odd"].htmlText="";
			}
			
			NewGuestModel.getInstance().handleNewGuestEvent(1005,2,mc);
		}
		
		/**
		 *	成功率
		 */
		private function showOdd():void{
			if(strongXml!=null){
				var odd:int=strongXml.succeed_odd;
				//vip 增加成功几率
				if(Data.myKing.Vip>0){
					odd+=strongXml.odd_vip;
				}
				if(odd>100)odd=100;
				mc["txt_odd"].htmlText=odd+"%";
			}	
		}
		/**
		 *	强化石数量
		 */
		public function showStones(sp_stone:Object):void{
			
			var　sp:Sprite=new Sprite();
			var bag:StructBagCell2=null;
			for each(var itemid:int in arrHotSell){
				child=ItemManager.instance().getStrongStoneItem(itemid) as MovieClip;
				child.mouseChildren=true;
				sp.addChild(child);
				
				bag=ItemManager.instance().setToolTip(child["mc_icon"],itemid);
				child["txt_name"].text=bag.itemname;
				child["txt_count"].text=Data.beiBao.getBeiBaoCountById(bag.itemid,true);
				
				
			}
			CtrlFactory.getUIShow().showList2(sp,1,0,40);
			sp_stone.source=sp;
			sp.x=10;
		}

		/****************通讯****************/
		/**
		 *	强化 
		 */
		private function equipStrong():void{
			if(curData==null){
				Lang.showMsg(Lang.getClientMsg("10015_lian_dan_lu"));
				return;
			}
			this.uiRegister(PacketSCEquipStrong.id,equipStrongReturn);
			var client:PacketCSEquipStrong=new PacketCSEquipStrong();
			
			client.type=0;
			client.pos=curData.pos;
			client.is_usecoin=mc["mc_check"].selected?1:0;
			this.uiSend(client);
		}
		
		private function equipStrongReturn(p:PacketSCEquipStrong):void{
			if(p==null)return;
			if(super.showResult(p)){
				//如果是不完美自动降级
				//mc["mc_effect_equip_success"].play();
				ItemManager.instance().showWindowEffect("effect_zhuang_bei_success",mc,204,190);
				//andy 2012-05-22 
				GameMusic.playWave(WaveURL.ui_equip_strong_success);
				
			}else{
				//mc["mc_effect_equip_fail"].play();
				if(p.tag==7018)
					ItemManager.instance().showWindowEffect("effect_fail",mc,330,175);
			}
			
			//失败也执行
			selectChange();
			clickItem();
			showStones(mc["sp_stone"]);
			NewGuestModel.getInstance().handleNewGuestEvent(1005,4,mc);
			NewGuestModel.getInstance().handleNewGuestEvent(1005,3,mc);
			
		}
		/**
		 *	强化特效播放完毕 
		 *  如果是自动强化，则再次发送强化
		 *  @2012-07-02
		 */
		private function strongEffectPlayEnd(fightValue:int=0):void{
			//2012-07-02 自动强化
					
		}

		
		private function buyStarReturn(p:PacketSCEquipStrongBuyStar):void{
			if(p==null)return;
			if(super.showResult(p)){
				//
				clickItem();
			}else{
				
			}
		}
		/****************内部方法****************/
		/**
		 *	列表选中条目刷新 
		 */
		private function selectChange():void{
			if(selectItem==null)return;
			if(selectItem.data==null||selectItem.data!=curData)return;
			LianDanLu.instance().showStar(selectItem["mc_up"]["txt_star"],curData.equip_strongLevel);

		}


		override public function windowClose() : void {
			NewGuestModel.getInstance().handleNewGuestEvent(1005,5,null);
			super.windowClose();
		}
		/**
		 *	 
		 */
		override protected function reset():void{
			this.curData=null;
			mc["txt_star"].text="";
			mc["txt_star"].mouseEnabled=false;
			mc["txt_star_next"].text="";
			mc["txt_star_next"].mouseEnabled=false;
			
			ItemManager.instance().removeToolTip(mc["mc_result"]);
			ItemManager.instance().removeToolTip(mc["mc_resultNew"]);
	
			
			for(i=1;i<=MAX_STRONG_LEVEL;i++){
				child=mc["zuan"+(i)];
				if(child==null)continue;
				child.gotoAndStop(1);
				Lang.removeTip(child);
				child.visible=false;
			}
	
			mc["txt_yin_liang"].htmlText="";
			mc["txt_yuan_bao"].htmlText="0"+Lang.getLabel("pub_yuan_bao");
			mc["txt_odd"].htmlText="";
			mc["txt_need_tool"].htmlText="";
			mc["txt_zhanDouLi"].htmlText="0";
		}
		
		
	}
}