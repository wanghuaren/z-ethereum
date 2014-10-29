package ui.base.fuben
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.clock.GameClock;
	
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import netc.Data;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import ui.base.vip.VipGift;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	import ui.view.view1.desctip.GameTip;
	import ui.view.view1.doubleExp.BuyFuBenTime;
	import ui.view.view1.fuben.FuBen;
	import ui.view.view1.fuben.FuBenDuiWu;
	import ui.view.view1.fuben.MyDuiWu;
	
	import world.FileManager;
	import world.WorldEvent;

	public class FuBenMain extends UIWindow
	{
		private static var m_instance:FuBenMain;

		public static function get instance():FuBenMain
		{
			if (null == m_instance)
			{
				m_instance=new FuBenMain();
			}
			return m_instance;
		}
		public var selectedData:Pub_InstanceResModel;
		public var clickSweep:int=0;
		//
		private var selectedItem:StructPlayerInstanceInfo2=null;
		private var _selNanDuLvl:int=1;

		public function get selectedNanDuLvl():int
		{
			return _selNanDuLvl;
		}
		public const AutoRefreshSecond:int=60;
		private var _curAutoRefresh:int=0;
		private var _spContent:Sprite;
		/**
		 * 1 - 九个格子
		 * 2 - 动态格子，使用sp
		 */
		public const LIST_MODE:int=2;

		protected function get spContent():Sprite
		{
			if (null == _spContent)
			{
				_spContent=new Sprite();
			}
			return _spContent;
		}

		public function FuBenMain()
		{
			blmBtn=0;
			type=0;
			//super(getLink(WindowName.win_fu_ben_new));
			super(getLink("win_new_fu_ben"));
		}

		override protected function init():void
		{
			//互斥
			if (MyDuiWu.instance.isOpen || GameTip.hasIconByActionId(MyDuiWu.ICONSN))
			{
				//
				MyDuiWu.instance.btnZoomClick=false;
				MyDuiWu.instance.LeftSignByWinClose();
				MyDuiWu.instance.winClose();
				//
				FuBenDuiWu.instance.btnZoomClick=false;
				FuBenDuiWu.instance.mcHandler({name: "btnClose"});
				FuBenDuiWu.instance.winClose();
				//
				GameTip.removeIconByActionId(MyDuiWu.ICONSN);
			}
			for (var j:int=1; j <= 9; j++)
			{
				if (mc["item_" + j] != null)
					mc["item_" + j].visible=false;
			}
			mc["sp"].visible=false;
			_clearSp();
			//2012-09-08 andy 当玩家战力值达不到推荐战力值时弹出面板
			mc["win_up_zhanli_tip"].visible=false;
			_selNanDuLvl=1;
			_regCk();
			_regPc();
			_regDs();
			refresh();
		}

		override public function get width():Number
		{
			return 741;
		}

		override public function get height():Number
		{
			return 439;
		}

		private function _regCk():void
		{
			_curAutoRefresh=0;
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, daoJiShi);
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, daoJiShi);
		}

		private function daoJiShi(e:WorldEvent):void
		{
			_curAutoRefresh++;
			if (_curAutoRefresh >= AutoRefreshSecond)
			{
				_curAutoRefresh=0;
					//你的代码
			}
		}

		private function _regPc():void
		{
			uiRegister(PacketSCPlayerInstanceInfo.id, SCPlayerInstanceInfo);
			uiRegister(PacketSCSInstanceSweep.id, SCSInstanceSweep);
			uiRegister(PacketSCGetNewExpLastTime.id, SCGetNewExpLastTime);
			uiRegister(PacketSCBuyNewExpLastTime.id, SCBuyNewExpLastTime);
			uiRegister(PacketSCSInstanceStart.id, SCSInstanceStart);
		}

		public function reqData():void
		{
		}

		private function _regDs():void
		{
		}

		public function refresh():void
		{
			_refreshTf();
			_refreshMc();
			_refreshSp();
			_refreshRb();
		}

		private function _refreshMc():void
		{
			FuBen.instanceVec=XmlManager.localres.getInstanceXml.getResPath2(Data.myKing.level) as Vector.<Pub_InstanceResModel>;
			FuBen.instanceVecBySerieSort=new Vector.<Pub_InstanceResModel>;
			//
			var jLen:int=FuBen.instanceVec.length;
			for (var j:int=0; j < jLen; j++)
			{
				var sort1:int=FuBen.instanceVec[j].instancesort;
				var sort2:int=FuBen.serieSort;
				if (sort1 == sort2)
				{
					FuBen.instanceVecBySerieSort.push(FuBen.instanceVec[j]);
					if (1 == FuBen.instanceVec[j].show_sort)
					{
						//mc['mcCeBianBg'].visible = false;
						//mc['sp'].visible = false;
						var instance_id:int=FuBen.instanceVec[j].instance_id;
						//test
						//instance_id = 20200030;
//						if(20220018 == instance_id ||
						if (20210009 == instance_id)
						{
							(mc as MovieClip).gotoAndStop(2);
						}
						else if (20200030 == instance_id)
						{
							(mc as MovieClip).gotoAndStop(4);
						}
						else
						{
							(mc as MovieClip).gotoAndStop(3);
						}
						//
						if (null != mc['mc_nan_du'])
							mc['mc_nan_du'].visible=false;
					}
					else
					{
						//mc['mcCeBianBg'].visible = true;
						//mc['sp'].visible = true;
						(mc as MovieClip).gotoAndStop(1);
					}
					//
					if (1 == (mc as MovieClip).currentFrame)
					{
						this.rebuildMoveBar(741); //mc.width);
					}
					else
					{
						this.rebuildMoveBar(580); //620); //588);
					}
				}
//				if(2 == FuBen.instanceVec[j].instancesort)
//				{
//					FuBen.instanceVec2.push(FuBen.instanceVec[j]);
//				}
//				
			}
			//test
			//mc['mcCeBianBg'].visible = false;
			//mc['sp'].visible = false;
			//(mc as MovieClip).gotoAndStop(2);
			//新手引导  -- 开启窗口的时候执行 副本引导
			//
			var vo:PacketCSPlayerInstanceInfo=new PacketCSPlayerInstanceInfo();
			uiSend(vo);
			var vo2:PacketCSGetNewExpLastTime=new PacketCSGetNewExpLastTime();
			uiSend(vo2);
		}

		private function _refreshTf():void
		{
			if (4 == (mc as MovieClip).currentFrame)
			{
				mc["txt_LastTime"].text=StringUtils.getStringDayTime(FuBen.exptime, false);
			}
		}

		private function _refreshSp():void
		{
		}

		private function _refreshRb():void
		{
		}

		private function SCPlayerInstanceInfo(p:IPacket):void
		{
			var value:PacketSCPlayerInstanceInfo=p as PacketSCPlayerInstanceInfo;
			FuBen.siiVec=value.arrIteminstanceinfo;
			if (1 == (mc as MovieClip).currentFrame)
			{
				this.rebuildMoveBar(741); //mc.width);
			}
			else
			{
				this.rebuildMoveBar(580); //620); //588);
			}
			showList();
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
			if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
					this.winClose();
				}
				else
				{
				}
			}
		}

		private function SCBuyNewExpLastTime(p:PacketSCBuyNewExpLastTime2):void
		{
			var vo2:PacketCSGetNewExpLastTime=new PacketCSGetNewExpLastTime();
			uiSend(vo2);
		}

		private function SCGetNewExpLastTime(p:PacketSCGetNewExpLastTime2):void
		{
			//
			FuBen.exptime=p.exptime;
			this._refreshTf();
		}

		private function _clearSp():void
		{
			while (spContent.numChildren > 0)
			{
				spContent.removeChildAt(0);
			}
		}

		private function showList():void
		{
			_clearSp();
			//var index_:int=0;
			var list:Vector.<Pub_InstanceResModel>=FuBen.instanceVecBySerieSort.sort(viewSort);
			//
			FuBen._vecCompleteCount=0;
			//list.forEach(callbackByList);	
			//
			var item1:DisplayObject;
			if (1 == LIST_MODE)
			{
				for (var j:int=1; j <= 9; j++)
				{
					if (list.length >= j)
					{
						if (1 == (mc as MovieClip).currentFrame)
						{
							mc["item_" + j.toString()].visible=true;
						}
						else
						{
							mc["item_" + j.toString()].visible=false;
						}
						callbackByList(list[j - 1], j - 1);
					}
					else
					{
						mc["item_" + j.toString()].visible=false;
						mc["item_" + j.toString()].data=null;
					}
				}
			}
			else
			{
				_clearSp();
				list.forEach(callbackByCube);
				CtrlFactory.getUIShow().showList2(spContent, 3, 218, 104);
				this.mc['sp'].source=spContent;
				this.mc['sp'].position=0;
				if (1 == (mc as MovieClip).currentFrame)
				{
					this.mc['sp'].visible=true;
				}
				else
				{
					this.mc['sp'].visible=false;
				}
					//var firstItem:DisplayObject = spContent.getChildByName('item'+(0 + 1).toString());
					//this.itemSelected(firstItem);
					//this.itemSelectedOther(firstItem);
			}
			//
			//CtrlFactory.getUIShow().showList2(spContent,1,170,50);
			//
			//mc["sp"].source=spContent;
			//spContent.x=6;//10
			//spContent.y = 10;
			//mc["sp"].scroll.alpha = 0;
			//	
			if (1 == LIST_MODE)
			{
				item1=mc.getChildByName("item_1");
			}
			if (2 == LIST_MODE)
			{
				item1=spContent.getChildByName("item_1");
			}
			if (null == item1)
			{
				return;
			}
			if (item1.visible)
			{
				this.itemSelected(item1);
			}
			rightContent(item1);
			//活动编号 :
			//福溪村幻境 20004
			//守护玄黄剑 20001
			//深渊鬼蜮 20005
			//MsgPrint.printTrace("_vec1CompleteCount:" + _vec1CompleteCount.toString(),
			//	MsgPrintType.WINDOW_REFRESH);
			if (FuBen._vec1CompleteCount >= FuBen.instanceVecBySerieSort.length)
			{
				FuBen._isVec1CompleteCount=true;
			}
			else
			{
				FuBen._isVec1CompleteCount=false;
			}
			//MsgPrint.printTrace("instanceVec2.length:" + instanceVec2.length.toString() + " _vec2CompleteCount:" + _vec2CompleteCount.toString(),
			//	MsgPrintType.WINDOW_REFRESH);
		}

		private function callbackByCube(itemData:Pub_InstanceResModel, index:int, itemDataList:Vector.<Pub_InstanceResModel>):void
		{
			var d:DisplayObject=ItemManager.instance().getitem_fuben_cube(index + 1);
			super.itemEvent(d as Sprite, itemData, true);
			d.name='item_' + (index + 1);
			if (d.hasOwnProperty('bg'))
			{
				d['bg'].mouseEnabled=false;
			}
			//文本
			callbackByList(itemData as Pub_InstanceResModel, index, d);
			spContent.addChild(d);
			//d[''].removeEventListener(MouseEvent.CLICK, btnXClick);
			//d[''].addEventListener(MouseEvent.CLICK, btnXClick);
			//悬浮信息
			//Lang.addTip(d,'yours_tip');
			//d.tipParam=[,]
		}

		public static function isCompleteCount(itemData:Pub_InstanceResModel):Boolean
		{
			if (null == itemData)
			{
				return false;
			}
			var sii:StructPlayerInstanceInfo2;
			for each (var spii:StructPlayerInstanceInfo2 in FuBen.siiVec)
			{
				if (spii.instanceid == itemData.instance_id)
				{
					sii=spii;
					break;
				}
			}
			var limit:Pub_Limit_TimesResModel=XmlManager.localres.limitTimesXml.getResPath(itemData.instance_times) as Pub_Limit_TimesResModel;
			var curNum:int=(sii == null ? 0 : sii.curnum);
			var maxNum:int=(limit != null ? limit.max_times : 1);
			if (curNum == maxNum)
			{
				return true;
			}
			return false;
		}

		//
//		private function callbackByList(itemData:Pub_InstanceResModel,
//										index:int,
//										arr:Vector.<Pub_InstanceResModel>):void 
		private function callbackByList(itemData:Pub_InstanceResModel, index:int, sprite:DisplayObject=null):void
		{
			if (null == sprite)
			{
				sprite=mc["item_" + (index + 1).toString()];
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
			var limit:Pub_Limit_TimesResModel=XmlManager.localres.limitTimesXml.getResPath(itemData.instance_times) as Pub_Limit_TimesResModel;
			sprite["txt_fuben"].text=itemData.instance_name;
			var curNum:int=(sii == null ? 0 : sii.curnum);
			var maxNum:int=(limit != null ? limit.max_times : 1);
			//活动编号 :
			//福溪村幻境 20004
			//守护玄黄剑 20001
			//深渊鬼蜮 20005
			/*&&
			(itemData.instance_id == 20004 ||
			itemData.instance_id == 20001 ||
			itemData.instance_id == 20005)*/
			if (curNum == maxNum)
			{
				FuBen._vecCompleteCount++;
			}
			sprite["txt_num"].text=curNum.toString() + "/" + maxNum.toString();
			//1.进入80级装备副本需要消耗副本传送令
			//2.在副本表(instance)中增加字段“itemid”和“itemnum”，这两个字段控制进入副本条件。
			sprite["txt_enter_req"].htmlText="";
			if (itemData.item_id > 0)
			{
				var bag:StructBagCell2=new StructBagCell2();
				bag.itemid=itemData.item_id;
				bag.num=itemData.item_num;
				Data.beiBao.fillCahceData(bag);
				//
				var count:int=Data.beiBao.getBeiBaoCountById(itemData.item_id);
				if (count >= itemData.item_num)
				{
					sprite["txt_enter_req"].htmlText=Lang.getLabel("FuBenMain_need_item_enough", [count, itemData.item_num, bag.itemname]);
				}
				else
				{
					sprite["txt_enter_req"].htmlText=Lang.getLabel("FuBenMain_need_item_not_enough", [count, itemData.item_num, bag.itemname]);
				}
			}
			//itemDO["num"].text = (sii==null?0:sii.curnum)+"/"+(limit!=null?limit.max_times:1);
//			sprite["txt_level"].text=itemData.instance_level;
			var grade_type:int=itemData.grade_type;
			var grade_sort:String=itemData.grade_sort.toString();
			var lvl:String=Data.myKing.level.toString();
			if (lvl.length == 1)
			{
				lvl="00" + lvl;
			}
			else if (lvl.length == 2)
			{
				lvl="0" + lvl;
			}
			var id:String=grade_sort + lvl;
			var id_:int=parseInt(id);
			if (itemData.show_sort == 2)
			{
//				sprite["uil"].source=FileManager.instance.getFuBenMapIconById(itemData.res_id);
				ImageUtils.replaceImage(sprite as DisplayObjectContainer,sprite['uil'],FileManager.instance.getFuBenMapIconById(itemData.res_id));
			}
			if (sii == null)
			{
				sii=new StructPlayerInstanceInfo2();
				sii.instanceid=itemData.instance_id;
				sii.curnum=0;
			}
			sii.maxnum=limit != null ? limit.max_times : 1;
			//sprite.data = sii;
			sprite["data"]=itemData;
			sprite["data2"]=sii;
			(sprite as DisplayObjectContainer).mouseChildren=false;
			(sprite as MovieClip).buttonMode=true;
			//
			sprite.removeEventListener(MouseEvent.CLICK, itemClickByList);
			sprite.addEventListener(MouseEvent.CLICK, itemClickByList);
			//
			//spContent.addChild(sprite);		
		}

		private function callbackByList1(itemData:Pub_InstanceResModel, index:int, arr:Vector.<Pub_InstanceResModel>):void
		{
			var sprite:*=ItemManager.instance().getFuBenItem(itemData.instance_id);
			//GamelibS.getswflink("game_index", "fuben_item") as MovieClip;
			super.itemEvent(sprite, itemData);
			sprite["name"]="item" + (index + 1);
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
			var limit:Pub_Limit_TimesResModel=XmlManager.localres.limitTimesXml.getResPath(itemData.instance_times) as Pub_Limit_TimesResModel;
			sprite["txt_fuben"].text=itemData.instance_name;
			var curNum:int=(sii == null ? 0 : sii.curnum);
			var maxNum:int=(limit != null ? limit.max_times : 1);
			//活动编号 :
			//福溪村幻境 20004
			//守护玄黄剑 20001
			//深渊鬼蜮 20005
			/*&&
			(itemData.instance_id == 20004 ||
			itemData.instance_id == 20001 ||
			itemData.instance_id == 20005)*/
			if (curNum == maxNum)
			{
				FuBen._vec1CompleteCount++;
			}
			//sprite["txt_num"].text = curNum.toString() + "/" + maxNum.toString();
			//itemDO["num"].text = (sii==null?0:sii.curnum)+"/"+(limit!=null?limit.max_times:1);
			//itemDO["level"].text = itemData.instance_level;
			//itemDO["award"].text = itemData.instance_prize;
			//itemDO["uil"].source = FileManager.instance.getFuBenIconById(itemData.res_id);
			if (sii == null)
			{
				sii=new StructPlayerInstanceInfo2();
				sii.instanceid=itemData.instance_id;
				sii.curnum=0;
			}
			sii.maxnum=limit != null ? limit.max_times : 1;
			//sprite.data = sii;
			sprite.data=itemData;
			sprite.data2=sii;
			sprite.mouseChildren=false;
			sprite.buttonMode=true;
			//
			sprite.removeEventListener(MouseEvent.CLICK, itemClickByList);
			sprite.addEventListener(MouseEvent.CLICK, itemClickByList);
			if ("win_fu_ben" == itemData.instance_donot_list_view_name.toLowerCase())
			{
			}
			else
			{
				//
				spContent.addChild(sprite);
			}
		}

		private function callbackByList2(itemData:Pub_InstanceResModel, index:int, arr:Vector.<Pub_InstanceResModel>):void
		{
			var sprite:*=ItemManager.instance().getFuBenItem(itemData.instance_id);
			//GamelibS.getswflink("game_index", "fuben_item") as MovieClip;
			super.itemEvent(sprite, itemData);
			sprite["name"]="item" + (index + 1);
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
			var limit:Pub_Limit_TimesResModel=XmlManager.localres.limitTimesXml.getResPath(itemData.instance_times) as Pub_Limit_TimesResModel;
			sprite["txt_fuben"].text=itemData.instance_name;
			var curNum:int=(sii == null ? 0 : sii.curnum);
			var maxNum:int=(limit != null ? limit.max_times : 1);
			//活动编号 :
			//福溪村幻境 20004
			//守护玄黄剑 20001
			//深渊鬼蜮 20005
			/*&&
			(itemData.instance_id == 20004 ||
			itemData.instance_id == 20001 ||
			itemData.instance_id == 20005)*/
			if (curNum == maxNum)
			{
				FuBen._vec2CompleteCount++;
			}
			//sprite["txt_num"].text = curNum.toString() + "/" + maxNum.toString();
			//itemDO["num"].text = (sii==null?0:sii.curnum)+"/"+(limit!=null?limit.max_times:1);
			//itemDO["level"].text = itemData.instance_level;
			//itemDO["award"].text = itemData.instance_prize;
			//itemDO["uil"].source = FileManager.instance.getFuBenIconById(itemData.res_id);
			if (sii == null)
			{
				sii=new StructPlayerInstanceInfo2();
				sii.instanceid=itemData.instance_id;
				sii.curnum=0;
			}
			sii.maxnum=limit != null ? limit.max_times : 1;
			//sprite.data = sii;
			sprite.data=itemData;
			sprite.data2=sii;
			sprite.mouseChildren=false;
			sprite.buttonMode=true;
			//
			sprite.removeEventListener(MouseEvent.CLICK, itemClickByList);
			sprite.addEventListener(MouseEvent.CLICK, itemClickByList);
			if ("win_fu_ben" == itemData.instance_donot_list_view_name.toLowerCase())
			{
			}
			else
			{
				//
				spContent.addChild(sprite);
			}
		}

		public function itemClickByList(e:MouseEvent):void
		{
			var sprite:*=e.target;
			rightContent(sprite);
		}
		private var _grade:int=0;

		private function rightContent(sprite:*):void
		{
			//mc["win_up_zhanli_tip"].visible=false;
			selectedData=sprite["data"];
			selectedItem=sprite["data2"];
			var grade_sort:String=sprite["data"]["grade_sort"];
			var lvl:String=Data.myKing.level.toString();
			if (lvl.length == 1)
			{
				lvl="00" + lvl;
			}
			else if (lvl.length == 2)
			{
				lvl="0" + lvl;
			}
			var id:String=grade_sort + lvl;
			var id_:int=parseInt(id);
//			if (null != m)
//			{
//				_grade=m.grade_value;
//			}
//			else
//			{
//				_grade = 0;
//			}
			_grade=parseInt(sprite["grade"]);
			if (2 == (mc as MovieClip).currentFrame || 3 == (mc as MovieClip).currentFrame || 4 == (mc as MovieClip).currentFrame)
			{
				mc["txt_fuben"].htmlText=sprite["data"]["instance_name"];
				mc["txt_fuben_desc"].htmlText=sprite["data"]["instance_desc"];
				if (null != mc["txt_grade"])
					mc["txt_grade"].htmlText=_grade.toString();
				if (null != mc["txt_num"])
					mc["txt_num"].text=sprite["data2"]["curnum"] + "/" + sprite["data2"]["maxnum"];
//				mc["showpiece"].source=FileManager.instance.getFunBenTitleById(sprite["data"]["icon"]);
				//
//				if(20220018 == selectedData['instance_id'] ||
				if (20210009 == selectedData['instance_id'])
				{
					if (null != mc['mc_nan_du'])
						mc['mc_nan_du'].visible=true;
				}
				else
				{
					if (null != mc['mc_nan_du'])
						mc['mc_nan_du'].visible=false;
				}
				refreshSelectNanDu();
			}
			//
			//instancesort:int;//副本类型(1单人，2多人) 3 多人不带列表
			//var instancesort:int=parseInt(sprite["data"]["instancesort"]);
			//var instanceid:int=parseInt(sprite["data"]["instance_id"]);
			//
			refreshItemPic();
			//
			this.itemSelected(sprite);
		}

		private function refreshGrade():void
		{
			if (null == selectedData)
			{
				return;
			}
			//mc["txt_grade"].text =selectedData.
			var grade_sort:String=selectedData.grade_sort.toString();
			var lvl:String=Data.myKing.level.toString();
			if (lvl.length == 1)
			{
				lvl="00" + lvl;
			}
			else if (lvl.length == 2)
			{
				lvl="0" + lvl;
			}
			var id:String=grade_sort + lvl;
			var id_:int=parseInt(id);
		}

		private function refreshItemPic():void
		{
			if (null == selectedData)
			{
				return;
			}
			//
			//var dropId:int  = sprite["data"]["dropid"];
			var dropId:int=this.selectedData.dropid;
			if (3 == this.selectedNanDuLvl)
			{
				dropId=this.selectedData.dropid3; //sprite["data"]["dropid3"];
			}
			else if (2 == this.selectedNanDuLvl)
			{
				dropId=this.selectedData.dropid2; //sprite["data"]["dropid2"];
			}
			else if (1 == this.selectedNanDuLvl)
			{
				dropId=this.selectedData.dropid; //sprite["data"]["dropid"];
			}
			var arr:Vector.<Pub_DropResModel>=XmlManager.localres.getDropXml.getResPath2(dropId) as Vector.<Pub_DropResModel>;
			//filter ------------------------------------------------------------
			var myLvl:int=Data.myKing.level;
			for (var j:int=0; j < arr.length; j++)
			{
				if (myLvl >= arr[j].min_level && myLvl <= arr[j].max_level)
				{
					//nothing
				}
				else
				{
					arr.splice(j, 1);
					j=-1;
				}
			}
			//------------------------------------------------------------------------------
			var item:Pub_ToolsResModel;
			arrayLen=arr.length;
			for (var i:int=1; i <= 8; i++)
			{
				item=null;
				child=mc["pic" + i];
				if (i <= arrayLen)
					item=XmlManager.localres.getToolsXml.getResPath(arr[i - 1].drop_item_id) as Pub_ToolsResModel;
				if (child != null)
				{
					if (item != null)
					{
//						child["uil"].source=FileManager.instance.getIconSById(item.tool_icon);
						ImageUtils.replaceImage(child,child['uil'],FileManager.instance.getIconSById(item.tool_icon));
						child["r_num"].text=VipGift.getInstance().getWan(arr[i - 1].drop_num);
						var bag:StructBagCell2=new StructBagCell2();
						bag.itemid=item.tool_id;
						Data.beiBao.fillCahceData(bag);
						child.data=bag;
						CtrlFactory.getUIShow().addTip(child);
						ItemManager.instance().setEquipFace(child);
						child.visible=true;
					}
					else
					{
						if (child["uil"] != null)
							child["uil"].unload();
						if (child["r_num"] != null)
							child["r_num"].text="";
						child.data=null;
						CtrlFactory.getUIShow().removeTip(child);
						ItemManager.instance().setEquipFace(child, false);
						child.visible=false;
					}
				}
			}
		}

//		public function viewSortTop(a:Pub_InstanceResModel,b:Pub_InstanceResModel):int
//		{
//			if(a.instance_id == FuBen.sortTopFuBenId)
//			{
//				//return 1;
//				return -1;
//			}
//			
//			if(b.instance_id == FuBen.sortTopFuBenId)
//			{
//				//return -1;
//				return 1;
//			}			
//			
//			//原样排序
//			return 0;
//		}
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

		private function tiaoZhan():void
		{
			//winClose();
			//UIMovieClip.currentObjName=null;
			//if(FuBenDuiWu._instance==null||FuBenDuiWu._instance.parent==null)FuBenDuiWu.instance.open();
			FuBenDuiWu.groupid=selectedItem.instanceid;
//			if(0 == selectedData["instancesort"] ||
//				1 == selectedData["instancesort"])
			if (1 == selectedData["max_num"])
			{
				//单人副本快速进入
				//#Request:PacketCSSInstanceStart
				//#Respond:PacketSCSInstanceStart
				if (20200030 == selectedItem.instanceid)
				{
					var c2:PacketCSEntryDoubleExpInstance=new PacketCSEntryDoubleExpInstance();
					this.uiSend(c2);
					winClose();
					UIMovieClip.currentObjName=null;
				}
				else
				{
					//------------------------------------------
					var client1:PacketCSSInstanceStart=new PacketCSSInstanceStart();
					client1.map_id=selectedItem.instanceid;
					client1.map_diff=this._selNanDuLvl - 1;
					this.uiSend(client1);
						//------------------------------------------
				}
			}
			else
			{
				winClose();
				UIMovieClip.currentObjName=null;
				FuBenDuiWu.instance.open(true);
			}
		}

		private function refreshSelectNanDu():void
		{
			if (3 == (mc as MovieClip).currentFrame || 4 == (mc as MovieClip).currentFrame)
			{
				return;
			}
			(mc["mc_nan_du"]["nan_du1"] as MovieClip).mouseChildren=false;
			(mc["mc_nan_du"]["nan_du2"] as MovieClip).mouseChildren=false;
			(mc["mc_nan_du"]["nan_du3"] as MovieClip).mouseChildren=false;
			if (1 == this.selectedNanDuLvl)
			{
				(mc["mc_nan_du"]["nan_du1"] as MovieClip).gotoAndStop(3);
				(mc["mc_nan_du"]["nan_du2"] as MovieClip).gotoAndStop(1);
				(mc["mc_nan_du"]["nan_du3"] as MovieClip).gotoAndStop(1);
			}
			if (2 == this.selectedNanDuLvl)
			{
				(mc["mc_nan_du"]["nan_du1"] as MovieClip).gotoAndStop(1);
				(mc["mc_nan_du"]["nan_du2"] as MovieClip).gotoAndStop(3);
				(mc["mc_nan_du"]["nan_du3"] as MovieClip).gotoAndStop(1);
			}
			if (3 == this.selectedNanDuLvl)
			{
				(mc["mc_nan_du"]["nan_du1"] as MovieClip).gotoAndStop(1);
				(mc["mc_nan_du"]["nan_du2"] as MovieClip).gotoAndStop(1);
				(mc["mc_nan_du"]["nan_du3"] as MovieClip).gotoAndStop(3);
			}
			refreshGrade();
			refreshItemPic();
		}

		private function nan_du1_over(e:MouseEvent):void
		{
			if (1 == this.selectedNanDuLvl)
			{
				(mc["mc_nan_du"]["nan_du1"] as MovieClip).gotoAndStop(3);
			}
			else
			{
				(mc["mc_nan_du"]["nan_du1"] as MovieClip).gotoAndStop(2);
			}
		}

		private function nan_du2_over(e:MouseEvent):void
		{
			if (2 == this.selectedNanDuLvl)
			{
				(mc["mc_nan_du"]["nan_du2"] as MovieClip).gotoAndStop(3);
			}
			else
			{
				(mc["mc_nan_du"]["nan_du2"] as MovieClip).gotoAndStop(2);
			}
		}

		private function nan_du3_over(e:MouseEvent):void
		{
			if (3 == this.selectedNanDuLvl)
			{
				(mc["mc_nan_du"]["nan_du3"] as MovieClip).gotoAndStop(3);
			}
			else
			{
				(mc["mc_nan_du"]["nan_du3"] as MovieClip).gotoAndStop(2);
			}
		}

		private function nan_du1_out(e:MouseEvent):void
		{
			if (1 == this.selectedNanDuLvl)
			{
				(mc["mc_nan_du"]["nan_du1"] as MovieClip).gotoAndStop(3);
			}
			else
			{
				(mc["mc_nan_du"]["nan_du1"] as MovieClip).gotoAndStop(1);
			}
		}

		private function nan_du2_out(e:MouseEvent):void
		{
			if (2 == this.selectedNanDuLvl)
			{
				(mc["mc_nan_du"]["nan_du2"] as MovieClip).gotoAndStop(3);
			}
			else
			{
				(mc["mc_nan_du"]["nan_du2"] as MovieClip).gotoAndStop(1);
			}
		}

		private function nan_du3_out(e:MouseEvent):void
		{
			if (3 == this.selectedNanDuLvl)
			{
				(mc["mc_nan_du"]["nan_du3"] as MovieClip).gotoAndStop(3);
			}
			else
			{
				(mc["mc_nan_du"]["nan_du3"] as MovieClip).gotoAndStop(1);
			}
		}

		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var target_name:String=target.name;
			//元件点击
			switch (target_name)
			{
				case "btnBuyFuBenTime":
					BuyFuBenTime.instance.open(true);
					break;
				case "btnOneKey":
					if (Math.abs(clickSweep - getTimer()) > 6000)
					{
						clickSweep=getTimer();
						var cs:PacketCSSInstanceSweep=new PacketCSSInstanceSweep();
						cs.sort=2;
						cs.para1=selectedItem.instanceid;
						cs.para2=this._selNanDuLvl - 1;
						uiSend(cs);
					}
					break;
				case "btnChuanSong":
				case "btnChuanSong2":
					if (selectedItem != null)
					{
						if (int(selectedItem.curnum) < int(selectedItem.maxnum))
						{
//							if(1 == viewMode)
//							{
							if (1 == (mc as MovieClip).currentFrame || 2 == (mc as MovieClip).currentFrame || 3 == (mc as MovieClip).currentFrame)
							{
								if (1 == (mc as MovieClip).currentFrame)
									//&& 1 == this.selectedNanDuLvl)
								{
									//if(JiaoSe.getZhanLiTotal()<_grade)
									if (Data.myKing.FightValue < _grade)
									{
										mc["win_up_zhanli_tip"]["mc_tip_txt"].gotoAndStop(3);
										mc["win_up_zhanli_tip"].visible=true;
										return;
									}
								}
								if (2 == this.selectedNanDuLvl || 3 == this.selectedNanDuLvl)
								{
									//不再根据战斗力是否达到推荐值来判断是否弹出提示。
									//王志祥说直接进
									//if(JiaoSe.getZhanLiTotal()<int(mc["txt_grade"].text))
									//if(Data.myKing.FightValue<int(mc["txt_grade"].text))
									if (Data.myKing.FightValue < int(mc["txt_grade"].text))
									{
										mc["win_up_zhanli_tip"]["mc_tip_txt"].gotoAndStop(this.selectedNanDuLvl - 1);
										mc["win_up_zhanli_tip"].visible=true;
										return;
									}
								}
							}
							//}
							tiaoZhan();
						}
						else
						{
							Lang.showMsg({type: 4, msg: Lang.getLabel("20006_fuben")});
						}
					}
					else
					{
					}
					break;
				case "btnGoAway":
					winClose();
					break;
				case "btnTiShengClose":
					mc["win_up_zhanli_tip"].visible=false;
					break;
				case "btnTiSheng":
					mc["win_up_zhanli_tip"].visible=false;
//					WoYaoBianQiang_Window.getInstance().open();
//					BaoDianFuZhuWindow.getInstance().setType(0);
//					if (!BaoDianFuZhuWindow.getInstance().isOpen)
//					{
//						BaoDianFuZhuWindow.getInstance().open(true);
//					}
//					else
//					{
//						BaoDianFuZhuWindow.getInstance().repaint();
//					}
					break;
				case "btnTiaoZhan":
					tiaoZhan();
					break;
				case "btnCloseUpTip":
					mc["win_up_zhanli_tip"].visible=false;
					break;
				case "nan_du1":
					this._selNanDuLvl=1;
					this.refreshSelectNanDu();
					break;
				case "nan_du2":
					this._selNanDuLvl=2;
					this.refreshSelectNanDu();
					break;
				case "nan_du3":
					this._selNanDuLvl=3;
					this.refreshSelectNanDu();
					break;
				default:
					break;
			}
		}

		/*
		private function showPicByItemId(itemArr:Vector.<int>,numArr:Vector.<int>,container:DisplayObjectContainer):void
		{
			var item:Pub_ToolsResModel;
			arrayLen=itemArr.length;
			var iLen:int = 5;
			var k:int = 1;
			for(i=1;i<=iLen;i++)
			{
				item=null;
				child=container['pic'+ k.toString() + i.toString(16)];
				if(i<=arrayLen)
					item=GameData.getToolsXml().getResPath(itemArr[i-1]);
				if(item!=null){
					child['uil'].source=FileManager.instance.getIconSById(item.tool_icon);
					child['txt_num'].text=VipGift.getInstance().getWan(numArr[i-1]);
					var bag:StructBagCell2=new StructBagCell2();
					bag.itemid=item.tool_id;
					bag.num=numArr[i-1];
					Data.beiBao.fillCahceData(bag);
					child.data=bag;
					CtrlFactory.getUIShow().addTip(child);
					ItemManager.instance().setEquipFace(child);
					child.visible = true;
				}else{
					child['uil'].unload();
					child['txt_num'].text='';
					child.data=null;
					CtrlFactory.getUIShow().removeTip(child);
					ItemManager.instance().setEquipFace(child,false);
					child.visible = false;
				}
			}
		}
		*/
		// 窗口关闭事件	
		override protected function windowClose():void
		{
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, daoJiShi);
			//
			FuBen.serieSort=0;
			//_clearSp();
			super.windowClose();
		}

		override public function getID():int
		{
			return 0;
		}
	}
}
