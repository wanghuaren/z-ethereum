package ui.view.view4.chengjiu
{
	import com.engine.utils.HashMap;

	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_ComposeResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	import common.utils.StringUtils;
	import common.utils.res.ResCtrl;

	import engine.event.DispatchEvent;
	import engine.support.IPacket;

	import flash.display.MovieClip;
	import flash.display.Sprite;

	import model.chengjiu.ChengjiuModel;

	import netc.Data;
	import netc.dataset.BeiBaoSet;
	import netc.dataset.JiaoSeSet;
	import netc.dataset.MyCharacterSet;
	import netc.packets2.StructBagCell2;

	import nets.packets.PacketCSEquipLevelUp;
	import nets.packets.PacketCSToolCompose;
	import nets.packets.PacketSCEquipLevelUp;
	import nets.packets.PacketSCToolCompose;

	import ui.base.npc.NpcBuy;
	import ui.base.npc.NpcShop;
	import ui.frame.ItemManager;
	import ui.frame.UIPanel;

	public class Chengjiu_zhanpao extends UIPanel
	{
		private static var _instance:Chengjiu_zhanpao;


		private var pageIdx:int=0;
		private var idxMax:int=1;
		private var ishadZhanpao:Boolean; //是否有战袍
		private var m_chengjiuArr:Array;
		private static const HE_CHENG_ID:int=80300300; //背包没有战袍时，点升级战袍 调用合成战袍协议，此为合成id
		private static const HUIZHANG_ID:int=11800076; //徽章id  用于点击购买界面

		public function Chengjiu_zhanpao()
		{
			super();
		}

		public static function getInstance(reload:Boolean=false):Chengjiu_zhanpao
		{
			if (_instance == null && reload == false)
			{
				_instance=new Chengjiu_zhanpao();
			}
			return _instance;
		}

		public function setUi(ui:Sprite):void
		{
			mc=ui as MovieClip;
			pageIdx=0;
			m_chengjiuArr=ChengjiuModel.getInstance().chengjiuzhanpaoArr;
			var arrlen:int=m_chengjiuArr.length;
			idxMax=Math.floor(arrlen / 6);

			init();
		}

		override public function init():void
		{
			Data.myKing.addEventListener(MyCharacterSet.SUI_PIAN3_UPD, pageChengjiu);
			var curIndex:int=m_chengjiuArr.indexOf(getShowId());
			pageIdx=Math.floor(curIndex / 6);
			shouIcon();
			showPanelProperty();
		}

		override public function mcHandler(target:Object):void
		{
			var name:String=target.name;
			var itemNum:int;

			if (name.indexOf("cj_zp_item_") >= 0)
			{
				itemNum=int(name.replace("cj_zp_item_", ""));
				setTargetIconLight(itemNum, target.data);
			}
			switch (name)
			{
				case "btnPrev":
					if (pageIdx > 0)
					{
						pageIdx--;
					}

					shouIcon();
					break;
				case "btnNext":
					if (pageIdx < idxMax - 1)
					{
						pageIdx++;

					}
					shouIcon();
					break;
				case "goumaicjhz": //购买成就徽章
					var bag:StructBagCell2=new StructBagCell2();
					bag.itemid=HUIZHANG_ID;
					Data.beiBao.fillCahceData(bag);

					NpcBuy.instance().setType(4, bag, true, NpcShop.PUB_SHOP_BUY_ID);
					break;
				case "btn_levelUp": //升级战袍
					getLightZhanpaoId();
					if (!ishadZhanpao)
					{
						heCheng(HE_CHENG_ID, 1);
					}
					else
					{
						shengJi(m_zhanpao.pos);
					}
					break;
				default:
					break;
			}

		}


		/**
		 *显示六个图标
		 */
		private function shouIcon():void
		{
			if (mc["tf_cj_xuqiu"] == null)
				return;
			var getidx:int=pageIdx * 6;
			var item_num:int=1;
			var compose:Pub_ComposeResModel;
			var item:StructBagCell2=null;
			item=new StructBagCell2();
			var zhanpaoid:int=getLightZhanpaoId();
			compose=XmlManager.localres.getPubComposeXml.getResPath(zhanpaoid) as Pub_ComposeResModel;
			if (compose == null)
			{
				mc["tf_cj_xuqiu"].htmlText="已经升级到最大";
				mc["btn_levelUp"].visible=false;
				compose=XmlManager.localres.getPubComposeXml.getResPath(m_chengjiuArr[m_chengjiuArr.length - 1]) as Pub_ComposeResModel;
			}
			var lightId:int=compose.tool_id;
			StringUtils.setEnable(mc["btnPrev"]);
			StringUtils.setEnable(mc["btnNext"]);
			if (pageIdx == 0)
			{
				StringUtils.setUnEnable(mc["btnPrev"]);
			}
			if (pageIdx == idxMax - 1)
			{
				StringUtils.setUnEnable(mc["btnNext"]);
			}
			setItemEffect(0);
			//			firstId =m_chengjiuArr[0];
			for (var i:int=getidx; i < getidx + 6; i++)
			{
				compose=XmlManager.localres.getPubComposeXml.getResPath(m_chengjiuArr[i]) as Pub_ComposeResModel;
				item=new StructBagCell2();
				item.itemid=compose.tool_id;
				Data.beiBao.fillCahceData(item);
				ItemManager.instance().setToolTipByData(mc["cj_zp_item_" + item_num], item, 1);
				if (mc["cj_zp_item_" + item_num] != null && mc["cj_zp_item_" + item_num]["txt_num"] != null)
					mc["cj_zp_item_" + item_num]["txt_num"].htmlText=ResCtrl.instance().getFontByColor(item.itemname, item.toolColor);

				if (lightId == item.itemid)
				{
					setTargetIconLight(item_num, item); //如果有id相同的图标 高亮显示
				}
				else
				{
					//setTargetIconLight(0,item);
				}
				++item_num;
			}
		}

		/**
		 *设置界面上各个  文本属性
		 * @param id
		 *
		 */
		private function showPanelProperty():void
		{
			var id:int=getLightZhanpaoId();
			var s:Pub_ComposeResModel;
			s=XmlManager.localres.getPubComposeXml.getResPath(id) as Pub_ComposeResModel;
			if (s == null)
			{
				mc["tf_cj_xuqiu"].htmlText="";
				mc["btn_levelUp"].visible=false;
				mc["tf_cj_xuqiu"].visible=false;
				s=XmlManager.localres.getPubComposeXml.getResPath(m_chengjiuArr[m_chengjiuArr.length - 1]) as Pub_ComposeResModel;
			}
			var tool:Pub_ToolsResModel=XmlManager.localres.getToolsXml.getResPath(s.tool_id) as Pub_ToolsResModel;
			if (tool == null)
				return;
//			mc["cj_zp_uil"].source =FileManager.instance.getIconXById( tool.tool_icon);
//			ImageUtils.replaceImage(mc,mc["cj_zp"],FileManager.instance.getIconXById( tool.tool_icon));
			if (mc["tf_zp_name"] == null)
				return;
			if (tool && mc["tf_zp_name"])
				mc["tf_zp_name"].htmlText=tool.tool_name;
			mc["tf_curr_cjValue"].htmlText=String(Data.myKing.value3);

			var to:Pub_ToolsResModel=XmlManager.localres.getToolsXml.getResPath(s.stuff_id1) as Pub_ToolsResModel;
			var colorStr:String="<font color='#8afd5c'>";
			if (Data.myKing.value3 < s.need_value3)
			{
				colorStr="<font color='#ff0000'>";
			}
			if (s.stuff_id1 == 0)
			{
				mc["tf_cj_xuqiu"].htmlText=colorStr + String(s.need_value3) + "</font>" + Lang.getLabel("2007101_chengjiudian"); //"点成就点";

			}
			else
			{
				mc["tf_cj_xuqiu"].htmlText=to.tool_name + "+" + colorStr + String(s.need_value3) + "</font>" + Lang.getLabel("2007101_chengjiudian"); //"点成就点";

			}

		}

		private function setItemEffect(lig:int):void
		{
			for (var i:int=1; i <= 6; i++)
			{
				if (mc && mc["cj_zp_item_" + i] && mc["cj_zp_item_" + i]["item_effect"])
				{
					if (i == lig)
					{
						mc["cj_zp_item_" + i]["item_effect"].gotoAndStop(2);
					}
					else
					{
						mc["cj_zp_item_" + i]["item_effect"].gotoAndStop(1);
					}
				}
			}
		}

		/**
		 *设置 6个图标其中一个高亮显示    和中间的大图标，以及右边属性文本
		 * @param lig
		 * @param stru
		 *
		 */
		private function setTargetIconLight(lig:int, stru:StructBagCell2):void
		{
			setItemEffect(lig);

			var map:HashMap=null;
			var str:String="";
			if (stru != null)
			{
				mc["tf_zp_name"].htmlText=stru.itemname;
				ItemManager.instance().setToolTipByData(mc["cj_zp"], stru, 2);
				map=ResCtrl.instance().getAtt(stru.equip_att1, false);
				str+=ResCtrl.instance().showEquipStrong(map, null, "FFF5D2", "");
				map=ResCtrl.instance().getAtt(stru.arrItemattrs, false);
				str+=ResCtrl.instance().showEquipStrong(map, null, "FFF5D2", "");
				mc["tf_shuxing"].htmlText=str;
			}
		}

		private function pageChengjiu(e:DispatchEvent=null):void
		{
			if (ChengjiuWin.getInstance().type == 2)
			{
				showPanelProperty();
				if (mc["tf_curr_cjValue"])
					mc["tf_curr_cjValue"].htmlText=String(Data.myKing.value3);
			}
		}
		private var m_zhanpao:StructBagCell2; //角色身上或者背包仓库中   的战袍

		/**
		 *从角色身上  背包 仓库找到披风， 设置下一个披风高亮显示
		 *
		 */
		private function getLightZhanpaoId():int
		{
			var return_num:int=0;
			var zhanpaoArr:Array;
			var zhanpao:StructBagCell2=null;

			zhanpaoArr=Data.beiBao.getBeiBaoByEquipType(JiaoSeSet.EQUIPTYPE_SHOULDER, true);
			if (zhanpaoArr.length == 0)
			{
				zhanpaoArr=Data.beiBao.getRoleEquipByType(JiaoSeSet.EQUIPTYPE_SHOULDER);
			}

			if (zhanpaoArr.length > 0)
				zhanpao=zhanpaoArr[0];
			if (zhanpao == null)
			{
				ishadZhanpao=false;
				return_num=m_chengjiuArr[0];
			}
			else
			{
				m_zhanpao=zhanpao
				ishadZhanpao=true;
				return_num=zhanpao.sort_para1;
			}

			return return_num;
		}

		/**
		 * 得到显示ID
		 * @return
		 *
		 */
		private function getShowId():int
		{
			var ret:int=getLightZhanpaoId();
			if (ret == 0)
				ret=m_chengjiuArr[m_chengjiuArr.length - 1];
			return ret;
		}

		////////////////////////////////////战袍  没有的时候 合成  有的时候 升级//////////////////////////////////////
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
				init();
			}
			else
			{

			}
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
				var curData:StructBagCell2=new StructBagCell2();
				if (curData.pos >= BeiBaoSet.ZHUANGBEI_INDEX && curData.pos <= BeiBaoSet.ZHUANGBEI_END_INDEX)
				{
					curData=Data.beiBao.getRoleEquipByPos(curData.pos);
				}
				else
				{
					curData=Data.beiBao.getBeiBaoDataByPos(curData.pos);
				}
				init();
					//show();
//				Lang.showMsg(Lang.getClientMsg("10033_shengonglu", [curData.itemname]));
			}
			else
			{

			}
		}

	}
}
