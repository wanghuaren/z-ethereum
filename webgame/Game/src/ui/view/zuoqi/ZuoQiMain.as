package ui.view.zuoqi
{
	import common.config.Att;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.clock.GameClock;
	import common.utils.res.ResCtrl;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import model.guest.NewGuestModel;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.MyCharacterSet;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import scene.action.Action;
	import scene.action.PathAction;
	import scene.king.SkinByWin;
	
	import ui.base.jiaose.JiaoSeMain;
	import ui.frame.FontColor;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIPanel;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view2.liandanlu.LianDanLu;
	
	import world.FileManager;
	import world.WorldEvent;
	import world.model.file.BeingFilePath;

	public class ZuoQiMain extends UIWindow
	{

		public const FV_NUM:int=4; //7;

		public const FUNC_NUM:int=14;

		public static function initselect_jie():int
		{
			if (null == curData)
			{
				return -1;
			}
			if (curData.skin_level * 10 <= curData.strong_level)
			{
				return curData.skin_level;

			}
			else
			{
				return curData.strong_level / 10;

			}
		}

		//
		public static function get curData():StructHorseList2
		{
			var horseList:Vector.<StructHorseList2>=Data.zuoQi.getHorseList().arrItemhorselist;
			var horseOpenNum:int=Data.zuoQi.getHorseList().horse_num;
			if (1 == horseOpenNum && horseList.length > 0)
			{
				return horseList[0];
			}
			return null;
		}

		//
		private var select_jie:int;


		/**
		 *
		 */
		private static var m_instance:ZuoQiMain;

		public static function getInstance(reload:Boolean=false):ZuoQiMain
		{
			if(m_instance==null&&reload==false)
			{
				m_instance=new ZuoQiMain();
			}
			return m_instance;
		}
		public function ZuoQiMain()
		{
			super(getLink(WindowName.win_zuo_qi));
		}

		override protected function init():void
		{

			mc['txt_succeed_odd'].htmlText='';
			mc['chk1_coin3'].htmlText='';
			mc["isjiefeng"].htmlText="";
			mc["txt_jiefeng_desc"].htmlText="";

			mc['mc_name'].visible=false;
			mc['mc_jie'].visible=false;
		

			//mc['mc_shiZhuang'].visible=false;
			mc['txt_att'].text="";
			mc['txt_att_next'].text="";

			//按钮区
			mc['btnQiCheng'].visible=false;
			mc['btnShenXin'].visible=false;
			mc['btnXiuXi'].visible=false;

			mc['btnPrev'].visible=false;
			mc['btnNext'].visible=false;

			mc['btnPrev'].mouseChildren=false;
			mc['btnNext'].mouseChildren=false;

			mc['btnPrev'].buttonMode=true;
			mc['btnNext'].buttonMode=true;

			mc['chk1'].visible=false;
			mc["mc_txt_xh"].visible=false;
			mc["mc_txt_cgl"].visible=false;
			select_jie=-1;

			curTime=0;
			
			this.uiRegister(PacketSCHorseList.id, SCHorseList);
			this.uiRegister(PacketSCRideOn.id, qiChengReturn);
			this.uiRegister(PacketSCRideOff.id, xiuXiReturn);
			this.uiRegister(PacketSCHorseStar.id, SCHorseStar);
			
			this.uiRegister(PacketSCHorseFachionUse.id, SCHorseFachionUse);
			uiRegister(PacketSCHorseFachionUnUse.id, SCHorseFachionUnUse);
			
			super.sysAddEvent(Data.myKing, MyCharacterSet.HORSE_STATUS, HORSE_STATUS_HAND);

			getData();
		}
		public function HORSE_STATUS_HAND(e:DispatchEvent):void
		{
			this.refresh();
		}
		public const pTime:int=300;
		public var curTime:int=0;
		override public function mcHandler(target:Object):void
		{
			if (Math.abs(getTimer() - curTime) < pTime){
				return;
			}
			curTime=getTimer();
			
			super.mcHandler(target);
			var target_name:String=target.name;
			
			//
			if (null != this.getChildByName('tip_tool')){
				this.removeChild(this.getChildByName('tip_tool'));
			}
			switch (target_name)
			{
				case "mc_shiZhuang":
					var cs:PacketCSHorseFachionUnUse=new PacketCSHorseFachionUnUse();
					uiSend(cs);
					break;	
				case "btnPrev":
					if ((this.select_jie - 1) >= 0)
					{
						this.select_jie--;
					}
					sendCSHorseSetCurrSkin(select_jie+1);
					this.refresh();
					break;
								
				case "btnNext":
					if ((this.select_jie + 1) <= ZuoQiMain.curData.max_skin_level)
					{
						this.select_jie++;
					}
					sendCSHorseSetCurrSkin(select_jie+1);
					this.refresh();
					
					break;
				case "btnShenXin":
					//
					CSHorseStar();
					break;
				case 'chk1':
					mc['chk1'].selected=!mc['chk1'].selected;	
					break;
				case "btnQiCheng":
					qiCheng();
					break
				case "btnXiuXi":
					xiuXi();
					break;
				default:
					break;	
			}
		}

		
		/*****************通讯*************/
		/**
		 * 坐骑列表 
		 * 
		 */		
		private function getData():void
		{
			var vo:PacketCSHorseList=new PacketCSHorseList();
			
			DataKey.instance.send(vo);
		}
		private function SCHorseList(p:PacketSCHorseList2):void
		{
			//2014-10-24
			if(ZuoQiMain.getInstance().isStartGuide()){
				NewGuestModel.getInstance().handleNewGuestEvent(1013,0,null);
			}
			select_jie=initselect_jie();
			this.refresh();
			
		}
		/**
		 * 进阶 
		 * @param p
		 * 
		 */	
		private function CSHorseStar():void{
			var p1:PacketCSHorseStar=new PacketCSHorseStar();
			
			if (mc['chk1'].selected)
			{
				p1.isrmb=1;
				
			}
			else
			{
				p1.isrmb=0;
			}
			
			p1.horsepos=curData.horsepos;
			uiSend(p1);
		}	
		private function SCHorseStar(p:PacketSCHorseStar2):void
		{
			if (super.showResult(p)){
				ItemManager.instance().showWindowEffect("effect_zhuang_bei_success", mc, 198, 211);
				this.refresh();
			}else{
				ItemManager.instance().showWindowEffect("effect_fail", mc, 328, 195);
			}
			NewGuestModel.getInstance().handleNewGuestEvent(1013,4,mc);
			NewGuestModel.getInstance().handleNewGuestEvent(1013,3,mc);
			NewGuestModel.getInstance().handleNewGuestEvent(1013,2,mc);
		}
		/**
		 * 更换皮肤 
		 * @param _level_Index
		 * 
		 */		
		private function sendCSHorseSetCurrSkin(_level_Index:int):void
		{
			var p:PacketCSHorseSetCurrSkin=new PacketCSHorseSetCurrSkin();
			p.page=_level_Index;
			DataKey.instance.send(p);
		}
		/**
		 * 坐骑时装
		 * @param p
		 * 
		 */		
		public function SCHorseFachionUse(p:PacketSCHorseFachionUse2):void
		{
			if (super.showResult(p))
			{				
				this.getData();
			}
			else
			{
				//
			}
		}
		public function SCHorseFachionUnUse(p:PacketSCHorseFachionUnUse2):void
		{
			if (super.showResult(p))
			{	
				this.getData();	
			}
			else
			{
				//
			}			
		}
		
		/**
		 *	 坐骑骑乘
		 */
		public static function qiCheng(horsepos:int=1):void
		{
			if (PathAction.isHuSong == true)
			{
				return;
			}
			if (Action.instance.yuJianFly.fly)
			{
				return;
			}
			
			if (Action.instance.yuBoat.boat)
			{
				//xiuXi();
				return;
			}
			
			if (Data.myKing.king.isBoat)
			{
				//xiuXi();
				return;
			}
			horsepos=1;

			var client:PacketCSRideOn=new PacketCSRideOn(); //上马
			client.horsepos=horsepos;
			DataKey.instance.send(client);
		}
		public function qiChengReturn(p:PacketSCRideOn2):void
		{
			if (super.showResult(p)){
				//this.refresh();
			}else{
				
			}
		}
		
		/**
		 *	 坐骑休息
		 */
		public static function xiuXi():void
		{			
			var client:PacketCSRideOff=new PacketCSRideOff(); //下马
			DataKey.instance.send(client);
		}
		
		private function xiuXiReturn(p:PacketSCRideOff):void
		{		
			if (super.showResult(p)){
				
			}else{
				
			}
		}
	
		private function refresh():void
		{
			var s:int;
			if (curData!=null)
			{
				mc['txt_not_open'].htmlText='';
				mc['mc_name'].visible=true;
				mc['mc_jie'].visible=true;
				

				var strong_lvl:int=curData.strong_level;
				var tt:int=Math.ceil(strong_lvl / 10);
				mc['mc_name'].gotoAndStop(tt);
				mc['mc_jie'].gotoAndStop(tt);
				if (strong_lvl % 10 == 0)
				{
					sendCSHorseSetCurrSkin(tt);
				}

				var start_:int=((strong_lvl-1) % 10+1);
				
				for (s=1; s <= 10; s++){
					if (start_ >= s){
						mc['star' + s.toString()].gotoAndStop(2);
					}else{
						mc['star' + s.toString()].gotoAndStop(1);
					}
					mc['star' + s.toString()].visible=true;
				}
				
				//
				mc['btnQiCheng'].visible=true;
				//最大阶是否要灰掉?
				mc['btnShenXin'].visible=true;
				
				var m_strong:Pub_Sitzup_UpResModel = XmlManager.localres.SitzUpUpXml.getStrong(curData.horseid,curData.curStrong+1);
				if(m_strong!=null){
					//
					var tool:Pub_ToolsResModel=XmlManager.localres.getToolsXml.getResPath(m_strong.need_tool) as Pub_ToolsResModel;
					if (null != tool){
						mc['txt_tool_name'].htmlText=LianDanLu.instance().showToolEnough(tool.tool_id,m_strong.num);	
					}
					else
					{
						mc['txt_tool_name'].htmlText="";
					}
					mc['chk1_coin3'].htmlText=Lang.getLabel("900003_chk1_coin3", [m_strong.cost_coin3]);
					mc['chk1_coin3'].visible=true;
					mc['chk1'].visible=true;
					mc["mc_txt_xh"].visible=true;
					mc["mc_txt_cgl"].visible=true;
					
					mc['txt_succeed_odd'].htmlText=Math.floor(m_strong.succeed_odd / 100).toString() + "%";
					
					
				}
				//显示属性
				var att:String=getAttByLevel(curData.horseid, curData.curStrong);
				if(att!=""){
					mc["txt_att"].htmlText=att;
					m_strong=XmlManager.localres.SitzUpUpXml.getStrong(curData.horseid, curData.curStrong) as Pub_Sitzup_UpResModel;
					
					if (null != m_strong)
					{
						mc['txt_zhanDouLi'].htmlText=m_strong.grade_value;
					}	
				}else{
					mc["txt_att"].text="";
				}
				//显示下一级属性
				att=getAttByLevel(curData.horseid, curData.curStrong+1,false);
				if(att!=""&&curData.strong_level < curData.maxStrong){
					mc["txt_att_next"].htmlText=att;
				}else{
					mc["txt_att_next"].text="";
				}
				//达到最大
				if (curData.strong_level == curData.maxStrong)
				{
					mc["btnShenXin"].visible=false;
					mc['txt_tool_name'].htmlText="";
				
					mc["txt_tool_name"].text="";
					mc["txt_succeed_odd"].text="";
					mc["chk1_coin3"].text="";
					mc['chk1'].visible=false;
					mc["mc_txt_xh"].visible=false;
					mc["mc_txt_cgl"].visible=false;
				}
				itemSelectedOther(curData);
				
				NewGuestModel.getInstance().handleNewGuestEvent(1013,1,mc);
			}else{
				mc['mc_name'].visible=false;
				mc['mc_jie'].visible=false;
		
				mc["txt_tool_name"].htmlText='';
				for (s=1; s <= 10; s++){
					mc['star' + s.toString()].gotoAndStop(1);
					mc['star' + s.toString()].visible=false;
				}
				mc['btnQiCheng'].visible=false;
				mc['btnShenXin'].visible=false;
				mc["btnPrev"].visible=false;
				mc["btnNext"].visible=false;
			}
		}
		
		public function itemSelectedOther(itemData:StructHorseList2=null):void{
			if (null != itemData){
				//
				if (select_jie > (itemData.strong_level / 10)){
					StringUtils.setUnEnable(mc["btnQiCheng"]);
				}else{
					StringUtils.setEnable(mc["btnQiCheng"]);
				}

				if (itemData.state == 1){
					mc["btnQiCheng"].visible=false;
					mc["btnXiuXi"].visible=true;
				}else{
					mc["btnQiCheng"].visible=true;
					mc["btnXiuXi"].visible=false;
				}
				if (-1 == select_jie){
					select_jie=itemData.curStrong;
				}
				if(select_jie>=curData.max_jie)select_jie=curData.max_jie;
				//
				refresh_sub_status();
				
				//坐骑形象
				var showM:Pub_Sitzup_ShowResModel=XmlManager.localres.SitzupShowXml.getS1(itemData.horseid,select_jie * 10+1) as Pub_Sitzup_ShowResModel;
				if (null != showM){
					var path:String=FileManager.instance.getZuoQiById(showM.s1_show);
					mc["mcZuoqi"].source=path;
				}
				//坐骑时尚
				this.showFachionId(itemData.fachion_id);
				var strong_lvl:int=curData.strong_level;
				if(strong_lvl>0&&strong_lvl>=(select_jie+1)*10){
					mc["isjiefeng"].htmlText=Lang.getLabel("900016_chibangkaiqi");
					mc["txt_jiefeng_desc"].htmlText="";
				}else{
					mc["isjiefeng"].htmlText=Lang.getLabel("900017_chibangkaiqi");
					mc["txt_jiefeng_desc"].htmlText="升到10星可解封此形象";
				}
			}
		}
		
		private function getAttByLevel(horseid:int,level:int,showName:Boolean=true):String{
			var ret:String="";
			var m_strong:Pub_Sitzup_UpResModel=XmlManager.localres.SitzUpUpXml.getStrong(horseid,level) as Pub_Sitzup_UpResModel;
			
			if (null != m_strong)
			{
				var list:Array=[];
				for (var j:int=1; j <= FUNC_NUM; j+=2){
					list.push({fn: m_strong["func" + j.toString()], v1: Math.abs(m_strong["value" + j]), v2: Math.abs(m_strong["value" + (j + 1)])});
				}				
				for (j=0; j < list.length; j++){
					if (list[j].fn > 0)
					{
						if(showName)ret+=Att.getAttName(list[j].fn)+"：";
						if (list[j].v2 > 0){
							ret+=Att.getAttValuePercent(list[j].fn, list[j].v1) + "-" + Att.getAttValuePercent(list[j].fn, list[j].v2);								
						}else{
							ret+=Att.getAttValuePercent(list[j].fn, list[j].v1);
						}
						ret+="<br/>";
					}
				}			
			}
			return ret;
		}
		/**
		 * 按钮状态变换 
		 * 
		 */		
		private function refresh_sub_status():void
		{
			mc["btnPrev"].visible=true;
			mc["btnNext"].visible=true;
			if (0 == select_jie || -1 == select_jie){
				StringUtils.setUnEnable(mc['btnPrev']);
			}else{
				StringUtils.setEnable(mc['btnPrev']);
			}
			if (null != ZuoQiMain.curData && (select_jie+1)*10 < ZuoQiMain.curData.maxStrong){
				StringUtils.setEnable(mc['btnNext']);
			}else{
				StringUtils.setUnEnable(mc['btnNext']);
				
			}
		}
		/**
		 *	物品列表
		 */
		private function showFachionId(value:int):void
		{
			var item:Pub_ToolsResModel=null;
			child=mc["mc_shiZhuang"];
			item=XmlManager.localres.getToolsXml.getResPath(value) as Pub_ToolsResModel;
			if (item != null){
				var bag:StructBagCell2=new StructBagCell2();
				bag.itemid=item.tool_id;
				Data.beiBao.fillCahceData(bag);
				//bag.num=arr[i-1].drop_num;

				ItemManager.instance().setToolTipByData(child, bag);
				child.mouseEnabled=true;
			}else
			{
				ItemManager.instance().removeToolTip(child);
			}
		}
		override public function winClose():void
		{
			NewGuestModel.getInstance().handleNewGuestEvent(1013,5,null);
			super.winClose();
		}
		override public function getID():int
		{
			return 0;
		}

		/**
		 * 角色界面 坐骑悬浮按钮属性
		 * @return 
		 * 
		 */		
		public function getCurAtt(horseList:Vector.<StructHorseList2>):String{
			if(horseList==null||horseList.length==0)return "您尚未装备坐骑。进阶坐骑可以大幅提升坐骑属性。坐骑功能35级开启。";
			var itemData:StructHorseList2=horseList[0];
			
			var ret:String="";
			ret=getAttByLevel(itemData.horseid, itemData.curStrong);
			
			if(itemData.curStrong==0||ret==""){
				ret="您尚未进阶坐骑。进阶坐骑可以大幅提升坐骑属性。坐骑功能35级开启。";
			}
			return ret;
		}
		
		/**
		 * 是否开始坐骑引导 
		 * 
		 */		
		public function isStartGuide():void{
			var horseList:Vector.<StructHorseList2>=Data.zuoQi.getHorseList().arrItemhorselist;
			if(Data.myKing.level>=35 && horseList!=null && horseList.length>0){
				NewGuestModel.getInstance().handleNewGuestEvent(1013,0,null);
			}
		}
	}
}
