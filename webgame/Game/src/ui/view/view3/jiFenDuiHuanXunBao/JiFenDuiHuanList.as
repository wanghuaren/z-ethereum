package ui.view.view3.jiFenDuiHuanXunBao
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_ComposeResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.res.ResCtrl;
	
	import display.components.CmbArrange;
	import display.components.MoreLessPage;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.BeiBaoSet;
	import netc.dataset.MyCharacterSet;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSGetVipLevelData;
	import nets.packets.PacketCSMineGradeExchange;
	import nets.packets.PacketSCGetVipLevelData;
	import nets.packets.PacketSCMineGradeExchange;
	
	import ui.base.beibao.BeiBao;
	import ui.base.paihang.PaiHang;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view2.liandanlu.LianDanLu;

	/**
	 *寻宝 积分兑换 列表
	 * @author Administrator
	 *
	 */
	public class JiFenDuiHuanList extends UIWindow
	{
		//当前选中数据
		private var arrTuPu:Array=null;
		private static const PAGE_SIZE:int=4;

		private static var _instance:JiFenDuiHuanList;

		public static function instance():JiFenDuiHuanList
		{
			if (_instance == null)
			{
				_instance=new JiFenDuiHuanList();
			}
			return _instance;
		}

		public function JiFenDuiHuanList()
		{
			super(this.getLink(WindowName.win_ji_fen_dui_huan_tu));
		}
		private var isShow:Boolean;

		public function setType(v:int, must:Boolean=false, _isShow:Boolean=true):void
		{
			type=v;
			isShow=_isShow;
			super.open(must);

		}

		override protected function openFunction():void
		{
			init();
		}

		private function filterArrTuPu():Array
		{
			var m_result:Array=[];
			for each (var m_pub_ComposeResModel:Pub_ComposeResModel in arrTuPu)
			{
				if (m_pub_ComposeResModel.vip_show == 0 || m_pub_ComposeResModel.vip_show <= m_level)
				{
					m_result.push(m_pub_ComposeResModel);
				}
			}
			
			return m_result;
		}

		override protected function init():void
		{
			Data.myKing.addEventListener(MyCharacterSet.XUN_BAO_VALUE_UPD,XUN_BAO_VALUE_UPD)
			DataKey.instance.register(PacketSCGetVipLevelData.id, _responseSCGetVipLevelData);

			var _p:PacketCSGetVipLevelData=new PacketCSGetVipLevelData();
			DataKey.instance.send(_p);
		}
		
		private function XUN_BAO_VALUE_UPD(e:DispatchEvent):void{
			JiFenDuiHuan.instance().setXunBaoValue();
			showPage(curPage);
		}

		private function _responseSCGetVipLevelData(p:IPacket):void
		{
			var _p:PacketSCGetVipLevelData=p as PacketSCGetVipLevelData;
			if (0 != _p.tag)
			{
				Lang.showResult(_p);
				return;
			}
			m_level=_p.level;
			init2();
		}
		private var m_level:int=0;

		public function init2():void
		{
			curPage=1;
			super.sysAddEvent(mc["mc_page"], MoreLessPage.PAGE_CHANGE, pageChangeHandle);
			Data.beiBao.addEventListener(BeiBaoSet.BAG_ADD, bagAddHandler);
			arrTuPu=XmlManager.localres.getPubComposeXml.getResPath3(type) as Array;
			arrTuPu.sortOn("mine_grade",Array.NUMERIC);
			arrTuPu_2=filterArrTuPu();
//			arrTuPu_2=arrTuPu;
			PaiHang.getInstance().setMetierCmb(mc["mc_cmb2"] as CmbArrange, cmbFunction);
			mc["mc_cmb2"].visible=isShow;
			if (isShow)
			{
				(mc["mc_cmb2"] as CmbArrange).changeSelected(Data.myKing.metier);
			}
			else
			{
				showTuPu();
			}
		}
		//职业类型
		private var metier:String="";
		private var arrTuPu_2:Array;

		/**
		 *	职业  1道士  3战士  4法师  6刺客
		 **/
		private function cmbFunction(ds:DispatchEvent):void
		{
			metier=ds.getInfo.data;
			curPage=1;
			if (metier == "")
			{
//				arrTuPu_2=arrTuPu;
				arrTuPu_2=filterArrTuPu();
				showTuPu();
				return;
			}
			arrTuPu_2=[];
			for each (var tupu:Pub_ComposeResModel in arrTuPu)
			{
				var tool_id:int=tupu.tool_id;
				var _Pub_ToolsResModel:Pub_ToolsResModel=XmlManager.localres.ToolsXml.getResPath(tool_id) as Pub_ToolsResModel;
				if (tupu.vip_show <= m_level && _Pub_ToolsResModel.tool_metier == int(metier))
				{
					arrTuPu_2.push(tupu);
				}
			}
			
			showTuPu();

		}

		public function setDuiHuanName(str:String):void
		{
			mc["txt_grade_jiFen"].htmlText=str;
		}
		/**
		 *	材料数量有变化
		 *  2013-03-11
		 */
		private function bagAddHandler(e:DispatchEvent):void
		{
			showTuPu();
		}

		override public function mcHandler(target:Object):void
		{
			var name:String=target.name;


			switch (name)
			{
				case "duihuanBtn":
					//合成
					var pos:int=target.parent["pos"];
					var makid:int=target.parent["makeId"];
					duihuanBtnClick(pos, makid);
					break;
				default:
					break;
			}

		}

		/**************通讯******************/
		/**
		 *
		 */
		private function duihuanBtnClick(_pos:int, _makid:int):void
		{
			super.uiRegister(PacketSCMineGradeExchange.id, heChengReturn);
			var client:PacketCSMineGradeExchange=new PacketCSMineGradeExchange();
			client.pos=_pos;
			client.makeid=_makid;
			super.uiSend(client);
		}

		private function heChengReturn(p:IPacket):void
		{
			if (super.showResult(p))
			{
				//show();
				Lang.showMsg(Lang.getClientMsg("20079_Huodonghecheng_Dunhuan"));
				
			}
			else
			{

			}
		}


		/**
		 *	显示列表
		 */
		private function showTuPu():void
		{

			var len:int=arrTuPu_2.length;
			var maxPage:int=Math.ceil(len / PAGE_SIZE);
			if (maxPage == 0)
				maxPage=1;
			mc["mc_page"].setMaxPage(curPage, maxPage);
		}

		/**
		 *	翻页
		 */
		private function pageChangeHandle(e:DispatchEvent):void
		{
			curPage=e.getInfo.count;
			showPage(curPage);
		}

		/**
		 *	得到某页数据
		 */
		private function showPage(curPage:int=1):void
		{
			var arrCurPage:Array=[];
			var start:int=(curPage - 1) * PAGE_SIZE;
			var end:int=curPage * PAGE_SIZE;
			var len:int=arrTuPu_2.length;
			for (var k:int=start; k < end; k++)
			{
				if (k >= start && k < len)
				{
					arrCurPage.push(arrTuPu_2[k]);
				}
			}
			
			
			len=arrCurPage.length;
			var compose:Pub_ComposeResModel;
			var tool:Pub_ToolsResModel=null;
			var item:StructBagCell2=null;
			var zhuangbeiArr:Array=[];
			for (i=1; i <= PAGE_SIZE; i++)
			{
				child=mc["itemBox" + i];
				if (child == null)
					continue;
				if (i <= len)
				{
					child.visible=true;
					compose=arrCurPage[i - 1];
					item=new StructBagCell2();
					item.itemid=compose.tool_id;
					Data.beiBao.fillCahceData(item);
					child["makeId"]=compose.make_id;
					ItemManager.instance().setToolTipByData(child["item"], item);
					var stuff_id1:int=compose.stuff_id1;
					var stuff_id2:int=compose.stuff_id2;
					var _Pub_ToolsResModel:Pub_ToolsResModel=XmlManager.localres.ToolsXml.getResPath(stuff_id1) as Pub_ToolsResModel;
					var _Pub_ToolsResModel2:Pub_ToolsResModel=XmlManager.localres.ToolsXml.getResPath(stuff_id2) as Pub_ToolsResModel;
					var _mp:StructBagCell2=null;
					var _mp2:Array=[];
					child["txt_sort"].htmlText=ResCtrl.instance().getFontByColor(item.itemname, item.toolColor);
					if (_Pub_ToolsResModel == null)//兑换不需要装备
					{
						if (Data.myKing.xunBaovalue >= compose.mine_grade)
						{
							child["txt_sortName"].htmlText=Lang.getLabel("5012_xuyaojifen", [compose.mine_grade]) //绿色显示
						}
						else
						{
							child["txt_sortName"].htmlText=Lang.getLabel("5012_xuyaojifen2", [compose.mine_grade]) //"需要"+compose.mine_grade+"积分"
						}
					}
					else//兑换需要装备
					{
						var v1:int ;
						var v2:int ;
						var v3:int ;
						var v4:int ;
						_mp=Data.beiBao.getOneById(String(_Pub_ToolsResModel.tool_id));//从背包中获取该装备
						var toolitem:StructBagCell2=new StructBagCell2();
						toolitem.itemid=_Pub_ToolsResModel.tool_id;
						Data.beiBao.fillCahceData(toolitem);
						if (_Pub_ToolsResModel2 != null)
						{
							_mp2=Data.beiBao.getBeiBaoDataByIdStr(String(_Pub_ToolsResModel2.tool_id),true);//神铸石
							var toolitem2:StructBagCell2=new StructBagCell2();
							toolitem2.itemid=_Pub_ToolsResModel2.tool_id;
							Data.beiBao.fillCahceData(toolitem2);
						}
						if (_mp != null)////背包中有该装备
						{
							v1 = Data.myKing.xunBaovalue;
							v2 = compose.mine_grade;
							if(_mp2!=null){
							v3 =_mp2.length;
							}
							v4 = compose.stuff_num2;
							
//							if (Data.myKing.xunBaovalue < compose.mine_grade)
//							{
								
								child["txt_sortName"].htmlText=Lang.getLabel("5012_xuyao") + "<font color='#8afd5c'><u>" +
									_Pub_ToolsResModel.tool_name + "</u></font>" + (_Pub_ToolsResModel2 == null ? "" : "+<font color='" +
										(_mp2.length == 0 ? "#ff0000" : (_mp2.length < compose.stuff_num2 ? "#ff0000" : "#8afd5c")) + "'><u>" +
										_Pub_ToolsResModel2.tool_name + "</u>(" + compose.stuff_num2 + ")</font>") + "+"+TextColorList(v1,v2) + 
									compose.mine_grade + "</font>" + Lang.getLabel("5012_jifen");
								
//								
//								child["txt_sortName"].htmlText=Lang.getLabel("5012_xuyao") + "<font color='#8afd5c'><u>" + _Pub_ToolsResModel.tool_name + "</u></font>" + (_Pub_ToolsResModel2 == null ? "" : "+<font color='" + (_mp2 == null ? "#ff0000" : (_mp2.num < compose.stuff_num2 ? "#ff0000" : "#8afd5c")) + "'><u>" + _Pub_ToolsResModel2.tool_name + "</u>(" + compose.stuff_num2 + ")</font>") + "+<font color='#ff0000'>" + compose.mine_grade + "</font>" + Lang.getLabel("5012_jifen");
//							}
//							else
//							{
//								child["txt_sortName"].htmlText=Lang.getLabel("5012_xuyao") + "<font color='#8afd5c'><u>" + 
//									_Pub_ToolsResModel.tool_name + "</u></font>" + (_Pub_ToolsResModel2 == null ? "" : "+<font color='" +
//										(_mp2 == null ? "#ff0000" : (_mp2.num < compose.stuff_num2 ? "#ff0000" : "#8afd5c")) + "'><u>" +
//										_Pub_ToolsResModel2.tool_name + "</u>(" + compose.stuff_num2 + ")</font>") + "+<font color='#8afd5c'>" +
//									compose.mine_grade + "</font>" + Lang.getLabel("5012_jifen");
//							}
							////////////////////////////计算兑换位置////////////////////////////////
							zhuangbeiArr=Data.beiBao.getBeiBaoDataById(_mp.itemid);
							var zhuangbeiMin:StructBagCell2=getStructBagCell2(zhuangbeiArr);
							child["wenzizhedang"].data=zhuangbeiMin;
							child["itemid1"]=_mp.itemid;
							var zhuangbeiMin2:StructBagCell2;
							if (_mp2.length != 0)
							{
								zhuangbeiArr=Data.beiBao.getBeiBaoDataById(_mp2[0].itemid);
								zhuangbeiMin2=getStructBagCell2(zhuangbeiArr);
								child["wenzizhedang1"].data=zhuangbeiMin2;
								child["itemid2"]=_mp2[0].itemid;
							}
							var m_pos:int;
							if (zhuangbeiMin == null)
							{
								if (zhuangbeiMin2 != null)
								{
									m_pos=zhuangbeiMin2.pos << 16
								}
							}
							else
							{
								if (zhuangbeiMin2 != null)
								{
									m_pos=(zhuangbeiMin2.pos << 16) | zhuangbeiMin.pos;
								}
							}
							child["pos"]=m_pos;
						}
						else if (_mp == null)////背包中没有该装备
						{
							if (Data.myKing.xunBaovalue >= compose.mine_grade)
							{
								child["txt_sortName"].htmlText=Lang.getLabel("5012_xuyao") + "<font color='#ff0000'><u>" +
									_Pub_ToolsResModel.tool_name + "</u></font>" + (_Pub_ToolsResModel2 == null ? "" : "+<font color='" +
										(_mp2.length == 0 ? "#ff0000" : (_mp2.length < compose.stuff_num2 ? "#ff0000" : "#8afd5c")) + "'><u>" +
										_Pub_ToolsResModel2.tool_name + "</u>(" + compose.stuff_num2 + ")</font>") + 
									"+<font color='#8afd5c'>" + compose.mine_grade + "</font>" + Lang.getLabel("5012_jifen");
							}
							else
							{
								child["txt_sortName"].htmlText=Lang.getLabel("5012_xuyao") + "<font color='#ff0000'><u>" + 
									_Pub_ToolsResModel.tool_name + "</u></font>" + (_Pub_ToolsResModel2 == null ? "" : "+<font color='" +
										(_mp2.length == 0 ? "#ff0000" : (_mp2.length < compose.stuff_num2 ? "#ff0000" : "#8afd5c")) + "'><u>" +
										_Pub_ToolsResModel2.tool_name + "</u>(" + compose.stuff_num2 + ")</font>") + 
									"+<font color='#ff0000'>" + compose.mine_grade + "</font>" + Lang.getLabel("5012_jifen");
							}

							child["wenzizhedang"].data=toolitem;
							if (toolitem2 != null)
							{
								child["wenzizhedang1"].data=toolitem2;
							}
						}

						CtrlFactory.getUIShow().addTip(child["wenzizhedang"]);
						if (toolitem2 != null)
						{
							CtrlFactory.getUIShow().addTip(child["wenzizhedang1"]);
						}
						LianDanLu.instance().showConfig(compose.make_id, false, child, 1, false);
					}
				}
				else
				{
					child.visible=false;
				}
			}
		}
/**
 * 
 * @param v1  拥有的数量
 * @param v2  需要的数量
 * @return 
 * 
 */		
private function TextColorList(v1:int,v2:int):String
{
	var str:String = "<font color='#8afd5c'>";
	
	if(v1>=v2){
		return str;
	}else{
		str ="<font color='#ff0000'>" 
		return str;
	}
}
		private function getStructBagCell2(value:Array):StructBagCell2
		{
			var m_result:StructBagCell2;
			if (value.length == 1)
			{
				m_result=value[0];
			}
			else if (value.length > 1)
			{
				m_result=checkZhuangbei(value);
			}
			else
			{
				m_result=null;
			}
			return m_result;
		}

		private function checkZhuangbei(_zhuangbeiArr:Array):StructBagCell2
		{
			var zhuangbeiMin:StructBagCell2=null;
			zhuangbeiMin=_zhuangbeiArr[0];



			for (var t:int=0; t < _zhuangbeiArr.length - 1; t++)
			{
				if (zhuangbeiMin.strongFailed < _zhuangbeiArr[t + 1].strongFailed)
				{

				}
				else
				{
					zhuangbeiMin=_zhuangbeiArr[t + 1];
				}
			}
			for each (var dd:StructBagCell2 in _zhuangbeiArr)
			{
				if (zhuangbeiMin.strongFailed == dd.strongFailed)
				{
					if (zhuangbeiMin.equip_strongLevel < dd.equip_strongLevel)
					{
						zhuangbeiMin=dd;
					}
				}
			}
			return zhuangbeiMin;
		}

		override protected function windowClose():void
		{
			super.windowClose();
		}

		override public function getID():int
		{
			return 1084;
		}
	}
}
