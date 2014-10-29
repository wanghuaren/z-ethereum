package ui.view.view3
{
	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_Equip_ResolveResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.clock.GameClock;
	import common.utils.res.ResCtrl;
	
	import engine.utils.HashMap;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import model.guest.NewGuestModel;
	
	import netc.Data;
	import netc.MsgPrint;
	import netc.dataset.BeiBaoSet;
	import netc.packets2.StructBagCell2;
	import netc.packets2.StructEvilGrain2;
	
	import nets.packets.PacketCSEquipResolve;
	import nets.packets.PacketSCEquipResolve;
	import nets.packets.StructBagCell;
	
	import ui.base.beibao.BeiBao;
	import ui.base.beibao.BeiBaoMenu;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view2.liandanlu.LianDanLu;
	import ui.view.view6.GameAlert;
	import ui.view.view6.GameAlertNotTiShi;
	
	import world.FileManager;
	import world.WorldEvent;

	public class ZhuangbeiFenjie extends UIWindow
	{
		private static var _instance:ZhuangbeiFenjie;

		private var arrZhuangbei:Array=[];
		/**给后端 传的 的装备的位置 */
		private var posArr:Vector.<int>;
		/**选中的装备 */
		private var m_seclectArr:Array=[];
		/**装备分解后 奖励物品的数据*/
		private var fenjiearr:Array;

		public function ZhuangbeiFenjie(DO:DisplayObject=null)
		{
			super(this.getLink(WindowName.win_zhuang_bei_hui_shou));
		}

		public static function instance():ZhuangbeiFenjie
		{
			if (_instance == null)
			{
				_instance=new ZhuangbeiFenjie();
			}
			return _instance;
		}

		override protected function openFunction():void
		{
			init();

		}

		override protected function init():void
		{
			super.blmBtn=2;
			if (PubData.mergeServerDay > 0)
			{
				mc["cbtn2"].visible=true;
			}
			else
			{
				mc["cbtn2"].visible=false;
			}
			this.seclectArr=[];
			posArr=new Vector.<int>;
			this.uiRegister(PacketSCEquipResolve.id, equiFenjie);
			var _desc:String=Lang.getLabel('zhuangbeifenjie_txt');
			mc['zhuangbeifenjie_txt'].htmlText=_desc;
			mc["btnYiJianFenJie"].mouseEnabled=true;
			StringUtils.setEnable(mc["btnYiJianFenJie"]);
			mcHandler(mc["cbtn1"]);
			
			if(Data.myKing.level<60){
				NewGuestModel.getInstance().handleNewGuestEvent(1066,0,mc);
			}
		}

		private function equiFenjie(p:PacketSCEquipResolve):void
		{
			seclectArr=[];
//			StringUtils.setEnable(mc["btnYiJianFenJie"]);
//			mc["btnYiJianFenJie"].mouseEnabled = true;
			if (p == null)
				return;
			if (super.showResult(p))
			{
				Lang.showMsg(Lang.getClientMsg("20078_ZhuangBei_Fenjie"));
			}


		}
		public static const FEIJIE_NUM:int=28;

		override public function mcHandler(target:Object):void
		{
			var name:String=target.name;
			super.mcHandler(target);

			if (name.indexOf("cbtn") == 0)
			{
				type=int(name.replace("cbtn", ""));
				mc["mc_tianJie"].visible=type == 2;
				clearBagSelected();
				return;
			}

			if (name.indexOf("item") == 0)
			{

				var k:int=int(name.replace("item", ""));
				var fanHuiBag:StructBagCell2=seclectArr.splice(k - 1, 1)[0];
				BeiBao.getInstance().setItemBag(fanHuiBag);
				seclectArr=seclectArr;

				return
			}

			switch (name)
			{
				case "btnFenJie":
					var bag:StructBagCell2=null;
					var hasQiangHua:Boolean=false;
					var hasXiangQian:Boolean=false;
					for (var k:int=0; k < posArr.length; k++)
					{
						bag=Data.beiBao.getBeiBaoDataByPos(posArr[k]);
						if (bag != null)
						{
							if (bag.equip_strongLevel > 0)
								hasQiangHua=true;
							for each (var stone:StructEvilGrain2 in bag.arrItemevilGrains)
							{
								if (stone.toolId > 0)
								{
									hasXiangQian=true;
									break;
								}
							}
						}
					}

					if (hasXiangQian)
					{
						Lang.showMsg(Lang.getClientMsg("50002_fenjie"));
						return;
					}
					else
					{

					}

					if (p5 == true && p6 == true)
					{
						GameAlertNotTiShi.instance.ShowMsg(Lang.getLabel("10229_fenjiezhuangbei3"), //
							GameAlertNotTiShi.FENJIE_ZHUANGBEI, null, sendFenjie);
					}
					else if (p6 == true)
					{
						GameAlertNotTiShi.instance.ShowMsg(Lang.getLabel("10229_fenjiezhuangbei2"), //
							GameAlertNotTiShi.FENJIE_ZHUANGBEI, null, sendFenjie);
					}
					else if (p5 == true)
					{
						GameAlertNotTiShi.instance.ShowMsg(Lang.getLabel("10229_fenjiezhuangbei1"), //
							GameAlertNotTiShi.FENJIE_ZHUANGBEI, null, sendFenjie);
					}
					else
					{
						GameAlertNotTiShi.instance.ShowMsg(Lang.getLabel("10229_fenjiezhuangbei"), //确定要回收装备吗？
							GameAlertNotTiShi.FENJIE_ZHUANGBEI, null, sendFenjie);
					}
					
					break;
				case "btnYiJianFenJie": ///一键放入要分解的装备
					if (seclectArr.length >= FEIJIE_NUM)
						return;
					seclectArr=[];
					var lensec:int=seclectArr.length;
					var shengyuGezi:int=FEIJIE_NUM - lensec;
					keFenjieArr=Data.beiBao.getBeiBaoBySort(13, false, ResCtrl.EquipLimit_Resolve);
//					for each(var cel2:StructBagCell2 in this.seclectArr){
//						keFenjieArr.splice(keFenjieArr.indexOf(cel2),1);
//				}
					for (var k:int=0; k < keFenjieArr.length; k++)
					{
						if (seclectArr.length >= FEIJIE_NUM)
						{
							seclectArr=seclectArr;
							return;
						}
						if (isTakeIn(keFenjieArr[k]))
						{
							seclectArr.push(keFenjieArr[k]);
							BeiBao.getInstance().removeItemContain(keFenjieArr[k]);
						}
					}

					seclectArr=seclectArr;
					NewGuestModel.getInstance().handleNewGuestEvent(1066,1,mc);
					break;
			}

		}
		private var keFenjieArr:Array

		/**
		 *点击icon后。将装备显示在左边带分解区域
		 *
		 */
		private function showSeclectIcon():void
		{
			var item:StructBagCell2=null;
			var len:int=seclectArr.length;
			for (i=0; i < FEIJIE_NUM; i++)
			{
				child=mc["item" + (i + 1)] as MovieClip;
				if (child == null)
					continue;
				if (i < len)
				{
					item=seclectArr[i];
					child.mouseEnabled=true;
					ItemManager.instance().setToolTipByData(child, item);
					LianDanLu.instance().showStar(child["txt_strong_level"], item.equip_strongLevel);
				}
				else
				{
					removeItemUil(i)
					child["txt_strong_level"].text="";
				}
			}
		}



		/**
		 *根据选中的装备获得分解后的奖励数据
		 *
		 */
		private function getFenJieGoods():void
		{
			fenjiearr=[];
			var dropV:Array=[];
			posArr=new Vector.<int>;
			var _jingyan:int=0; //奖励经验值
			var _yinliang:int=0; //奖励银两值
			var _lingyun:int=0; //奖励灵韵值
			var _tianshu:int=0; //奖励天书值

			for (i=0; i < seclectArr.length; i++)
			{
				var itgoods:StructBagCell2=seclectArr[i];
				posArr.push(itgoods.pos);
				var _Pub_EquipFJ:Pub_Equip_ResolveResModel=XmlManager.localres.getEquipFenjieXml.getResPath2(itgoods.toolColor, itgoods.level, itgoods.itemid) as Pub_Equip_ResolveResModel;
				if (_Pub_EquipFJ == null)
					continue;
				_jingyan+=_Pub_EquipFJ.add_exp;
				_yinliang+=_Pub_EquipFJ.add_coin1;
				_lingyun+=_Pub_EquipFJ.add_value1;
				_tianshu+=_Pub_EquipFJ.HeavenBookExp;
			}
			if (type == 1)
			{
				mc["jiangliNum1"].htmlText=_lingyun.toString();

				mc["jiangliNum2"].htmlText=_jingyan.toString();
				mc["jiangliNum3"].htmlText=_yinliang.toString();
			}
			else
			{
				mc["mc_tianJie"]["jiangliNum1"].htmlText=_tianshu.toString();

				mc["mc_tianJie"]["jiangliNum2"].htmlText=_jingyan.toString();
				mc["mc_tianJie"]["jiangliNum3"].htmlText=_yinliang.toString();
			}
		}

		public function setFenjieGoodsItem(_fenjieArr:Array):void
		{
			for (var t:int=1; t <= 6; t++)
			{
//				ItemManager.instance().removeToolTip(mc["fenjiehou"]["item"+(t)]);
//				mc["fenjiehou"]["item"+(t)]['effect_item'].visible = false;
			}
			var t1:int=0;
			var hxmp:HashMap=new HashMap();
//			hxmp.
			for (var i:int=0; i < _fenjieArr.length; i++)
			{
				if (hxmp.containsKey(_fenjieArr[i].itemid.toString()) == false)
				{
					hxmp.put(_fenjieArr[i].itemid.toString(), _fenjieArr[i]);
				}
				else
				{
					(hxmp.getValue(_fenjieArr[i].itemid.toString()) as StructBagCell2).num+=_fenjieArr[i].num;
				}
			}
			var keys:Array=hxmp.keys();
		}

		private function setDropItem(_dropArr:Array):void
		{
			for (var cont:int=0; cont < _dropArr.length; cont++)
			{
				var arrV:Vector.<Pub_DropResModel>=_dropArr[cont].arrv;
			}
		}


		/**清空Item
		 * @param k
		 */
		public function removeItemUil(k:int):void
		{
			mc["item" + (k + 1)].mouseEnabled=false;
			ItemManager.instance().removeToolTip(mc["item" + (k + 1)] as MovieClip);
		}

		private function setZhuangbeiFenjie():void
		{
		}

		public function addSeclctArr(_bagSCell2:StructBagCell2):void
		{
			seclectArr.push(_bagSCell2);
			seclectArr=seclectArr;
		}

		override protected function windowClose():void
		{
			// 面板关闭事件
			NewGuestModel.getInstance().handleNewGuestEvent(1066,3,null);
			clearBagSelected();
			super.windowClose();
		}

		private function sendFenjie():void
		{
			//2013-10-22 andy 有强化或者镶嵌宝石的装备提示
			var client:PacketCSEquipResolve=new PacketCSEquipResolve();
			client.arrItemequips=posArr;
			this.uiSend(client);
//			mc["btnYiJianFenJie"].mouseEnabled = false;
			StringUtils.setUnEnable(mc["btnYiJianFenJie"]);
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, _onClockSecond);
			NewGuestModel.getInstance().handleNewGuestEvent(1066,2,mc);
		}
		public var NEED_TIME:int=1;

		private function _onClockSecond(e:WorldEvent):void
		{
			if (NEED_TIME <= 0)
			{
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, _onClockSecond);
				StringUtils.setEnable(mc["btnYiJianFenJie"]);
				NEED_TIME=1;
				return;
			}
			NEED_TIME=NEED_TIME - 1;
		}

		public function seclectArrAdd(arr:Array):void
		{
			seclectArr=arr;
		}

		public function get seclectArr():Array
		{
			return m_seclectArr;
		}
		private var p5:Boolean=false;
		private var p6:Boolean=false;

		public function set seclectArr(value:Array):void
		{
			m_seclectArr=value;
			p5=false;
			p6=false;
			if (type == 1)
			{
				for each (var cel2:StructBagCell2 in m_seclectArr)
				{
					if (cel2.toolColor == 5)
					{
						p5=true;
					}
					else if (cel2.toolColor == 6)
					{
						p6=true;
					}
				}
			}
			else
			{

			}


			showSeclectIcon();
			getFenJieGoods();
		}

		/**
		 * 判断能否放入 1.普通2.天劫 2014-06-20
		 * 2014-10-29 策划修改60级之前和60级之后一键放入规则不一致
		 * @param bagCell2
		 * @return
		 *
		 */
		public function isTakeIn(bagCell2:StructBagCell2):Boolean
		{
			if (bagCell2 == null)
				return false;
			if ((ZhuangbeiFenjie.instance().type == 1 && bagCell2.soar_lv == 0) || (ZhuangbeiFenjie.instance().type == 2 && bagCell2.soar_lv > 0 && bagCell2.soar_lv < 5))
			{
				if(Data.myKing.level<60){
					if(bagCell2.level<=45&&bagCell2.toolColor<=2){
						return true;
					}else{
						return false;
					}
				}else{
					return true;
				}
			}
			else
			{
				return false;
			}
		}

		/**
		 * 清空选中状态 2014-06-20
		 *
		 */
		private function clearBagSelected():void
		{
			for (i=0; i < seclectArr.length; i++)
			{
				BeiBao.getInstance().setItemBag(seclectArr[i]);
				removeItemUil(i)
			}
			seclectArr=[];
		}

		override public function getID():int
		{
			return 1079;
		}


	}
}
