package ui.view.view2.liandanlu
{
	
	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_Equip_Strong_2ResModel;
	import common.config.xmlres.server.Pub_Equip_Strong_CostResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.drag.MainDrag;
	import common.utils.res.ResCtrl;
	
	import engine.event.DispatchEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.text.TextField;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import ui.base.npc.NpcBuy;
	import ui.base.npc.NpcShop;
	import ui.base.renwu.Renwu;
	import ui.frame.FontColor;
	import ui.frame.ItemManager;
	import ui.frame.UIPanel;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.newFunction.FunJudge;
	import ui.view.view1.fuben.FuBen;
	import ui.view.view2.NewMap.GameAutoPath;
	import ui.view.view2.motianwanjie.MoTianWanJie;
	import ui.view.view4.yunying.ZhiZunVIPMain;

	/**
	 *	炼丹炉
	 *  andy 2011-12-12 
	 *  andy 2013-04-11
	 *  andy 2013-12-25  3000万 
	 */
	public class LianDanLu extends UIWindow{

		//curMc
		private var panel:UIPanel;
		//
		private var arrBtnName:Array=["","btn_chong_xing","btn_jian_ding","","btn_bao_shi","btn_bao_shi"];
		//由于菜单切换太快，导致帧上元件为空，特此控制两次点击时间
		private var delayTime:int=1;
		//
		private var date:Date=null;
		//
		private var childIndex:int=0;
		private var arrBagData:Array=null;
		
		private var mc_content:Sprite=null;
		
		private static var _instance:LianDanLu;

		public static function instance():LianDanLu{
			if(_instance==null){
				_instance=new LianDanLu();
			}
			return _instance;
		}
		
		public function LianDanLu(){
			super(this.getLink(WindowName.win_zhuangbei));
			doubleClickEnabled=true;
		}
		
		override public function get width():Number{
			return 655;
		}
		override public function get height():Number{
			return 495;
		}

		private var callBackFunc:Function=null;
		public function setType(v:int,must:Boolean=false,f:Function=null,childMenu:int=0):void{			
			if(FunJudge.judgeByName(arrBtnName[v])==false){
				return;
			}else{
				
			}
			type=v;
			callBackFunc = f;
			childIndex=childMenu;
			super.open(must);
		}
		override protected function openFunction():void{
			init();
		}
		override protected function init():void{
			super.init();
			super.blmBtn=5;
			super.sysAddEvent(PubData.mainUI.stage,MainDrag.DRAG_UP,dragUpHandler);
			mc_content=new Sprite();
			
			
			//初始化是否开放
			for(i=1;i<=blmBtn;i++){
				if(mc["cbtn"+i]!=null)
				mc["cbtn"+i].visible=FunJudge.judgeByName(arrBtnName[i],false);
			}
			if(date==null)
				date=new Date();
			if(type==0) type=1;

			mcHandler({name:"cbtn"+type});
			
		}	
		override protected function mcDoubleClickHandler(target:Object):void{
			var name:String=target.name;
			if(panel!=null) panel.mcDoubleClickHandler(target);
		}
		override public function mcHandler(target:Object):void
		{
			if(date.time-delayTime<200){
				return;
			}else
				delayTime=date.time;
			
			var name:String=target.name;
			if(name.indexOf("cbtn")==-1){
				if(panel!=null) panel.mcHandler(target);
				return;
			}
			
			super.mcHandler(target);
			if(panel!=null&&panel.parent!=null)panel.parent.removeChild(panel);
			type=int(name.replace("cbtn",""));
			switch(name){
				case "cbtn1":
					//强化
					panel=QH.instance();
					break;
				case "cbtn2":
					//强化转移
					panel=QHMove.instance();
					break;
				case "cbtn3":
					//强化清除
					panel=QHClear.instance();
					break;
				case "cbtn4":
					//强化石合成
					panel=QHCompose.instance();
					break;
				case "cbtn5":
					//宝石镶嵌
					panel=BSXQ.instance();
					break;
				case "cbtn6":
					//宝石合成
					panel=BSHC.instance();
					break;
				default :
					break;
			}
			panel.x=0;
			panel.y=0;
			panel.type=childIndex;
			panel.init();
			this.mc["mc_content"].addChild(panel);
			
		}
		
		
		override protected function windowClose():void{
			super.windowClose();
			if(panel!=null)panel.windowClose();
			
			
		}
		
		
		/**
		 *	装备列表
		 *  @param who    1.已经穿戴 2.未穿戴 3.宝石 4.强化石
		 *  @param sp     滚动条
		 *  @param isDrag 是否拖拽
		 */
		public static const arrLimit:Array=[0,ResCtrl.EquipLimit_Strong,ResCtrl.EquipLimit_Strong,ResCtrl.EquipLimit_Strong,ResCtrl.EquipLimit_Beswallow,ResCtrl.EquipLimit_Inherit,ResCtrl.EquipLimit_ColorUp,ResCtrl.EquipLimit_Awake,ResCtrl.EquipLimit_Resolve];	
		private const defaultCount:int=24;
		private var sp_content:Sprite=null;
		private var isDrag:Boolean=false;
		
		public function showEquip(who:int,drag:Boolean=false):void{
			isDrag=drag;
			if(who==1){
				arrBagData=this.getWearEquip(arrLimit[type]);		
			}else if(who==2){
				arrBagData=this.getNotWearEquip(arrLimit[type]);		
			}else if(who==3){
				arrBagData=Data.beiBao.getBeiBaoBySort(17,true);	
				arrBagData.sortOn("stoneLevel",Array.NUMERIC|Array.DESCENDING);
			}else if(who==4){
				arrBagData=Data.beiBao.getBeiBaoBySort(19,true);	
				arrBagData.sortOn("stoneLevel",Array.NUMERIC|Array.DESCENDING);
			}else{
				arrBagData=this.getWearEquip(arrLimit[type]);
				arrBagData=arrBagData.concat(this.getNotWearEquip(arrLimit[type]));
			}

			var temp:Array=[];
			if(type==4){
				//2014-05-19 宝石合成，增加宝石碎片
				arrBagData=arrBagData.sortOn("isTrade",Array.NUMERIC|Array.DESCENDING);
				arrBagData=arrBagData.sortOn("stoneLevel",Array.NUMERIC);
			}else if(type==6){
				//2014-05-19 宝石合成，增加宝石碎片
				temp=Data.beiBao.getBeiBaoBySort(23,true);
				arrBagData=arrBagData.concat(temp);
			}else{
				
			}
			if(sp_content!=null&&sp_content.numChildren>0){
				while(sp_content.numChildren>0)sp_content.removeChildAt(0);
			}
			
			if(arrBagData!=null){
				var item:StructBagCell2=null;
				var len:int=arrBagData.length;
				sp_content=new Sprite();
				var cellCount:int=len<defaultCount?defaultCount:len;
				for(i=0;i<cellCount;i++){
					child=ItemManager.instance().getDuanZaoItem(i) as MovieClip;
					if(child==null)continue;
					child.name="item"+(i+1);
					if(i<len){
						item=arrBagData[i];
						if(isDrag){
							MainDrag.getInstance().regDrag(child);
						}else{
							MainDrag.getInstance().unregDrag(child);
						}
						child.mouseEnabled = true;
						setOneEuip(child,item);
						if(child["mc_not_show"]!=null)
							child["mc_not_show"].visible=false;
					}else{
						child.mouseEnabled = false;
						if(child["mc_not_show"]!=null)
							child["mc_not_show"].visible=true;
					}
					sp_content.addChild(child);
				}
			}
//			panel.mc["sp_equip"].overHeight=30;
			
			
			CtrlFactory.getUIShow().showList2(sp_content,6,0,40);
			panel.mc["sp_equip"].source=sp_content;
			panel.mc["sp_equip"].position=0;
			sp_content.x=10;
		}
		/**
		 *	设置一个装备信息
		 */
		public function setOneEuip(child:MovieClip,item:StructBagCell2):void{
			child.mouseChildren=false;
			child["mc_up"].gotoAndStop(type);
			if(item!=null){
				ItemManager.instance().setToolTipByData(child,item);
				if(type==1||type==2||type==3){
					//强化星级
					if(item.equip_strongLevel>0){
						child["mc_up"]["txt_star"].htmlText="+"+item.equip_strongLevel;
					}else{
						child["mc_up"]["txt_star"].htmlText="";
					}
				}else{
					
				}
			}else{
				
			}
		}
		
		/**
		 *	消耗银两
		 *  2013-12-21 
		 */
		public function showMoney(sort:int,strongLevel:int):String{
			var ret:String="";
			var need:Pub_Equip_Strong_CostResModel=XmlManager.localres.equipStrongCostXml.getResPath2(sort,strongLevel) as Pub_Equip_Strong_CostResModel;
			if(need!=null){
				if(need.need_coin1>0){
					ret+=isEnoughCoin(need.need_coin1,1);
				}
				if(need.need_coin3>0){
					ret+=isEnoughCoin(need.need_coin3,3);
				}
			}
			return ret;
		}
		/**
		 *	消耗银两
		 *  2013-12-21 
		 */
		public function showMoneyType(sort:int,strongLevel:int):String{
			var ret:String="";
			var need:Pub_Equip_Strong_CostResModel=XmlManager.localres.equipStrongCostXml.getResPath2(sort,strongLevel) as Pub_Equip_Strong_CostResModel;
			if(need!=null){
				if(need.need_coin1>0){
					ret+=Lang.getLabel("pub_yin_liang");
				}
				if(need.need_coin3>0){
					ret+=Lang.getLabel("pub_yuan_bao");
				}
			}
			return ret;
		}
		
		/**
		 *	元宝是否充足
		 *  2013-12-28
		 * 	@param coin     数值
		 *  @param coinType 类型
		 */
		public function isEnoughCoin(coin:int,coinType:int=1):String{
			var ret:String="";
			var enough:Boolean=coinType==1?Data.myKing.coin1>=coin:Data.myKing.coin3>=coin;

			if(enough){
				ret="<font color='#00ff00'>"+coin+"</font>";
			}else{
				ret="<font color='#ff0000'>"+coin+"</font>";
			}
			return ret;
		}
		
		/**
		 *	显示强化星级
		 *  2013-12-21 
		 */
		public function showStar(txt:TextField,strongLevel:int):void{
			if(strongLevel>0){
				txt.htmlText="<b>+"+strongLevel+"</b>";
			}else{
				txt.htmlText="";
			}
		}
		/**
		 *	显示配方  此处会报空对象错误   王稳修改一下 2014.01.26.19:25
		 * 	@param data        配方id
		 *  @param isIcon      是否以元件显示 
		 *  @param content     父容器
		 *  @param rowNum      每行显示个数
		 *  @param isCheckRole 如果是装备，是否统计身上的装备
		 */
		public function showConfig(data:Object,isIcon:Boolean=true,content:MovieClip=null,rowNum:int=1,isCheckRole:Boolean=true):Array{
			var config:Array=null;
			if(data is Array){
				config=data as Array;
			}else{
				config=ResCtrl.instance().getDanFangConfig(data as int);
			}
			
			if(content==null)content=panel.mc as MovieClip;
			
			var len:int=config.length;
			var item:StructBagCell2=null;
			//2012-05-17 缺材料的元宝价格
			var needCoin3:int=0;
			//文本显示材料
			if(isIcon==false){
				var needCaiLiao:String="";
				for(i=0;i<len;i++){
					item=config[i];
					//材料包含仓库
					var cnt:int=0;
					if(item.itemid>10){
						cnt=Data.beiBao.getBeiBaoCountById(item.itemid,true);
						if(item.sort==13&&isCheckRole){
							cnt+=Data.beiBao.confirmRoleEquipById(item.itemid);
						}
						if(cnt<item.need_num){
							needCaiLiao+=ResCtrl.instance().getFontByColor(item.itemname,item.toolColor)+" <font color='#"+FontColor.TOOL_NOT_ENOUGH+"'>["+cnt+"/"+item.need_num+"]</font>";
							needCoin3+=item.buyprice3*(item.need_num-cnt);
						}else{
							needCaiLiao+=ResCtrl.instance().getFontByColor(item.itemname,item.toolColor)+" <font color='#"+FontColor.TOOL_ENOUGH+"'>["+cnt+"/"+item.need_num+"]</font>";
						}
					}else{
						//特殊碎片
						needCaiLiao+=showSuiPianEnough(item.itemid,item.need_num);
					}
					if(i%rowNum==0&&i>0)
						needCaiLiao+="<br/>";
					else
						needCaiLiao+="  ";
				}				
				if(content["txt_need"]!=null){
					if(len>0)
						content["txt_need"].htmlText=needCaiLiao;
					else
						content["txt_need"].htmlText="";
				}				
			}else{
				//ICON显示材料
				var child:MovieClip=null;
				for(i=1;i<=4;i++){
					child=content["cailiao"+i];
					if(child==null)continue;
					if(i<=len){
						item=config[i-1];
						ItemManager.instance().setToolTipByData(child,item,1);
						//材料包含仓库
						cnt=Data.beiBao.getBeiBaoCountById(item.itemid,true);
						child["txt_num"].visible=true;
						if(cnt<item.need_num){
							child["txt_num"].htmlText="<font color='#"+FontColor.TOOL_NOT_ENOUGH+"'>"+cnt+"/"+item.need_num+"</font>";
							needCoin3+=item.buyprice3*(item.need_num-cnt);
							
						}else{
							child["txt_num"].htmlText="<font color='#"+FontColor.TOOL_ENOUGH+"'>"+cnt+"/"+item.need_num+"</font>";
						}
						if(content["txt_cailiao_name"+i]!=null)
							content["txt_cailiao_name"+i].htmlText=ResCtrl.instance().getFontByColor(item.itemname,item.toolColor-1);
						
					}else{
						ItemManager.instance().removeToolTip(child);
						if(content["txt_cailiao_name"+i]!=null)
							content["txt_cailiao_name"+i].htmlText="";
					}
				}
			}
			
			if(content["mc_need_coin"]!=null){
				if(needCoin3>0){
					content["mc_need_coin"].visible=true;
					content["mc_need_coin"]["txt_yuan_bao"].text="【"+needCoin3+Lang.getLabel("pub_yuan_bao")+"】";
				}else{
					content["mc_need_coin"].visible=false;
				}	
			}	
			return config;
		}
		/**
		 *	显示需要碎片数量
		 * 	@param id        碎片id
		 *  @param need_num  需要数量

		 */
		public function showSuiPianEnough(id:int,need_num:int):String{
			var isEnough:Boolean=getSuiPianValue(id)>=need_num;
			if(!isEnough){
				return Lang.getLabel("pub_suipian"+id)+" <font color='#"+FontColor.TOOL_NOT_ENOUGH+"'>×"+need_num+"</font>";
			}else{
				return Lang.getLabel("pub_suipian"+id)+" <font color='#"+FontColor.TOOL_ENOUGH+"'>×"+need_num+"</font>";
			}
		}
		/**
		 *	根据图谱ID取碎片值
		 * 	@param id        图谱id
		 *  @param need_num  碎片值
		 
		 */
		public function getSuiPianValue(id:int):int{
			switch(id){
				case 1:
					//
					return Data.myKing.value1;
					break;
				case 2:
					//
					return Data.myKing.value2;
					break;
				case 3:
					//
					return Data.myKing.value3;
					break;
				case 4:
					//
					return Data.myKing.value4;
					break;
				case 5:
					//
					return Data.myKing.value5;
					break;
				default:
					return 0;
					break;
			}
		}
		/**
		 *	显示需要道具数量
		 * 	@param id        道具id
		 *  @param need_num  需要数量
		 
		 */
		public function showToolEnough(id:int,need_num:int,needLine:Boolean=false):String{
			var toolName:String=XmlManager.localres.getToolsXml.getResPath(id)["tool_name"];
			var count:int=Data.beiBao.getBeiBaoCountById(id,true);
			var isEnough:Boolean=count>=need_num;
			if(!isEnough){
				return "<font color='#"+FontColor.TOOL_NOT_ENOUGH+"'>"+(needLine?"<u>"+toolName+"</u>":toolName)+" ×"+need_num+"</font>";
			}else{
				return "<font color='#"+FontColor.TOOL_ENOUGH+"'>"+(needLine?"<u>"+toolName+"</u>":toolName)+" ×"+need_num+"</font>";
			}
		}
		/**
		 *	消耗银两是否充足 2014-02-11
		 *  @param need_num  需要数量		 
		 */
		public function showCoin1Enough(need_coin1:int):String{
			var coin1:int=Data.myKing.coin1;
			var isEnough:Boolean=coin1>=need_coin1;

			if(!isEnough){
				return "<font color='#"+FontColor.TOOL_NOT_ENOUGH+"'>"+StringUtils.changeToTenThousand(need_coin1)+Lang.getLabel("pub_yin_liang")+"</font>";
			}else{
				return "<font color='#"+FontColor.TOOL_ENOUGH+"'>"+StringUtils.changeToTenThousand(need_coin1)+Lang.getLabel("pub_yin_liang")+"</font>";
			}
		}

		/**
		 *	装备拖拽弹起事件
		 *  2013-04-12 
		 */
		private function dragUpHandler(e:DispatchEvent) : void {
			var start:Object=MainDrag.currTarget;
			var end:Object=e.getInfo;
			
			if (start != null) {
				var startData:StructBagCell2=start.data;
				if(startData==null)return;
				if(start==end)return;
				if (CtrlFactory.getUICtrl().checkParent(end, WindowName.win_bs_xq)) {
					//吞噬
					if(end.name.indexOf("mc_stone_icon")==0){
						//function delay():void{
							BSXQ.instance().dragUp(end as Sprite,startData);
						//}
						//flash.utils.setTimeout(delay,300);
						
					}
					
					return;
				}else {

				}  
			}	
		}
		
		
		/**
		 *	装备界面上的各种文本点击 
		 */
		public function linkHandle(e:TextEvent):void{
			//传送
			if(e.text.indexOf("@")>=0){
				Renwu.textLinkListener_(e);
				return;
			}
			
			var arr:Array=e.text.split(",");
			var type:int=arr[0];
			switch(type){
				case 0:
					//兑换商店
					//NpcShop.instance().setshopId(NpcShop.DUI_HUAN_SHOP_ID);
					break;
				case 1:
					//多人副本
//					HuoDong.instance().setType(5);
					break;
				case 2:
					//

					break;
				case 3:
					//单人副本
					//FuBen.viewMode = 1;
					FuBen.instance.open(true);
					break;
				case 4:
					//魔天万界
					MoTianWanJie.instance().open(true);
					break;
				case 5:
					//直接购买
					var bag:StructBagCell2=new StructBagCell2();
					bag.itemid=arr[1];
					Data.beiBao.fillCahceData(bag);
					
					NpcBuy.instance().setType(4,bag,true,NpcShop.PUB_SHOP_BUY_ID);
					break;
				case 6:
					//合成神翼升级材料
					
					break;
				case 7:
					//2012-01-08 抽奖界面
					
					break;
				case 8:
					//2013-04-23  至尊特权界面
					ZhiZunVIPMain.getInstance().open(true);
					break;
				default:
					GameAutoPath.seek(type);
					break;
			}
		}
		/**
		 *	穿戴的装备
		 *  2013-07-31  
		 *  @param  limitType 装备操作限制
		 */
		public function getWearEquip(limitType:int=0):Array{
			var ret:Array=[];
			var arrRole:Array=null;

			//角色装备【】
			arrRole=Data.beiBao.getRoleEquipList(0,15,limitType);
			if(arrRole==null)arrRole=[];

			ret=arrRole;
			return ret;
		} 
		/**
		 *	未穿戴的装备
		 *  2013-07-31 
		 *  @param  limitType 装备操作限制
		 */
		public function getNotWearEquip(limitType:int=0):Array{
			var ret:Array=[];
			var arrRole:Array=null;

			arrRole=Data.beiBao.getBeiBaoBySort(13,false,limitType);
			//arrRole=arrRole.concat(Data.beiBao.getBeiBaoByType(21,false,limitType));

			if(arrRole==null)arrRole=[];
			ret=arrRole;
			return ret;
		} 
		/**
		 * 获得装备战斗力 
		 * @param v
		 * @return 
		 * 
		 */		
		public function getEquipFightValue(v:StructBagCell2):int{
			var ret:int=0;
			ret+=v.gradeValue;
			var strongXml:Pub_Equip_Strong_2ResModel=XmlManager.localres.getEquipSrongXml.getResPath2(v.strongId,v.equip_strongLevel) as Pub_Equip_Strong_2ResModel ;
			if(strongXml!=null){
				ret+=strongXml.grade_value;
			}
			return ret;
		}
		
		override public function getID():int
		{
			return 1012;
		}
		
		public function getPanel():UIPanel{
			return panel;
		}

	}
}