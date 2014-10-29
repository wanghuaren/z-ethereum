package ui.view.view1.zhanlizhi
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.config.xmlres.lib.TablesLib;
	import common.managers.Lang;
	
	import engine.load.GamelibS;
	import engine.support.IPacket;
	
	import flash.display.Sprite;
	import flash.events.TextEvent;
	
	import netc.Data;
	
	import nets.packets.PacketCSFightValue;
	import nets.packets.PacketSCFightValue;
	
	import ui.base.jiaose.JiaoSeMain;
	import ui.frame.ImageUtils;
	import ui.frame.UIWindow;
	import ui.view.jingjie.JingJie2Win;
	import ui.view.view1.Accordion.Accordion;
	import ui.view.view2.liandanlu.LianDanLu;
	import ui.view.zuoqi.ZuoQiMain;
	
	import world.FileManager;
	
	/**
	 * @author suhang
	 * 战力值面板
	 */
	public class ZhanLiZhi extends UIWindow
	{
		private var UIACC : Accordion;
		private var panel1 : Sprite;
		private var panel2 : Sprite;
		private var panel3 : Sprite;
		private var panel4 : Sprite;
		private var panel5 : Sprite;
		private var panel6 : Sprite;
		
		//private var labelArr:Array;
		private var arrLink:Array;
		
		private var id:int;
		
		private var value:PacketSCFightValue;
		
		public function ZhanLiZhi(id_:int=0)
		{
			id = id_;
			super(getLink("win_zhan_li_zhi"));
		}
		
		private static var _instance : ZhanLiZhi = null;
		
		public static function instance(id_:int=0) : ZhanLiZhi {
			if(id_==0)id_=Data.myKing.roleID;
			if (null == _instance)
			{
				_instance=new ZhanLiZhi(id_);
			}
			else
			{
				_instance.id = id_;
			}
			
			_instance.uiRegister(PacketSCFightValue.id,_instance.SCFightValue);
			var vo:PacketCSFightValue = new PacketCSFightValue();
			vo.roleid = id_;
			_instance.uiSend(vo);
			
			return _instance;
		}
		
		// 面板初始化
		override protected function init():void
		{
			super.init();
			this.visible=false;
			if(UIACC==null){
				UIACC = new Accordion();
				UIACC.size(510, 245);
				UIACC.move(23, 140);
				panel1 = GamelibS.getswflink("game_index","mAccordionPanel") as Sprite;
				panel2 = GamelibS.getswflink("game_index","mAccordionPanel") as Sprite;
				panel3 = GamelibS.getswflink("game_index","mAccordionPanel") as Sprite;
				panel4 = GamelibS.getswflink("game_index","mAccordionPanel") as Sprite;
				panel5 = GamelibS.getswflink("game_index","mAccordionPanel") as Sprite;
				panel6 = GamelibS.getswflink("game_index","mAccordionPanel") as Sprite;
//				labelArr = Lang.getLabelArr("zhanlizhi_2101");
				UIACC.setTitleList = [["",panel1],
					["",panel2],
					["",panel3],
					["",panel4],
					["",panel5],
					["",panel6]];
			}
			addChild(UIACC);
			UIACC.setAddEvent();
			
			sysAddEvent(panel1["txt1"], TextEvent.LINK, textLinkListener);
			sysAddEvent(panel1["txt2"], TextEvent.LINK, textLinkListener);
			sysAddEvent(panel2["txt1"], TextEvent.LINK, textLinkListener);
			sysAddEvent(panel2["txt2"], TextEvent.LINK, textLinkListener);
			sysAddEvent(panel3["txt1"], TextEvent.LINK, textLinkListener);
			sysAddEvent(panel3["txt2"], TextEvent.LINK, textLinkListener);
			sysAddEvent(panel4["txt1"], TextEvent.LINK, textLinkListener);
			sysAddEvent(panel4["txt2"], TextEvent.LINK, textLinkListener);
			sysAddEvent(panel5["txt1"], TextEvent.LINK, textLinkListener);
			sysAddEvent(panel5["txt2"], TextEvent.LINK, textLinkListener);
			sysAddEvent(panel6["txt1"], TextEvent.LINK, textLinkListener);
			sysAddEvent(panel6["txt2"], TextEvent.LINK, textLinkListener);
			
			showWin(value);
		}
		
		/**  评分提示表(grade)    grade_type
		 * a)	1:人物属性
* b)	2:伙伴属性
* c)	3:人物装备基础
* d)	4:伙伴装备基础
* e)	5:人物装备强化
* f)	6:伙伴装备强化
* g)	7:人物装备重铸
* h)	8:伙伴装备重铸
* i)	9:人物星魂
* j)	10:伙伴星魂
* k)	11:炼骨
* l)	12：玩家丹药
* m)	13：伙伴丹药
 * 
 *  0：无链接
1:人物属性      空
2:伙伴属性      空
3:人物装备基础  空 
4:伙伴装备基础  空
5:人物装备强化 炼丹炉界面强化分页 默认打开人物装备选择栏
6:伙伴装备强化 炼丹炉界面强化分页 默认打开伙伴装备选择栏(出战)
7:人物装备重铸 炼丹炉界面重铸分页 默认打开人物装备选择栏
8:伙伴装备重铸 炼丹炉界面重铸分页 默认打开伙伴装备选择栏(出战)
9:人物星魂     星魂装备界面默认选中玩家
10:伙伴星魂    星魂装备界面默认选中伙伴(出战)
11:炼骨        打开角色信息界面，炼骨分页
12：玩家丹药   打开丹药查看界面，默认显示玩家
13：伙伴丹药   打开丹药查看界面，默认显示伙伴(出战)
14：坐骑       打开角色信息界面，坐骑分页

		 */
		private function SCFightValue(p:IPacket) : void {
			value = p as PacketSCFightValue;
			if(value.tag==0){
				open();
			}else{
				Lang.showMsg(Lang.getClientMsg("10018_hao_you"));
				super.winClose();
			}
		}
		
		override public function open(must:Boolean=false, type:Boolean=true):void{
			super.open(must,type);
		}
		
		private function showWin(value:PacketSCFightValue):void{
			if(value.ranklevel==0){
				mc["paiming"].text = Lang.getLabel("20067_ZhanLiZhi");
			}else{
				mc["paiming"].text = value.ranklevel;
			}
			this.visible=true;
//			mc["pic"].source = FileManager.instance.getHeadIconXById(value.playericon);
			ImageUtils.replaceImage(mc,mc["pic"],FileManager.instance.getHeadIconXById(value.playericon));
			var temp:String = "";
			if(value.vip!=0){
				mc["mc_vip"].gotoAndStop(value.vip+1);
				temp = "   ";
			}else{
				mc["mc_vip"].gotoAndStop(1);
			}
			
			mc["playerInfo"].text = temp + XmlRes.GetJobNameById(value.playermetier)+"/"+value.playerlevel+
				Lang.getLabel("pub_ji")+"/"+value.playername;
			
			panel1["txt1"].htmlText = Lang.getLabel("20032_ZhanLiZhi")+value.player+getLinks(1)+"\n"+Lang.getLabel("20034_ZhanLiZhi")+value.playerbone+getLinks(11);
			panel1["txt2"].htmlText = Lang.getLabel("20033_ZhanLiZhi")+value.pet+getLinks(2);
			panel2["txt1"].htmlText = Lang.getLabel("20035_ZhanLiZhi")+value.playerequipbase+getLinks(3)+"\n"+
				Lang.getLabel("20037_ZhanLiZhi")+value.playerequipstrong+getLinks(5)+"\n"+Lang.getLabel("20039_ZhanLiZhi")+value.playerequipapp+getLinks(7);
			panel2["txt2"].htmlText = Lang.getLabel("20036_ZhanLiZhi")+value.petequipbase+getLinks(4)+"\n"+
				Lang.getLabel("20038_ZhanLiZhi")+value.petequipstrong+getLinks(6)+"\n"+Lang.getLabel("20040_ZhanLiZhi")+value.petequipapp+getLinks(8);
			panel3["txt1"].htmlText = Lang.getLabel("20041_ZhanLiZhi")+value.playerstart+getLinks(9);
			panel3["txt2"].htmlText = Lang.getLabel("20042_ZhanLiZhi")+value.petstart+getLinks(10);
			panel4["txt1"].htmlText = Lang.getLabel("20043_ZhanLiZhi")+value.playerpill+getLinks(12);
			panel4["txt2"].htmlText = Lang.getLabel("20044_ZhanLiZhi")+value.petpill+getLinks(13);
			panel5["txt1"].htmlText = Lang.getLabel("20045_ZhanLiZhi")+value.playerhourse+getLinks(14);
			panel6["txt1"].htmlText = Lang.getLabel("20084_ZhanLiZhi")+value.playerequipevilgrain+getLinks(15);
			panel6["txt2"].htmlText = Lang.getLabel("20085_ZhanLiZhi")+value.petequipevilgrain+getLinks(16);
			
			UIACC.setIndexTitle(0, " <font color='#FFFF00' size='14'>"+(value.player+value.pet+value.playerbone)+"</font>");
			UIACC.setIndexTitle(1, " <font color='#FFFF00' size='14'>"+(value.playerequipbase+value.playerequipstrong+value.playerequipapp
				+value.petequipbase+value.petequipstrong+value.petequipapp)+"</font>");
			UIACC.setIndexTitle(2, " <font color='#FFFF00' size='14'>"+(value.playerstart+value.petstart)+"</font>");
			UIACC.setIndexTitle(3, " <font color='#FFFF00' size='14'>"+(value.playerpill+value.petpill)+"</font>");
			UIACC.setIndexTitle(4, " <font color='#FFFF00' size='14'>"+(value.playerhourse)+"</font>");
			UIACC.setIndexTitle(5, " <font color='#FFFF00' size='14'>"+(value.playerequipevilgrain+value.petequipevilgrain)+"</font>");
			
			mc["txt_zhanDouLi"].text = value.player+value.pet+value.playerequipbase+value.playerequipstrong
				+value.playerequipapp+value.petequipbase+value.petequipstrong+value.petequipapp+value.playerstart
				+value.petstart+value.playerpill+value.petpill+value.playerhourse+value.playerbone+value.playerequipevilgrain+value.petequipevilgrain;
		}
		
		//获取链接
		private function getLinks(type:int):String{
			if(id!=Data.myKing.objid){
				return "";
			}
			if(arrLink==null){
				var t:TablesLib = XmlManager.localres.getPubGradeXml;
				arrLink = XmlManager.localres.getPubGradeXml.getResPath2(Data.myKing.level) as Array;
			}
			var len:uint = arrLink.length;
			for(var i:int=0;i<len;i++){
				if(arrLink[i].grade_type==type){
					return "  <a href='event:"+arrLink[i].func+"'>"+arrLink[i].content+"</a>";
				}
			}
			return "";
		}
		
		private function textLinkListener(e:TextEvent):void
		{
			switch(e.text){
				case "1":
					JiaoSeMain.getInstance().setType(1);
					break;
				case "2":
					//伙伴
					JiaoSeMain.getInstance().setType(1);
					break;
				case "3":
					JiaoSeMain.getInstance().setType(1);
					break;
				case "4":
					//伙伴
					JiaoSeMain.getInstance().setType(1);
					break;
				case "5":
					var ldl3:LianDanLu = LianDanLu.instance();
					ldl3.setType(1);
					break;
				case "6":
					var ldl4:LianDanLu = LianDanLu.instance();
					ldl4.setType(1);
					break;
				case "7":
					var ldl:LianDanLu = LianDanLu.instance();
					ldl.setType(2);
					break;
				case "8":
					var ldl2:LianDanLu = LianDanLu.instance();
					ldl2.setType(2);
					break;
				case "9":
				case "10":
//					if(GuanXingTaiWindow.getInstance().isOpen)
//					{
//						GuanXingTaiWindow.getInstance().winClose();
//					}
//					else if(!XinghunWindow.getInstance().isOpen)
//					{
//						GuanXingTaiWindow.getInstance().open();
//						
//					}
//					
//					if(XinghunWindow.getInstance().isOpen)
//					{
//						XinghunWindow.getInstance().winClose();
//					}
					
					
					break;
				case "11":

					break;
				case "12":
				    JingJie2Win.getInstance().open();
					break;
				case "13":
					JingJie2Win.getInstance().open();
					break;
				case "14":
					ZuoQiMain.getInstance().open();
					break;
				case "15":
					LianDanLu.instance().setType(3,true)
					break;
				case "16":
					LianDanLu.instance().setType(3,true)
					break;
			}
		}
		
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			switch (target.name)
			{
				case "":
					
					break;
			}
		}
		
		// 窗口关闭事件
		override protected function windowClose():void
		{
			super.windowClose();
		}
	}
}