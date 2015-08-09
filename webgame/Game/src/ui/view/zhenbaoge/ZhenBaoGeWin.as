package ui.view.zhenbaoge
{
	import com.bellaxu.res.ResMc;

	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.config.xmlres.lib.IResModel;
	import common.config.xmlres.server.Pub_Ibshop_PageResModel;
	import common.managers.Lang;
	import common.utils.AsToJs;
	import common.utils.CtrlFactory;

	import display.components.MoreLess;
	import display.components.MoreLessPage;

	import engine.event.DispatchEvent;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Dictionary;

	import main.ProgramTest;

	import netc.Data;
	import netc.dataset.MyCharacterSet;
	import netc.packets2.StructBagCell2;
	import netc.packets2.StructTreasureGoodsInfo2;

	import nets.packets.PacketCSTreasureShopBuy;
	import nets.packets.PacketCSTreasureShopQuery;
	import nets.packets.PacketCSTreasureShopTryOn;
	import nets.packets.PacketSCTreasureShopBuy;
	import nets.packets.PacketSCTreasureShopQuery;
	import nets.packets.PacketSCTreasureShopTryOn;

	import scene.king.SkinByWin;
	import scene.music.GameMusic;
	import scene.music.WaveURL;

	import ui.base.vip.ChongZhi;
	import ui.frame.ImageUtils;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view8.YBExtractWindow;

	import world.FileManager;
	import world.model.file.BeingFilePath;

	public class ZhenBaoGeWin extends UIWindow
	{
		public static const PAGE_COUNT:int=8;
		//数据对应的标签
		private var _ver:int=0;

		private var dataCache:Dictionary=new Dictionary(true);

		private var currentItemData:StructBagCell2;
		private var currentItemDataSource:StructTreasureGoodsInfo2;
		private var currentBuyCount:int=0;
		private var tryOnItemId:int=0;
		private var tryOnPacket:PacketSCTreasureShopTryOn=null;
		private var iconLoadFromLocal:Boolean=false;
		//形象
		private var character:SkinByWin=new SkinByWin();
		private static var _instance:ZhenBaoGeWin=null;
		//坐骑预览索引
		private var currentScanPageNum:int=1;
		private var totalScanPageNum:int=1;
		//方向
		private var fangXiang:int=1;
		private var skinShiZhuang:SkinByWin;

		public function ZhenBaoGeWin()
		{
			blmBtn=6;
			super(getLink(WindowName.win_zhen_bao_ge));
			character.x=-90;
			character.y=440;
			character.mouseChildren=character.mouseEnabled=false;
			type=1;
		}

		public static function getInstance():ZhenBaoGeWin
		{
			if (_instance == null)
			{
				_instance=new ZhenBaoGeWin();
			}
			return _instance;
		}

		override public function get width():Number
		{
			return 594;
		}

		override public function get height():Number
		{
			return 567;
		}


		public function setType(v:int, must:Boolean=false, f:Function=null):void
		{
			type=v;
			super.open(must);
		}

		override protected function init():void
		{
			super.init();
			mc["mc_FanLiRi"].visible=PubData.isShowAD;
			mc["mc_DaFangSong"].visible=PubData.isStartGoldFree1;
			mc["mc_ChongZhiFanLiRi"].visible=PubData.isStartGoldFree2;
			super.sysAddEvent(Data.myKing, MyCharacterSet.COIN_UPDATE, coinUpdate);
			super.sysAddEvent(mc["ui_page"], MoreLessPage.PAGE_CHANGE, changePage);
			this.uiRegister(PacketSCTreasureShopQuery.id, onGetItemListCallback);
			this.uiRegister(PacketSCTreasureShopBuy.id, onItemBuyCallback);
			this.uiRegister(PacketSCTreasureShopTryOn.id, onItemTryOnCallback);
			this.mc["mcBuyPanel"].visible=false;
			this.mc["mcTryOnPanel"].visible=false;
			this.character.visible=false;
			this.mc["mcTryOnPanel"]["petC"].visible=false;
			this.reset();
			coinUpdate();
			this.mcHandler({name: "cbtn" + type});
		}

		override public function open(must:Boolean=false, type:Boolean=true):void
		{
			super.open(must, type);
		}

		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var targetName:String=target.name;
			if (targetName.indexOf("cbtn") == 0)
			{
				var index:int=int(targetName.replace("cbtn", ""));
//				if (index!=type){
				type=index;
				this.curPage=0;
				this.total=0;
				this.getItemList();
//				}
				return;
			}
			if (targetName == "btnBuy")
			{
				this.currentItemData=target.parent.data;
				this.currentItemDataSource=target.parent.data1;
//				this.showItemBuyPanel();
				this.currentBuyCount=target.parent["ui_count"].value;

				//2014-07-29
				if (this.type == 6)
				{
					AsToJs.callJS("payment", this.currentItemDataSource.ibs);
					return;
				}

				this.buyItem();
				return;
			}

//			var inf:StructTreasureGoodsInfo2 = null;
//			if (targetName.indexOf("item_")==0){
//				this.mc["btnPrev"].visible=this.mc["btnNext"].visible=false;
//				this.totalScanPageNum = this.currentScanPageNum = 1;
//				inf = StructTreasureGoodsInfo2(target.data1);
//				if (inf.isshow==1){
//					if (inf.showid==0){
//						tryOnItemId = inf.itemid;
//						this.iconLoadFromLocal = false;
//						this.updateScanNumInfo();
//					}else{
//						tryOnItemId = inf.showid;
//						this.iconLoadFromLocal = true;
//					}
//					this.tryOn();
//				}else{
//					tryOnItemId = -1;
//					this.hideTryOnPanel();
//				}
//				return;
//			}
//			if (target.parent && target.parent.name.indexOf("item_")==0){
//				this.mc["btnPrev"].visible=this.mc["btnNext"].visible=false;
//				this.totalScanPageNum = this.currentScanPageNum = 1;
//				inf = StructTreasureGoodsInfo2(target.parent.data1);
//				if (inf.isshow==1){
//					if (inf.showid==0){
//						tryOnItemId = inf.itemid;
//						this.iconLoadFromLocal = false;
//						this.updateScanNumInfo();
//					}else{
//						tryOnItemId = inf.showid;
//						this.iconLoadFromLocal = true;
//					}
//					this.tryOn();
//				}else{
//					tryOnItemId = -1;
//					this.hideTryOnPanel();
//				}
//				return;
//			}

			switch (targetName)
			{
				case "mc_DaFangSong":
					flash.net.navigateToURL(new URLRequest(Lang.getLabel("QQ_Raffle_free_url")), "_blank");
					break;
				case "mc_ChongZhiFanLiRi":
					flash.net.navigateToURL(new URLRequest(Lang.getLabel("QQ_Raffle_free_url")), "_blank");
					break;
				case "btnSub":
					if (this.currentBuyCount > 1)
					{
						this.currentBuyCount--;
						this.mc["mcBuyPanel"]["tNum"].text=this.currentBuyCount.toString();
						this.mc["mcBuyPanel"]["tPrice"].text=(this.currentItemDataSource.ibs * this.currentBuyCount) + XmlRes.GetMoneyNameById(this.currentItemData.moneyType);
					}
					break;
				case "btnAdd":
					this.currentBuyCount++;
					this.mc["mcBuyPanel"]["tNum"].text=this.currentBuyCount.toString();
					this.mc["mcBuyPanel"]["tPrice"].text=(this.currentItemDataSource.ibs * this.currentBuyCount) + XmlRes.GetMoneyNameById(this.currentItemData.moneyType);
					break;
				case "btnMax":
					break;
				case "btnChongZhi":
					ChongZhi.getInstance().open(true);
					break;
				case "btnYBExtract": //提取元宝
					if (!YBExtractWindow.getInstance().isOpen)
					{
						YBExtractWindow.getInstance().open();
					}
					else
					{
						YBExtractWindow.getInstance().winClose();
					}
					break;
				case "yuLanBtn":
					var showid:int=target.parent["showid"];
					var sex:int=target.parent["sex"];
					tryOn(showid, sex); //时装预览
					break;
				case "rightBtn":
					var showid1:int=target.parent["showid"];
					fangXiang--;
					if (fangXiang < 1)
					{
						fangXiang=8;
					}
					if (skinShiZhuang.getRole()) //切换方向
					{
						skinShiZhuang.setAction("F"+fangXiang);
					}
					break;
				case "leftBtn":
					var showid2:int=target.parent["showid"];
					fangXiang++;
					if (fangXiang > 8)
					{
						fangXiang=1;
					}
					if (skinShiZhuang.getRole()) //切换方向
					{
						skinShiZhuang.setAction("F"+fangXiang);
					}
					break;
				default:
					break;
			}
		}

		/**
		 * 更新与坐骑预览相关的数据
		 */
		private function updateScanNumInfo():void
		{
			this.currentScanPageNum=1;
			this.iconLoadFromLocal=false;
			if (this.iconLoadFromLocal == false)
			{
				if (this.tryOnItemId > 0)
				{
					this.totalScanPageNum=XmlManager.localres.getToolsXml.getResPath(this.tryOnItemId)["strong_maxlevel"];
				}
			}
		}

		/**
		 *	元宝银两数值显示
		 */
		private function coinUpdate(e:DispatchEvent=null):void
		{
			//元宝
			var coin3:int=Data.myKing.coin3;
			var coin2:int=Data.myKing.coin2;

			mc["tYuanBaoBind"].text=coin2;
			mc["tYuanBao"].text=coin3;
		}

		private function getItemList():void
		{
			var p:PacketCSTreasureShopQuery=new PacketCSTreasureShopQuery();
			p.type=type;
			p.ver=_ver;
			uiSend(p);
		}

		/**
		 * 获取物品列表
		 */
		private function onGetItemListCallback(p:PacketSCTreasureShopQuery):void
		{
			if (p.type != this.type)
				return;
			if (this._ver != p.ver)
			{
				//更新缓存的数据
				var tempList:Vector.<StructTreasureGoodsInfo2>=p.arrItemgoodslist;
				this.dataCache[type]=tempList;
			}
			this.curPage=1;
			var dataList:Vector.<StructTreasureGoodsInfo2>=this.dataCache[type];
			if (dataList == null)
			{
				this.count=0;
			}
			else
			{
				this.count=this.dataCache[type].length;
			}
			this.total=Math.ceil(count / PAGE_COUNT);
			if (total == 0)
			{
				total=1;
			}
			mc["ui_page"].setMaxPage(this.curPage, this.total);
			this.updateItemData();
		}

		/**
		 * 初始化道具信息
		 */
		private function updateItemData():void
		{
			var sourceList:Vector.<StructTreasureGoodsInfo2>=this.dataCache[type];
			var len:int=0;
			if (sourceList != null)
			{
				len=sourceList.length;
			}
			var fromIndex:int=(this.curPage - 1) * PAGE_COUNT;
			var endIndex:int=this.curPage * PAGE_COUNT;
			if (endIndex > len)
			{
				endIndex=len;
			}
			var info:StructTreasureGoodsInfo2;
			var mcGrid:MovieClip;
			var cell:StructBagCell2;
			var dataIndex:int=0;
			for (var i:int=1; i <= PAGE_COUNT; i++)
			{
				dataIndex=fromIndex + (i - 1);
				if (sourceList == null || sourceList.length <= dataIndex)
				{
					info=null;
				}
				else
				{
					info=sourceList[dataIndex];
				}
				mcGrid=this.mc["item_" + i];
				(mcGrid["ui_count"] as MoreLess).showCount(1);



				if (info == null)
				{
					mcGrid.visible=false;
					mcGrid.data=null;
					CtrlFactory.getUIShow().removeTip(mcGrid);
				}
				else
				{
					//预览按钮是否显示
					if (info.isshow == 1)
					{
						mcGrid["yuLanBtn"].visible=true;
					}
					else
					{
						mcGrid["yuLanBtn"].visible=false;
					}
					mcGrid.visible=true;
					cell=new StructBagCell2();
					cell.itemid=info.itemid;
					Data.beiBao.fillCahceData(cell);
					cell.moneyType=info.moneytype;
					mcGrid["showid"]=info.showid;
					mcGrid["sex"]=cell.sex;
					mcGrid["mc_money_icon1"].gotoAndStop(cell.moneyType);
					mcGrid["mc_money_icon2"].gotoAndStop(cell.moneyType);
//					mcGrid["uil"].source = cell.iconBig;
					ImageUtils.replaceImage(mcGrid, mcGrid["uil"], cell.iconBig);

					mcGrid["tName"].text=cell.itemname;
					mcGrid["tfOldPrice"].text=info.ib;
					mcGrid["tfNowPrice"].text=info.ibs;
					mcGrid["txt_num"].text=info.num > 1 ? info.num : "";
					MovieClip(mcGrid["mcDiscount"]).gotoAndStop(info.sign + 1); //打折
					mcGrid["mcLine"].width=mcGrid["tfOldPrice"].textWidth;
					mcGrid["data"]=cell;
					mcGrid.data=cell;
					mcGrid.data1=info;
					CtrlFactory.getUIShow().addTip(mcGrid);
				}
			}
		}

		private function showItemBuyPanel():void
		{
			if (this.mc["mcBuyPanel"].visible == false)
			{
				this.mc["mcBuyPanel"].visible=true;
			}
			var pane:MovieClip=this.mc["mcBuyPanel"];
//			pane["uil"].source = this.currentItemData.iconBig;

			ImageUtils.replaceImage(pane, pane["uil"], this.currentItemData.iconBig);

			pane["tName"].text=this.currentItemData.itemname;
			pane["tNum"].text="1";
			pane["tPrice"].text=this.currentItemDataSource.ibs + XmlRes.GetMoneyNameById(this.currentItemData.moneyType);
			this.currentBuyCount=1;
		}

		private function buyItem():void
		{
			var m_buyCount:int=1;
			if (ProgramTest.canBuyCount > 0)
			{
				m_buyCount=ProgramTest.canBuyCount;
			}
			while (0 < m_buyCount--)
			{
				var p:PacketCSTreasureShopBuy=new PacketCSTreasureShopBuy();
				p.goodsid=this.currentItemDataSource.goodsid;
				p.cnt=this.currentBuyCount;
				this.uiSend(p);
			}
		}

		private function onItemBuyCallback(p:PacketSCTreasureShopBuy):void
		{
			if (Lang.showResult(p))
			{
				//关闭购买界面？
				this.mc["mcBuyPanel"].visible=false;
			}
		}

		/**
		 * 试穿
		 */
		private function tryOn(showid:int, sex:int):void //str:String = "F1", bool:Boolean = true):void   //
		{
			if (this.mc["mcTryOnPanel"].visible == false)
			{
				this.mc["mcTryOnPanel"].visible=true;
				this.mc["mcTryOnPanel"]["petC"].visible=true;
				skinShiZhuang=new SkinByWin("F1");
				var path:BeingFilePath=FileManager.instance.getMainByHumanId(Data.myKing.king.s0, 0, showid, Data.myKing.king.s3, sex);
				path.rightHand = FileManager.instance.getRightHand(Data.myKing.metier);
				skinShiZhuang.setSkin(path);
				while (this.mc["mcTryOnPanel"]["petC"].numChildren > 0)
				{
					this.mc["mcTryOnPanel"]["petC"].removeChildAt(0);
				}
				this.mc["mcTryOnPanel"]["petC"].addChild(skinShiZhuang);
			}
			else
			{
//				if(bool)
//				{
				this.mc["mcTryOnPanel"].visible=false;
//				}
			}
//			this.mc["mcTryOnPanel"]["petC"].visible=true;
//			var skin:Sprite=FileManager.instance.getWindowSkinUrl(Data.myKing.king.s0, Data.myKing.king.s1, showid, Data.myKing.king.s3, 
//				                Data.myKing.king.sex, Data.myKing.king.metier, Data.myKing.king.roleID, 0);
//			skinShiZhuang.scaleX = 1.2;
//			skinShiZhuang.scaleY = 1.2;
//			trace("================",skin);
//			trace("================",skin.getChildAt(0).name, skin.getChildAt(1).name);
//			(skin.getChildAt(0) as MovieClip).gotoAndPlay("D2F2");
//			(skin.getChildAt(1) as MovieClip).gotoAndPlay("D2F2");
//			(Data.myKing.king.s0 as MovieClip).gotoAndPlay("D2F2");
//			this.mc["mcTryOnPanel"]["petC"].addChild(Data.myKing.king.);
//			var skin:Sprite=FileManager.instance.getWindowSkinUrl(Data.myKing.s0, Data.myKing.s1, showid, Data.myKing.s3, Data.myKing.sex, Data.myKing.metier, Data.myKing.roleID, 0);
		/*if (this.mc["mcTryOnPanel"].visible == false)
		{
			this.mc["mcTryOnPanel"].visible=true;
		}
		this.mc["btnPrev"].visible=this.mc["btnNext"].visible=this.totalScanPageNum > 1;
		if (this.totalScanPageNum > 1)
		{
			this.mc["btnPrev"].gotoAndStop(2);
			this.mc["btnNext"].gotoAndStop(1);
		}
		if (this.iconLoadFromLocal)
		{
			character.visible=false;
			this.mc["petC"].visible=true;
//				this.mc["petC"].source=FileManager.instance.getPetSkinById(this.tryOnItemId);
			ImageUtils.replaceImage(mc,mc["petC"],FileManager.instance.getPetSkinById(this.tryOnItemId));
			return;
		}
		this.mc["petC"].visible=false;
		var list:Vector.<int>=new Vector.<int>();
		list.push(this.tryOnItemId);
		var p:PacketCSTreasureShopTryOn=new PacketCSTreasureShopTryOn();
		p.arrItemitemids=list;
		this.uiSend(p);*/
		}

		/**
		 * 隐藏试穿界面
		 */
		private function hideTryOnPanel():void
		{
			this.mc["mcTryOnPanel"].visible=false;
			this.character.visible=false;
			this.mc["petC"].visible=false;
			this.mc["petC"].unload();
			this.currentScanPageNum=this.totalScanPageNum=1;
		}

		private function onItemTryOnCallback(p:PacketSCTreasureShopTryOn):void
		{
			this.tryOnPacket=p;
			var s0:int=p.s0;
			var s1:int=p.s1;
			var s2:int=p.s2;
			var s3:int=p.s3;
			var r1:int=p.r1;
			var sex:int=Data.myKing.sex;
			var bp:BeingFilePath=this.getSkinConfig(s0, s1, s2, s3, sex);
			if (character.parent == null)
			{
				this.mc.addChild(character);
			}
			else
			{
				character.visible=true;
			}
			character.setSkin(bp);
		}

		private function getSkinConfig(s0:int, s1:int, s2:int, s3:int, sex:int):BeingFilePath
		{
			var key:String=s0 + "_" + s1 + "_" + s2 + "_" + s3 + "_" + sex;
			var p:BeingFilePath=dataCache[key];
			if (p == null)
			{
				p=FileManager.instance.getMainByHumanId(s0, s1, s2, s3, sex);
				dataCache[key]=p;
			}
			return p;
		}

		/**
		 *	翻页 【商品列表】
		 */
		private function changePage(e:DispatchEvent=null):void
		{
			super.curPage=e.getInfo.count;
			this.updateItemData();
		}

		private var tabInited:Boolean=false;

		private function reset():void
		{
			var mcGrid:MovieClip;
			if (tabInited == false)
			{
				tabInited=true;
//				var tabList:XMLList=XmlManager.localres.ibShopPageXml.contentXml.C_Pub_Ibshop_Page;
				var tabList:Array=XmlManager.localres.ibShopPageXml.contentData.contentXml;
				var resModel:Pub_Ibshop_PageResModel;
				var page_id:int;
				var page_name:String;
				var page_switch:int;
				var btnTab:Object;
				var tabCount:int=0;
				var startX:int=59;
				var startY:int=48;
				for each (var xml:IResModel in tabList)
				{
					page_id=xml["page_id"];
					page_name=xml["page_name"];
					page_switch=xml["page_switch"];
					btnTab=this.mc["cbtn" + page_id];
					btnTab.label=page_name;
					btnTab.visible=page_switch == 1;
					if (btnTab.visible == true)
					{
						btnTab.x=startX;
						startX+=btnTab.width + 2;
					}
					tabCount++;
				}

				for (var index:int=tabCount + 1; index < 7; index++)
				{
					btnTab=this.mc["cbtn" + index];
					btnTab.visible=false;
				}
			}

			for (var i:int=1; i <= PAGE_COUNT; i++)
			{
				mcGrid=this.mc["item_" + i];
				mcGrid["mcLine"].mouseChildren=false;
				mcGrid["uil"].mouseChildren=false;
				mcGrid.visible=false;
				mcGrid.data=null;
				CtrlFactory.getUIShow().removeTip(mcGrid);
				(mcGrid["ui_count"] as MoreLess).showCount(1);
			}
//			this.mc["btnPrev"].visible=this.mc["btnNext"].visible=false;
			this.currentScanPageNum=this.totalScanPageNum=1;
		}

		private function getFangXiangStr(num:int):String
		{
			var str:String;
			switch (num)
			{
				case 1:
					str="F1";
					break;
				case 2:
					str="F2";
					break;
				case 3:
					str="F3";
					break;
				case 4:
					str="F4";
					break;
				case 5:
					str="F5";
					break;
				case 6:
					str="F6";
					break;
				case 7:
					str="F7";
					break;
				case 8:
					str="F8";
					break;
			}
			return str;
		}

		override public function winClose():void
		{
			super.winClose();
			type=1;
			GameMusic.playWave(WaveURL.ui_welcome_next);
		}
	}
}
