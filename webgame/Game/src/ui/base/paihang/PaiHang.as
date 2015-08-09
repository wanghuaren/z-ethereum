package ui.base.paihang
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.config.xmlres.server.Pub_WingResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	
	import display.components.CmbArrange;
	import display.components.MoreLessPage;
	
	import engine.event.DispatchEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.*;
	
	import model.qq.YellowDiamond;
	
	import netc.Data;
	import netc.packets2.PacketWCRankList2;
	import netc.packets2.PacketWCRankPlayerInfo2;
	import netc.packets2.StructBagCell2;
	import netc.packets2.StructBourn2;
	import netc.packets2.StructRankEquipInfo2;
	import netc.packets2.StructRankSatrInfo2;
	import netc.packets2.StructServerRank2;
	
	import nets.packets.PacketCSRankList;
	import nets.packets.PacketCSRankPlayerInfo;
	import nets.packets.PacketWCRankList;
	import nets.packets.PacketWCRankPlayerInfo;
	
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.view.jingjie.JingJiePanel;
	import ui.view.view1.buff.GameBuff;
	import ui.view.view1.zhanlizhi.ZhanLiZhi;
	import ui.view.view2.liandanlu.LianDanLu;
	import ui.view.view4.chibang.ChiBang;
	import ui.view.view4.soar.SoarPanel;
	import ui.view.zuoqi.ZuoQiMain;
	
	import world.FileManager;
	
	/**
	 * 排行榜
	 * @author andy
	 * @date   2012-04-07
	 */
	public final class PaiHang extends UIWindow
	{
		//榜单类型
		private var sort:int=3;
		//
		private var curData:StructServerRank2;
		private var curPlayer:PacketWCRankPlayerInfo2;
		private var item:StructServerRank2;
		//排行榜前三名颜色
		private const arrColor:Array=["", "#ff9b0f", "#f64afd", "#09a3d7"];
		//排行榜榜单规则
		private var arrPaiHangRule:Array;
		//由于策划变化，服务端不删除sort,sort一直往后增加，
		private var maxMenuNum:int=0;
		//称号
		private var mc_title:MovieClip;
		//职业类型
		private var metier:String="";
		//称号资源匹配
		private var arrTitle:Array=[];
		private static var _instance:PaiHang;

		public static function getInstance():PaiHang
		{
			if (_instance == null)
				_instance=new PaiHang();
			return _instance;
		}

		public function PaiHang(obj:Object=null)
		{
			super(getLink("win_pai_hang_bang"), obj);
		}
		
		
		public function setType(v:int,must:Boolean=false):void{			
			type=v;
			super.open(must);
		}
		override protected function init():void
		{
			super.init();
			super.pageSize=10;
			super.blmBtn=20;
			super.sysAddEvent(mc, MouseEvent.MOUSE_OVER, mouseHandle);
			super.sysAddEvent(mc, MouseEvent.MOUSE_OUT, mouseHandle);
			super.sysAddEvent(mc["mc_page"], MoreLessPage.PAGE_CHANGE, changePage);
			super.uiRegister(PacketWCRankPlayerInfo.id, getplayerInfoReturn);
			super.uiRegister(PacketWCRankList.id, initPage);
			arrPaiHangRule=Lang.getLabelArr("arrPaiHang");
			maxMenuNum=arrPaiHangRule.length;
			if (mc_title == null)
			{
				mc_title=new MovieClip();
				mc_title.x=110;
				mc_title.y=130;
				mc.addChild(mc_title);
				Lang.addTip(mc_title, "pub_param");
				arrTitle[11]=1;
				arrTitle[12]=2;
				arrTitle[13]=19;
				arrTitle[21]=3;
				arrTitle[22]=4;
				arrTitle[23]=20;
				arrTitle[31]=5;
				arrTitle[32]=6;
				arrTitle[33]=21;
				arrTitle[91]=7;
				arrTitle[92]=8;
				arrTitle[93]=22;
				arrTitle[51]=9;
				arrTitle[52]=10;
				arrTitle[53]=23;
				arrTitle[121]=11;
				arrTitle[122]=12;
				arrTitle[123]=24;
			}
			mc["m_role"].visible=false;
			mc["m_role"].mouseEnabled=mc["m_role"].mouseChildren=false;

			for (i=1; i <= maxMenuNum; i++)
			{
				child=mc["btnMenu" + i];
				if (child == null)
					continue;
				child.tipParam=[arrPaiHangRule[i]];
				Lang.addTip(child, "pub_param", 120);
			}
			for (i=1; i <= 10; i++)
			{
				mc["item" + i].visible=false;
			}
			//职业
			setMetierCmb(mc["mc_cmb2"], cmbFunction,4);
			if(type==0)
				type=3;
			mcHandler({name: "cbtn" + type});
			
		}

		private function mouseHandle(me:MouseEvent):void
		{
			var name:String=me.target.name;
			switch (me.type)
			{
				case MouseEvent.MOUSE_OVER:
					break;
				case MouseEvent.MOUSE_OUT:
					break;
				default:
					break;
			}
		}

		override public function mcHandler(target:Object):void
		{
			var name:String=target.name;
			super.mcHandler(target);
			if (name.indexOf("cbtn") == 0)
			{
				sort=int(name.replace("cbtn", ""));
				//sort=3;
				//榜单
				metier="";
//				mc["mc_cmb2"].visible=false;
//				if (sort == 3)
//				{
//					//metier=Data.myKing.metier.toString();
					mc["mc_cmb2"].visible=true;
					(mc["mc_cmb2"] as CmbArrange).changeSelected(Data.myKing.metier);
//				}
				mc["mc_head"].gotoAndStop(sort);	
				getData();
				return;
			}
			if (name.indexOf("item") == 0)
			{
				super.itemSelected(target);
				curData=target.data;
				getplayerInfo();
				return;
			}
			switch (name)
			{
				case "btn_zlzpd":
					if (curData == null)
						return;
					ZhanLiZhi.instance(curData.roleid);
					break;
			}
		}

		/**
		 *	获得数据
		 */
		public function getData():void
		{
			if (Data.paiHang.getData(sort) == null || Data.paiHang.arrIsUpdate[sort] == 0)
			{
				var client:PacketCSRankList=new PacketCSRankList();
				client.sort=sort;
				super.uiSend(client);
			}
			else
			{
				initPage();
			}
		}

		/**
		 *	初始化分页
		 */
		private function initPage(p:PacketWCRankList2=null):void
		{
			curPage=1;
			var arr:Vector.<StructServerRank2>=Data.paiHang.getData(sort, 0, metier);
			if (arr == null)
				return;
			var len:int=arr.length;
			var maxPage:int=Math.ceil(len / pageSize);
			if (maxPage == 0)
				maxPage=1;
			mc["mc_page"].setMaxPage(curPage, maxPage);
			var have:Boolean=false;
			if (metier != "")
				arr=Data.paiHang.getData(sort);
			for each (item in arr)
			{
				if (item.roleid == Data.myKing.roleID)
				{
					have=true;
					break;
				}
			}
			if (have)
			{
				mc["txt_mySort"].htmlText=Lang.getLabel("10044_pai_hang", [item.sort]);
			}
			else
			{
				mc["txt_mySort"].htmlText=Lang.getLabel("10045_pai_hang");
			}
		}

		/**
		 *	显示
		 */
		private function show():void
		{
			var arr:Vector.<StructServerRank2>=Data.paiHang.getData(sort, curPage, metier);
			var len:int=arr.length;
			var num:int=0;
			for (i=1; i <= 10; i++)
			{
				child=mc["item" + i];
				num=(curPage - 1) * 10 + i;
				if (i <= len)
				{
					item=arr[i - 1];
					//前三名彩色字体
					if (num <= 10)
					{
						var numberOne:int=this.getTitleNum(num);
						child["txt_1"].htmlText="<font color='" + arrColor[numberOne] + "'><b>" + num + "</b></font>";
						child["txt_2"].htmlText="<font color='" + arrColor[numberOne] + "'><b>" + item.name + "</b></font>";
						child["txt_3"].htmlText="<font color='" + arrColor[numberOne] + "'><b>" + (sort == 2 ? item.metier : item.jobName) + "</b></font>";
						child["txt_4"].htmlText="<font color='" + arrColor[numberOne] + "'><b>" + item.data + "</b></font>";
						//前两名增加悬浮 2012-10-08 策划调整 只显示第一名
						if (item.sort <= 10)
						{
							//2014-02-13 策划不显示称号悬浮
							//Lang.addTip(child, "pub_param");
							numberOne=this.getTitleNum(item.sort);
							var cnt:int=arrTitle[sort * 10 + numberOne];
							child["tipParam"]=[Lang.getLabelArr("arrChengHaoDesc")[cnt]];
						}
						else
						{
							Lang.removeTip(child);
						}
					}
					else
					{
						Lang.removeTip(child);
						child["txt_1"].text=num;
						child["txt_2"].text=item.name;
						child["txt_3"].text=sort == 2 ? item.metier : item.jobName;
						child["txt_4"].text=item.data;
					}
					YellowDiamond.getInstance().handleYellowDiamondMC2(child["mcQQYellowDiamond"], item.qqyellowvip);
					super.itemEvent(mc["item" + i], item);
					child.visible=true;
				}
				else
				{
					child["txt_1"].text="";
					child["txt_2"].text="";
					child["txt_3"].text="";
					child["txt_4"].text="";
					child.data=null;
					child.visible=false;
				}
			}
			if (len > 0)
				mcHandler(mc["item1"]);
			else
			{
				for (i=1; i <= 10; i++)
				{
					mc["item" + i]["bg"].gotoAndStop(1);
				}
			}
		}

		/**
		 */
		private function cmbFunction(ds:DispatchEvent):void
		{
			if (sort == 3||sort == 18)
			{
				metier=ds.getInfo.data;
				initPage();
			}
			else
			{
			}
		}

		/***********通讯***********/
		/**
		 *	获得玩家详细信息
		 */
		private function getplayerInfo():void
		{
			if (curData == null)
				return;
			while (mc_title.numChildren > 0)
				mc_title.removeChildAt(0);
			super.uiRegister(PacketWCRankPlayerInfo.id, getplayerInfoReturn);
			var client:PacketCSRankPlayerInfo=new PacketCSRankPlayerInfo();
			client.role=curData.roleid;
			client.pet=sort == 2 ? curData.extPara1 : 0;
			super.uiSend(client);
		}

		private function getplayerInfoReturn(p:PacketWCRankPlayerInfo2):void
		{
			if (curData == null)
				return;
			//if(curData.roleid!=p.roleid)return;
			curPlayer=p;
			switch (sort)
			{
				case 1:
				case 2:
				case 3:
				case 9:
				case 5:
				case 12:
				case 18:	
					mc["m_role"].visible=true;
					mc["txt_mingZi"].text=curData.name;
					var skin:Sprite=FileManager.instance.getWindowSkinUrl(curPlayer.s0, curPlayer.s1, curPlayer.s2, curPlayer.s3, curPlayer.sex, curPlayer.metier, curPlayer.roleid);
					while (mc["m_role"].numChildren > 0)
						mc["m_role"].removeChildAt(0);
					mc["m_role"].addChild(skin);
					
					//显示装备
					clearEquipItem();
					var arr:Vector.<StructRankEquipInfo2>=p.arrItemequipInfo;
					var equip:StructRankEquipInfo2;
					var bag:StructBagCell2;
					for each (equip in arr)
					{
						child=mc["equip_item" + equip.pos];
						if (child == null)
							continue;
						if(mc["txt_metierAttName"+equip.pos]!=null)
						mc["txt_metierAttName"+equip.pos].visible=false;
						bag=new StructBagCell2();
						bag.itemid=equip.equip.itemid;
						Data.beiBao.fillCahceData(bag);
						Data.beiBao.fillServerData(bag, equip.equip);
						bag.equip_source=4;
						LianDanLu.instance().showStar(child["txt_strong_level"], bag.equip_strongLevel);
						child.mouseChildren=false;
						child.data=bag;
//						child["uil"].source=bag.icon;
						ImageUtils.replaceImage(child,child["uil"],bag.icon);
						ItemManager.instance().setEquipFace(child);
						CtrlFactory.getUIShow().addTip(child);
					}
					btnTip();
					break;
				default:
					break;
			}
		}
		
		/**
		 * 按鈕懸浮 2014-08-18 
		 * 
		 */		
		private function btnTip():void{
			var tip_content:String="";
			mc["btnVip"].mouseChildren=false;
			tip_content=GameBuff.getInstance().checkVipBuff(curPlayer.vipLevel);
			mc["btnVip"].tipParam=[tip_content==""?"VIP":tip_content];
			Lang.addTip(mc["btnVip"],"10035_jiaose",150);
			
			mc["btnMa"].mouseChildren=false;
			mc["btnMa"].tipParam=[ZuoQiMain.getInstance().getCurAtt(curPlayer.arrItemhorselist)];
			Lang.addTip(mc["btnMa"],"10036_jiaose",150);
			
			mc["btnLong"].mouseChildren=false;
			mc["btnLong"].tipParam=[JingJiePanel.instance().getCurAtt(curPlayer.starLevel)];			
			Lang.addTip(mc["btnLong"],"10037_jiaose",150);
			
			mc["btnZhuan"].mouseChildren=false;
			mc["btnZhuan"].tipParam=[SoarPanel.getInstance().getCurAtt(curPlayer.soarLevel)];
			Lang.addTip(mc["btnZhuan"],"10038_jiaose",150);
			
			//mc["btnJie"].mouseChildren=false;
			//tip_content=GameBuff.getInstance().checkJieHunBuff(curPlayer.marrySort);
			//mc["btnJie"].tipParam=[tip_content==""?"结婚":tip_content];
			//Lang.addTip(mc["btnJie"],"10039_jiaose",150);
			
			mc["btnFly"].mouseChildren=false;
			mc["btnFly"].tipParam=[ChiBang.getInstance().getCurAtt(curPlayer.wingLevel,false)];
			Lang.addTip(mc["btnFly"],"10040_jiaose",150);
			var currWing:Pub_WingResModel=XmlManager.localres.getWingXml.getResPath(curPlayer.wingLevel) as Pub_WingResModel;
			mc["btnFly"].gotoAndStop(currWing.wing_sort);
		}

		/************内部方法**********/
		/**
		 *	翻页
		 */
		private function changePage(e:DispatchEvent=null):void
		{
			curPage=e.getInfo.count;
			show();
		}

		/**
		 *	清理装备
		 */
		private function clearEquipItem():void
		{
			var _loc1:*;
			for (i=1; i <= 16; i++)
			{
				_loc1=mc.getChildByName("equip_item" + i);
				if (_loc1 == null)
					continue;
				_loc1["uil"].unload();
				ImageUtils.cleanImage(_loc1);
				_loc1["txt_strong_level"].htmlText="";
				if(mc["txt_metierAttName"+i]!=null)
				mc["txt_metierAttName"+i].visible=true;
				_loc1.mouseChildren=false;
				_loc1.data=null;
				ItemManager.instance().setEquipFace(_loc1, false);
			}
		}


		/**
		 * 设置职业下拉框
		 *<t k='pub_job1'>逍遥派</t>
		 <t k='pub_job2'>天波府</t>
		 <t k='pub_job3'>神剑山庄</t>
		 <t k='pub_job4'>慈航静斋</t>
		 <t k='pub_job5'>唐门</t>
		 <t k='pub_job6'>明教</t>
		 <t k='pub_job7'>宠物</t>
		 */
		public function setMetierCmb(cmb:CmbArrange, callBack:Function, rowCount:int=5):void
		{
			var arrCmb:Array=new Array();
			arrCmb.push({label: Lang.getLabel("pub_quan_bu"), data: "", visible: 1});
			arrCmb.push({label: Lang.getLabel("pub_job1"), data: 1, visible: 1});
			arrCmb.push({label: Lang.getLabel("pub_job2"), data: 2, visible: 0});
			arrCmb.push({label: Lang.getLabel("pub_job3"), data: 3, visible: 1});
			arrCmb.push({label: Lang.getLabel("pub_job4"), data: 4, visible: 1});
			arrCmb.push({label: Lang.getLabel("pub_job5"), data: 5, visible: 0});
			arrCmb.push({label: Lang.getLabel("pub_job6"), data: 6, visible: 0});
			cmb.rowCount=rowCount;
			cmb.overHeight=5;
			cmb.addItems=arrCmb;
			cmb.addEventListener(DispatchEvent.EVENT_COMB_CLICK, callBack);
		}

		/**
		 *	根据排序，得到称号等级
		 *  1名一个，2－3名1个，4-10名1个
		 *  2013-05-27
		 */
		private function getTitleNum(sort:int):int
		{
			var num:int=(sort == 1) ? 1 : (sort >= 2 && sort <= 3) ? 2 : 3;
			return num;
		}

		

		override public function getID():int
		{
			return 1024;
		}

		
		/**
		 *	RankSort_Fight = 1,//战力排行
			RankSort_Pet=2,//宠物
			RankSort_Level=3,//等级
			RankSort_Money=4,
			RankSort_Star=5,//武魂
			RankSort_Honor=6,
			RankSort_Bone=7,//炼骨
			RankSort_Consume=8,//消费
			RankSort_Bourn=9,//星界 境界
			RankSort_Refound=10,//重铸
			RankSort_EvilGrain=11,//魔纹
			RankSort_Card=12,//藏经阁-卡片
			RankSort_Ploit = 13, //功勋，军衔
			RankSort_Horse = 14, // 坐骑排行
			RankSort_Soar = 15, // 飞升排行
			RankSort_AttAck = 16, // 攻击排行 
			RankSort_AttAckMetier = 17, // 职业攻击排行榜
			RankSort_Ar = 18, // 成就排行榜  
		 */
	}
}
