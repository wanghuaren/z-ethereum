package ui.view.view1.desctip
{
	import com.greensock.TweenLite;
	
	import common.config.GameIni;
	import common.config.PubData;
	import common.managers.Lang;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import scene.manager.SceneManager;
	import scene.music.GameMusic;
	import scene.music.WaveURL;
	
	import ui.base.fuben.FuBenController;
	import ui.base.mainStage.UI_index;
	import ui.base.vip.DayChongZhi;
	import ui.view.marry.MarriageTiShiWin;
	import ui.view.pay.WinFirstPay;
	import ui.view.view1.fuben.FuBen;
	import ui.view.view2.mrfl_qiandao.MeiRiFuLiWin;
	import ui.view.view2.other.ExpiredTip;
	import ui.view.view2.other.LingQuHero;
	import ui.view.view4.qq.QQGoldTick;
	import ui.view.view4.yunying.HuoDongZhengHe;
	import ui.view.view4.yunying.KaiFuHaoLi;
	import ui.view.view4.yunying.ZhiZunVIP;
	import ui.view.view4.yunying.ZhiZunVIPMain;
	import ui.view.view6.GameAlert;
	import ui.view.view7.UI_Exclamation;
	import ui.view.view8.YBExtractWindow;

	/**
	 *	消息提示
	 *  suhang 2012-4-26
	 */
	public class GameTip
	{
		private static var Pool:Array=[];
		private static var List:Array=[];
		private static var IconY:int=135;
		private static var waitingIcoin:Array=[]; //等待显示的信息

		//private static var panel : Sprite  = UI_index.indexMC;
		private static var isShow:Boolean=true;

		private static function get panel():Sprite
		{
			//return UI_index.indexMC;
			return UI_Exclamation.instance.mc;
		}

		public function GameTip()
		{

		}

		/**
		*    type 1:信息  2：奖励  3：操作
		 *   Func 有一个返回参数 1代表确认 0代表取消
		*/
		public static function addTipButton(Func:Function, type:int, msg:String="", sn:Object=1, action_id:int=-1, trigDel_Map:Boolean=true):WarningIcon
		{
			//玄仙不用处理
			//if(type==7)return null;
			if (GameTipCenter.instance.isExistTip(type))
				return null; //相同的只出一次
			if (msg != null)
				msg=Lang.filterMsg(msg);
			for each (var wi:WarningIcon in List)
			{
				if ((wi.msg == msg && type != 2)||(type==2 && sn.hasOwnProperty("type")&&wi.sn.hasOwnProperty("type")&& sn["type"]>0&&sn["type"]==wi.sn.type))
					return null;
			}
			for each (var wi2:WarningIcon in waitingIcoin)
			{
				//2013-04-11 andy 奖励不判断描述内容
				if (wi2.msg == msg && type != 2||(type==2 && sn.hasOwnProperty("type")&&wi2.sn.hasOwnProperty("type") && sn["type"]>0&&sn["type"]==wi2.sn.type))
					return null;
			}
			var icon:WarningIcon=null;
			if (Pool.length > 0)
			{
				icon=Pool.shift() as WarningIcon;
			}
			else
			{
				icon=new WarningIcon();
			}
			GameMusic.playWave(WaveURL.ui_xitong_xiaoxi);
			icon.setIcon(type);
			icon.Func=Func;
			icon.msg=msg;
			icon.action_id=action_id;

			//check
			if (-1 == icon.action_id)
			{
				trigDel_Map=false;
			}

			icon.trig_del_Map=trigDel_Map;

			icon.sn=sn;
			icon.buttonMode=true;

			icon.addEventListener(Event.REMOVED_FROM_STAGE, REMOVED_FROM_STAGE);
			icon.addEventListener(MouseEvent.MOUSE_DOWN, MOUSE_DOWN);


			//界面飞出信息个数，暂定15个，
			if (List.length >= 15)
			{
				waitingIcoin.push(icon);
			}
			else
			{
				addToPanel(icon);
				UpdateList(icon);
			}

			return icon;
		}

		//添加至面板
		private static function addToPanel(icon:WarningIcon):void
		{
			List.push(icon);
			icon.visible=isShow;
			panel.addChild(icon);
		}

		//刷新列表
		public static function UpdateList(icon:WarningIcon=null):void
		{
			if (icon != null)
				icon.x=GameIni.MAP_SIZE_W;
			var xx:int;
			for (var s:* in List)
			{
				var IC:WarningIcon=List[s] as WarningIcon;
				IC.y=GameIni.MAP_SIZE_H - IconY - 15;
				xx=int(GameIni.MAP_SIZE_W - IC.width * List.length) / 2 + IC.width * s;
				TweenLite.to(IC, 1, {x: xx});
			}
		}


		private static function REMOVED_FROM_STAGE(e:Event):void
		{
			var icon:WarningIcon=e.currentTarget as WarningIcon;
			icon.removeEventListener(Event.REMOVED_FROM_STAGE, REMOVED_FROM_STAGE);
			icon.removeEventListener(MouseEvent.MOUSE_DOWN, MOUSE_DOWN);
			icon.Func=null;
			icon.trig_del_Map=false;
			Pool.push(icon);
			List.splice(List.indexOf(icon), 1);

			//如果有等待的信息，
			icon=null;
			if (waitingIcoin.length > 0)
			{
				icon=waitingIcoin.shift();
				addToPanel(icon);
			}
			UpdateList(icon);
		}

		private static function MOUSE_DOWN(e:MouseEvent):void
		{
			var icon:WarningIcon=null;
			if (e.currentTarget is WarningIcon)
				icon=e.currentTarget as WarningIcon;
			else
				icon=e.currentTarget.parent as WarningIcon;
//			try {
//				if(icon.Func != null)icon.Func.call();
//			}catch(e : Error) {
//			}
			switch (icon.leixing)
			{
				case 1:
				case 4:
					//打开确定提示框
					(new GameAlert).ShowMsg(icon.msg, 2);
					icon.parent.removeChild(icon);
					break;
				case 2:
					//奖励专用 点击弹出面板确定按钮，奖字方可消失
					if(icon.sn is Object &&icon.sn.hasOwnProperty("type")){
						if (icon.sn["type"] == 1)
						{
							//您有未领取的VIP奖励
							ZhiZunVIPMain.getInstance().setType(1);
						}else if (icon.sn["type"] == 2)
						{
							//您有未领取的至尊会员奖励
							ZhiZunVIPMain.getInstance().setType(2);
						}
						else if (icon.sn["type"] == 3)
						{
							//您有未领取的首冲奖励
							WinFirstPay.instance.open();
						}
						else if (icon.sn["type"] == 4)
						{
							//您有未领取的每日首冲奖励
							//DayChongZhi.getInstance().open();
							HuoDongZhengHe.getInstance().setType(0,true);
						}
						else if (icon.sn["type"] == 5)
						{
							//您有未领取的充值奖励（开服豪礼）奖励
							KaiFuHaoLi.getInstance().open(true);
						}else{
							
						}
						icon.parent.removeChild(icon);
					}else{
						(new GameAlert).ShowMsg(icon.msg, 4, null, icon.Func, icon.sn, 0);
					}
					break;
				case 3:
					if (icon.trig_del_Map && SceneManager.instance.isAtGameTranscript())
					{
						//先弹活动提示再弹推出副本提示
						if (UI_index.UIAct.checkActionState(icon.action_id))
						{
							var func:Function=icon.Func;
							var handler:Function=function(flag:int=1):void
							{
								if (flag == 1)
								{
									setTimeout(FuBenController.Leave, 500, false, func,icon.sn);
								}
//								FuBenController.Leave(false,icon.Func);
							};
							(new GameAlert()).ShowMsg(icon.msg, 4, null, handler, 1, 0);
						}


//						var callback:Function = function():void{
//							if(UI_index.UIAct.checkActionState(icon.action_id)){
//								var callback1:Function = function ():void{
//									new GameAlert().ShowMsg(icon.msg,4,null,icon.Func,icon.sn,0);
//								};
//								setTimeout(callback1,600);
////								new GameAlert().ShowMsg(icon.msg,4,null,icon.Func,icon.sn,0);
//							}
//						};
//						FuBenController.Leave(false,callback);
					}
					else
					{


						//打开确定取消框，点击确定执行回调函数
						//2013-01-21 tom说如果是活动已经结束，直接弹出结束界面
						if (UI_index.UIAct.checkActionState(icon.action_id))
							(new GameAlert).ShowMsg(icon.msg, 4, null, icon.Func, icon.sn, 0);
					}

					icon.parent.removeChild(icon);


					break;
				case 5:
					//过期物品
					if (int(icon.msg) == 1)
					{ //vip过期
						ZhiZunVIPMain.getInstance().setType(1);
					}
					else
					{
						ExpiredTip.getInstance().setData(int(icon.msg));
					}
					if(icon.Func!=null)
					icon.Func.call(null, icon.sn);
					//20120-12-07 andy 防止服务端不发删除消息，客户端自己删除
					icon.parent.removeChild(icon);
					break;
				//金券兑换
				case 12:
				case 6:

					//打开指定功能【要和策划约定】
					if (icon.sn["type"] == 1)
					{
						//活动面板→阵营福利页签
						//HuoDong.instance().setType(8,true);
						//HuoDongFuLi.instance().setType(4,true);
					}
					else if (icon.sn["type"] == 2)
					{
						//活动面板→签到 2012-10-19 andy
						MeiRiFuLiWin.getInstance().setType(1);
					}
					else if (icon.sn["type"] == 3)
					{
						//FuBen.viewMode = 2;
						FuBen.instance.open();
					}
					else if (icon.sn["type"] == 4)
					{
//						ExpAdd.getInstance().open();
					}
					else if (icon.sn["type"] == 5)
					{
						HuoDongZhengHe.getInstance().setType(5);
					}
					else if (icon.sn["type"] == 6)
					{
						WinFirstPay.instance.open();
					}
					else if (icon.sn["type"] == 8)
					{
						//祝福
						MarriageTiShiWin.getInstance().open();

					}
					else if (icon.sn["type"] == 10)
					{
						//金券
						PubData.save(1, new Date().month + 1);
						QQGoldTick.instance.open();
					}
					else if (icon.sn["type"] == 11)
					{
						//领取英雄
						LingQuHero.instance.open();
					}
					else if (icon.sn["type"] == 12)
					{
						//提取元宝 2014-11-05
						YBExtractWindow.getInstance().open();
					}
					else
					{

					}
					icon.parent.removeChild(icon);
					break;
				case 7:
					//2012-11-23 分享
					(new GameAlert).ShowMsg(icon.msg, 4, null, icon.Func, icon.sn, 0);
					icon.parent.removeChild(icon);
					break;

				case 10:
					icon.Func.call(null, icon.sn);
					icon.parent.removeChild(icon);
					break;
				case 11:
					//2014-04-01 交易
					new GameAlert().ShowMsg(icon.msg, 4, null, icon.Func, {roleid: icon.sn["roleid"], agree: 1}, {roleid: icon.sn["roleid"], agree: 0});
					icon.parent.removeChild(icon);
					break;
				default:

					break;
			}
		}

		public static function removeIcon(sn:int):void
		{
			for each (var wi:WarningIcon in List)
			{
				if (wi != null && wi.parent != null && wi.sn == sn)
				{
					wi.parent.removeChild(wi);
				}
			}
		}

		/**
		 *	根据活动ID删除感叹号
		 *  注：有的活动大图标和感叹号同时出现，点击大图标感叹号也要消失
		 *  2013-02-22 andy
		 *  @param action_id  活动ID
		 */
		public static function removeIconByActionId(action_id:int):void
		{
			for each (var wi:WarningIcon in List)
			{
				if (wi != null && wi.parent != null && wi.action_id == action_id)
				{
					wi.parent.removeChild(wi);
				}
			}
		}

		public static function hasIconByActionId(action_id:int):Boolean
		{
			for each (var wi:WarningIcon in List)
			{
				if (wi != null && wi.parent != null && wi.action_id == action_id)
				{
					return true;
				}
			}

			return false;
		}

		/**
		 *	根据活动ID自动点击感叹号
		 *  注：有的活动大图标和感叹号同时出现，点击大图标感叹号也要消失
		 *  2013-10-21 andy
		 *  @param action_id  活动ID
		 */
		public static function autoClickIconByActionId(action_id:int):void
		{
			for each (var wi:WarningIcon in List)
			{
				if (wi != null && wi.parent != null && wi.action_id == action_id)
				{
					wi.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
			}
		}

		/**
		 *	是否显示警告信息 【进入剧情不显示】
		 *  @2012-08-14 andy
		 */
		public static function showTip(v:Boolean=true):void
		{
			isShow=v;
			for each (var wi:WarningIcon in List)
			{
				wi.visible=isShow;
			}
		}
	}
}
