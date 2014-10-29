package ui.view.shihuang
{
	import common.config.xmlres.GameData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.clock.GameClock;
	import common.utils.res.ResCtrl;
	
	import display.components.MoreLessPage;
	
	import engine.event.DispatchEvent;
	import engine.load.GamelibS;
	import engine.support.IPacket;
	import engine.utils.HashMap;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.*;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import ui.base.mainStage.UI_index;
	import ui.base.npc.NpcShop;
	import ui.base.vip.VipGift;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view1.fuben.FuBen;
	import ui.view.view6.Alert;
	
	import world.FileManager;
	import world.WorldEvent;
	
	/**
	 * 
	 * 副本id：20220040
		show_sort：3
		instancesort：14
 
	 */ 
	public class ShiHuangMoKu extends UIWindow
	{
		public static const INSTANCE_ID:int = 20220040;
		
//		11800321	始皇魔窟初级弓箭手	
//		11800322	护镜碎片高级弓箭手
		
		public static const ITEM31:int = 11800321;
		public static const ITEM32:int = 11800322;
		
		public static const goods1:int = 1000026;
		public static const goods2:int = 1000027;
		
		public static const LIMIT_ID:int = 89000087;
		
		/**
		 * 最大次数
		 */		
		public var maxNum:int;
		public var curNum:int;
		
		public static var ExpP:PacketSCGetDenExpValue2 = new PacketSCGetDenExpValue2();;
		
		public static var ExpP3:int = 0;
		
		public static function get INSTANCE_DATA():Pub_InstanceResModel
		{		
			return XmlManager.localres.getInstanceXml.getResPath(INSTANCE_ID) as Pub_InstanceResModel;
		}
		
		public function get bag():StructBagCell2
		{
		
			if(INSTANCE_DATA.item_id > 0){
				var _bag:StructBagCell2=new StructBagCell2();
				_bag.itemid=INSTANCE_DATA.item_id;
				_bag.num=INSTANCE_DATA.item_num;
				Data.beiBao.fillCahceData(_bag);
				
				//
//				var count:int = Data.beiBao.getBeiBaoCountById(itemData.item_id);
//				
//				if(count >= itemData.item_num)
//				{
//					
//					sprite["txt_enter_req"].htmlText =Lang.getLabel("FuBenMain_need_item_enough",[count,itemData.item_num,bag.itemname]);
//					
//				}else{
//					
//					sprite["txt_enter_req"].htmlText =Lang.getLabel("FuBenMain_need_item_not_enough",[count,itemData.item_num,bag.itemname]);
//				}
				
				return _bag;
				
			}
			
			return null;
		
		
		}
		
		
		private static var m_instance:ShiHuangMoKu;
		public static function get instance():ShiHuangMoKu
		{
			if (null == m_instance)
			{
				m_instance= new ShiHuangMoKu();
			}
			return m_instance;
		}
		
		public const AutoRefreshSecond:int = 60;
		private var _curAutoRefresh:int=0;
		private var _spContent:Sprite;
		protected function get spContent():Sprite
		{
			if(null == _spContent)
			{
				_spContent = new Sprite();
			}
			return _spContent;
		}
		
		public function ShiHuangMoKu()
		{
			blmBtn = 0;
			type = 0;
//			super(getLink(WindowName.win_shi_huang_mo_ku));
		}
		
		public function setType(v:int,must:Boolean=false):void{			
			type=v;
			super.open(must);
		}
		
		override protected function init():void
		{
			if(type==0)type=1;
			(mc as MovieClip).gotoAndStop(type);
			
			_regCk();
			_regPc();
			_regDs();
			
			//
			this.getData();
			
			refresh();
		}
		
		private function _regCk():void
		{
			_curAutoRefresh = 0;
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,daoJiShi);
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,daoJiShi);
		}
		
		private function daoJiShi(e:WorldEvent):void
		{
			_curAutoRefresh++;
			if(_curAutoRefresh >=AutoRefreshSecond)
			{
				_curAutoRefresh=0;
				//你的代码
			}
		}
		
		
		private function _regPc():void
		{
			//
			uiRegister(PacketSCGetDenExpValue.id,SCGetDenExpValue);
			uiRegister(PacketSCGetDenExp.id,SCGetDenExp);
			
			//
			uiRegister(PacketSCCallBack.id,SCCallBack);
			
			//
			uiRegister(PacketSCTreasureShopBuy.id,SCTreasureShopBuy);
			
			//
			uiRegister(PacketSCPlayerInstanceInfo.id, SCPlayerInstanceInfo);
			uiRegister(PacketSCSInstanceSweep.id, SCSInstanceSweep);
			uiRegister(PacketSCSInstanceStart.id,SCSInstanceStart);
			
			
		}
		
		/**
		 * 是否领取过免费弓箭手
		 */ 
		public var isLinQuGongJianShou:Boolean = false;
		
		/**
		 * 是否刷新过怪物
		 */ 
		public var isShuangXingGuaiWu:Boolean = false;
		
		public function SCCallBack(p:PacketSCCallBack2):void
		{
		
			switch(p.callbacktype)
			{
				
				case 100017401:
					
//					SendCallBack(userid, 100017401, {0,0}, {})
//					--{0,0} 第一个参数是否领取过免费弓箭手 1为已领取 0为未领取
//					--{0,0} 第二个参数为获得的经验
					
					if(0 == p.arrItemintparam[0].intparam)
					{
						isLinQuGongJianShou = false;
					}
					else
					{
						isLinQuGongJianShou = true;
					}
					
					ExpP3 = p.arrItemintparam[1].intparam;
					
					break;
			
			
				case 100017402:
					//免费领取弓箭手
					//SendCallBack(userid, 100017402, {0}, {})
					//--{0} 第一个参数是msgid，代表错误编号

					if(0 == p.arrItemintparam[0].intparam)
					{
						
						//
						this.isLinQuGongJianShou = true;
						
					}else
					{
						Lang.showResult({tag:p.arrItemintparam[0].intparam});
					}
					break;
			
			
				case 100017403:
					
//					100017403 then--开始刷新怪物
//					SendCallBack(userid, 100017403, {0}, {})
//					--{0} 第一个参数是msgid，代表错误编号
					
					if(0 == p.arrItemintparam[0].intparam)
					{
						
						this.isShuangXingGuaiWu = true;
						
						this.winClose();
						
					}else
					{
						Lang.showResult({tag:p.arrItemintparam[0].intparam});
					}
					
					break;
			
			
				case 100017404:
					
//					--param1为购买的弓箭手id
//					print(param1)
//					
//					SendCallBack(userid, 100017404, {0}, {})
//					--{0} 第一个参数是msgid，代表错误编号
					
					if(0 == p.arrItemintparam[0].intparam)
					{
												
					}else
					{
						Lang.showResult({tag:p.arrItemintparam[0].intparam});
					}
					
					break;
			
			
			
			
			}
		
			//
			this.refresh();
			
		}
		
		private function SCTreasureShopBuy(p:PacketSCTreasureShopBuy):void
		{
			if (Lang.showResult(p))
			{
				//关闭购买界面？
				//this.mc["mcBuyPanel"].visible=false;
			}
		}
		
		public function SCGetDenExpValue(p:PacketSCGetDenExpValue2):void
		{
			ExpP = p;
			
						if(p.hasOwnProperty('tag'))
			{
				if(super.showResult(p)){
					
					this.refresh();
					
				}else{
					
				}
				
			}
		}
		
		public function SCGetDenExp(p:PacketSCGetDenExp2):void
		{
						if(p.hasOwnProperty('tag'))
			{
				if(super.showResult(p)){
					
					this.getData();
					
				}else{
					
				}
				
			}
		}
		
		private function SCPlayerInstanceInfo(p:IPacket):void
		{
			var value:PacketSCPlayerInstanceInfo=p as PacketSCPlayerInstanceInfo;
			FuBen.siiVec=value.arrIteminstanceinfo;
			
			this.refresh();
			
		}
		
		//SCSInstanceSweep
		private function SCSInstanceSweep(p:PacketSCSInstanceSweep2):void
		{
			//播特效
			if (0 == p.tag)
			{
				if (2 == p.sort)
				{
					this.refresh();
				}
				
			}
		}
		
		private function SCSInstanceStart(p:PacketSCSInstanceStart2):void
		{
			if(p.hasOwnProperty('tag'))
			{
				if(super.showResult(p)){
					
					this.winClose();
					
				}else{
					
				}
				
			}
		}
		
		public function getData():void
		{
			var cs:PacketCSGetDenExpValue = new PacketCSGetDenExpValue();
			uiSend(cs);
			
			var cs1:PacketCSCallBack = new PacketCSCallBack();
			cs1.callbacktype = 100017401;
			uiSend(cs1);
			
		}
		
		
		
		private function _regDs():void
		{
		}
		
		
//		public function txt_focus_in(e:FocusEvent):void
//		{
//			e.target.text = '';
//		}
		
		
		public function refresh():void
		{
			_refreshTf();
			_refreshMc();
			_refreshSp();
			_refreshRb();
		}
		
		private function _refreshMc():void
		{
			if(1 == (mc as MovieClip).currentFrame)
			{
				//
				var arr:Vector.<Pub_DropResModel>=XmlManager.localres.getDropXml.getResPath2(INSTANCE_DATA.dropid) as Vector.<Pub_DropResModel>;
				
				//
				var itemList:Array = [];
				
				for(var j:int=0;j<arr.length;j++)
				{
					itemList.push(arr[j].drop_item_id);
				}
				
				//
				showPicByItemId1(itemList,[0],mc);
			
			}
			
			
			if(3 == (mc as MovieClip).currentFrame)
			{
				
				//mc_item31
				//mc_item32
				this.showPicByItemId31([ITEM31],[0],mc);
				this.showPicByItemId32([ITEM32],[0],mc);
				
				
				
			
			}
		}
		
		private function callbackByList(itemData:Pub_InstanceResModel, index:int,sprite:DisplayObject=null):void
		{
			
			if(null == sprite)
			{
				sprite =mc;
			}			
			
			//super.itemEvent(sprite,itemData);
			//sprite["name"]="item"+(index+1);
			
			//
			var sii:StructPlayerInstanceInfo2;
			
			for each (var spii:StructPlayerInstanceInfo2 in FuBen.siiVec)
			{
				if (spii.instanceid == itemData.instance_id)
				{
					sii=spii;
					break;
				}
			}
			
			var limit:Pub_Limit_TimesResModel=XmlManager.localres.limitTimesXml.getResPath(LIMIT_ID) as Pub_Limit_TimesResModel;//itemData.instance_times);
			
			//sprite["txt_fuben"].text=itemData.instance_name;
			
			curNum=(sii == null ? 0 : sii.curnum);
			maxNum=(limit != null ? limit.max_times : 1);
			
			
			
			
		}
		
		private function _refreshTf():void
		{
			
			
			if(1 == (mc as MovieClip).currentFrame)
			{
				//
				callbackByList(INSTANCE_DATA,0);
				
				
				mc['txt_11'].htmlText = Lang.getLabel("1000000_ShiHuang_txt_11",[maxNum-curNum]);
				mc['txt_12'].htmlText = Lang.getLabel("1000000_ShiHuang_txt_12");
				
				(mc['txt_11'] as TextField).selectable = false;
				mc['txt_12'].selectable = false;
				
				
				if(0 == ExpP.exp)
				{
					mc['txt_12'].visible = false;
				}
				else
				{
					mc['txt_12'].visible = true;
				}
			}
			
			
			if(2 == (mc as MovieClip).currentFrame)
			{
				mc['txt_20'].htmlText = Lang.getLabel("1000000_ShiHuang_free_linqu");
				mc['txt_21'].htmlText = Lang.getLabel("1000000_ShiHuang_2_bei_linqu",[XmlManager.localres.ExpActionPrizeXml.getResPath(2)["need_coin3"].toString()]);
				mc['txt_22'].htmlText = Lang.getLabel("1000000_ShiHuang_3_bei_linqu",[XmlManager.localres.ExpActionPrizeXml.getResPath(3)["need_coin3"].toString()]);
				mc['txt_23'].htmlText = Lang.getLabel("1000000_ShiHuang_4_bei_linqu",[XmlManager.localres.ExpActionPrizeXml.getResPath(4)["need_coin3"].toString()]);
				mc['txt_24'].htmlText = Lang.getLabel("1000000_ShiHuang_5_bei_linqu",[XmlManager.localres.ExpActionPrizeXml.getResPath(5)["need_coin3"].toString()]);
			
				mc['txt_20'].selectable = false;
				mc['txt_21'].selectable = false;
				mc['txt_22'].selectable = false;
				mc['txt_23'].selectable = false;
				mc['txt_24'].selectable = false;
				
				//
				mc['txt_exp21'].text = ExpP.exp.toString();
				
			}
			
			if(3 == (mc as MovieClip).currentFrame)
			{				
				//
				if(!this.isLinQuGongJianShou)
				{
					mc['mc_3'].gotoAndStop(1);
				}
				else if(this.isLinQuGongJianShou && !this.isShuangXingGuaiWu)
				{
					mc['mc_3'].gotoAndStop(2);
				}
				else
				{
					mc['mc_3'].gotoAndStop(3);
					
					//
					mc['mc_3']['txt_exp31'].text = ExpP3.toString();
					
					//
					mc['mc_3']['txt_20'].htmlText = Lang.getLabel("1000000_ShiHuang_free_linqu");
					mc['mc_3']['txt_21'].htmlText = Lang.getLabel("1000000_ShiHuang_2_bei_linqu",[XmlManager.localres.ExpActionPrizeXml.getResPath(2)["need_coin3"].toString()]);
					mc['mc_3']['txt_22'].htmlText = Lang.getLabel("1000000_ShiHuang_3_bei_linqu",[XmlManager.localres.ExpActionPrizeXml.getResPath(3)["need_coin3"].toString()]);
					mc['mc_3']['txt_23'].htmlText = Lang.getLabel("1000000_ShiHuang_4_bei_linqu",[XmlManager.localres.ExpActionPrizeXml.getResPath(4)["need_coin3"].toString()]);
					mc['mc_3']['txt_24'].htmlText = Lang.getLabel("1000000_ShiHuang_5_bei_linqu",[XmlManager.localres.ExpActionPrizeXml.getResPath(5)["need_coin3"].toString()]);
					
					mc['mc_3']['txt_20'].selectable = false;
					mc['mc_3']['txt_21'].selectable = false;
					mc['mc_3']['txt_22'].selectable = false;
					mc['mc_3']['txt_23'].selectable = false;
					mc['mc_3']['txt_24'].selectable = false;
				}
			}
			
			//
			addTextColor();
			
		}
		
		private function _refreshSp():void
		{
		}
		
		private function _refreshRb():void
		{
		}
		
		private function buyItem(tool:Pub_ToolsResModel):void
		{
//			var cs:PacketCSCallBack = new PacketCSCallBack();
//			cs.callbacktype = 100017404;
//			cs.callbackparam1 = tool.tool_id;
//			uiSend(cs);
			
			var cs:PacketCSItemBuy = new PacketCSItemBuy();
			cs.itemid = tool.tool_id;
			cs.num = 1;
			uiSend(cs);
		}
		
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var target_name:String=target.name;
			
			if (target_name == "btnBuy")
			{
				//this.currentItemData=target.parent.data;
				//this.currentItemDataSource=target.parent.data1;
				
				//this.currentBuyCount=this.currentItemDataSource.num;
				this.buyItem(target.parent.data);
				return;
			}
			
			//元件点击
			switch (target_name)
			{
				
				case 'btn21':
					
					break;
				
				case 'btn22_back':
					
					(this.mc as MovieClip).gotoAndStop(1);
					refresh();
					
					break;
				
				case 'txt_11':
										//var p0:Packetxx = new Packetxx();
					//uiSend(p0);
					
					
					var client1:PacketCSSInstanceStart=new PacketCSSInstanceStart();
					client1.map_id=INSTANCE_DATA.instance_id;
					//client1.map_diff = this._selNanDuLvl-1;
					
					this.uiSend(client1);
					break;
				case 'txt_12':
										//var p1:Packetxx = new Packetxx();
					//uiSend(p1);
					
					(this.mc as MovieClip).gotoAndStop(2);
					refresh();
					
					
					break;
				
				case 'txt_20':
					
					var linQu0:PacketCSGetDenExp = new PacketCSGetDenExp();
					linQu0.multiple = 1;
					uiSend(linQu0);
					
					break;
				
				case 'txt_21':
					var linQu1:PacketCSGetDenExp = new PacketCSGetDenExp();
					linQu1.multiple = 2;
					uiSend(linQu1);
					
					break;
				
				case 'txt_22':
					var linQu2:PacketCSGetDenExp = new PacketCSGetDenExp();
					linQu2.multiple = 3;
					uiSend(linQu2);
					
					break;
				
				case 'txt_23':
					var linQu3:PacketCSGetDenExp = new PacketCSGetDenExp();
					linQu3.multiple = 4;
					uiSend(linQu3);
					
					break;
				
				case 'txt_24':
					var linQu4:PacketCSGetDenExp = new PacketCSGetDenExp();
					linQu4.multiple = 5;
					uiSend(linQu4);
					
					break;
				
				case 'btn3_1':
					
					var cs31:PacketCSCallBack = new PacketCSCallBack();
					cs31.callbacktype = 100017402;
					uiSend(cs31);
					
					break;
				
				case 'btn3_2':
					
					var cs32:PacketCSCallBack = new PacketCSCallBack();
					cs32.callbacktype = 100017403;
					uiSend(cs32);
					
					break;
				
				case 'btnExit':
					
					
					UI_index.instance.mcHandler({name:"tuichufuben"});
					
					//
					this.isLinQuGongJianShou = false;
					this.isShuangXingGuaiWu = false;
					
					this.winClose();					
					
					break;
				
				default:
					break;
			}
		}
		
		/**
		 * 不显示数量，不显示悬浮
		 */ 
		public function showPicByItemId1(itemArr:Array,numArr:Array,container:DisplayObjectContainer):void
		{
			var item:Pub_ToolsResModel;
			arrayLen=itemArr.length;
			var iLen:int = 1;
			var k:int = 1;
			for(i=1;i<=iLen;i++)
			{
					item=null;
					child=container['pic'+ k.toString() + i.toString(16)];
							
					if(i<=arrayLen)
						item=GameData.getToolsXml().getResPath(itemArr[i-1]) as Pub_ToolsResModel;
					if(item!=null){
//						child['uil'].source=FileManager.instance.getIconSById(item.tool_icon);
						ImageUtils.replaceImage(child,child["uil"],FileManager.instance.getIconSById(item.tool_icon));
						//child['txt_num'].text=VipGift.getInstance().getWan(numArr[i-1]);
						var bag_:StructBagCell2=new StructBagCell2();
						bag_.itemid=item.tool_id;
						bag_.num=numArr[i-1];
						Data.beiBao.fillCahceData(bag_);
						child.data=bag_;
						//CtrlFactory.getUIShow().addTip(child);
						ItemManager.instance().setEquipFace(child);
						child.visible = true;
					}else{
						child['uil'].unload();
						//child['txt_num'].text='';
						child.data=null;
						CtrlFactory.getUIShow().removeTip(child);
						ItemManager.instance().setEquipFace(child,false);
						child.visible = false;
					}
			}
		
		}
		
		public function showPicByItemId31(itemArr:Array,numArr:Array,container:DisplayObjectContainer):void
		{
			var item:Pub_ToolsResModel;
			arrayLen=itemArr.length;
			var iLen:int = 1;
			var k:int = 1;
			for(i=1;i<=iLen;i++)
			{
				item=null;
				child=container['mc_item31']['pic'+ k.toString() + i.toString(16)];
				
				if(i<=arrayLen)
					item=GameData.getToolsXml().getResPath(itemArr[i-1]) as Pub_ToolsResModel;
				if(item!=null){
//					child['uil'].source=FileManager.instance.getIconSById(item.tool_icon);
					ImageUtils.replaceImage(child,child["uil"],FileManager.instance.getIconSById(item.tool_icon));
					//child['txt_num'].text=VipGift.getInstance().getWan(numArr[i-1]);
					var bag_:StructBagCell2=new StructBagCell2();
					bag_.itemid=item.tool_id;
					bag_.num=numArr[i-1];
					Data.beiBao.fillCahceData(bag_);
					child.data=bag_;
					CtrlFactory.getUIShow().addTip(child);
					ItemManager.instance().setEquipFace(child);
					child.visible = true;
					
					//
					container['mc_item31']['txt_tool_name'].text = item.tool_name;
					container['mc_item31']['txt_tool_coin3'].text = item.tool_coin3 + Lang.getLabel("pub_yuan_bao");
					
					container['mc_item31']["data"] = item;
					
				}else{
					child['uil'].unload();
					//child['txt_num'].text='';
					child.data=null;
					CtrlFactory.getUIShow().removeTip(child);
					ItemManager.instance().setEquipFace(child,false);
					child.visible = false;
					
					//
					container['mc_item31']['txt_tool_name'].text = "";
					container['mc_item31']['txt_tool_coin3'].text = "";
					
					container['mc_item31']["data"] = null;
					
				}
			}
			
		}
		
		public function showPicByItemId32(itemArr:Array,numArr:Array,container:DisplayObjectContainer):void
		{
			var item:Pub_ToolsResModel;
			arrayLen=itemArr.length;
			var iLen:int = 1;
			var k:int = 1;
			for(i=1;i<=iLen;i++)
			{
				item=null;
				child=container['mc_item32']['pic'+ k.toString() + i.toString(16)];
				
				if(i<=arrayLen)
					item=GameData.getToolsXml().getResPath(itemArr[i-1]) as Pub_ToolsResModel;
				if(item!=null){
//					child['uil'].source=FileManager.instance.getIconSById(item.tool_icon);
					ImageUtils.replaceImage(child,child["uil"],FileManager.instance.getIconSById(item.tool_icon));
					//child['txt_num'].text=VipGift.getInstance().getWan(numArr[i-1]);
					var bag_:StructBagCell2=new StructBagCell2();
					bag_.itemid=item.tool_id;
					bag_.num=numArr[i-1];
					Data.beiBao.fillCahceData(bag_);
					child.data=bag_;
					CtrlFactory.getUIShow().addTip(child);
					ItemManager.instance().setEquipFace(child);
					child.visible = true;
					
					//
					container['mc_item32']['txt_tool_name'].text = item.tool_name;
					container['mc_item32']['txt_tool_coin3'].text = item.tool_coin3 + Lang.getLabel("pub_yuan_bao");
					
					container['mc_item32']["data"] = item;
					
				}else{
					child['uil'].unload();
					//child['txt_num'].text='';
					child.data=null;
					CtrlFactory.getUIShow().removeTip(child);
					ItemManager.instance().setEquipFace(child,false);
					child.visible = false;
					
					//
					container['mc_item32']['txt_tool_name'].text = "";
					container['mc_item31']['txt_tool_coin3'].text = "";
					
					container['mc_item32']["data"] = null;
				}
			}
			
		}
		
		private function showPicByItemId(itemArr:Vector.<int>,numArr:Vector.<int>,container:DisplayObjectContainer):void
		{
//			var item:Pub_ToolsResModel;
//			arrayLen=itemArr.length;
//			var iLen:int = 5;
//			var k:int = 1;
//			for(i=1;i<=iLen;i++)
//			{
//				item=null;
//				child=container['pic'+ k.toString() + i.toString(16)];
//				
//				if(i<=arrayLen)
//					item=GameData.getToolsXml().getResPath(itemArr[i-1]);
//				if(item!=null){
//					child['uil'].source=FileManager.instance.getIconSById(item.tool_icon);
//					child['txt_num'].text=VipGift.getInstance().getWan(numArr[i-1]);
//					var bag:StructBagCell2=new StructBagCell2();
//					bag.itemid=item.tool_id;
//					bag.num=numArr[i-1];
//					Data.beiBao.fillCahceData(bag);
//					child.data=bag;
//					CtrlFactory.getUIShow().addTip(child);
//					ItemManager.instance().setEquipFace(child);
//					child.visible = true;
//				}else{
//					child['uil'].unload();
//					child['txt_num'].text='';
//					child.data=null;
//					CtrlFactory.getUIShow().removeTip(child);
//					ItemManager.instance().setEquipFace(child,false);
//					child.visible = false;
//				}
//			}
		}
		
		public function viewSort(a:Pub_InstanceResModel, b:Pub_InstanceResModel):int
		{
			
			if (a.view_sort_id > b.view_sort_id)
			{
				return 1;
			}
			
			if (a.view_sort_id < b.view_sort_id)
			{
				return -1;
			}
			//原样排序
			return 0;
		}
		
		public function addTextColor():void
		{
		
			var targetList:Array = [];
			
			if(1 == (mc as MovieClip).currentFrame)
			{
				targetList.push(mc['txt_11']);
				targetList.push(mc['txt_12']);
			}
			
			if(2 == (mc as MovieClip).currentFrame)
			{
				targetList.push(mc['txt_20']);
				targetList.push(mc['txt_21']);
				targetList.push(mc['txt_22']);
				targetList.push(mc['txt_23']);
				targetList.push(mc['txt_24']);
			
			}
			
			if(3 == (mc as MovieClip).currentFrame)
			{
			
				if(3 == (mc['mc_3'] as MovieClip).currentFrame)
				{
					targetList.push(mc['mc_3']['txt_20']);
					targetList.push(mc['mc_3']['txt_21']);
					targetList.push(mc['mc_3']['txt_22']);
					targetList.push(mc['mc_3']['txt_23']);
					targetList.push(mc['mc_3']['txt_24']);
				}
			
			}
			
			//
			for(var j:int=0;j<targetList.length;j++){
				
				addTextColorEvent(targetList[j]);
			
			}
		}
		
		/**
		 * 文本框点击改变颜色
		 */
		public function addTextColorEvent(targetText:TextField):void
		{
			//
			targetText.removeEventListener(MouseEvent.MOUSE_DOWN, textDownHandler);
			targetText.removeEventListener(MouseEvent.MOUSE_UP, textUpHandler);
			
			var htmlText:String=targetText.htmlText;
			
			targetText.hasEventListener(MouseEvent.MOUSE_DOWN) ? "" : targetText.addEventListener(MouseEvent.MOUSE_DOWN, textDownHandler);
			function textDownHandler(e:MouseEvent):void
			{
				htmlText=targetText.htmlText;
				targetText.setTextFormat(CtrlFactory.getUICtrl().getTextFormat({color: 0xffff00}));
				targetText.hasEventListener(MouseEvent.MOUSE_UP) ? "" : targetText.addEventListener(MouseEvent.MOUSE_UP, textUpHandler);
			}
			// function textHandler(e:TextEvent):void {
			// targetText.removeEventListener(TextEvent.LINK,textHandler);
			// }
			function textUpHandler(e:MouseEvent):void
			{
				//targetText.removeEventListener(MouseEvent.MOUSE_DOWN, textDownHandler);
				//targetText.removeEventListener(MouseEvent.MOUSE_UP, textUpHandler);
				
				
				targetText.htmlText=htmlText + "";
			}
		}
		
		override protected function windowClose():void
		{
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,daoJiShi);
			//_clearSp();
			super.windowClose();
		}
		
		
		override public function getID():int
		{
			return 0;
		}
		
	}
}