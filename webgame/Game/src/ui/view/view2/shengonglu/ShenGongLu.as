package ui.view.view2.shengonglu
{

	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_ComposeResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	import common.utils.res.ResCtrl;
	
	import display.components.MoreLessPage;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	
	import flash.display.MovieClip;
	import flash.events.TextEvent;
	
	import model.guest.NewGuestModel;
	
	import netc.Data;
	import netc.dataset.BeiBaoSet;
	import netc.dataset.JiaoSeSet;
	import netc.dataset.MyCharacterSet;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSEquipLevelUp;
	import nets.packets.PacketCSToolCompose;
	import nets.packets.PacketSCEquipLevelUp;
	import nets.packets.PacketSCToolCompose;
	
	import ui.base.npc.NpcShop;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view2.liandanlu.LianDanLu;

	/**
	 *	神工炉【天宫开物】
	 *  andy 2013-12-18
	 */
	public class ShenGongLu extends UIWindow
	{
		//当前选中数据
		private var curData:StructBagCell2=null;
		//当前选中数据
		private var mc_list:MovieClip=null;

		private static const PAGE_SIZE:int=6;

		private static var _instance:ShenGongLu;

		public static function instance():ShenGongLu
		{
			if (_instance == null)
			{
				_instance=new ShenGongLu();
			}
			return _instance;
		}

		public function ShenGongLu()
		{
			super(this.getLink(WindowName.win_tian_gong_kai_wu));
		}

		override public function get width():Number
		{
			return 330;
		}

		public function setType(v:int,must:Boolean=false):void{			
			type=v;
			super.open(must);
		}
		override protected function openFunction():void
		{
			init();
		}

		override protected function init():void
		{
			super.init();
			super.blmBtn=0;
			super.sysAddEvent(Data.myKing, MyCharacterSet.SUI_PIAN1_UPD, SUI_PIAN_UPD);
			super.sysAddEvent(Data.myKing, MyCharacterSet.SUI_PIAN2_UPD, SUI_PIAN_UPD);
			super.sysAddEvent(Data.myKing, MyCharacterSet.SUI_PIAN3_UPD, SUI_PIAN_UPD);
			super.sysAddEvent(Data.myKing,MyCharacterSet.SUI_PIAN4_UPD, SUI_PIAN_UPD);

			(mc as MovieClip).gotoAndStop(1);
			if(type>0){	
				mcHandler(mc["dbtn"+type]);
			}else{
				
			}
			//2014-10-29 官印引导
			var arr:Array=Data.beiBao.getRoleEquipByType(JiaoSeSet.EQUIPTYPE_TRINKET);
			if(arr!=null&&arr.length>0){
				NewGuestModel.getInstance().handleNewGuestEvent(1065,0,mc);
			}
		}

		override public function mcHandler(target:Object):void
		{
			var name:String=target.name;
			if (name.indexOf("dbtn") == 0)
			{
				type=int(name.replace("dbtn", ""));
				(mc as MovieClip).gotoAndStop(2);
				mc_list=mc["mc_list"];
				mc_list.visible=false;
				curPage=0;
				super.sysAddEvent(mc_list["mc_page"], MoreLessPage.PAGE_CHANGE, pageChangeHandle);
				super.sysAddEvent(mc["txt_tupu"], TextEvent.LINK, linkHandler);
				curData=null;
				mc["mc_dang"].visible=false;
				var langNum:String="";
				if (type == 1)
					langNum="10027_shengonglu";
				else if (type == 2)
					langNum="10028_shengonglu";
				else if (type == 3)
					langNum="10029_shengonglu";
				else if (type == 4)
					langNum="10031_shengonglu";
				else if (type == 5)
					langNum="10032_shengonglu";
				else if (type == 10)
					langNum="10030_shengonglu";
				else if (type == 11)
					langNum="10030_shengonglu";
				else if (type == 12)
					langNum="10030_shengonglu";
				else
				{
				}

				Lang.addTip(mc["btnHuoDe"], langNum, 120);

				show();
				NewGuestModel.getInstance().handleNewGuestEvent(1065,1,mc);
				return;
			}
			if (name.indexOf("item") == 0 && target["mc_icon"].data != null && target["mc_icon"].data is StructBagCell2)
			{
				curData=target["mc_icon"].data;
				clickItem();
				if (TuPu.instance().isOpen)
					TuPu.instance().winClose();
				return;
			}

			switch (name)
			{
				case "btnBackFirst":
					//返回首页
					(mc as MovieClip).gotoAndStop(1);
					if (TuPu.instance().isOpen)
						TuPu.instance().winClose();
					break;
				case "btnCloseList":
					//返回首页
					mc_list.visible=false;
					break;
				case "btnDuanZao":
					//锻造
					if (curData == null)
						return;
					if (curData.pos == 0)
					{
						heCheng(curData.sort_para1, 1);
					}
					else
					{
						shengJi(curData.pos);
					}
					break;
				case "btnDuiHuanKing":
					//返回首页
					NpcShop.instance().setshopId(NpcShop.JIE_ZHI_SHOP_ID);
					break;
				default:
					break;
			}

		}

		/**
		 *	升级界面
		 */
		private var arrEquip:Array=[];

		private function show():void
		{
			switch (type)
			{
				case 1:
					arrEquip=getUp(JiaoSeSet.EQUIPTYPE_TRINKET);
					if (arrEquip.length > 0)
						curData=arrEquip[0];
					break;
				case 2:
					arrEquip=getUp(JiaoSeSet.EQUIPTYPE_CUIRASS);
					if (arrEquip.length > 0)
						curData=arrEquip[0];
					break;
				case 3:
					arrEquip=getUp(JiaoSeSet.EQUIPTYPE_SHOULDER);
					if (arrEquip.length > 0)
						curData=arrEquip[0];
					break;
				case 4:
					arrEquip=getUp(JiaoSeSet.EQUIPTYPE_SECRETWEAPON);
					if (arrEquip.length > 0)
						curData=arrEquip[0];
					break;
				case 5:
					arrEquip=getUp(JiaoSeSet.EQUIPTYPE_GOLDSTAMP);
					if (arrEquip.length > 0)
						curData=arrEquip[0];
					break;
				case 10:
					arrEquip=getUp(JiaoSeSet.EQUIPTYPE_RING);
					mc_list.visible=true;
					showKing();
					if (TuPu.instance().isOpen)
					{
						TuPu.instance().refresh(curData.level);
					}
					break;
				default:
					break;
			}
			clickItem();
		}

		/**
		 *	获得存在的指定的装备类型物品【唯一】
		 */
		private function getUp(equip_type:int):Array
		{
			var ret:Array=null;
			ret=Data.beiBao.getRoleEquipByType(equip_type, ResCtrl.EquipLimit_LevelUp);
			if (ret.length == 0)
			{
				ret=Data.beiBao.getBeiBaoByEquipType(equip_type, true, ResCtrl.EquipLimit_LevelUp);
			}

			if (ret.length == 0)
			{
				//如果没有，则默认合成第一个物品
				var sort_param1:int=0;
				if (equip_type == JiaoSeSet.EQUIPTYPE_TRINKET)
				{
					sort_param1=80300100;
				}
				else if (equip_type == JiaoSeSet.EQUIPTYPE_CUIRASS)
				{
					sort_param1=80300200;
				}
				else if (equip_type == JiaoSeSet.EQUIPTYPE_SHOULDER)
				{
					sort_param1=80300300;
				}
				else if (equip_type == JiaoSeSet.EQUIPTYPE_SECRETWEAPON)
				{
					sort_param1=80300500;
				}
				else if (equip_type == JiaoSeSet.EQUIPTYPE_GOLDSTAMP)
				{
					sort_param1=80300600;
				}
				else if (equip_type == JiaoSeSet.EQUIPTYPE_RING)
				{
					sort_param1=0;
				}
				else
				{
					sort_param1=0;
				}
				if (sort_param1 > 0)
				{
					var bag:StructBagCell2=new StructBagCell2();
					bag.sort_para1=sort_param1;
					ret.push(bag);
				}
			}
			return ret;
		}

		/**
		 *	选中物品
		 */
		public var suiPianId:int=0;
		public var tuPuId:int=0;

		private function clickItem():void
		{
			if (mc["txt_count"] == null)
			{
				return;
			}
			if (curData == null)
			{
				mc["txt_count"].htmlText="";
				mc["mc_result"]["uil"].unload();
				ItemManager.instance().removeToolTip(mc["mc_result"]);
				mc["txt_name"].htmlText="";
				mc["txt_need"].htmlText="";
				mc["txt_tupu"].htmlText="";
			}
			else
			{
				suiPianId=type;
				mc["txt_count"].htmlText=showSuiPian(suiPianId);
				//需要材料
				var arr:Array=LianDanLu.instance().showConfig(curData.sort_para1, false, mc as MovieClip, 2);
				//显示材料
				if (arr.length > 0)
				{
					

					//升级后装备
					var bagResult:StructBagCell2=new StructBagCell2();
					bagResult.itemid=arr[0].resultId;
					Data.beiBao.fillCahceData(bagResult);
					ItemManager.instance().setToolTipByData(mc["mc_result"], bagResult);

					mc["txt_name"].htmlText=ResCtrl.instance().getFontByColor(bagResult.itemname, bagResult.toolColor);
					mc["txt_xiaohao"].htmlText=Lang.getLabel("10027_shengonglu", [ResCtrl.instance().getFontByColor(bagResult.itemname, bagResult.toolColor)]);
					//图谱
					var compose:Pub_ComposeResModel=XmlManager.localres.getPubComposeXml.getResPath(curData.sort_para1) as Pub_ComposeResModel;
					tuPuId=compose.para_int;
					mc["txt_tupu"].htmlText="<a href='event:" + tuPuId + "'><u>" + Lang.getLabel("pub_tupu" + tuPuId) + "<u></a>";
					mc["mc_dang"].visible=false;
				}
				else
				{
					//达到最大
					if (TuPu.instance().isOpen)
						TuPu.instance().winClose();
					ItemManager.instance().setToolTipByData(mc["mc_result"], curData);
					mc["txt_name"].htmlText=ResCtrl.instance().getFontByColor(curData.itemname, curData.toolColor);
					mc["txt_xiaohao"].htmlText=Lang.getLabel("10007_shen_gong_lu");
					mc["mc_dang"].visible=true;
				}

			}
		}

		/**
		 *	显示当前碎片值
		 */
		public function showSuiPian(id:int, needCount:int=0):String
		{
			if(id==10)id=11800130;
			if (id < 100)
			{
				return Lang.getLabel("pub_suipian" + id) + ": <font color='#8afd5c'>" + LianDanLu.instance().getSuiPianValue(id) + "</font>";
			}
			else
			{
				var count:int=Data.beiBao.getBeiBaoCountById(id);
				var tool:Pub_ToolsResModel=XmlManager.localres.getToolsXml.getResPath(id) as Pub_ToolsResModel;
				return tool.tool_name + ": <font color='#8afd5c'>" + count + "</font>";
			}
		}


		/**
		 *	碎片值有变化
		 */
		public function SUI_PIAN_UPD(e:DispatchEvent=null):void
		{
			clickItem();
			if (TuPu.instance().isOpen)
				TuPu.instance().refresh(curData.level);
		}

		/**************通讯******************/
		/**
		 *	合成
		 */
		private function heCheng(makeId:int, count:int):void
		{
			super.uiRegister(PacketSCToolCompose.id, heChengReturn);
			var client:PacketCSToolCompose=new PacketCSToolCompose();
			client.makeid=makeId;
			client.count=count;
			super.uiSend(client);
		}

		private function heChengReturn(p:IPacket):void
		{
			if (super.showResult(p))
			{
				show();
				Lang.showMsg(Lang.getClientMsg("10033_shengonglu", [curData.itemname]));
			}
			else
			{

			}

			NewGuestModel.getInstance().handleNewGuestEvent(1065,2,mc);
		}

		/**
		 *	升级
		 */
		private function shengJi(pos:int):void
		{
			super.uiRegister(PacketSCEquipLevelUp.id, shengJiReturn);
			var client:PacketCSEquipLevelUp=new PacketCSEquipLevelUp();
			client.pos=pos;
			super.uiSend(client);
		}

		private function shengJiReturn(p:IPacket):void
		{
			if (super.showResult(p))
			{
				if(curData.pos>=BeiBaoSet.ZHUANGBEI_INDEX && curData.pos<=BeiBaoSet.ZHUANGBEI_END_INDEX){
					curData=Data.beiBao.getRoleEquipByPos(curData.pos);
				}else{
					curData=Data.beiBao.getBeiBaoDataByPos(curData.pos);
				}
				show();
				Lang.showMsg(Lang.getClientMsg("10033_shengonglu", [curData.itemname]));
			}
			else
			{

			}
			NewGuestModel.getInstance().handleNewGuestEvent(1065,2,mc);
		}


		/**
		 *	点击图谱
		 */
		private function linkHandler(te:TextEvent):void
		{
			TuPu.instance().setType(int(te.text), curData.level);
		}

		/**
		 *	显示戒指列表
		 */
		private function showKing():void
		{
			if(curPage==0)curPage=1;
			var len:int=arrEquip.length;
			arrEquip.sortOn("pos", Array.NUMERIC);
			var maxPage:int=Math.ceil(len / PAGE_SIZE);
			if (maxPage == 0)
				maxPage=1;
			mc_list["mc_page"].setMaxPage(curPage, maxPage);
		}

		private function pageChangeHandle(e:DispatchEvent):void
		{
			curPage=e.getInfo.count;
			showPage(curPage);
		}

		private function showPage(curPage:int=1):void
		{
			var arrCurPage:Array=[];
			var start:int=(curPage - 1) * PAGE_SIZE;
			var end:int=curPage * PAGE_SIZE;
			var len:int=arrEquip.length;
			for (var k:int=start; k < end; k++)
			{
				if (k >= start && k < len)
				{
					arrCurPage.push(arrEquip[k]);
				}
			}
			//arrCurPage.sortOn("pos", Array.NUMERIC);
			len=arrCurPage.length;
			var item:StructBagCell2=null;
			var compose:Pub_ComposeResModel=null;
			var tool:Pub_ToolsResModel=null;
			for (i=0; i < PAGE_SIZE; i++)
			{
				child=mc_list["item" + (i + 1)];
				if (child == null)
					continue;
				child["txt_name"].mouseEnabled=false;
				child["txt_need"].mouseEnabled=false;
				item=arrCurPage[i];
				if (i < len)
				{
					child.visible=true;
					ItemManager.instance().setToolTipByData(child["mc_icon"], item);
					child["txt_name"].htmlText="<u>" + ResCtrl.instance().getFontByColor(item.itemname, item.toolColor) + "</u>";
					compose=XmlManager.localres.getPubComposeXml.getResPath(item.sort_para1) as Pub_ComposeResModel;
					if (compose != null)
					{
						tool=XmlManager.localres.getToolsXml.getResPath(compose.stuff_id2) as Pub_ToolsResModel;
						child["txt_need"].htmlText=Lang.getLabel("10028_shengonglu", [tool.tool_name, compose.stuff_num2]);
					}
					else
					{
						child["txt_need"].htmlText=Lang.getLabel("10007_shen_gong_lu");
					}
				}
				else
				{
					child.visible=false;
				}
			}
		}

		override protected function windowClose():void
		{
			NewGuestModel.getInstance().handleNewGuestEvent(1065,3,mc);
			super.windowClose();
			type=0;
		}

		override public function getID():int
		{
			return 1077;
		}

	}
}
