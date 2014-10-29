package ui.base.beibao
{
	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.component.ToolTip;
	import common.utils.drag.MainDrag;
	import common.utils.res.ResCtrl;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.dataset.BeiBaoSet;
	import netc.dataset.MyCharacterSet;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import scene.action.ColorAction;
	import scene.action.hangup.GamePlugIns;
	import scene.manager.MouseManager;
	import scene.manager.SceneManager;
	import scene.mouse.MouseSkinType;
	import scene.music.GameMusic;
	import scene.music.WaveURL;
	
	import ui.base.fuben.FuBenController;
	import ui.base.jiaose.JiaoSeMain;
	import ui.base.mainStage.UI_index;
	import ui.base.npc.NpcBuy;
	import ui.base.npc.NpcShop;
	import ui.base.renwu.Renwu;
	import ui.base.vip.ChongZhi;
	import ui.base.vip.DuiHuan;
	import ui.frame.Image;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.jingjie.JingJie2Win;
	import ui.view.marry.LightenFireworksWin;
	import ui.view.newFunction.FunJudge;
	import ui.view.pay.WinFirstPay;
	import ui.view.view1.chat.MainChat;
	import ui.view.view1.xiaoGongNeng.WuPinShiYongTiShi;
	import ui.view.view2.booth.Booth;
	import ui.view.view2.booth.BoothBuy;
	import ui.view.view2.liandanlu.LianDanLu;
	import ui.view.view2.other.NewPlayerGift;
	import ui.view.view2.other.UseTimes;
	import ui.view.view2.trade.Trade;
	import ui.view.view3.ZhuangbeiFenjie;
	import ui.view.view4.yunying.XunBaoChangKu;

	/**
	 *  背包
	 *	2011-12-05
	 */
	public final class BeiBao extends UIWindow
	{
		private static var _instance:BeiBao;

		/**点击要分解的装备 */
		public function get fenJieZhuangBeiMap():Array
		{
			if (m_fenJieZhuangBeiMap == null)
			{
				m_fenJieZhuangBeiMap=new Array();
			}
			return m_fenJieZhuangBeiMap;
		}

		/**
		 * @private
		 */
		public function set fenJieZhuangBeiMap(value:Array):void
		{
			m_fenJieZhuangBeiMap=value;

		}

		/**
		 *	背包窗体显示
		 * 	@param must 是否必须
		 */
		public static function getInstance():BeiBao
		{
			if (_instance == null)
			{
				_instance=new BeiBao();
			}
			return _instance;
		}

		public function BeiBao(d:Object=null):void
		{
			super(getLink("win_bao_guo"), d);
			//this.clickRectangle=new Rectangle(0, 0, 300, 465);
			doubleClickEnabled=true;

		}

		override public function get width():Number
		{
			return 365;
		}

		override protected function openFunction():void
		{

			init();
		}

		//面板初始化
		override protected function init():void
		{
			type=1;
			this.uiRegister(PacketSCUseItem.id, useItemReturn);
			this.uiRegister(PacketSCUseItemAutoBuy.id, useItemAutoReturn);
			this.uiRegister(PacketSCHorseFachionUse.id, SCHorseFachionUse);
			this.uiRegister(PacketSCHorseUse.id, getHorseReturn);

			super.sysAddEvent(PubData.mainUI.stage, MainDrag.DRAG_UP, dragUpHandler);
			super.sysAddEvent(Data.beiBao, BeiBaoSet.BAG_UPDATE, showPackage);
			super.sysAddEvent(Data.myKing, MyCharacterSet.COIN_UPDATE, coinUpdate);
			super.sysAddEvent(Data.myKing, MyCharacterSet.BAG_SIZE_UPDATE, bagSizeUpdate);
			super.sysAddEvent(Data.myKing, MyCharacterSet.BAG_START_UPDATE, bagStartUpdate);

			mc.hitArea=this.hitArea;

			//2014-01-07 
			Lang.addTip(mc["mc_yinliang_icon"], "10024_beibao");
			Lang.addTip(mc["mc_yuanbao_icon"], "10025_beibao");
			Lang.addTip(mc["mc_lijin_icon"], "10026_beibao");
			//2013-03-11 9377说摆摊暂时不显示
			var iconShow:Boolean=FunJudge.judgeByName(WindowName.win_booth, false); //WindowModelClose.isOpen(WindowModelClose.win_booth);
			//mc["mc_icon_desc"].visible=iconShow;
			mc["btnBaiTan"].visible=iconShow;

			mc["mc_vip"].visible=(Data.myKing.VipVip > 0 || Data.myKing.TestVIP > 0);

			coinUpdate();

			showPackage();
			//0020167: 【1221】打开背包后，不再显示vip购买界面
//			if(!ZhiZunHotSale.getInstance().isOpen)
//			{
//				ZhiZunHotSale.getInstance().open(true);
//			}
			fenJieZhuangBeiMap=[];
			if (fenJieOpen)
			{
				ZhuangbeiFenjie.instance().open();
				fenJieOpen=false;
			}
			
			if(Data.myKing.Pay>0){
				mc["mc_pay_small"].visible=false;
			}else{
				mc["mc_pay_small"].visible=true;
				WinFirstPay.instance.fillContent(mc["mc_pay_small"]);
			}
		}
		/**
		 *	整理时间间隔 2013-11-07
		 */
		private var zhengLiDelay:Number=0;

		/**
		 *	单击菜单使用
		 *  2013-08-13
		 */
		public function clickMenuUse(target:Object):void
		{	
			mcDoubleClickHandler(target);
		}

		public static function delAll():void
		{
			for (var m_i:int=0; m_i < Data.beiBao.getBeiBaoData().length; m_i++)
			{
				NpcBuy.instance().sell(Data.beiBao.getBeiBaoData()[m_i].pos, Data.beiBao.getBeiBaoData()[m_i].num);
			}
		}

		// 面板双击事件
		override protected function mcDoubleClickHandler(target:Object):void
		{
			var name:String=target.name;
			if (ZhuangbeiFenjie.instance().isOpen || MouseManager.instance.mouseSkinType == MouseSkinType.MouseBangPaiJuan)
			{
				
				this.mcHandler(target);
				return;
			}
			//项目转换
			if (name.indexOf("item") == 0)
			{
				//任务物品不能使用
				if (type == 4)
					return;
				var bag:StructBagCell2=target.data as StructBagCell2;

				//JingjieController.getInstance().chiDanYao(bag);
				if (bag == null)
					return;
				if(bag.lock){
					Lang.showMsg(Lang.getClientMsg("10167_trade"));
					return;
				}
				PubData.chat.clearChatSend(bag.itemname);

				var winBooth:String=getBooth();

				//如果摆摊打开，则为上架
				if (winBooth == WindowName.win_booth)
				{
					//不可交易【拖拽】
					if (bag.isTrade == false)
					{
						Lang.showMsg(Lang.getClientMsg("10140_booth"));
						return;
					}
					//已经上架中
					if (bag.lock)
					{
						Lang.showMsg(Lang.getClientMsg("10141_booth"));
						return;
					}
					BoothBuy.getInstance().setData(bag);
					return;
				}
				//如果仓库打开，则放入仓库
				if (winBooth == WindowName.win_cang_ku)
				{
					var posIndex:int=Data.beiBao.getCangKuFirstEmpty(Store.getInstance().type, Data.myKing.BankSize);

					storeOn(bag.pos, posIndex);
					return;
				}
				//如果商店打开，则为出售
				if (winBooth == WindowName.win_npc_shang_dian)
				{
					if (bag.isSale == false)
					{
						Lang.showMsg(Lang.getClientMsg("10022_bao_guo"));
						return;
					}
					NpcBuy.instance().setType(2, bag, true);
					return;
				}
				//如果交易打开，则为上架 2014-04-01
				if (winBooth == WindowName.win_jiao_yi)
				{
					//不可交易【拖拽】
					if (bag.isTrade == false)
					{
						Lang.showMsg(Lang.getClientMsg("10140_booth"));
						return;
					}
					//已经上架中
					if (bag.lock)
					{
						Lang.showMsg(Lang.getClientMsg("10141_booth"));
						return;
					}
					Trade.getInstance().CSTradeAddItem(bag.pos);
					return;
				}
				if (ZhuangbeiFenjie.instance().isOpen )
				{
					this.mcHandler(target);
				}
				/**
				 *1001 装备升星界面
					1002 装备鉴定界面
					1003 宝石镶嵌界面
					1004 宝石合成界面
					1005 神装界面
					1006 觉醒界面
					1007 马鞍强化界面
					1008 坐骑强化界面
					1009 藏经阁界面
					1010 宠物洗品质界面
					1011 宠物洗资质界面
					1012 宠物强化界面
					1013 宠物技能学习界面
					1014 宠物解封界面
					1015 神器升级
					1016 神器灵件升级界面
					1017 翅膀升级界面
					1018 星界界面
					1019 丹药炼制界面
					1020 兑换界面第一页“装备兑换”
					1021 兑换界面第二页“神器兑换”
					1022 兑换界面第三页“丹方兑换”
					1023 兑换界面第四页“阵法兑换”
					1024 兑换界面第五页“宠物兑换”
					1025 兑换界面第六页“特殊兑换”

					2001 回城功能调用
					2002 宠物天赋重置功能调用
					2003 穿戴装备(原类型13)
					2004 穿戴神器(原类型21)
					2005 穿戴翅膀(原类型22)
					2006 穿戴宠物装备(原类型27)
					2007 穿戴坐骑(原类型6)
					2008 穿戴宠物(原类型16)
					2009 双击使用道具(16)
					2010 宝石升级功能调用(25)
					2011 双击包裹中的使用次数物品，自动弹出使用物品页面(20)
					2012 双击封印的宠物蛋(26)
					2013 学习技能书(28)
					2014 打开新礼包界面
					2015 传送功能调用
					2016坐骑时装

				 */
				switch (bag.dbsort)
				{
					case 1001:
						//装备升星界面
						LianDanLu.instance().setType(1);
						break;
					case 1002:
						//
						LianDanLu.instance().setType(2);
						break;
					case 1003:
						//
						LianDanLu.instance().setType(4);
						break;
					case 1004:
						//
						LianDanLu.instance().setType(5);
						break;
					case 1005:
						//
						LianDanLu.instance().setType(6);
						break;
					case 1006:
						//
						LianDanLu.instance().setType(7);
						break;
					case 1007:
						//

						break;
					case 1008:
						//

						break;
					case 1009:
						//

						break;
					case 1010:
						//

						break;
					case 1011:
						//

						break;
					case 1012:
						//

						break;
					case 1013:
						//

						break;
					case 1014:
						//

						break;
					case 1015:
						//

						break;
					case 1016:
						//

						break;
					case 1017:
						//

						break;
					case 1018:
						//2012-08-08 andy 策划修改：双击丹药，只打开境界界面
						JingJie2Win.getInstance().open();
						break;
					case 1019:
						//

						break;
					case 1020:
						//
						//NpcShop.instance().setshopId(NpcShop.DUI_HUAN_SHOP_ID,1);
						break;
					case 1021:
						//
						//NpcShop.instance().setshopId(NpcShop.DUI_HUAN_SHOP_ID,2);
						break;
					case 1022:
						//
						//NpcShop.instance().setshopId(NpcShop.DUI_HUAN_SHOP_ID,3);
						break;
					case 1023:
						//
						//NpcShop.instance().setshopId(NpcShop.DUI_HUAN_SHOP_ID,4);
						break;
					case 1024:
						//
						//NpcShop.instance().setshopId(NpcShop.DUI_HUAN_SHOP_ID,5);
						break;
					case 1025:
						//
						//NpcShop.instance().setshopId(NpcShop.DUI_HUAN_SHOP_ID,6);
						break;
					case 1026:
						//

						break;
					case 2001:
					case 2009:
						//使用道具
						if (bag.isused == 1)
						{
							//回城卷
							if (bag.tool_icon == 11800180 && SceneManager.instance.isAtGameTranscript())
							{
								FuBenController.Leave(false, function():void
								{
									useItem(bag.pos)

								});

							}
							else
							{
								useItem(bag.pos);
							}
						}
						break;
					case 2002:
						//

						break;
					case 2003:
					case 2004:
					case 2005:
						//穿装备
						equipOn(bag.pos);
//						if(bag.dbsort==2004){
//							
//						}else
//							JiaoSeMain.getInstance().setType(1);
						UIMovieClip.currentObjName=null;
						break;
					case 2006:
						///伙伴穿装备 2013-07-24
						//equipOnPet(bag.pos);
						break;
					case 2007:
						//
						getHorse(bag.pos);
						break;
					case 2008:
						//
//						var _labelString1:String='';
//						if (PetModel.getInstance().isFullPetSlot())
//						{
//							_labelString1=Lang.getLabel("40094_pet_jiefeng_0");
//							alert.ShowMsg(_labelString1, 2, null, null, 0, 0);
//						}
//						else
//						{
//							//通过是否“可交易” 判断是否绑定。
//							if (bag.isTrade)
//							{
//								_labelString1=Lang.getLabel("40094_pet_jiefeng_1");
//								alert.ShowMsg(_labelString1, 4, null, function(v:int):void
//								{
//									if (1 == v)
//									{
//										//PetModel.getInstance().requestCSPetUnseal(bag.pos);
//										useItem(bag.pos);
//									}
//									
//								}, 1, 0);
//							}
//							else
//							{
//								//PetModel.getInstance().requestCSPetUnseal(bag.pos);
//								useItem(bag.pos);
//							}
//							
//						}
						break;
					case 2010:
						//宝石升级卷轴 2013-10-13

						break;
					case 2011:
						//
						UseTimes.getInstance().reset(bag.itemid);
						//useItem(bag.pos);
						break;
					case 2012:
						//
//						var _labelString1:String='';
//						if (PetModel.getInstance().isFullPetSlot())
//						{
//							_labelString1=Lang.getLabel("40094_pet_jiefeng_0");
//							alert.ShowMsg(_labelString1, 2, null, null, 0, 0);
//						}
//						else
//						{
//							//通过是否“可交易” 判断是否绑定。
//							if (bag.isTrade)
//							{
//								_labelString1=Lang.getLabel("40094_pet_jiefeng_1");
//								alert.ShowMsg(_labelString1, 4, null, function(v:int):void
//								{
//									if (1 == v)
//									{
//										PetModel.getInstance().requestCSPetUnseal(bag.pos);
//									}
//									
//								}, 1, 0);
//							}
//							else
//							{
//								PetModel.getInstance().requestCSPetUnseal(bag.pos);
//							}
//							
//						}
						break;
					case 2013:
						//

						break;
					case 2014:
						//
						if (NewPlayerGift.getInstance().isNewPlayerGift(bag.itemid))
						{
							//双击包裹中的新手礼包，自动新手礼包页面
							NewPlayerGift.getInstance().open(true);
							return;
						}
						break;
					case 2015:
						if (!ChuanSong.getInstance().isOpen)
						{
							//useItem(bag.pos);

							if (Data.myKing.level >= bag.level)
							{
								ChuanSong.getInstance().openFromBeibao();
							}
							else
							{
								Lang.showMsg(Lang.getClientMsg("40070_bao_guo"));
							}

						}
						break;
					case 2016:

						useHorseFachion(bag.pos);

						break;
					default:
						if (bag.isused == 1)
						{
							useItem(bag.pos);
						}
						break;
				}
				//播放音乐	
				if (bag != null)
				{
					if (bag.sort == 9)
					{
						GameMusic.playWave(WaveURL.ui_chiyao);
					}
					else if (bag.sort == 13 && bag.pos == 1)
					{
						GameMusic.playWave(WaveURL.ui_shiyong_wuqi);
					}
					else if (bag.sort == 13 && bag.pos != 1)
					{
						GameMusic.playWave(WaveURL.ui_shiyong_zhuangbei);
					}else if(bag.itemid == 11800332)//浪漫烟花
					{
						LightenFireworksWin.getInstance().confirm(bag.itemname,1);
					}else if(bag.itemid == 11800333){//璀璨烟花
						LightenFireworksWin.getInstance().confirm(bag.itemname,2);
					}
					else if (bag.itemid == 11600003)
					{
						//回城卷轴
						GameMusic.playWave(WaveURL.dj_use_juan_zhou);
					}
					else
					{
						GameMusic.playWave(WaveURL.ui_shiyong_wupin);
					}
				}
				//悬浮消失
				ToolTip.instance().notShow();
				BeiBaoMenu.getInstance().notShow();
			}
		}
		private var m_fenJieZhuangBeiMap:Array;

		// 面板点击事件
		override public function mcHandler(target:Object):void
		{

			super.mcHandler(target);
			var name:String=target.name;
			if (name.indexOf("cbtn") >= 0)
			{
				type=int(name.replace("cbtn", ""));
				showPackage();

				alert.willClose();
				return;
			}

			if (name.indexOf('instance') == 0)
			{
				ColorAction.ResetMouseByBangPai();
				return;
			}

			if (name == "btnCangKu" || name == "btnShangDian")
			{
				ColorAction.ResetMouseByBangPai();
			}

			//点住shift不放，然后点击物品直接把物品放到左下角聊天框
			if (name.indexOf("item") == 0 && target.data != null && target.data is StructBagCell2)
			{
				if((target.data as StructBagCell2).lock){
					Lang.showMsg(Lang.getClientMsg("10167_trade"));
					return;
				}
				if (UI_index.shift_)
				{
					//点击shift,放入聊天框展示
					txtChat(target.data, UI_index.chat["txtChat"]);
				}
				else if (MouseManager.instance.mouseSkinType == MouseSkinType.MouseBangPaiJuan)
				{

					juan(target.data);

					return;

				}
				else if (MouseManager.instance.mouseSkinType == MouseSkinType.MouseBagSale)
				{
					//快捷出售
					saleToSys(target.data);
					//MouseManager.instance.show(0);
					return;

				}
				else if (ZhuangbeiFenjie.instance().isOpen )
				{
					if(ZhuangbeiFenjie.instance().seclectArr.length >= ZhuangbeiFenjie.FEIJIE_NUM)return;
					var bagCell2:StructBagCell2=target.data as StructBagCell2;
					if (bagCell2.sort == 13 && ResCtrl.instance().getEquipLimit(bagCell2.equip_limit, ResCtrl.EquipLimit_Resolve))
					{ //装备
						if(ZhuangbeiFenjie.instance().isTakeIn(bagCell2)){
							ItemManager.instance().removeToolTip(target as MovieClip);
	//						fenJieZhuangBeiMap.push(bagCell2);
							ZhuangbeiFenjie.instance().addSeclctArr(bagCell2);
							if(target!=null&&target["txt_strong_level"]!=null)
							target["txt_strong_level"].text="";
						}
					}
					else
					{
						Lang.showMsg({type: 4, msg: Lang.getLabel("5009_BuNengFenJieMsg")}); //不能分解的装备  点击弹出提示
					}

				}
				else if (Trade.getInstance().isOpen)
				{
				
					mcDoubleClickHandler(target);
				}
				else if (MainDrag.currData == null)
				{
					
				}
				else
				{
					//显示下拉菜单
					flash.utils.setTimeout(function (){BeiBaoMenu.getInstance().showMenu(target as MovieClip)},100);
				}
				return;
			}

			if (MouseManager.instance.mouseSkinType == MouseSkinType.MouseBagSale)
			{
				MouseManager.instance.show(0);
			}
			switch (name)
			{
				case "btnQuickSale":
					if (ZhuangbeiFenjie.instance().isOpen)
						return;
					//快捷出售 2013-12-17
					if (MouseManager.instance.mouseSkinType == MouseSkinType.MouseBagSale)
					{
						MouseManager.instance.show(0);
						return;
					}
					MouseManager.instance.show(MouseSkinType.MouseBagSale);
					break;
				case "btnZhengLi":
					if (ZhuangbeiFenjie.instance().isOpen)
						return;
					if (Data.date.nowDate.time - zhengLiDelay < 10000)
					{
						Lang.showMsg(Lang.getClientMsg("10006_bao_guo"));
						return;
					}
					zhengLiDelay=Data.date.nowDate.time;
					if (Data.beiBao.getBeiBaoData() == null || Data.beiBao.getBeiBaoData().length == 0)
					{
						Lang.showMsg(Lang.getClientMsg("10012_bao_guo"));
					}
					else
					{
						if (Booth.isBooth)
						{
							Lang.showMsg(Lang.getClientMsg("10142_beibao"));
							return;
						}
						tidyCell();
					}
					break;
				case "btnShangDian":
					yuanChengShangDian();

					break;
				case "btnCangKu":
					yuanChengCangKu();
					break;
				case "btnDuiHuan":
					DuiHuan.getInstance().open(true);
					break;
				case "btnChongZhi":
					ChongZhi.getInstance().open();
					break;
				case "btnBaiTan":
					if (ZhuangbeiFenjie.instance().isOpen)
						return;
					//2013-02-25 摆摊
					if (Data.myKing.level < 30)
					{
						Lang.showMsg(Lang.getClientMsg("10152_beibao"));
						return;
					}
					boothEnable();
					break;
				case "btnHuoDongCangKu":
					XunBaoChangKu.getInstance().open();
					break;
				case "btnPaySmall":
					ChongZhi.getInstance().open();
					break;
				default:
					break;

			}
		}

		/**
		 *	远程商店
		 *  2013-11-22
		 */
		public function yuanChengShangDian():void
		{
			NpcShop.instance().setshopId(70100000, 1, true);


		}

		/**
		 *	远程仓库
		 *  2013-11-22
		 */
		public function yuanChengCangKu():void
		{
			Store.getInstance().open(true);
		}
		private var fenJieOpen:Boolean=false;

		public function openFenjie():void
		{
			fenJieOpen=true;
			this.open();
		}

		/**
		 *	背包列表
		 */
		private function showPackage(ds:DispatchEvent=null):void
		{
			if (ZhuangbeiFenjie.instance().isOpen)
				return;
			clearItem();
			var arr:Array=Data.beiBao.getBeiBaoDataByPage(type);
			arr.sortOn("pos");
			arr.forEach(callback);
			ToolTip.instance().resetOver();

			mc["txt_count"].htmlText=arr.length + "/" + BeiBaoSet.BEIBAO_MAX;
		}

		//列表中条目处理方法
		private function callback(itemData:StructBagCell2, index:int, arr:Array):void
		{
			if(itemData==null)return;
			var pos:int=Data.beiBao.getBeiBaoCellPos(itemData.pos);
			var sprite:*=mc.getChildByName("item" + pos);
			if (sprite == null)
				return;
			super.itemEvent(sprite, itemData);
			sprite.buttonMode=false;

			ImageUtils.replaceImage(sprite,sprite["uil"],itemData.icon);

//			sprite["uil"].source=itemData.icon;
			sprite["txt_num"].text=itemData.num;
	
			ItemManager.instance().setEquipFace(sprite);
			sprite["lengque"].gotoAndStop(37);
			CtrlFactory.getUIShow().addTip(sprite);
			MainDrag.getInstance().regDrag(sprite);
//			if(sprite["mc_is_metier"]!=null)
//			sprite["mc_is_metier"].visible=!Data.jiaoSe.checkMetier(itemData.metier,Data.myKing.metier);

		}

		public function setItemBag(_cell:StructBagCell2):void
		{
			var pos:int=Data.beiBao.getBeiBaoCellPos(_cell.pos);
			var sprite:*=mc.getChildByName("item" + pos);
			if (sprite == null)
				return;
			super.itemEvent(sprite, _cell);
			sprite.buttonMode=false;
//			sprite["uil"].source=_cell.icon;

ImageUtils.replaceImage(sprite,sprite["uil"],_cell.icon);
			
	
			ItemManager.instance().setEquipFace(sprite);
			sprite["lengque"].gotoAndStop(37);
			CtrlFactory.getUIShow().addTip(sprite);
			MainDrag.getInstance().regDrag(sprite);
		}

		public function removeItemContain(_cell:StructBagCell2):void
		{
			var pos:int=Data.beiBao.getBeiBaoCellPos(_cell.pos);
			var sprite:*=mc.getChildByName("item" + pos);
			ImageUtils.cleanImage(sprite);
			sprite["txt_star"].text="";
			ItemManager.instance().removeToolTip(sprite as MovieClip);
		}

		/*************通信***********/
		/**
		 *	开启背包格子
		 */
		private function openCell(v:int=1):void
		{
			if (v > 0)
			{
				this.uiRegister(PacketSCAddBagSize.id, openCellReturn);
				var client:PacketCSAddBagSize=new PacketCSAddBagSize();
				client.num=v;
				this.uiSend(client);
			}
			else
			{
				if (this.isOpen == false)
					return;
				for (i=1; i <= Data.beiBao.BAG_PAGE_COUNT; i++)
				{
					mc["item" + i]["select"].gotoAndStop(1);
				}
			}
		}

		private function openCellReturn(p:PacketSCAddBagSize):void
		{
			if (p == null)
				return;
			if (super.showResult(p))
			{

			}
			else
			{
				//mcHandler({name:"cbtn"+type});

			}
		}

		/**
		 *	整理背包
		 */
		private function tidyCell():void
		{
			this.uiRegister(PacketSCTrimBag.id, tidyCellReturn);
			var _loc1:PacketCSTrimBag=new PacketCSTrimBag();
			this.uiSend(_loc1);
		}

		private function tidyCellReturn(p:PacketSCTrimBag):void
		{
			if (p == null)
				return;
			if (super.showResult(p))
			{
				Lang.showMsg(Lang.getClientMsg("10000_bao_guo"));
				GameMusic.playWave(WaveURL.ui_reset_bag);
				PubData.chat.clearChatSend();
				//物品使用提示 2013-11-07
				//WuPinShiYongTiShi.instance().checkBeiBaoGoods();
				WuPinShiYongTiShi.instance().NEED_TIME=10;
			}
			else
			{

			}
		}

		/**
		 *	销毁背包物品
		 */
		public function destroyItem(obj:Object):void
		{
			this.uiRegister(PacketSCDestroyItem.id, destroyItemReturn);
			var _loc1:PacketCSDestroyItem=new PacketCSDestroyItem();
			_loc1.pos=int(obj);
			this.uiSend(_loc1);
		}

		private function destroyItemReturn(p:PacketSCDestroyItem):void
		{
			if (p == null)
				return;
			if (super.showResult(p))
			{

			}
			else
			{

			}
		}

		/**
		 *	掉落背包物品
		 *  2013-12-28
		 */
		public function drop(obj:Object):void
		{
			this.uiRegister(PacketSCDrop.id, dropReturn);
			var _loc1:PacketCSDrop=new PacketCSDrop();
			_loc1.pos=int(obj);
			this.uiSend(_loc1);
		}

		private function dropReturn(p:PacketSCDrop):void
		{
			if (p == null)
				return;
			if (super.showResult(p))
			{

			}
			else
			{

			}
		}

		/**
		 *	存东西到仓库
		 */
		private function storeOnByDrag(pos:int, cangku_pos:int):void
		{
			var p:PacketCSMoveItem=new PacketCSMoveItem();
			p.srcindex=pos;
			p.destindex=cangku_pos;
			uiSend(p);
		}

		private function storeOn(pos:int, cangku_pos:int):void
		{
			//如果仓库满，弹出提示
			//可扩展
			var storeDataLen:int=Data.beiBao.getStoreData().length;
			var cangKuMaxLen:int=BeiBaoSet.CANGKU_END_INDEX - BeiBaoSet.CANGKU_INDEX + 1;
			var cangKuLen:int=Data.myKing.BankSize;

			if (storeDataLen < cangKuMaxLen)
			{
				//满
				if (storeDataLen == cangKuLen)
				{
					Store.getInstance().beibaoOnButFull();
					return;
				}
			}

			if (storeDataLen == cangKuMaxLen)
			{
				//满
				if (storeDataLen == cangKuLen)
				{
					Store.getInstance().beibaoOnButFull2();
					return;
				}
			}

			var p:PacketCSMoveItem=new PacketCSMoveItem();
			p.srcindex=pos;
			p.destindex=cangku_pos;
			uiSend(p);
		}

		override public function open(must:Boolean=false, type:Boolean=true):void
		{
			super.open(must, type);

		}



		/**
		 * 通过一个 物品的ID ，找到背包中第一个出现该物品的格子对象
		 * @param itemID    物品ID
		 * @return
		 *
		 */
		private function _getItemBoxByID(itemID:int):MovieClip
		{
			var _mc:MovieClip=null;
			var _items:Array=Data.beiBao.getBeiBaoDataById(itemID);

			var _index:int;
			if (null != _items && _items.length >= 1)
			{
				var pos:int=(_items[0] as StructBagCell2).pos;
				var page:int=Math.ceil(pos / Data.beiBao.BAG_PAGE_COUNT);
				mcHandler({name: "cbtn" + page});
				_index=Data.beiBao.getBeiBaoCellPos(pos);
			}

			if (_index >= 1 && _index <= 36)
			{
				_mc=mc["item" + _index];
			}


			return _mc;
		}

		public function getItemBoxByID(itemID:int):MovieClip
		{
			return _getItemBoxByID(itemID);
		}

		/**
		 *	穿装备【主角】
		 */
		public function equipOn(pos:int=0, equip_pos:int=0):void
		{

			this.uiRegister(PacketSCEquipItem.id, equipOnReturn);
			var cleint:PacketCSEquipItem=new PacketCSEquipItem();
			cleint.srcindex=pos;
			cleint.equip_pos=equip_pos;
			uiSend(cleint);

		}

		private function equipOnReturn(p:PacketSCEquipItem):void
		{
			if (p == null)
				return;
			if (super.showResult(p))
			{

			}
			else
			{

			}
		}




		/**
		 *	获得坐骑
		 */
		private function getHorse(pos:int=0):void
		{

			var cleint:PacketCSHorseUse=new PacketCSHorseUse();
			cleint.horsepos=pos;
			uiSend(cleint);
		}

		private function getHorseReturn(p:PacketSCHorseUse):void
		{
			if (p == null)
				return;
			if (super.showResult(p))
			{
				winClose();
			}
			else
			{

			}
		}

		public function useHorseFachion(pos:int=0):void
		{
			var cs:PacketCSHorseFachionUse=new PacketCSHorseFachionUse();
			cs.fachionpos=pos;
			uiSend(cs);

		}

		private function SCHorseFachionUse(p:PacketSCHorseFachionUse2):void
		{
			if (super.showResult(p))
			{

			}
			else
			{

			}
		}

		/**
		 *	使用道具
		 */
		public function useItem(pos:int=0):void
		{
			var useBag:StructBagCell2=Data.beiBao.getBeiBaoDataByPos(pos);
			if(useBag!=null){
				if(useBag.itemid==11800531){
					if(Data.myKing.level<80){
						alert.ShowMsg(Lang.getLabel("10160_beibao"),4,null,CSUseItem,pos,-1);
						return;
					}else if(Data.myKing.level>80){
						alert.ShowMsg(Lang.getLabel("10161_beibao"),2,null);
						return;
					}else{
					
					}
				}	
			}
			
			CSUseItem(pos);
		}
		
		private function CSUseItem(pos:int):void{
			if(pos!=-1){
			var cleint:PacketCSUseItem=new PacketCSUseItem();
			cleint.bagindex=pos;
			uiSend(cleint);
			}
		}

		private function useItemReturn(p:PacketSCUseItem):void
		{
			if (p == null)
				return;
			if (super.showResult(p))
			{

			}
			else
			{

			}
		}




		/**
		 *	使用道具【包裹中有自动消耗，若是没有直接扣钱】
		 */
		public function useItemAtuo(itemId:int):void
		{

			var cleint:PacketCSUseItemAutoBuy=new PacketCSUseItemAutoBuy();
			cleint.itemid=itemId;
			uiSend(cleint);
			if (itemId == 11800180)
			{
				//回城卷轴
				GameMusic.playWave(WaveURL.dj_use_juan_zhou);
			}
		}

		private function useItemAutoReturn(p:PacketSCUseItemAutoBuy):void
		{
			if (p == null)
				return;
			if (super.showResult(p))
			{

			}
			else
			{

			}

			if (0 == p.tag)
			{
				//如果边界回城成功就判断一下是否处于挂机状态，如果处于挂机状态，停止挂机	
				if (GamePlugIns.getInstance().running)
				{
					GamePlugIns.getInstance().stop();
				}
			}
		}

		/**
		 *	摆摊区域判断
		 *  2013-02-26
		 */
		private function boothEnable():void
		{
			super.uiRegister(PacketSCBoothTryOpen.id, SCBoothTryOpenReturn);
			var client:PacketCSBoothTryOpen=new PacketCSBoothTryOpen();
			super.uiSend(client);
		}

		private function SCBoothTryOpenReturn(p:PacketSCBoothTryOpen):void
		{
			if (super.showResult(p))
			{
				if (Booth.getInstance().isOpen == false)
					Booth.getInstance().setData(Data.myKing.roleID);
			}
			else
			{
				//2014-01-14 不在摆摊区域
				if (p.tag == 100001)
					alert.ShowMsg(Lang.getLabel("10184_booth", [Renwu.getChuanSongText(20320035)]), 2);
			}
		}

		/**
		 *	背包物品拖拽弹起事件
		 */
		private function dragUpHandler(e:DispatchEvent):void
		{
			var start:Object=MainDrag.currTarget;
			var end:Object=e.getInfo;

			if (start != null && start.parent == mc)
			{
				var startData:StructBagCell2=start.data;
				if (startData == null)
					return;
				if (start == end)
					return;
				if(startData.lock){
					Lang.showMsg(Lang.getClientMsg("10167_trade"));
					return;
				}
				PubData.chat.clearChatSend(startData.itemname);
				if (end.parent == mc && end.name.indexOf("item") == 0)
				{
					//背包内换位置
					if (start.data == null)
						return;
					var _loc1:int=startData.pos;
					var _loc2:int=int(end.name.replace("item", ""));
					if (_loc1 == _loc2)
					{
						return;
					}
					var p:PacketCSMoveItem=new PacketCSMoveItem();
					p.srcindex=_loc1;
					p.destindex=_loc2;
					uiSend(p);
					CtrlFactory.getUIShow().closeCurrentTip();
					return;
				}
				else if (CtrlFactory.getUICtrl().checkParent(end, "win_jue_se"))
				{
					//穿装备【主角拖拽包括伙伴】
					i=int(end.name.replace("equip_item", ""));
					if (i == 0)
						return;
					if (JiaoSeMain.getInstance().isOpen && JiaoSeMain.getInstance().type == 1)
					{
						equipOn(startData.pos, i);
					}
					return;
				}
				else if (CtrlFactory.getUICtrl().checkParent(end, "mc_hotKey"))
				{
//					//快捷栏【拖拽】
//					i=int(end.name.replace("item_hotKey",""));
//					if(i!=5&&i!=6)return;
//					Jineng.instance.selectSkill(i,startData.itemid);
//					return;
				}
				else if (CtrlFactory.getUICtrl().checkParent(end, "win_npc_shang_dian"))
				{
					//出售给系统【拖拽】
					saleToSys(startData);
					return;
				}
				else if (CtrlFactory.getUICtrl().checkParent(end, "win_cang_ku"))
				{

					//存东西到仓库【拖拽】
					i=int(end.name.replace("item", ""));
					if (i == 0)
						return;

					var cangku_pos:int=i + BeiBaoSet.STORE_PAGE_CELL_COUNT * (Store.getInstance().type - 1);

					cangku_pos=cangku_pos + (BeiBaoSet.CANGKU_INDEX - 1);

					storeOnByDrag(startData.pos, cangku_pos);
					return;
				}
				else if (CtrlFactory.getUICtrl().checkParent(end, WindowName.win_booth))
				{
					mcDoubleClickHandler(start);
					return;
				}
				else if (CtrlFactory.getUICtrl().checkParent(end, WindowName.win_jiao_yi))
				{
					mcDoubleClickHandler(start);
					return;
				}
				else
				{

				}
				switch (end.name)
				{
					case "gridLayer":
						if (startData.isTrade)
						{
							alert.ShowMsg(Lang.getLabel("10003_bao_guo", [ResCtrl.instance().getFontByColor(startData.itemname, startData.toolColor)]), 4, mc, drop, startData.pos);
						}
						else
						{
							Lang.showMsg(Lang.getClientMsg("10008_bao_guo"));
						}
						//2013-12-28 销毁废弃，改为不可丢弃
						//alert.ShowMsg(Lang.getLabel("10037_bao_guo"), 4, mc, destroyItem, startData.pos);
						break;
					case "txtChat":
					case "txt_booth_ad":
						txtChat(MainDrag.currData, end as TextField);
						break;
					default:
				}
			}
		}

		/**
		 * 帮派捐
		 */
		public function juan(value:StructBagCell2):void
		{
			if (value == null)
				return;

			var cs:PacketCSGuildGiveItem=new PacketCSGuildGiveItem();
			cs.pos=value.pos;
			uiSend(cs);

		}

		/**
		 *	出售给系统
		 *  2013-10-11
		 */
		public function saleToSys(startData:StructBagCell2):void
		{
			if (startData == null)
				return;
			if (startData.isSale == false)
			{
				Lang.showMsg(Lang.getClientMsg("10022_bao_guo"));
				return;
			}
			if (startData.toolColor == 5)
			{
				alert.ShowMsg(Lang.getLabel("10001_bao_guo"), 4, null, sale, startData);
			}
			else if (startData.toolColor == 6)
			{
				alert.ShowMsg(Lang.getLabel("10002_bao_guo"), 4, null, sale, startData);
			}
			else
			{
				sale(startData);
			}

		}

		private function sale(v:StructBagCell2):void
		{
			//2013-12-28 物品1个，直接卖出，不弹窗
			if (v.num > 1)
				NpcBuy.instance().setType(2, v);
			else
				NpcBuy.instance().sell(v.pos, 1);
		}

		public function txtChat(data:Object, tf:TextField):void
		{
			if (tf == null)
				return;
			var txt:String=tf.text;
			var i:int=0;
			var hasTool:Boolean=false;
			while (i < tf.length - 1)
			{
				i=txt.indexOf("{", i);
				if (i == -1)
					break;
				i++;
				if (txt.charAt(i) != "F")
				{
					hasTool=true;
					break;
				}
			}
			if (!hasTool)
			{
				MainChat.chatData[data.itemname]=data;
				tf.appendText("{" + data.itemname + "}");
				tf.setSelection(tf.text.length, tf.text.length);
				if (focusManager != null)
					focusManager.setFocus(tf);
			}
		}

		/**
		 *	元宝银两数值显示
		 */
		private function coinUpdate(e:DispatchEvent=null):void
		{
			//银两
			var coin1:int=Data.myKing.coin1;
			//元宝
			var coin3:int=Data.myKing.coin3;
			var coin2:int=Data.myKing.coin2;


			mc["txt_yin_liang"].text=coin1;
			mc["txt_yuan_bao_bang_ding"].text=coin2;
			mc["txt_yuan_bao"].text=coin3;
		}

		/**
		 * 包裹格子【花钱开启】
		 */
		private function bagSizeUpdate(e:DispatchEvent=null):void
		{

		}

		/**
		 *	包裹格子【升级开启】
		 */
		private function bagStartUpdate(e:DispatchEvent=null):void
		{

		}

		override protected function windowClose():void
		{
			// 面板关闭事件
			super.windowClose();
			type=0;
			if (MouseManager.instance.mouseSkinType == MouseSkinType.MouseBagSale)
			{
				MouseManager.instance.show(0);
			}

			//在窗口关闭的时候执行资源销毁
//			this.dispose();
		}

		/**
		 *	包裹显示CD冷却时间
		 */
		public static function showCD(cdKey:int, frame:int):void
		{
			//【注】为了保证组件在关闭状态下被系统垃圾回收，_instance变量会被置为NULL；
			//如果不对_instance进行判定，则每次接口调用getInstance()都会导致_instance实例被自动创建，违背了现有垃圾回收的设计方案
			if (_instance == null)
			{
				return;
			}
			var child:MovieClip;
			var i:int=0;
			if (BeiBao.getInstance().type == 1 || BeiBao.getInstance().type == 2 || BeiBao.getInstance().type == 3)
			{
				for (i=1; i <= Data.beiBao.BAG_PAGE_COUNT; i++)
				{
					child=_instance.mc.getChildByName("item" + i) as MovieClip;
					if (child != null && child.data != null && child.data is StructBagCell2 && (child.data as StructBagCell2).cooldown_id == cdKey)
					{
						//2012-10-24 
						//child.mouseEnabled=false;
						if (child["lengque"] == null)
							return;
						child["lengque"].gotoAndStop(frame);
						if (frame == 36)
						{
							child["lengque"].gotoAndStop(37);
								//child.mouseEnabled=true;
						}
					}
				}
			}
		}

		/**
		 *	摆摊 上架下架
		 *  2013-02-25
		 *  2014-04-01 交易
		 */
		public static function boothUpOrDown(pos:int, lock:Boolean):void
		{
			var child:MovieClip;
			var k:int=0;
			Data.beiBao.setBeiBaoLock(pos, lock);
			if (BeiBao.getInstance().type != 4)
			{
				for (k=1; k <= Data.beiBao.BAG_PAGE_COUNT; k++)
				{
					child=_instance.mc.getChildByName("item" + k) as MovieClip;

					if (child != null && child.data != null)
					{
						if (pos == -1)
						{
							child["mc_booth_lock"].visible=child.data.lock;
							//CtrlFactory.getUIShow().setColor(child, 1);
							continue;
						}
						if ((child.data as StructBagCell2).pos == pos)
						{
							child["mc_booth_lock"].visible=child.data.lock;
							//CtrlFactory.getUIShow().setColor(child, lock ? 2 : 1);
						}
					}
				}
			}
		}

		/****************内部调用方法**************/


		/**
		 *	换页时清理格子数据
		 */
		private function clearItem():void
		{
			if (mc == null)
			{
				trace("元件MC为空");
				return;
			}
			for (i=1; i <= BeiBaoSet.BEIBAO_MAX; i++)
			{
				child=mc.getChildByName("item" + i) as MovieClip;
				child["uil"].unload();
				ImageUtils.cleanImage(child);

				child["txt_num"].text="";
				child["select"].gotoAndStop(1);
				child["txt_star"].text="";
				child.data=null;
				ItemManager.instance().setEquipFace(child, false);
				child.mouseChildren=false;
				child.mouseEnabled=true;
				child.buttonMode=false;

				CtrlFactory.getUIShow().setColor(child, 1);

				super.itemEventRemove(child);
				//新加优化代码，清除对象监听器，保证被系统进行垃圾回收
				CtrlFactory.getUIShow().removeTip(child);
				MainDrag.getInstance().unregDrag(child);
			}
		}


		/**
		 *	获得第一页格子数量
		 */
		private function getFirstPageSize():int
		{
			var v:int=Data.myKing.BagStart;
			return 18 + (v == 18 ? 0 : v == 24 ? 6 : v == 30 ? 12 : 18);
		}

		override public function getID():int
		{
			return 1001;
		}

		/**
		 *	 计算包裹扩充格子价格
		 */
		public function gettKuoChongYuanBao(cnt:int=1):int
		{
			var ret:int=0;
			var cell:Pub_Pack_OpenResModel=XmlManager.localres.packopenXml.getResPath(Data.myKing.BagSize) as Pub_Pack_OpenResModel;
			var cellNext:Pub_Pack_OpenResModel=XmlManager.localres.packopenXml.getResPath(Data.myKing.BagSize + cnt) as Pub_Pack_OpenResModel;
			ret=cellNext.need_coin - cell.need_coin;
			return ret;
		}

		/**
		 *	 计算包裹扩充格子时间
		 *   2013-11-20
		 */
		public function gettKuoChongTime(cnt:int=1):int
		{
			var ret:int=0;
			//var  cell:Pub_Pack_OpenResModel=XmlManager.localres.packopenXml.getResPath(Data.myKing.BagEnd);
			var cellNext:Pub_Pack_OpenResModel=XmlManager.localres.packopenXml.getResPath(Data.myKing.BagSize + cnt) as Pub_Pack_OpenResModel;
			//当前扩充的格子如果时间为0，则扩充弹窗时间不显示
			if (cellNext == null || cellNext.need_time == 0)
				return 0;
			var onLine:Number=Data.myKing.onLineMinute * 60;
			var offLine:Number=Data.myKing.OfflineSecs;
			var rmbBuy:int=Data.myKing.RmbBuySecs;
			ret=cellNext.need_time - (onLine + offLine + rmbBuy);
			return ret;
		}

		/**
		 *	摆摊，商店，仓库 同时打开，层级高的执行操作
		 *  2013-03-08
		 */
		private function getBooth():String
		{
			var arr:Array=[];
			var index:int=0;
			if (Booth.getInstance().isOpen && Booth.getInstance().booth_id == Data.myKing.roleID)
			{
				index=Booth.getInstance().parent.getChildIndex(Booth.getInstance());
				arr[index]=WindowName.win_booth;
			}
			if (Store.getInstance().isOpen)
			{
				index=Store.getInstance().parent.getChildIndex(Store.getInstance());
				arr[index]=WindowName.win_cang_ku;
			}
			if (NpcShop.instance().isOpen)
			{
				index=NpcShop.instance().parent.getChildIndex(NpcShop.instance());
				arr[index]=WindowName.win_npc_shang_dian;
			}
			if (Trade.getInstance().isOpen)
			{
				index=Trade.getInstance().parent.getChildIndex(Trade.getInstance());
				arr[index]=WindowName.win_jiao_yi;
			}

			if (arr.length > 0)
				return arr[arr.length - 1];
			else
				return "";
		}

		/**
		 * 组件销毁
		 * 清除资源引用
		 */
		override public function dispose():void
		{
			this.clearItem(); //清除道具元件中的资源以及事件监听
			super.dispose(); //调用父类的销毁接口
			_instance=null; //清除当前实例，保证系统垃圾回收的顺利进行
		}

		override public function winClose():void
		{
			//0020167: 【1221】打开背包后，不再显示vip购买界面
//			if(ZhiZunHotSale.getInstance().isOpen)
//			{
//				ZhiZunHotSale.getInstance().winClose();
//			}
			if (ZhuangbeiFenjie.instance().isOpen)
			{
				ZhuangbeiFenjie.instance().winClose();
			}
//			{
//				if (_getItemBoxByID(Data.beiBao.updataItemId) != null)
//					mcDoubleClickHandler(_getItemBoxByID(Data.beiBao.updataItemId));
//			}
			MouseManager.instance.show(0);
			super.winClose();


		}
	}
}
