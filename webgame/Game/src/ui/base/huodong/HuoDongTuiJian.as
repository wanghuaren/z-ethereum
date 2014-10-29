package ui.base.huodong
{
	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.clock.GameClock;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	
	import netc.Data;
	import netc.dataset.*;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import scene.color.GameColor;
	
	import ui.base.mainStage.UI_index;
	import ui.base.renwu.Renwu;
	import ui.base.vip.VipGift;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view2.NewMap.GameAutoPath;
	import ui.view.view2.liandanlu.LianDanLu;
	import ui.view.view2.mrfl_qiandao.QianDaoPage_2;
	import ui.view.view2.other.ControlButton;
	
	import world.FileManager;
	import world.WorldEvent;
	
	/**
	 *	活动推荐
	 */
	public class HuoDongTuiJian extends UIWindow
	{
		//列表内容容器
		private var mc_content:Sprite;
		
		public const AutoRefreshSecond:int=30;
		private var curAutoRefresh:int=0;
		
		private static var _instance:HuoDongTuiJian;
										
		//默认的OperatingActivity索引
		private var m_defaultOAIndex:int=0;
		
		/**
		 *
		 */
		public static function instance():HuoDongTuiJian
		{
			if (_instance == null)
			{
				_instance=new HuoDongTuiJian();
			}
			return _instance;
		}
		
		public function HuoDongTuiJian(d:Object=null)
		{
			blmBtn=3;
			type=1;
			super(getLink(WindowName.win_huo_dong_tui_jian), d);
		}
		
		public function setType(t:int=1, must:Boolean=false, defaultOAIndex:int=0):void
		{
			type=t;
			this.m_defaultOAIndex=defaultOAIndex;
			super.open(must);
			
		}
		
		override protected function openFunction():void
		{
			init();
		}
		
		override public function get width():Number
		{
			return 806;
		}
		
		override public function get height():Number
		{
			return 450;
		}
		
		//面板初始化
		override protected function init():void
		{
			if (m_initW < 0)
			{
				m_initW=mc.width;
				m_initH=mc.height;
			}
			
			//已被挪走或关闭的标签页
			//mc["cbtn6"].visible = false;
			//mc["cbtn7"].visible = false;
			//mc["cbtn8"].visible = false;
			//newcodes
			//mc["cbtn9"].visible = false;
			//			mc["cbtn2"].visible = false;
			//			mc["cbtn4"].visible = false;
			//mc["cbtn11"].visible = false;
			//mc["cbtn5"].visible = false;
			//end
			clearMcContent();
									
			mc_content=new Sprite();
			//this.addChild(mc_content);
			
			super.sysAddEvent(mc_content, MouseEvent.MOUSE_OVER, overHandle);
			super.sysAddEvent(Data.huoDong, HuoDongSet.HUOYUE_UPD, showDayTuiJian);
			super.sysAddEvent(Data.huoDong, HuoDongSet.TUIJIAN_LIST_UPD, showDayTuiJian);
			
			//地宫boss
			//this.uiRegister(PacketSCGetDiGongBossState.id,onGetBossStateCallback);
			
			
			//推荐
//			this.uiRegister(PacketSCGetDayLimitPrize.id, SCGetDayLimitPrize);
			
			
			//
			this.uiRegister(PacketSCGetActivityPrize.id, linQuReturn);
			this.uiRegister(PacketSCLimitUpdate.id, limitUpdate);
			
			//this.uiRegister(PacketSCServerTitleWinerName.id, _SCServerTitleWinerName);
			
			this.uiRegister(PacketSCGetDayPrizeRmb.id,SCGetDayPrizeRmb);
			
			//
			curAutoRefresh=0;
			
			//
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, autoRefreshHandler);
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, autoRefreshHandler);
			
			//
			mcHandler({name: "cbtn" + type});
			
			//
			HuoDongEventDispatcher.getInstance().checkReward();
			
			//
			UI_index.instance.huoYueChk();
			
			replace();
			
			//_visibleTipComplateTask(true);
			
		}
		
		private function _visibleTipComplateTask(b:Boolean):void
		{
			//0010527: [版本：玄仙传奇]推荐引导
			if (Data.myKing.level > 40||Data.myKing.level <25)
			{
				b=false;
			}
			
			if(null != mc['mcMeirituijian']){
			mc['mcMeirituijian'].visible=b;
			}
			
			if (b)
			{
//				if(null != mc['mcMeirituijian']){
//				mc['mcMeirituijian'].x=30;
//				}
			}
			else
			{
//				if(null != mc['mcMeirituijian']){
//				mc['mcMeirituijian'].x=142;
//				}
				
			}
		}
		
		
		public function SCGetDayLimitPrize(p:PacketSCGetDayLimitPrize2):void
		{
			
			if (super.showResult(p))
			{
				
				if(null != mc["btnTuiJianTaskLingQu"])
					StringUtils.setUnEnable(mc["btnTuiJianTaskLingQu"]);
				
				
				if (ControlButton.getInstance().isVisible("arrHuoYue"))
				{
					ControlButton.getInstance().setVisible("arrHuoYue", true, false,0,HuoDong.GetDayTuiJianByNumTip());
				}
				
				
			}
			else
			{
				
			}
		}
		
		public function SCGetDayPrizeRmb(p:PacketSCGetDayPrizeRmb2):void
		{
			if (super.showResult(p))
			{
				//刷新数据 2013-08-15 andy
				refreshContent(type);
			}
			else
			{
				//nothing
			}
		}
		
				
		private function autoRefreshHandler(e:WorldEvent):void
		{
			if (6 == type)
			{
				return;
			}
			
			curAutoRefresh++;
			
			if (curAutoRefresh >= AutoRefreshSecond)
			{
				curAutoRefresh=0;
				mcHandler({name: "cbtn" + type});
				//
				HuoDongEventDispatcher.getInstance().checkReward();
				//
				UI_index.instance.huoYueChk();
				
				
			}
			
		}
		
		private function clearMcContent():void
		{
			if (null != mc_content)
			{
				while (mc_content.numChildren > 0)
					mc_content.removeChildAt(0);
			}
		}
		
		private function overHandle(e:MouseEvent):void
		{
			var nm:String=e.target.name;
			if (nm.indexOf("item") == 0)
			{
				//var itemData:StructFriendData2=e.target.data;
				//e.target.tipParam=[itemData.rolename,itemData.jobName,itemData.level,""];
			}
		}
		
		public function itemSelectedOther(target:Object):void
		{
			
		
		}
		
		public function limitUpdate(p:PacketSCLimitUpdate2):void
		{
			//面板刷新 mcHandler
			this.refreshContent((mc as MovieClip).currentFrame);
			
		}
		
		public function linQuReturn(p:PacketSCGetActivityPrize):void
		{
			if (super.showResult(p))
			{
				HuoDongPrize.instance().open(true);
				HuoDongPrize.instance().btnStartClick(p);
			}
			else
			{
				
			}
			
		}
		
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			
			//			
		//	HuoDongBridge.qianDao(mc).mcHandler(target);//2014年1月8日 11:05:01
			
			//有任何点击都将重置倒计时
			curAutoRefresh=0;
			
			var target_name:String=target.name;
			
			
			//
			if (target_name.indexOf("cbtn") >= 0)
			{
				var tp:int=int(target_name.replace("cbtn", ""));
				this.type=tp;
				//有limitUpdate指令
				//UI_index.HuoDongLimitInit();
				refreshContent(tp);
				return;
			}
			
			if (target_name.indexOf("item") == 0)
			{
				
				itemSelected(target);
				itemSelectedOther(target);
			}
			
			
			var client1:PacketCSGetActivityPrize;
			
			switch (target_name)
			{
				
				case "btnLinQu":
					
					var target_parent_name:String=target.parent.name;
					var btnLinQu_n:int=int(target_parent_name.replace("btnLinQu", ""));
					
					client1=new PacketCSGetActivityPrize();
					client1.step_id=btnLinQu_n;
					this.uiSend(client1);
					break;
				case "boxLinQu1":
				case "boxLinQu2":
				case "boxLinQu3":
				case "boxLinQu4":
					var boxLinQu_n:int=int(target_name.replace("boxLinQu", ""));
					
					client1=new PacketCSGetActivityPrize();
					client1.step_id=boxLinQu_n;
					this.uiSend(client1);
					
					break;
				
				case "btnLinQuFuLi":
					
					var csAward:PacketCSGetCampActRankAward=new PacketCSGetCampActRankAward();
					this.uiSend(csAward);
					
					break;
				
				
				case "btnTuiJianQianDao"://签到
					//mcHandler({name: "cbtn12"});
					mcHandler({name: "cbtn1"});
					break;
				case "btnTuiJianTaskLingQu":
					
					//	var csTuiJianTaskLingQu:PacketCSGetDayLimitPrize=new PacketCSGetDayLimitPrize();
					//	this.uiSend(csTuiJianTaskLingQu);
					
					if("btnTuiJianTaskLingQu3" == target.parent.name)
					{
						csTuiJianTaskLingQu=new PacketCSGetDayLimitPrize();
						csTuiJianTaskLingQu.step = 1;					
						this.uiSend(csTuiJianTaskLingQu);	
						
					}else if("btnTuiJianTaskLingQu5" == target.parent.name)
					{
						csTuiJianTaskLingQu=new PacketCSGetDayLimitPrize();
						csTuiJianTaskLingQu.step = 2;					
						this.uiSend(csTuiJianTaskLingQu);	
						
					}else if("btnTuiJianTaskLingQu8" == target.parent.name)
					{
						csTuiJianTaskLingQu=new PacketCSGetDayLimitPrize();
						csTuiJianTaskLingQu.step = 3;					
						this.uiSend(csTuiJianTaskLingQu);		
						
					}else if("btnTuiJianTaskLingQu10" == target.parent.name)
					{
						csTuiJianTaskLingQu=new PacketCSGetDayLimitPrize();
						csTuiJianTaskLingQu.step = 4;					
						this.uiSend(csTuiJianTaskLingQu);	
						
					}else
					{
						
						var csTuiJianTaskLingQu:PacketCSGetDayLimitPrize=new PacketCSGetDayLimitPrize();
						this.uiSend(csTuiJianTaskLingQu);
						
					}
					
					break;
				default:
					break;
			}
			
		}
		
		/**
		 * 自动寻路 
		 * 
		 */
		private function autoSeek(seekId:int):void{
			var vo:PacketCSAutoSeek=new PacketCSAutoSeek();
			vo.seekid=seekId;
			this.uiSend(vo);
		}
		
		public function refreshContent(cbtnX:int):void
		{
						
			(this.mc as MovieClip).gotoAndStop(cbtnX);
			
			
			mc["sp"].visible = false;
			mc["sp10"].visible = false;
			
			_visibleTipComplateTask(false);
			
			switch (cbtnX)
			{
				case 1:
					
					
					break;
				
				case 2:
					
					showDayTuiJian();
					
					_visibleTipComplateTask(true);
					
					break;
							
				case 3:
								
					
					showServerVerUpdate();
					
					//save ver 
					PubData.save(3,PubData.para3);
//					var cs: = new ();
//					
//					cs.data.para1 = -1;
//					cs.data.para2 = -1;
//					cs.data.para3 = PubData.data.para3;
//					cs.data.para4 = -1;
//					
//					uiSend(cs);	
					
					break;
				
				default:
					break;
				
			}
			
		}
		
		
		
		private function txtActionJoinLink(e:TextEvent):void
		{
			Renwu.textLinkListener_(e);
		}
		
		
		
		public function showDayTuiJianTaskSort(a:Pub_CommendResModel, b:Pub_CommendResModel):int
		{
			if (a.ar_complete)
			{
				return 1;
			}
			
			if (b.ar_complete)
			{
				return -1;
			}
			//原样排序
			return 0;
		}
		
		public function showDayTuiJianSort(a:StructActRecList2, b:StructActRecList2):int
		{
			if (a.ar_complete)
			{
				return 1;
			}
			
			if (b.ar_complete)
			{
				return -1;
			}
			//原样排序
			return 0;
		}
		
		public var wan_cheng:int=0;
		/**
		 *	每日推荐 
		 */
		public function showDayTuiJian(e:DispatchEvent=null):void
		{
			if (2 != (mc as MovieClip).currentFrame)
			{
				return;
			}
			//
			mc["sp"].visible=true;
			
			var i:int;
			var len:int;
			//领取按钮根据活跃度来
			var huoYue:int=Data.huoDong.huoYue;
			var myLvl:int = Data.myKing.level;
			//列表	
			clearMcContent();
			//
			//mc["txtHuoYue"].text = Data.huoDong.huoYue;
			
			//活跃进度条			
			if (0 == huoYue)
			{
				huoYue=1;
			}
			if (huoYue > 100)
			{
				huoYue=100;
			}
			var btnList:Array = [
				mc["btnTuiJianTaskLingQu3"],
				mc["btnTuiJianTaskLingQu5"],
				mc["btnTuiJianTaskLingQu8"],
				mc["btnTuiJianTaskLingQu10"],
			];
			
			var txtList:Array = [
				mc["txtTuiJianTaskLingQu3"],
				mc["txtTuiJianTaskLingQu5"],
				mc["txtTuiJianTaskLingQu8"],
				mc["txtTuiJianTaskLingQu10"],
			];
			
			var j:int;
			for(j=0;j<btnList.length;j++)
			{
				btnList[j].visible = false;				
				btnList[j].gotoAndStop(1);
				
				(txtList[j] as TextField).visible = false;
				(txtList[j] as TextField).mouseEnabled = false;			
			}
			
			for(j=0;j<btnList.length;j++)
			{
				var canLin:Boolean = HuoDong.isBtnTuiJianTaskCanLin(j);
				var yiLin:Boolean = HuoDong.isBtnTuiJianTaskYiLin(j);
				
				//
				if(canLin && !yiLin)
				{
					btnList[j].visible = true;
					btnList[j].gotoAndStop(1);
					btnList[j]["mc_effect"].mouseEnabled = false;
					
					(txtList[j] as TextField).visible = false;
				}
				else if(yiLin && !canLin)
				{
					btnList[j].visible = true;
					btnList[j].gotoAndStop(2);
					
					(txtList[j] as TextField).visible = false;
				}
				else
				{
					btnList[j].visible = false;
					(txtList[j] as TextField).visible = true;					
				}
			}
			
			//共4行，每行的格子个数
			var line:Array = [5,5,5,5];
			
			//60100549	活跃度领奖
			var DROP_ID_LIST:Array=Data.huoDong.dayTuiJianTaskDropid;
			
			len = line.length;
			
			for(var k:int=1;k<=len;k++)
			{					
				var dropArr:Vector.<Pub_DropResModel>=XmlManager.localres.getDropXml.getResPath2(DROP_ID_LIST[k-1]) as Vector.<Pub_DropResModel>;
				
				var item:Pub_ToolsResModel;
				arrayLen=dropArr.length;
				
				var iLen:int = line[k-1];
				for(i=1;i<=iLen;i++)
				{
					item=null;
					child=mc["pic"+ k.toString() + i.toString()];
					if(i<=arrayLen)
						item=XmlManager.localres.getToolsXml.getResPath(dropArr[i-1].drop_item_id) as Pub_ToolsResModel;
					if(item!=null){
//						child["uil"].source=FileManager.instance.getIconSById(item.tool_icon);
						ImageUtils.replaceImage(child,child['uil'],FileManager.instance.getIconSById(item.tool_icon));
						child["txt_num"].text=VipGift.getInstance().getWan(dropArr[i-1].drop_num);		
						var bag:StructBagCell2=new StructBagCell2();
						bag.itemid=item.tool_id;
						Data.beiBao.fillCahceData(bag);
						
						child.data=bag;
						CtrlFactory.getUIShow().addTip(child);
						ItemManager.instance().setEquipFace(child);
						
						//
						child.visible = true;
						
					}else{
						child["uil"].unload();
						child["txt_num"].text="";
						child.data=null;
						CtrlFactory.getUIShow().removeTip(child);
						ItemManager.instance().setEquipFace(child,false);
						//
						child.visible = false;
					}
				}
				
				
			}
			var arr:Vector.<Pub_CommendResModel>=Data.huoDong.dayTuiJianTaskList;
			
			var arr1:Vector.<Pub_CommendResModel>=new Vector.<Pub_CommendResModel>();
			var arr2:Vector.<Pub_CommendResModel>=new Vector.<Pub_CommendResModel>();
			var arr3:Vector.<Pub_CommendResModel>=new Vector.<Pub_CommendResModel>();
			var arr4:Vector.<Pub_CommendResModel>=new Vector.<Pub_CommendResModel>();
			
			var kLen:int=arr.length;
			
			for (k=0; k < kLen; k++)
			{
				//			
				var model2:Pub_Limit_TimesResModel=XmlManager.localres.limitTimesXml.getResPath(arr[k].limit_id) as Pub_Limit_TimesResModel;
				
				var limitCount:int;
				
				if (null == model2)
				{
					limitCount=0;
					
				}
				else
				{
					limitCount=model2.max_times;
				}
				
				
				//== 改为 >= ，以防策划数据填写有误
				var itemData_count:int=arr[k].curnum;
				var itemData_show_level:int=arr[k].show_level;
				
				var _isGet:int = arr[k].isGet(Data.huoDong.isGet);
				
				//排序规则调整为：可领取奖励的任务→可接取的任务→已完成的任务→不可接取的任务。
				
				//
				if(itemData_count >= limitCount && 0 == _isGet)
				{				
					arr1.push(arr[k]);
					
				}else if (itemData_count >= limitCount && 1 == _isGet)
				{
					//"已完成";
					arr3.push(arr[k]);
					
				}
				else
				{
					
					if (myLvl >= itemData_show_level)
					{
						//未完成
						arr2.push(arr[k]);
						
						
						
					}
					else
					{
						//不可接
						arr4.push(arr[k]);
						
						
					}
					
					//-------------------------------------------------------------------------------------
				}
				
			}
			
			var arrA:Vector.<Pub_CommendResModel>=arr1.concat(arr2).concat(arr3).concat(arr4);
			
			wan_cheng=0;
			
			arrA.forEach(callbackByTuiJianTask);
			
			//
			CtrlFactory.getUIShow().showList2(mc_content, 1, 320, 25);
			
			//
			mc["txt_tui_jian_lian_xu_day"].text=Data.huoDong.getQianDao().continuetimes;
			
			//
			mc["txt_wan_cheng"].text="(" + wan_cheng.toString() + "/" + "10)";//arrA.length.toString() + ")";
			
			//
			var wan_cheng_per:int =  (wan_cheng / arrA.length) * 100;
			
			if(0 == wan_cheng_per)
			{
				wan_cheng_per = 1;
			}
			
			if(wan_cheng_per > 100)
			{
				wan_cheng_per = 100;
			}
			
			mc["bar_wan_cheng"].gotoAndStop(wan_cheng_per);
			
			mc["sp"].source=mc_content;
			mc["sp"].y = 106;
			mc_content.x=10;
			mc_content.y=4;
			
			var item1:DisplayObject=mc_content.getChildAt(0)
			
			if (null == item1)
			{
				return;
			}
			this.itemSelected(item1);
			
			
		}
		private function getItemByName(_str:String):Sprite
		{
			var s:Sprite;
			var i:int;
			for(i=0;i<mc_content.numChildren;i++){
				s = mc_content.getChildAt(i) as Sprite;
				if(s["txt_active_desc"].text==_str){
					return s;
				}
			}
			return null;
		}
		private function callbackByTuiJianTask(itemData:Pub_CommendResModel, index:int, arr:Vector.<Pub_CommendResModel>):void
		{
			var sprite:*=ItemManager.instance().getHuoDongTuiJianTaskItem(itemData.id);
			
			super.itemEvent(sprite, itemData, true);
			
			sprite["txt_active_desc"].mouseEnabled=false;
			sprite["txt_activity"].mouseEnabled=false;
			sprite["bg"].mouseEnabled=false;
			
			//
			sprite["name"]="item" + (index + 1);
			
			if(itemData.name=="undefined"||itemData.name=="name") return;
			
			sprite["txt_active_desc"].text=itemData.name;
			sprite["txt_activity"].text=itemData.prize_desc;
			sprite["txt_count"].text=itemData.npc_name;
			sprite["txt_chuan"].htmlText="";
			
			//
			sprite.removeEventListener(MouseEvent.MOUSE_OVER, itemOverListenerTuiJianTask);
			sprite.removeEventListener(MouseEvent.MOUSE_OUT, itemOutListenerTuiJianTask);
			sprite["btn_count"].removeEventListener(MouseEvent.CLICK, itemClickByTuiJianTask);
			sprite["btn_chuan"].removeEventListener(MouseEvent.CLICK, itemClickByTuiJianTask);
			sprite["btn_count"].removeEventListener(MouseEvent.CLICK, itemClickByTuiJianTaskLinQu);
			sprite["btn_chuan"].removeEventListener(MouseEvent.CLICK, itemClickByTuiJianTaskLinQu);
			
			//			
			var model2:Pub_Limit_TimesResModel=XmlManager.localres.limitTimesXml.getResPath(itemData.limit_id) as Pub_Limit_TimesResModel;
			
			var limitCount:int;
			
			if (null == model2)
			{
				limitCount=0;
				
			}
			else
			{
				limitCount=model2.max_times;
			}
			
			
			//== 改为 >= ，以防策划数据填写有误
			var itemData_count:int=itemData.curnum;
			var itemData_show_level:int=itemData.show_level;
			var myLvl:int=Data.myKing.level;
			
			
			
			//
			if(itemData_count >= limitCount && 0 == itemData.isGet(Data.huoDong.isGet))
			{				
				//点击领取奖励
				sprite["txt_count"].text = "";
				sprite["txt_count"].htmlText= "<font color='#e17d24'><u>" + Lang.getLabel("pub_lin_qu_jiang_li") + "</u></font>";
				sprite["txt_chuan"].htmlText="";
				
				wan_cheng++;
				
				var fontGetColor:uint=0x00CC00;
				
				GameColor.setTextColor(sprite["txt_active_desc"], fontGetColor, TextFormatAlign.LEFT);
				GameColor.setTextColor(sprite["txt_activity"], fontGetColor, TextFormatAlign.LEFT);
				GameColor.setTextColor(sprite["txt_count"], fontGetColor, TextFormatAlign.CENTER);
				
				//				
				sprite.addEventListener(MouseEvent.MOUSE_OVER, itemOverListenerTuiJianTask);
				sprite.addEventListener(MouseEvent.MOUSE_OUT, itemOutListenerTuiJianTask);
				sprite["btn_count"].addEventListener(MouseEvent.CLICK, itemClickByTuiJianTaskLinQu);
				sprite["btn_chuan"].addEventListener(MouseEvent.CLICK, itemClickByTuiJianTaskLinQu);
				
				
			}
			else if (itemData_count >= limitCount && 1 == itemData.isGet(Data.huoDong.isGet))
			{
				//sprite["txt_count"].text= "已完成";
				sprite["txt_count"].text=Lang.getLabel("pub_complete");
				sprite["txt_chuan"].htmlText="";
				
				wan_cheng++;
				
				var fontCompleteColor:uint=0x00CC00;
				
				GameColor.setTextColor(sprite["txt_active_desc"], fontCompleteColor, TextFormatAlign.LEFT);
				GameColor.setTextColor(sprite["txt_activity"], fontCompleteColor, TextFormatAlign.LEFT);
				GameColor.setTextColor(sprite["txt_count"], fontCompleteColor, TextFormatAlign.CENTER);
				
				//
				
				
				
			}
			else
			{
				
				if (myLvl >= itemData_show_level)
				{
					//未完成
					var fontJieShou1:uint=0xfff5d2;
					var fontJieShou2:String="#7bac1b";
					
					sprite["txt_count"].text="";
					sprite["txt_count"].htmlText="<font color='" + fontJieShou2 + "'><u>" + Lang.getLabel("pub_jie_shou_ren_wu") + "</u><font>";
					sprite["txt_chuan"].htmlText="<font color='#e17d24'><u>{" + Lang.getLabel("pub_chuan") + "}</u></font>";
					
					GameColor.setTextColor(sprite["txt_active_desc"], fontJieShou1, TextFormatAlign.LEFT);
					GameColor.setTextColor(sprite["txt_activity"], fontJieShou1, TextFormatAlign.LEFT);
					//GameColor.setTextColor(sprite["txt_count"],fontJieShou1,TextFormatAlign.LEFT);
					
					//					
					sprite.addEventListener(MouseEvent.MOUSE_OVER, itemOverListenerTuiJianTask);
					sprite.addEventListener(MouseEvent.MOUSE_OUT, itemOutListenerTuiJianTask);
					sprite["btn_count"].addEventListener(MouseEvent.CLICK, itemClickByTuiJianTask);
					sprite["btn_chuan"].addEventListener(MouseEvent.CLICK, itemClickByTuiJianTask);
					
					
				}
				else
				{
					//不可接
					//19ff01
					var fontCannotJie:int=0x666666;
					
					sprite["txt_count"].text=itemData.level_desc;
					sprite["txt_chuan"].htmlText="";
					
					GameColor.setTextColor(sprite["txt_active_desc"], fontCannotJie, TextFormatAlign.LEFT);
					GameColor.setTextColor(sprite["txt_activity"], fontCannotJie, TextFormatAlign.LEFT);
					GameColor.setTextColor(sprite["txt_count"], fontCannotJie, TextFormatAlign.CENTER);
					
				}
				
				//-------------------------------------------------------------------------------------
			}
			
			mc_content.addChild(sprite);
			
			//悬浮信息
			//Lang.addTip(sprite,"hao_you_tip");
			//sprite.tipParam=[itemData.rolename,itemData.jobName,itemData.level,""];
			
			sprite.tipParam=[itemData.tips_desc];
			Lang.addTip(sprite, "pub_param", 150);
		}
		
		public function itemClickByTuiJianTaskLinQu(e:MouseEvent):void
		{
			
			
			
			var s:*=e.target;
			var sprite:DisplayObjectContainer;
			
			var vo:PacketCSGetDayPrizeRmb;
			
			//
			if (s as TextField || s as SimpleButton)
			{
				if ("txt_chuan" == s.name || "btn_chuan" == s.name)
				{
					sprite=s.parent;
					
					if (sprite.name.indexOf("item") >= 0)
					{
						if(0 == sprite["data"]["isGet"])
						{
							vo = new PacketCSGetDayPrizeRmb();
							vo.limitid = sprite["data"]["limit_id"];
							this.uiSend(vo);
						}		
					}
					
				}
				
				
				//
				if ("txt_count" == s.name || "btn_count" == s.name)
				{
					sprite=s.parent;
					
					if (sprite.name.indexOf("item") >= 0)
					{
						if(0 == sprite["data"]["isGet"])
						{
							vo = new PacketCSGetDayPrizeRmb();
							vo.limitid = sprite["data"]["limit_id"];
							this.uiSend(vo);
						}
					}
					
				}
				
			}
			
			
			
		}
		
		public function itemClickByTuiJianTask(e:MouseEvent):void
		{
			var s:*=e.target;
			var sprite:DisplayObjectContainer;
			
			var npcid:int;
			var npcid2:int;
			var isNeedCamp:Boolean;
			
			var vo:PacketCSAutoSeek;
			if (s as TextField || s as SimpleButton)
			{
				if ("txt_chuan" == s.name || "btn_chuan" == s.name)
				{
					sprite=s.parent;
					
					if (sprite.name.indexOf("item") >= 0)
					{
						npcid=sprite["data"]["npc_id"];
						npcid2=sprite["data"]["npc_id2"];
						
						isNeedCamp=1 == sprite["data"]["camp"] ? true : false;
						
						if (isNeedCamp)
						{
							if (3 == Data.myKing.campid)
							{
								
								GameAutoPath.chuan(npcid2);
								
								
							}
							else
							{
								GameAutoPath.chuan(npcid);
							}
							
						}
						else
						{
							GameAutoPath.chuan(npcid);
						}
						
					}
					
				} //end if
				
				
				if ("txt_count" == s.name || "btn_count" == s.name)
				{
					sprite=s.parent;
					
					if (sprite.name.indexOf("item") >= 0)
					{
						npcid=sprite["data"]["npc_id"];
						npcid2=sprite["data"]["npc_id2"];
						
						isNeedCamp=1 == sprite["data"]["camp"] ? true : false;
						
						if (isNeedCamp)
						{
							if (3 == Data.myKing.campid)
							{
								GameAutoPath.seek(npcid2);
								//MissionNPC.instance().setNpcId(npcid2, false);
								
							}
							else
							{
								GameAutoPath.seek(npcid);
								//MissionNPC.instance().setNpcId(npcid, false);
								
							}
							
						}
						else
						{
							if(89000048 == sprite["data"]["limit_id"])
							{
								//XuanShang.getInstance().open(true);
								
							}else{
								GameAutoPath.seek(npcid);
							}
							//MissionNPC.instance().setNpcId(npcid, false);
						}
						
					}
					
				} //end if
				
				
				
			}
			
		}
		
		
		
		//tuiJian task begin -----------------------------------------------------------------------------------
		public function itemOverListenerTuiJianTask(e:MouseEvent):void
		{
			var sprite:*=e.target;
			
			if (sprite as TextField)
			{
				sprite=sprite.parent;
			}
			
			if (sprite.name.indexOf("item") >= 0)
			{
				GameColor.setTextColor(sprite["txt_active_desc"], 0x54E9D3, TextFormatAlign.LEFT);
				GameColor.setTextColor(sprite["txt_activity"], 0x54E9D3, TextFormatAlign.LEFT);
				//GameColor.setTextColor(sprite["txt_count"],0x54E9D3,TextFormatAlign.CENTER);
			}
		}
		
		public function itemOutListenerTuiJianTask(e:MouseEvent):void
		{
			var sprite:*=e.target;
			
			if (sprite as TextField)
			{
				sprite=sprite.parent;
			}
			
			if (sprite.name.indexOf("item") >= 0)
			{
				GameColor.setTextColor(sprite["txt_active_desc"], 0xfff5d2, TextFormatAlign.LEFT);
				GameColor.setTextColor(sprite["txt_activity"], 0xfff5d2, TextFormatAlign.LEFT);
				
				//Lang.getLabel("pub_complete")
				//GameColor.setTextColor(sprite["txt_count"],0xffffff,TextFormatAlign.CENTER);
			}
		}
		
		

		public function showServerVerUpdate():void
		{
			
			if(3 != (mc as MovieClip).currentFrame)
			{
				return;
			}
			
			
			if(null != QianDaoPage_2.xmlModel)
			{
				mc["txt_title"].htmlText = QianDaoPage_2.xmlModel.title;
				
				mc["txt_contents"].htmlText = QianDaoPage_2.xmlModel.contents;
				mc["txt_contents"].height=mc["txt_contents"].textHeight + 10;	
				
				mc["sp10"].source = mc["txt_contents"];
				
				mc["sp10"].visible = true;
			}	
			
			
		}
		
		
		public function viewSort(a:Object, b:Object):int
		{
			var a_view_sort_id:int=parseInt(a.view_sort_id);
			var b_view_sort_id:int=parseInt(b.view_sort_id);
			
			//if(a.view_sort_id > b.view_sort_id)
			if (a_view_sort_id > b_view_sort_id)
			{
				return 1;
			}
			
			//if(a.view_sort_id < b.view_sort_id)
			if (a_view_sort_id < b_view_sort_id)
			{
				return -1;
			}
			//原样排序
			return 0;
		}
		
		//列表中条目处理方法
		private function callbackByTuiJian(itemData:StructActRecList2, index:int, arr:Vector.<StructActRecList2>):void
		{
			var sprite:*=ItemManager.instance().getHuoDongTuiJianItem(itemData.arid);
			super.itemEvent(sprite, itemData);
			sprite["name"]="item" + (index + 1);
			
			//
			var model1:Pub_AchievementResModel=XmlManager.localres.AchievementXml.getResPath(itemData.arid) as Pub_AchievementResModel;
			
			if (null == model1)
			{
				return;
			}
			
			sprite["txt_active_desc"].text=itemData.target_desc;
			sprite["txt_activity"].text=itemData.active_desc;
			
			var model2:Pub_Limit_TimesResModel=XmlManager.localres.limitTimesXml.getResPath(model1.limit_id) as Pub_Limit_TimesResModel;
			
			var limitCount:int;
			
			if (null == model2)
			{
				limitCount=0;
				
			}
			else
			{
				limitCount=model2.max_times;
			}
			
			//== 改为 >= ，以防策划数据填写有误
			if (itemData.count >= limitCount)
			{
				//sprite["txt_count"].text= "已完成";
				sprite["txt_count"].text=Lang.getLabel("pub_complete");
				
				var fontCompleteColor:uint=0x19ff01; //0x666666;
				
				GameColor.setTextColor(sprite["txt_active_desc"], fontCompleteColor, TextFormatAlign.LEFT);
				GameColor.setTextColor(sprite["txt_activity"], fontCompleteColor, TextFormatAlign.LEFT);
				GameColor.setTextColor(sprite["txt_count"], fontCompleteColor, TextFormatAlign.CENTER);
				
				sprite.removeEventListener(MouseEvent.MOUSE_OVER, itemOverListenerTuiJian);
				sprite.removeEventListener(MouseEvent.MOUSE_OUT, itemOutListenerTuiJian);
				//sprite.removeEventListener(MouseEvent.CLICK, itemClickByTuiJian);
				sprite.removeEventListener(MouseEvent.DOUBLE_CLICK, itemDClickByTuiJian);
				
			}
			else
			{
				sprite["txt_count"].text=itemData.count.toString() + "/" + limitCount.toString();
				
				//-------------------------------------------------------------------------------------
				sprite.removeEventListener(MouseEvent.MOUSE_OVER, itemOverListenerTuiJian);
				sprite.removeEventListener(MouseEvent.MOUSE_OUT, itemOutListenerTuiJian);
				//sprite.removeEventListener(MouseEvent.CLICK, itemClickByTuiJian);
				sprite.removeEventListener(MouseEvent.DOUBLE_CLICK, itemDClickByTuiJian);
				
				sprite.addEventListener(MouseEvent.MOUSE_OVER, itemOverListenerTuiJian);
				sprite.addEventListener(MouseEvent.MOUSE_OUT, itemOutListenerTuiJian);
				//sprite.addEventListener(MouseEvent.CLICK, itemClickByTuiJian);
				
				sprite.doubleClickEnabled=true;
				sprite.addEventListener(MouseEvent.DOUBLE_CLICK, itemDClickByTuiJian);
				
				/*function itemOverListener2(e:MouseEvent):void
				{
				GameColor.setTextColor(sprite["txt_count"],0x54E9D3,TextFormatAlign.LEFT);
				GameColor.setTextColor(sprite["txt_active_desc"],0x54E9D3,TextFormatAlign.LEFT);
				GameColor.setTextColor(sprite["txt_activity"],0x54E9D3,TextFormatAlign.LEFT);
				}
				function itemOutListener2(e:MouseEvent):void
				{
				GameColor.setTextColor(sprite["txt_count"],0xffffff,TextFormatAlign.LEFT);
				GameColor.setTextColor(sprite["txt_active_desc"],0xffffff,TextFormatAlign.LEFT);
				GameColor.setTextColor(sprite["txt_activity"],0xffffff,TextFormatAlign.LEFT);
				}*/
				
				//-------------------------------------------------------------------------------------
			}
			
			mc_content.addChild(sprite);
			//悬浮信息
			//Lang.addTip(sprite,"hao_you_tip");
			//sprite.tipParam=[itemData.rolename,itemData.jobName,itemData.level,""];
		}
		
		
		//tuiJian begin -----------------------------------------------------------------------------------
		public function itemOverListenerTuiJian(e:MouseEvent):void
		{
			var sprite:*=e.target;
			
			GameColor.setTextColor(sprite["txt_count"], 0x54E9D3, TextFormatAlign.LEFT);
			GameColor.setTextColor(sprite["txt_active_desc"], 0x54E9D3, TextFormatAlign.LEFT);
			GameColor.setTextColor(sprite["txt_activity"], 0x54E9D3, TextFormatAlign.LEFT);
			
		}
		
		public function itemOutListenerTuiJian(e:MouseEvent):void
		{
			var sprite:*=e.target;
			
			GameColor.setTextColor(sprite["txt_count"], 0xfff5d2, TextFormatAlign.LEFT);
			GameColor.setTextColor(sprite["txt_active_desc"], 0xfff5d2, TextFormatAlign.LEFT);
			GameColor.setTextColor(sprite["txt_activity"], 0xfff5d2, TextFormatAlign.LEFT);
		}
		
		//tuiJian end -----------------------------------------------------------------------------------
		
		
		
		/**
		 * 1	进入强化页面
		 2	进入重铸页面
		 
		 * LianDanLu.instance().setType(1)  强化
		 * LianDanLu.instance().setType(2)重铸
		 * LianDanLu.instance().setType(3)丹药
		 *  JiaoSe.getInstance().setType(2); 炼骨
		 */
		public function itemDClickByTuiJian(e:MouseEvent):void
		{
			var sprite:*=e.target;
			var win_t:int=parseInt(sprite["data"]["window_type"]);
			
			switch (win_t)
			{
				case 1:
					
					LianDanLu.instance().setType(1);
					break;
				
				case 2:
					
					LianDanLu.instance().setType(2);
					break;
				
				case 3:
					break;
				
				case 4:
					//LianDanLu.instance().setType(3);
					break;
				
				case 5:
					
					//JiaoSe.getInstance().setType(2); 
					break;
				
			}
			
			
		}
		
		
		public function findLimit(limit_id:int,sprite:Sprite=null):Array
		{
			var limitList:Vector.<StructLimitInfo2>=Data.huoDong.getDayTaskAndDayHuoDongLimit();
			var jLen:int=limitList.length;
			
			//var limit_id:int = itemData["limit_id"];
			
			var find:Boolean=false;
			var numComplete:Boolean=false;
			var find_cunnum:int=0;
			var find_maxnum:int=0;
			
			for (var j:int=0; j < jLen; j++)
			{
				if (limitList[j].limitid == limit_id)
				{
					if (limitList[j].curnum == limitList[j].maxnum)
					{
						//sprite["kai_qi2"].visible = false;
						//sprite["kai_qi3"].visible = true;		
						
						numComplete=true;
						
					}
					else
					{
						//sprite["kai_qi2"].visible = true;
						//sprite["kai_qi3"].visible = false;	
						
						numComplete=false;
					}
					
					find_cunnum=limitList[j].curnum;
					find_maxnum=limitList[j].maxnum;
					
					find=true;
					if (sprite!=null){
						sprite["txt_limit"].htmlText =  limitList[j].curnum.toString() + "/" + limitList[j].maxnum.toString();
						if(limit_id==0){
							sprite["txt_limit"].htmlText = "无";
						}
					}
					break;
				}
			} //end for
			
			return [find, numComplete, find_cunnum, find_maxnum];
			
		}
		
		public static function joinTime(action_start:String, action_end:String):int
		{
			
			var time_cp:int=0;
			//
			var now:Date=Data.date.nowDate;
			
			//var action_start:String = itemData["action_start"];
			//var action_end:String = itemData["action_end"];
			
			var action_start_spli:Array=action_start.split(":");
			var action_end_spli:Array=action_end.split(":");
			
			var action_start_hour:int=action_start_spli[0];
			var action_start_min:int=action_start_spli[1];
			var action_start_sec:int=action_start_spli[2];
			
			var action_end_hour:int=action_end_spli[0];
			var action_end_min:int=action_end_spli[1];
			var action_end_sec:int=action_end_spli[2];
			
			var start:Date=Data.date.nowDate;
			start.hours=action_start_hour;
			start.minutes=action_start_min;
			start.seconds=action_start_sec;
			
			var end:Date=Data.date.nowDate;
			end.hours=action_end_hour;
			end.minutes=action_end_min;
			end.seconds=action_end_sec;
			
			//开启时间
			if (now.time >= start.time && now.time <= end.time)
			{
				//开启
				//sprite["kai_qi1"].visible = false;
				//sprite["kai_qi2"].visible = true;
				
				time_cp=1;
				
			}
			else if (now.time < start.time)
			{
				//sprite["kai_qi1"].visible = true;
				//sprite["kai_qi1"].gotoAndStop(1);
				//sprite["kai_qi2"].visible = false;
				
				time_cp=0;
				
			}
			else if (now.time > end.time)
			{
				//sprite["kai_qi1"].visible = true;
				//sprite["kai_qi1"].gotoAndStop(2);
				//sprite["kai_qi2"].visible = false;
				
				time_cp=2;
			}
			
			return time_cp;
		}
		
		
		// 窗口关闭事件
		override protected function windowClose():void
		{
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, autoRefreshHandler);
			(this.mc as MovieClip).gotoAndStop(1);
			super.windowClose();
			
			if (null != HuoDongBridge.m_RewardOfAddMoney)
			{
				HuoDongBridge.m_RewardOfAddMoney(mc).stopTimer();
			}
			
			//HuoDongEventDispatcher.getInstance().checkReward();
		}
		
		
		
		override public function getID():int
		{
			return 1016;
		}
		
		
		
		//窗口第一次初始化的宽度和高度
		private var m_initW:int=-1;
		private var m_initH:int=-1;
		private var m_gPoint:Point; //全局坐标
		private var m_lPoint:Point; //本地坐标
		
		private function replace():void
		{
			
			if (null == m_gPoint)
			{
				m_gPoint=new Point();
				
			}
			
			if (null == m_lPoint)
			{
				m_lPoint=new Point();
			}
			
			if (null != mc && null != mc.parent && null != mc.stage)
			{
				m_gPoint.x=(mc.stage.stageWidth - m_initW) >> 1;
				m_gPoint.y=(mc.stage.stageHeight - m_initH) >> 1;
				
				m_lPoint=this.parent.globalToLocal(m_gPoint);
				
				mc.x=0;
				mc.y=0;
				
				this.x=m_lPoint.x;
				this.y=m_lPoint.y;
			}
			
			
		}
		
	
		
	
		
		
	}
}
