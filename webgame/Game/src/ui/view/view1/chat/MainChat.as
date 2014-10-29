package ui.view.view1.chat
{
	import com.greensock.TweenLite;
	
	import common.config.GameIni;
	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_InstanceResModel;
	import common.managers.Lang;
	import common.utils.ControlTip;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.component.ButtonGroup;
	import common.utils.res.ResCtrl;
	
	import display.components.ScrollContent;
	
	import engine.event.DispatchEvent;
	import engine.load.GamelibS;
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import model.jiazu.JiaZuModel;
	import model.qq.YellowDiamond;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.PacketSCSayCamp2;
	import netc.packets2.PacketSCSayGuild2;
	import netc.packets2.PacketSCSayMap2;
	import netc.packets2.PacketSCSayTeam2;
	import netc.packets2.PacketSCSayTrade2;
	import netc.packets2.PacketSCSayWorld2;
	import netc.packets2.StructBagCell2;
	import netc.packets2.StructFriendData2;
	
	import nets.packets.PacketCSSayCamp;
	import nets.packets.PacketCSSayEnable;
	import nets.packets.PacketCSSayGuild;
	import nets.packets.PacketCSSayMap;
	import nets.packets.PacketCSSayTeam;
	import nets.packets.PacketCSSayTrade;
	import nets.packets.PacketCSSayWorld;
	import nets.packets.PacketCSTeamInvit;
	import nets.packets.PacketSCSayCamp;
	import nets.packets.PacketSCSayCampResult;
	import nets.packets.PacketSCSayGuild;
	import nets.packets.PacketSCSayGuildResult;
	import nets.packets.PacketSCSayMap;
	import nets.packets.PacketSCSayMapResult;
	import nets.packets.PacketSCSayPrivate;
	import nets.packets.PacketSCSayPrivateResult;
	import nets.packets.PacketSCSayTeam;
	import nets.packets.PacketSCSayTeamResult;
	import nets.packets.PacketSCSayTrade;
	import nets.packets.PacketSCSayTradeResult;
	import nets.packets.PacketSCSayWorld;
	import nets.packets.PacketSCSayWorldResult;
	
	import scene.king.IGameKing;
	import scene.manager.SceneManager;
	import scene.music.GameMusic;
	import scene.music.WaveURL;
	
	import ui.base.fuben.FuBenMain;
	import ui.base.huodong.TouZi;
	import ui.base.jiaose.JiaoSeLook;
	import ui.base.mainStage.UI_index;
	import ui.base.renwu.Renwu;
	import ui.base.shejiao.haoyou.ChatWarningControl;
	import ui.base.shejiao.haoyou.GameFindFriend;
	import ui.base.vip.DayChongZhi;
	import ui.base.vip.VipZuoJi;
	import ui.frame.FontColor;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.UIMessage;
	import ui.view.pay.WinFirstPay;
	import ui.view.view1.fuben.FuBenDuiWu;
	import ui.view.view2.NewMap.DiGongMap;
	import ui.view.view2.NewMap.TransMap;
	import ui.view.view2.booth.Booth;
	import ui.view.view2.liandanlu.LianDanLu;
	import ui.view.view2.motianwanjie.MoTianWanJie;
	import ui.view.view2.other.CBParam;
	import ui.view.view2.trade.Trade;
	import ui.view.view4.smartimplement.SmartImplementWindow;
	import ui.view.view4.yunying.ZhiZunVIPMain;
	import ui.view.view5.jiazu.JiaZuList;
	import ui.view.view7.UI_Mrb;

	/**
	 *@author suhang
	 *@version 2011-12
	 * 左下角聊天类
	 */
	public class MainChat extends UIWindow
	{
		private static var _instance:MainChat;
		private const SPACE:String="   ";
		public static var chatData:Object={};
		public static var chatQuk:Boolean=false;
		/**
		 * 说话频道  1 普通  2队伍 3帮派 4阵营  5世界  、、、、、、6系统   7个人
		 */
		public static var channel:int=1;
		/**
		 * 信息显示频道 1综合  2个人 3.	普通 4.	队伍 5.	帮派 6.	阵营 7.	世界 8.	系统
		 */
		public static var channelShow:int=1;
		/**
		 * 普通信息
		 */
		public static const PU_TONG:int=1;
		/**
		 * 队伍 信息
		 */
		public static const DUI_WU:int=2;
		/**
		 * 帮派信息
		 */
		public static const BANG_PAI:int=3;
		/**
		 * 阵营信息
		 */
		public static const ZHEN_YING:int=4;
		/**
		 * 世界信息
		 */
		public static const SHI_JIE:int=5;
		/**
		 * 系统信息
		 */
		public static const XI_TONG:int=6;
		/**
		 * 个人信息
		 */
		public static const GE_REN:int=7;
		/**
		 * 交易 信息
		 */
		public static const JIAO_YI:int=8;
		//自己话的缓存
		private var chatCookie:Array=[];
		private var cookieMax:int=10;
		private var cookiePoint:int=0;
		/**
		 * 所有信息
		 */
		private var chatAll:Vector.<ChatVO>=new Vector.<ChatVO>;
		/**
		 *	缓存信息最大条数
		 */
		public static const CHAT_LEN:int=100; //
		/**
		 *	显示信息最大条数
		 */
		public static const CHAT_LEN_SHOW:int=30; //50太卡，优化
		//聊天文字集合
		private var content:Sprite=new Sprite();
		//聊天文字组件总高度
		private var contentHeight:int=4;
		//聊天滚动面板
		private var sp:ScrollContent;
		//快速聊天回复
		private var arrQuickSay:Array;
		private var mc_quick_say:Sprite;
		//时间间隔记录
		private var sendTime:uint;
		private var putongTime:uint;
		private var duiwuTime:uint;
		private var jiazuTime:uint;
		private var zhenyingTime:uint;
		private var shijieTime:uint;
		private var jiaoYiTime:uint;
		private var sendInterval:uint=10000;
		private var putongInterval:uint=1000;
		private var duiwuInterval:uint=1000;
		private var jiazuInterval:uint=1500;
		private var zhenyingInterval:uint=2000;
		private var shijieInterval:uint=3500;
		private var jiaoYiInterval:uint=3500; //暂定跟世界频道时间间隔一样
		private var selectRole:Object; //选中的人物
		//2013-01-26 andy 改变显示内容的高度
		private var chatHeight:int=0;
		public static var btnLongYoff:int=0;

		public function MainChat(DO:DisplayObject)
		{
			UIMovieClip.currentObjName=null;
			super(DO, null, 1, false);
			this.addEventListener(Event.ENTER_FRAME,onEnterFrame)
			_instance = this;
		}
		
		public static function get instance():MainChat
		{
			return _instance;
		}
		
		private var counttime:int

		protected function onEnterFrame(event:Event):void
		{
//			if(getTimer()-counttime>20000){
//				counttime=getTimer()
			for (var j:int=0; j < faceHash.length; j++)
			{
				var face:MovieClip=faceHash[j];
				if (face)
				{
					var p1:Point=face.parent.localToGlobal(new Point(face.x, face.y));
					var bg:MovieClip=mc["mc_chat_bg"]
					var top:Point=bg.parent.localToGlobal(new Point(bg.x, bg.y));
					var rect_1:Rectangle=new Rectangle(top.x, top.y - bg.height, bg.width, bg.height);
					var rect_2:Rectangle=new Rectangle(p1.x, p1.y, face.width, face.height);
					if (rect_1.intersects(rect_2))
					{
						face.play()
					}
					else
					{
						face.stop()
					}
				}
			}
//			}
		}
		private var faceMc:MovieClip;

		public function setFaceMcVisible(value:Boolean):void
		{
			if (value)
			{
				if (!this.mc.contains(faceMc))
				{
					faceMc.visible=true;
					this.mc.addChild(faceMc);
				}
			}
			//
			if (!value)
			{
				if (null != faceMc.parent)
				{
					faceMc.visible=false;
					faceMc.parent.removeChild(faceMc);
					var index:int=faceHash.indexOf(faceMc)
					if (index != -1)
					{
						faceHash.splice(index, 1)
					}
				}
			}
		}

		override protected function init():void
		{
			//初始化执行方法
			super.init();
			this.addEventListener(MouseEvent.MOUSE_OVER, overMcHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, outMcHandler);
			this.addEventListener(MouseEvent.ROLL_OVER, overRollMcHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, overRollMcHandler);
			chatHeight=mc["sp"].height;
			mc["txtChat"].htmlText="";
			Lang.addTip(mc["txtChat"], "mainchat_shift", 180);
			faceMc=mc["face"];
			if (faceMc["uil"] != null)
			{
				faceMc["uil"].source=GameIni.GAMESERVERS + "pubres/chatFace.png";
//				ImageUtils.replaceImage(faceMc,faceMc["uil"],GameIni.GAMESERVERS + "pubres/chatFace.png");
			}
			//mc["face"].visible=false;
			setFaceMcVisible(false);
			addTipMC();
			//回车发言
			sysAddEvent(mc["txtChat"], KeyboardEvent.KEY_DOWN, sendChatKeyDownHandler);
			addEventListener(DispatchEvent.EVENT_CHAT_TEXT_LINK, chatTxtLinkHandler);
			//2013-02-01
			Lang.addTip(mc["mc_infoHeight"], "mainchat_infoHeight");
			mc["txtChat"].text="";
			(mc["txtChat"] as TextField).maxChars=55;
			ctrlMCChannel(false);
			//初始化频道
			initButton();
			sp=mc["sp"] as ScrollContent;
			sp.position=100;
			sp.source=content;
			this.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
			uiRegister(PacketSCSayMapResult.id, SCSayMapResult);
			uiRegister(PacketSCSayMap.id, SCSayMap);
			uiRegister(PacketSCSayWorldResult.id, SCSayMapResult);
			uiRegister(PacketSCSayWorld.id, SCSayWorld);
			uiRegister(PacketSCSayPrivateResult.id, SCSayMapResult);
			uiRegister(PacketSCSayPrivate.id, SCSayPrivate);
			uiRegister(PacketSCSayTeamResult.id, SCSayMapResult);
			uiRegister(PacketSCSayTeam.id, SCSayTeam);
			uiRegister(PacketSCSayCampResult.id, SCSayMapResult);
			uiRegister(PacketSCSayCamp.id, SCSayCamp);
			uiRegister(PacketSCSayGuildResult.id, SCSayMapResult);
			uiRegister(PacketSCSayGuild.id, SCSayGuid);
			uiRegister(PacketSCSayTradeResult.id, SCSayTradeResult);
			uiRegister(PacketSCSayTrade.id, SCSayTrade);
			mc["mc_xiaLa"].visible=false;
			sysAddEvent(mc["mc_xiaLa"], MouseEvent.ROLL_OUT, outMcHandler);
			mc_quick_say=mc["mc_quick_say"];
			mc["btnQuickSay"].mouseChildren=false;
			mc["btnQuickSay"].gotoAndStop(1);
			mc_quick_say.visible=false;
			arrQuickSay=Lang.getLabelArr("arrQuickSay");
			if (arrQuickSay != null)
			{
				var quick_content:Sprite=new Sprite();
				var len:int=arrQuickSay.length;
				for (i=0; i < len; i++)
				{
					if (arrQuickSay[i] == null)
						continue;
					child=ItemManager.instance().getQuickSay(i) as MovieClip;
					child["txt_say"].text=arrQuickSay[i];
					child.mouseChildren=false;
					child.name="item_quick_say" + i;
					quick_content.addChild(child);
				}
				CtrlFactory.getUIShow().showList2(quick_content);
				mc_quick_say["sp_quick_say"].source=quick_content;
			}
		}

		//初始化聊天类型按钮【修改】
		public function initButton():void
		{
			var arrBtn:Array=[];
			for (var i:int=1; i < 9; i++)
			{
				if (i == 2)
					continue; //【个人】频道取消了
				arrBtn.push(mc["messageType" + i]);
			}
			ChatChoose.bg=new ButtonGroup(arrBtn, 1);
			sysAddEvent(ChatChoose.bg, DispatchEvent.EVENT_DOWN_HANDER, ChatChoose.downHander);
		}

		//  私聊  
		private function chatTxtLinkHandler(e:DispatchEvent):void
		{
			mc["txtChat"].text="/" + e.getInfo.split("|||")[0] + " ";
			channel=6;
			//btnClick(channel);
			ctrlMCChannel(false);
			mc["txtChat"].setSelection(mc["txtChat"].text.length, mc["txtChat"].text.length);
			focusManager.setFocus(mc["txtChat"]);
		}

		//键盘快捷键
		private function sendChatKeyDownHandler(e:KeyboardEvent):void
		{
			//Debug.instance.traceMsg(e.keyCode);
			switch (e.keyCode)
			{
				case 13:
					mcHandler(mc["btnSend"]);
					setTimeout(function():void
					{
						focusManager.setFocus(UI_index.indexMC);
					}, 200);
					break;
				case 38:
					cookiePoint=cookiePoint > 0 ? cookiePoint - 1 : 0;
					if (chatCookie[cookiePoint] != null)
						mc["txtChat"].text=chatCookie[cookiePoint];
					break;
				case 40:
					cookiePoint=cookiePoint < chatCookie.length - 1 ? cookiePoint + 1 : chatCookie.length;
					if (cookiePoint == chatCookie.length)
					{
						mc["txtChat"].text="";
					}
					else
					{
						mc["txtChat"].text=chatCookie[cookiePoint];
					}
					break;
			}
		}

		private function addTipMC():void
		{
			//悬浮
		}

		override public function mcHandler(target:Object):void
		{
			//面板点击事件
			super.mcHandler(target);
			if (target.name.indexOf("F") == 0 && target.parent.name == "face")
			{
				//target.parent.visible=false;
				this.setFaceMcVisible(false);
				if (mc["txtChat"].text.length < 55)
				{
					mc["txtChat"].text+="{" + target.name + "}";
					mc["txtChat"].setSelection(mc["txtChat"].text.length, mc["txtChat"].text.length);
				}
				focusManager.setFocus(mc["txtChat"]);
				return;
			}
			if (target.name.indexOf("item_quick_say") >= 0)
			{
				var cnt:int=int(target.name.replace("item_quick_say", ""));
				mc["txtChat"].text=arrQuickSay[cnt];
				mc_quick_say.visible=false;
				mc["btnQuickSay"].gotoAndStop(2);
				return;
			}
			switch (target.name)
			{
				case "btnSend":
					var sendmsg:String=mc["txtChat"].text;
					if (StringUtils.trim(sendmsg) == "")
						return;
					if (getTimer() - sendTime < 10000)
					{
						if (sendmsg == chatCookie[chatCookie.length - 1])
						{
							Lang.showMsg({type: 4, msg: Lang.getLabel("20004_MainChat")});
							return;
						}
					}
					switch (channel)
					{
						case 1:
//							if (Data.myKing.level < 30)
//							{
//								showResult({tag: 12008, msg: ""});
//								return;
//							}
							if (getTimer() - putongTime < putongInterval)
							{
								Lang.showMsg({type: 4, msg: Lang.getLabel("20005_MainChat")});
								return;
							}
							break;
						case 2:
							if (getTimer() - duiwuTime < duiwuInterval)
							{
								Lang.showMsg({type: 4, msg: Lang.getLabel("20005_MainChat")});
								return;
							}
							break;
						case 3:
							//2012-09-01 andy 增加家族聊天
							if (getTimer() - jiazuTime < jiazuInterval)
							{
								Lang.showMsg({type: 4, msg: Lang.getLabel("20005_MainChat")});
								return;
							}
							break;
						case 4:
//							if (Data.myKing.level < 30)
//							{
//								showResult({tag: 12009, msg: ""});
//								return;
//							}
							if (getTimer() - zhenyingTime < zhenyingInterval)
							{
								Lang.showMsg({type: 4, msg: Lang.getLabel("20005_MainChat")});
								return;
							}
							break;
						case 5:
//							if (Data.myKing.level < 30)
//							{
//								showResult({tag: 12007, msg: ""});
//								return;
//							}
							if (getTimer() - shijieTime < shijieInterval)
							{
								Lang.showMsg({type: 4, msg: Lang.getLabel("20005_MainChat")});
								return;
							}
							break;
						case JIAO_YI:
							if (getTimer() - jiaoYiTime < jiaoYiInterval)
							{
								Lang.showMsg({type: 4, msg: Lang.getLabel("20005_MainChat")});
								return;
							}
							break;
						default:
							break;
					}
					//不能发送html标签
					var sendmsgLen:int=sendmsg.length;
					for (var i:int=0; i < sendmsgLen; i++)
					{
						if (sendmsg.charAt(i) == "<")
						{
							//您的文字中有特殊字符
							alert.ShowMsg(Lang.getLabel("10107_mainchat"));
							return;
						}
					}
					if (ChatFilter.instance.isVerify(sendmsg))
					{
						//达到验证条件
						ChatFilter.instance.open(true);
					}
					else
					{
						send(sendmsg, channel);
					}
					break;
				case "btnFace":
					//mc["face"].visible=!mc["face"].visible;
					if (null == faceMc.parent)
					{
						setFaceMcVisible(true);
					}
					else
					{
						setFaceMcVisible(false);
					}
					break;
				case "btnC":
					ctrlMCChannel();
					break;
				case "btnC1":
					channel=1;
					ctrlMCChannel(true, target);
					break;
				case "btnC2":
					channel=2;
					ctrlMCChannel(true, target);
					break;
				case "btnC3":
					channel=3;
					ctrlMCChannel(true, target);
					break;
				case "btnC4":
					channel=4;
					ctrlMCChannel(true, target);
					break;
				case "btnC5":
					channel=5;
					ctrlMCChannel(true, target);
					break;
				case "chooseBtn":
					ChatChoose.instance.open();
					break;
				case "nameBtn":
					if (target.parent.data.r_id != 0 && target.parent.data.r_id != Data.myKing.roleID)
					{
						if (selectRole != null && target.parent != selectRole)
							selectRole.alpha=0;
						mc["mc_xiaLa"].visible=true;
						mc["mc_xiaLa"].x=target.x + 40;
						var globalP:Point=target.parent.localToGlobal(new Point(target.x, target.y));
						if (globalP.y + 15 + mc["mc_xiaLa"].height < GameIni.MAP_SIZE_H)
						{
							mc["mc_xiaLa"].y=mc.globalToLocal(globalP).y + 20;
						}
						else
						{
							mc["mc_xiaLa"].y=mc.globalToLocal(globalP).y - mc["mc_xiaLa"].height;
						}
						selectRole=target.parent;
					}
					break;
				case "abtn1": //加为好友
					GameFindFriend.addFriend(selectRole.data.king_name, 1);
					mc["mc_xiaLa"].visible=false;
					break;
				case "abtn2": //聊  天
					ChatWarningControl.getInstance().getChatPlayerInfo(selectRole.data.r_id);
					mc["mc_xiaLa"].visible=false;
					break;
				case "abtn3": //组   队
					var vo4:PacketCSTeamInvit=new PacketCSTeamInvit();
					vo4.roleid=selectRole.data.r_id;
					uiSend(vo4);
					mc["mc_xiaLa"].visible=false;
					break;
				case "abtn4": //查  看
					JiaoSeLook.instance().setRoleId(selectRole.data.r_id);
					mc["mc_xiaLa"].visible=false;
					break;
				case "abtn5": //家族邀请
					UI_index.UIAct.jzInvite(selectRole.data.king_name);
					mc["mc_xiaLa"].visible=false;
					break;
				case "abtn6": //复制名称 2012-09-21 andy
					StringUtils.copyFont(selectRole.data.king_name);
					mc["mc_xiaLa"].visible=false;
					break;
				case "abtn7": //拉黑 2013-01-30 andy
					GameFindFriend.addFriend(selectRole.data.king_name, 4);
					mc["mc_xiaLa"].visible=false;
					break;
				case "abtn8": //交易 2014-03-31 andy
					Trade.getInstance().CSTradeRequest(selectRole.data.r_id);
					mc["mc_xiaLa"].visible=false;
					break;
				case "btnQuickSay":
					mc_quick_say.visible=!mc_quick_say.visible;
					mc["btnQuickSay"].gotoAndStop(mc_quick_say.visible ? 1 : 2);
					break;
				case "btnMoreInfo":
					//2013-01-26
					(target.parent as MovieClip).gotoAndStop(2);
					changeHeight(2);
					ControlTip.getInstance().notShow();
					break;
				case "btnLessInfo":
					//2013-01-26
					(target.parent as MovieClip).gotoAndStop(1);
					changeHeight(1);
					ControlTip.getInstance().notShow();
					break;
				default:
					break;
			}
		}
		private var vectorFilter:Vector.<String>=new Vector.<String>();
		private var repeatCount:int=0;

		/**
		 *	发送
		 *  2013-01-28 andy
		 */
		public function send(sendmsg:String, chatChannel:int):void
		{
			if (vectorFilter.length < 20)
			{
				vectorFilter.push(sendmsg);
			}
			else
			{
				if (vectorFilter.indexOf(sendmsg) < 0)
				{
					vectorFilter.unshift(sendmsg);
					repeatCount=0;
				}
				else
				{
					repeatCount++;
					if (repeatCount > 20)
					{
						//禁言   当前前话与前10条中一条内容完全一样  并重复5次
						var nosay:PacketCSSayEnable=new PacketCSSayEnable();
						nosay.enable_time=60; //单位分钟
						DataKey.instance.send(nosay);
						return;
					}
				}
			}
			var arr_:Array=beforSend(sendmsg);
			var itemPos:Vector.<int>;
			var type:int=0;
			if (arr_ != null)
			{
				sendmsg=arr_[0];
				itemPos=new Vector.<int>;
				itemPos.push(arr_[1]);
				type=arr_[2];
			}
			switch (chatChannel)
			{
				case 1:
					var vo:PacketCSSayMap=new PacketCSSayMap();
					vo.content=sendmsg;
					if (itemPos != null)
						vo.arrItempos=itemPos;
					vo.type=type;
					uiSend(vo);
					putongTime=getTimer();
					break;
				case 2:
					var vo3:PacketCSSayTeam=new PacketCSSayTeam();
					vo3.content=sendmsg;
					if (itemPos != null)
						vo3.arrItempos=itemPos;
					vo3.type=type;
					uiSend(vo3);
					duiwuTime=getTimer();
					break;
				case 3:
					//2012-09-01 andy 增加家族聊天
					var guild:PacketCSSayGuild=new PacketCSSayGuild();
					guild.content=sendmsg;
					if (itemPos != null)
						guild.arrItempos=itemPos;
					guild.type=type;
					uiSend(guild);
					jiazuTime=getTimer();
					break;
				case 4:
					var vo5:PacketCSSayCamp=new PacketCSSayCamp();
					vo5.content=sendmsg;
					if (itemPos != null)
						vo5.arrItempos=itemPos;
					vo5.type=type;
					uiSend(vo5);
					zhenyingTime=getTimer();
					break;
				case 5:
					var vo2:PacketCSSayWorld=new PacketCSSayWorld();
					vo2.content=sendmsg;
					if (itemPos != null)
						vo2.arrItempos=itemPos;
					vo2.type=type;
					uiSend(vo2);
					shijieTime=getTimer();
					break;
				case JIAO_YI:
					var jyVo:PacketCSSayTrade=new PacketCSSayTrade();
					jyVo.content=sendmsg;
					if (itemPos != null)
					{
						jyVo.arrItempos=itemPos;
					}
					jyVo.type=type;
					uiSend(jyVo);
					jiaoYiTime=getTimer();
					break;
				default:
					break;
			}
			chatCookie[cookiePoint]=mc["txtChat"].text;
			cookiePoint=cookiePoint < cookieMax ? cookiePoint + 1 : cookieMax;
			focusManager.setFocus(UI_index.indexMC);
			mc["txtChat"].text="";
			MainChat.chatData={};
			sendTime=getTimer();
		}

		//发送聊天之前的逻辑处理
		private function beforSend(msg:String):Array
		{
			var arr:Array=new Array;
			var currStr:String=null;
			var i:int=msg.length - 1;
			var lastPos:int;
			var blmData:Boolean=false;
			while (i >= 0)
			{
				currStr=msg.substr(i, 1);
				if (currStr == "}")
				{
					lastPos=i;
					blmData=true;
				}
				else if (currStr == "{")
				{
					blmData=false;
					if (msg.substr(i + 1, 1) == "F" || msg.substr(i + 1, 1) == "C")
					{
					}
					else
					{
						var name_:String=msg.substring(i + 1, lastPos);
						var data_:StructBagCell2=MainChat.chatData[name_];
						if (data_ == null)
						{
							return [msg, 0, 0];
						}
						msg=msg.substring(0, i) + "{T@" + name_ + "@" + ResCtrl.instance().arrColor[data_.toolColor] + "@" + data_.itemid + "}" + msg.substring(lastPos + 1, msg.length);
						arr.push(msg);
						arr.push(data_.pos);
						//2012-10-10 andy 身上传的装备也可以在聊天框展示
//						if (data_.pet_pos == 0)
//							arr.push(0);
//						else
//						{
//							var pos:int=data_.pet_pos;
//							arr.push(pos);
//						}
						return arr;
					}
				}
				i--;
			}
			return null;
		}

		//隐藏频道选择
		private function ctrlMCChannel(show:Boolean=true, target:Object=null):void
		{
			for (var i:int=1; i < 6; i++)
			{
				if (i == 4)
					continue; //阵营取消
				if (show)
				{
					if (target != null)
					{
						var ind:int=target.name.indexOf("btnC");
						var targetIndex:int=int(String(target.name).substr(ind));
						if (i == targetIndex)
						{
							mc["mcChannel"]["btnC" + i].visible=true;
						}
						else
						{
							mc["mcChannel"]["btnC" + i].visible=false;
						}
					}
					else
					{
						mc["mcChannel"]["btnC" + i].visible=!mc["mcChannel"]["btnC" + i].visible;
					}
				}
				else
				{
					mc["mcChannel"]["btnC" + i].visible=false;
				}
			}
			if (target != null)
			{
				var temp:Object=GamelibS.getswflink("game_index", target.name);
				//=========whr===============
				if (temp != null)
				{
					temp.name="btnC";
					mc["mcChannel"].removeChild(mc["mcChannel"].getChildByName("btnC"));
					mc["mcChannel"].addChild(temp);
				}
			}
		}

		//显示区域切换  1综合  2个人 3.	普通 4.	队伍 5.	帮派 6.	阵营(改为交易) 7.	世界 8.	系统
		public function btnClick(context:int):void
		{
			while (content.numChildren > 0)
			{
				content.removeChildAt(0);
			}
			contentHeight=4;
			channelShow=context;
//			mc["messageTypeFocus"].x = mc["messageType"+context].x;
//			mc["messageTypeFocus"].y = mc["messageType"+context].y;
			changeChannel();
			addChat();
		}

		/**
		 * 聊天信息过滤时对应切换一下聊天频道
		 *
		 */
		private function changeChannel():void
		{
			var mcc:MovieClip=mc["mcChannel"];
			switch (channelShow)
			{
				case 3:
					this.mcHandler(mcc["btnC1"]);
					break;
				case 4:
					this.mcHandler(mcc["btnC2"]);
					break;
				case 5:
					this.mcHandler(mcc["btnC3"]);
					break;
				case 7:
					this.mcHandler(mcc["btnC5"]);
					break;
				default:
					break;
			}
		}

		/**
		 *	 显示信息
		 */
		private function addChat():void
		{
			var vo:ChatVO;
			var len:int=chatAll.length;
			for (var i:int=0; i < len; i++)
			{
				vo=chatAll[i];
				oneChat(vo);
			}
			sp.update();
			if (sp.position > 70)
			{
				sp.position=100;
			}
		}

		//添加一个聊天条目
		private function addOneChat(vo:ChatVO):void
		{
			oneChat(vo);
			sp.update();
			if (sp.position > 70)
			{
				sp.position=100;
			}
		}

		//添加一个聊天条目的具体执行
		private function oneChat(vo:ChatVO):void
		{
			if (canShow(vo.type, channelShow))
			{
				var disO:DisplayObject=GamelibS.getswflink("game_index", WindowName.win_control_chat);
				disO["pindao"].gotoAndStop(vo.type);
				var defaultColor:String="29fe0e";
//				var defaultColor:String=COLOR_XI_TONG;
				var channelColor:String=FontColor.COLOR_PU_TONG;
				var username:String=(vo.content.username == "" || vo.type == 6) ? "" : "[" + vo.content.username + "]:";
				if (vo.type == XI_TONG)
				{
//					username="                        " + username;
//					username="<br/>" + username;
					channelColor=FontColor.COLOR_XI_TONG;
						//vo.content.content="<font color='#"+defaultColor+"'>" + vo.content.content + "</font>";
				}
				else if (vo.type == PU_TONG)
				{
					channelColor=FontColor.COLOR_PU_TONG;
				}
				else if (vo.type == DUI_WU)
				{
					channelColor=FontColor.COLOR_DUI_WU;
				}
				else if (vo.type == BANG_PAI)
				{
					channelColor=FontColor.COLOR_BANG_PAI;
				}
				else if (vo.type == SHI_JIE)
				{
					channelColor=FontColor.COLOR_SHI_JIE;
				}
				else if (vo.type == JIAO_YI)
				{
					channelColor=FontColor.COLOR_JIAO_YI;
				}
				vo.content.content="<font color='#" + channelColor + "'>" + vo.content.content + "</font>";
				//2012-10-12 皇族
				var huang:String="";
				if (int(vo.content.city) > 0)
					huang="<font color='#ffcc00'><b>[" + Lang.getLabel("pub_huang") + "]</b></font>";
				fontPic(disO as MovieClip, SPACE + huang + "<font color='#" + FontColor.COLOR_NAME + "'> " + username + "</font>" + vo.content.content, vo.content.username, vo.content.userid, vo.content.arrItemequipattrs, vo.content.vip, vo.content.qqyellowvip);
				disO.y=contentHeight;
				contentHeight=contentHeight + disO.height - 6;
				disO["txt"].mouseWheelEnabled=false;
				content.addChild(disO);
				disO.x=10;
			}
		}
		private var faceHash:Array=new Array

		//一个聊天条目的图文排列
		private function fontPic(chatItem:MovieClip, msg:String, username:String, userid:int, data:Object, vip:int, qqyellowvip:int):void
		{
			//	try {
			var spaceStr:String="  `    ";
			var dataChat:Array=new Array;
			var currStr:String=null;
			var i:int=msg.length - 1;
			var lastPos:int;
			var blmData:Boolean=false;
			while (i >= 0)
			{
				currStr=msg.substr(i, 1);
				if (currStr == "}")
				{
					lastPos=i;
					blmData=true;
				}
				else if (currStr == "{")
				{
					blmData=false;
					if (msg.substr(i + 1, 1) == "F")
					{
						dataChat.push(msg.substring(i + 1, lastPos));
						msg=msg.substring(0, i) + spaceStr + msg.substring(lastPos + 1, msg.length);
					}
					else
					{
						//2012-08-11 andy 文字可以点击
						var p:String=msg.substring(i + 1, lastPos);
						var arr:Array=p.split("@");
						if (arr.length >= 3)
						{
							msg=msg.substring(0, i) + "<a href='event:" + p + "'><font color='#" + arr[2] + "'><u>" + arr[1] + "</u></font></a>" + msg.substring(lastPos + 1, msg.length);
							chatItem.data=data;
							chatItem["txt"].addEventListener(TextEvent.LINK, textLinkListener, false, 0, true);
						}
					}
				}
				i--;
			}
			var yellowType:int=YellowDiamond.getInstance().handleYellowDiamondMC2(chatItem["vip"], qqyellowvip);
			if (yellowType > 0)
			{
				if (GameIni.PF_3366 == GameIni.pf())
				{
					if (yellowType == YellowDiamond.QQ_YELLOW_NULL)
					{
						if (YellowDiamond.getInstance().get3366Level() > 0)
						{
							//没有蓝钻，有包子
							msg="      " + msg;
							chatItem["vip"].x=32;
						}
					}
					else if (yellowType == YellowDiamond.QQ_YELLOW_COMMON)
					{
						msg="          " + msg;
						chatItem["vip"].x=32;
					}
					else if (yellowType == YellowDiamond.QQ_YELLOW_YEAR)
					{
						msg="                 " + msg;
						chatItem["vip"].x=35;
					}
					else
					{
					}
				}
				else
				{
					//调整黄钻位置
					if (yellowType == YellowDiamond.QQ_YELLOW_COMMON)
					{
						//微软雅黑
						//msg="        " + msg;
						//宋体
						msg="       " + msg;
						chatItem["vip"].x=15;
					}
					else
					{
						//微软雅黑
						//msg="               " + msg;
						//宋体
						msg="         " + msg;
						chatItem["vip"].x=34;
					}
				}
			}
			else
			{
				//微软雅黑
				//msg="   " + msg;
				//宋体
				msg="  " + msg;
			}
			chatItem["txt"].htmlText=msg;
			var rect:Rectangle=null;
			var face:MovieClip=null;
			var dataObj:String=null;
			chatItem["txt"].height=chatItem["txt"].textHeight + 6;
			var msg2:String=chatItem["txt"].text;
			i=msg2.indexOf(spaceStr, 0);
			var xiuzheng:int=0;
			var first:Boolean=true;
			while (i >= 0)
			{
				rect=chatItem["txt"].getCharBoundaries(i + 2);
//				if(rect.x<5&&rect.y>15){
//					xiuzheng = -8;
//				}
//                if(rect.y>30&&first){
//					if(rect.x<5){
//						first = false;
//						xiuzheng = -8;
//					}else{
//						first = false;
//						xiuzheng = 0;
//					}
//				}
				dataObj=dataChat.pop();
				if (null != dataObj && dataObj.indexOf("F") == 0)
				{
					var d:DisplayObject=gamelib.getswflink("libface", dataObj.split("<")[0]);
					if (null == d)
					{
						continue;
					}
					face=d as MovieClip;
					face.x=rect.x + chatItem["txt"].x + xiuzheng - 7;
					face.y=rect.y - 2;
					face.width=22;
					face.height=22;
					var p1:Point=this.localToGlobal(new Point(face.x, face.y));
					var top:Point=this.localToGlobal(new Point(sp.x, sp.y));
					var rect_1:Rectangle=new Rectangle(top.x, top.y, sp.width, sp.height);
					var rect_2:Rectangle=new Rectangle(p1.x, p1.y, face.width, face.height);
					if (rect_1.intersects(rect_2))
					{
						face.play()
					}
					else
					{
						face.stop()
					}
					faceHash.push(face)
					//newcodes
					face.mouseChildren=face.mouseEnabled=false;
					chatItem.addChild(face);
				}
				i=msg2.indexOf(spaceStr, i + spaceStr.length);
			}
			//	msg=msg.replace(/  `  /g, "  `  ");
			chatItem["txt"].htmlText=msg;
			chatItem["txt"].height=chatItem["txt"].textHeight + 14;
			//-------------名字上加菜单----------
			chatItem["menu"].alpha=0;
			rect=chatItem["txt"].getCharBoundaries(msg2.indexOf(":")); //说
			if (rect)
			{
				chatItem["menu"].visible=true;
				chatItem["menu"]["ground"].width=rect.x - 0;
				chatItem["menu"]["nameBtn"].x=rect.x - 4;
				//如果有【皇】，把【皇】去掉
				chatItem["menu"].data={king_name: StringUtils.trim(username), r_id: userid};
			}
			else
			{
				chatItem["menu"].visible=false;
			}
		}

		/**
		 * 文字点击事件
		 *  {E@打开面板@字体色@面板编号}
			{R@查看玩家@字体色@用户ID}
			{T@查看道具@字体色@装备ID}
			{C@传送文字@字体色@mapID@mapx@mapy}
			{C1@家族救援@字体色@mapID@mapx@mapy}
			{C2@传@字体色}                      元宝传送
			{S@自动寻路@字体色@seekid}
		 */
		private function textLinkListener(e:TextEvent):void
		{
			var arr:Array=e.text.split("@");
			var type:String=arr[0];
			switch (type)
			{
				case "T":
					//装备
					var sbc:StructBagCell2=new StructBagCell2;
					sbc.num=1;
					sbc.itemid=arr[3];
					sbc.pos=1;
					Data.beiBao.fillCahceData(sbc);
					var data:Object=e.target.parent.data;
					if (data != null && data.length != 0 && data[0].hasOwnProperty("arrItemequipattrs"))
					{
						Data.beiBao.fillServerData(sbc, data[0]);
						if (sbc.sort == 13 || sbc.sort == 21)
						{
							//装备
							sbc.equip_usedCount=1;
						}
						else if (sbc.sort == 12)
						{
							//星魂
							sbc.para=data[0].strongLevel;
						}
					}
					var sprite:Sprite=ResCtrl.instance().getNewDesc(sbc);
					var tip:Sprite=new Sprite;
					tip.name="tip_tool";
					tip.addChild(sprite);
					tip.addEventListener(MouseEvent.MOUSE_OUT, outMcHandler);
					PubData.mainUI.cartoon.addChild(tip);
					tip.x=this.x + mouseX - 6;
					tip.y=this.y + mouseY - sprite.height + 10;
					tip.mouseChildren=false;
					break;
				case "E":
					//打开面板
					//2012-07-10 andy
					switch (arr[3])
					{
						case "1":
							//成为vip
//							Vip.getInstance().setData(0);
							ZhiZunVIPMain.getInstance().open(true);
							break;
						case "2":
						case "3":
							//武魂 比武场
							break;
						case "4":
							//摩天万界
//							if (Data.myKing.level >= CBParam.ArrMoTian_On_Lvl)
//							{
//								MoTianWanJie.instance().open(true);
//							}
//							else
//							{
//								//35级开放此玩法
//								UIMessage.gamealert.ShowMsg(Lang.getLabel("50006_UI_index"), 2);
//							}
							break;
						case "5":
							//四神器
							SmartImplementWindow.getInstance().open(true);
							break;
						case "6":
							//魔纹
							LianDanLu.instance().setType(3, true)
							break;
						case "7":
							//重铸
							LianDanLu.instance().setType(2, true);
							break;
						case "8":
							//领取神兽
							VipZuoJi.getInstance().open();
							break;
						case "9":
							//领取神将
							//VipPet.getInstance().open();
							break;
						case "10":
							//立刻加入家族
							if (UI_Mrb.hasInstace())
							{
								UI_Mrb.instance.mcHandler({name: "btnJiaZu"});
							}
							break;
						case "11":
							//打开地宫 2012-09-24
							DiGongMap.instance().open();
							break;
						case "12":
							if (arr.length < 6)
							{
								return;
							}
							var itemData:Pub_InstanceResModel=XmlManager.localres.getInstanceXml.getResPath(int(arr[4])) as Pub_InstanceResModel;
							if (FuBenMain.isCompleteCount(itemData))
							{
								//
								Lang.showMsg(Lang.getClientMsg("20075_FuBen_CompleteCount"));
								return;
							}
							//自动发送加入副本
							FuBenDuiWu.instance.setFromWorld(int(arr[4]), int(arr[5]));
							FuBenDuiWu.instance.open();
							break;
						case "13":
							//2012-11-30 我要种树  
							if (!Data.myKing.Guild.isGuildPeople)
							{
								//开启家族里列表窗口，帮助玩家加入家族
								JiaZuList.getInstance().open();
							}
							else
							{
								//开启家族拜关公窗口
							}
							break;
						case "14":
							//若 玩家等级>=30 级 且 未加入家族 则 自动向该家族发送加入申请 ，并反馈该玩家提示:
							//{加入申请已提交，请耐心等待}
							//已经加入家族的玩家点击连接，则反馈提示
							//{你已加入了其他家族}
							if (Data.myKing.level >= 30)
							{
								JiaZuModel.getInstance().requestGuildReq(int(arr[4]));
							}
							break;
						case "15":
							//查看摊位 2013-03-07
							if (arr.length < 5)
							{
								return;
							}
							Booth.getInstance().boothCheck(arr[4]);
							break;
						case "16":
							//帮派结盟 立刻参加 2013-07-26
							break;
						case "17":
							//至尊vip 2013-04-22
							ZhiZunVIPMain.getInstance().open();
							break;
						case "19":
							//2013-10-12 每日副本
							//FuBenMap.instance().open();
							break;
						case "20":
							//2013-10-12 活动界面第三页(世界BOSS)
//							HuoDong.instance().setType(4);
							break;
						case "21":
							//2013-10-30 装备强化
							LianDanLu.instance().setType(1, true);
							break;
						case "22":
							//2013-10-30 宠物品质
							break;
						case "23":
							//2013-10-30 宠物资质
							break;
						case "24":
							//2013-10-30 宠物强化
							break;
						case "25":
							//2013-11-26 宠物技能
							break;
						case "26":
							//2014-10-11  首充
							WinFirstPay.instance.open();
							break;
						case "27":
							//2014-10-11  每日首充
							DayChongZhi.getInstance().open();
							break;
						default:
							break;
					}
					break;
				case "R":
					//查看角色
					mc["mc_xiaLa"].visible=true;
					var globalP:Point=e.target.parent.localToGlobal(new Point(e.target.mouseX, e.target.mouseY));
					var mcP:Point=mc.globalToLocal(globalP);
					mc["mc_xiaLa"].x=mcP.x;
					mc["mc_xiaLa"].y=mcP.y - mc["mc_xiaLa"].height - 5;
					if (selectRole == null)
					{
						selectRole=new Object;
						selectRole["data"]=new Object;
					}
					selectRole["data"]["r_id"]=arr[3];
					selectRole["data"]["king_name"]=arr[1];
					break;
				case "C":
					//摆摊免费传送 2012-09-21 andy
					if (arr.length < 6)
						return;
					//2013-09-23 10级之前不传送
					if (Data.myKing.level < 10)
					{
						Lang.showMsg(Lang.getClientMsg("10161_mainchat"));
						return;
					}
					TransMap.instance().chuanSongFree(arr[3], arr[4], arr[5]);
					break;
				case "C1":
					//家族救援 2012-10-09 andy
					if (arr.length < 6)
						return;
					TransMap.instance().jiaZuHelp(arr[3], arr[4], arr[5]);
					break;
				case "C2":
					//元宝传送 2013-09-25 andy 单字“传”
					if (arr.length < 4)
						return;
					var te:TextEvent=new TextEvent(TextEvent.LINK);
					te.text="2@" + arr[3];
					;
					Renwu.textLinkListener_(te);
					break;
				case "S":
					//自动寻路 2013-09-25 andy 
					if (arr.length < 4)
						return;
					var te:TextEvent=new TextEvent(TextEvent.LINK);
					te.text="1@" + arr[3];
					Renwu.textLinkListener_(te);
					break;
				case "L":
					//连接 2013-03-01 andy
					if (arr.length < 4)
						return;
					flash.net.navigateToURL(new URLRequest(arr[3]), "_blank");
					break;
			}
		}

		private function overMcHandler(e:MouseEvent):void
		{
			if (e.target.parent.name == "menu" && e.target.parent.data.r_id != 0 && e.target.parent.data.r_id != Data.myKing.roleID)
			{
				//聊天内容玩家名字
				TweenLite.to(e.target.parent, 0.5, {alpha: 1});
			}
			else if (e.target.name == "mc_xiaLa")
			{
			}
			else if (e.target.name.indexOf("item_quick_say") >= 0)
			{
				//2012-07-16 andy 快速回复
				e.target["bg"].gotoAndStop(2);
			}
			else
			{
			}
		}

		private function outMcHandler(e:MouseEvent):void
		{
			if (e.target.parent.name == "menu")
			{
				if (mc["mc_xiaLa"].visible && e.target.parent == selectRole)
				{
					if (selectRole)
						TweenLite.to(selectRole, 0.5, {alpha: 0, delay: .6});
				}
				else
				{
					TweenLite.to(e.target.parent, 0.5, {alpha: 0, dealy: .6});
				}
			}
			else if (e.target.name == "mc_xiaLa")
			{
				mc["mc_xiaLa"].visible=false;
				if (selectRole)
					TweenLite.to(selectRole, 0.5, {alpha: 0});
			}
			else if (e.target.name.indexOf("item_quick_say") >= 0)
			{
				e.target["bg"].gotoAndStop(1);
			}
			else if (e.target.name == "tip_tool")
			{
				//道具悬浮
				e.target.parent.removeChild(e.target as DisplayObject);
				e.target.removeEventListener(MouseEvent.MOUSE_OUT, outMcHandler);
			}
			else
			{
			}
		}
		/**
		 *	2014-01-14
		 */
		private const BG_ALPHA:Number=0.4;
		private const DELAY_SHOW_TIME:int=1;

		private function overRollMcHandler(e:MouseEvent):void
		{
			switch (e.type)
			{
				case MouseEvent.ROLL_OVER:
					//mc["mc_chat_bg"].alpha=BG_ALPHA;
					TweenLite.to(mc["mc_chat_bg"], DELAY_SHOW_TIME, {alpha: 1});
					//mc["sp"]["scroll"].alpha=0;
					TweenLite.to(mc["sp"]["scroll"], DELAY_SHOW_TIME, {alpha: 1});
					break;
				case MouseEvent.ROLL_OUT:
					//mc["mc_chat_bg"].alpha=1;
					TweenLite.to(mc["mc_chat_bg"], DELAY_SHOW_TIME, {alpha: BG_ALPHA});
					//mc["sp"]["scroll"].alpha=1;
					TweenLite.to(mc["sp"]["scroll"], DELAY_SHOW_TIME, {alpha: BG_ALPHA});
					break;
				default:
					break;
			}
		}

		//各种服务器发来的聊天信息
		private function SCSayMapResult(p:IPacket):void
		{
			showResult(p);
		}

		/**
		 * 普通频道聊天
		 * @param p
		 *
		 */
		private function SCSayMap(p:IPacket):void
		{
			var result:PacketSCSayMap2=p as PacketSCSayMap2;
			addSay(1, result);
			showTalk(result.userid, result.content_primitve);
		}

		private function SCSayTradeResult(p:IPacket):void
		{
			showResult(p);
		}

		/**
		 * 交易频道信息
		 * @param p
		 *
		 */
		private function SCSayTrade(p:IPacket):void
		{
			var result:PacketSCSayTrade2=p as PacketSCSayTrade2;
			addSay(JIAO_YI, result);
			showTalk(result.userid, result.content_primitve);
		}

		/**
		 * 世界频道聊天
		 * @param p
		 *
		 */
		private function SCSayWorld(p:IPacket):void
		{
			var result:PacketSCSayWorld2=p as PacketSCSayWorld2;
			var _level:int=Data.myKing.level;
			if (_level >= result.minlevel)
			{
				addSay(5, result);
				GameMusic.playWave(WaveURL.ui_xitong_xiaoxi);
			}
		}

		private function SCSayPrivate(p:IPacket):void
		{
//			var result:PacketSCSayPrivate2 = p as PacketSCSayPrivate2;
//			var vo:ChatVO = new ChatVO(7,result);
//			cacheInfo(vo);
//			addOneChat(vo);
		}

		/**
		 * 组队频道聊天
		 * @param p
		 *
		 */
		private function SCSayTeam(p:IPacket):void
		{
			var result:PacketSCSayTeam2=p as PacketSCSayTeam2;
			addSay(2, result);
			showTalk(result.userid, result.content_primitve);
		}

		private function SCSayCamp(p:IPacket):void
		{
			var result:PacketSCSayCamp2=p as PacketSCSayCamp2;
			if (result.usercamp == Data.myKing.campid)
			{
				addSay(4, result);
			}
		}

		/**
		 * 家族频道聊天
		 * @param p
		 *
		 */
		private function SCSayGuid(p:IPacket):void
		{
			var result:PacketSCSayGuild2=p as PacketSCSayGuild2;
			addSay(3, result);
			showTalk(result.userid, result.content_primitve);
		}

		//系统消息
		public function SCSayXiTong(p:Object):void
		{
			addSay(6, p);
		}

		//系统家族消息
		public function SCSayJiaZu(p:Object):void
		{
			addSay(3, p);
		}

		//组队消息
		public function SCSayZuDui(p:Object):void
		{
			addSay(DUI_WU, p);
		}

		/**
		 *	个人信息
		 *  2012-11-09 andy
		 */
		public function SCSayMyself(p:Object):void
		{
			p.content="<font color='#e29e47'>" + p.content + "</font>";
			var vo:ChatVO=new ChatVO(7, p);
			cacheInfo(vo);
			addOneChat(vo)
		}

		private function addSay(type:int, result:Object):void
		{
			var enemy:Boolean=false;
			var vec:Vector.<StructFriendData2>=Data.haoYou.getHaoYouListByType(4);
			for each (var sfd:StructFriendData2 in vec)
			{
				if (sfd.roleid == result.userid && sfd.roleid != 0)
				{
					enemy=true;
					break;
				}
			}
			if (!enemy)
			{
				var vo:ChatVO=new ChatVO(type, result);
				cacheInfo(vo);
				addOneChat(vo);
			}
		}

		/**
		 *	缓存信息
		 */
		private function cacheInfo(vo:ChatVO):void
		{
			while (chatAll.length >= CHAT_LEN)
			{
				chatAll.shift();
			}
			chatAll.push(vo);
			if (content.numChildren >= CHAT_LEN_SHOW)
			{
				content.removeChildAt(0)["txt"].removeEventListener(TextEvent.LINK, textLinkListener);
				contentHeight=0;
				var do_:DisplayObject;
				for (var i:int=0; i < content.numChildren; i++)
				{
					do_=content.getChildAt(i);
					do_.y=contentHeight;
					contentHeight+=do_.height - 6;
				}
			}
		}

		private function showTalk(userid:int, content:String):void
		{
			var k:IGameKing=SceneManager.instance.GetKing_Core(userid);
			if (null == k)
			{
				return;
			}
			k.getSkin().getHeadName().showBubbleChat(content);
		}

		/**
		 * 消息过滤 【查看信息频道切换】
		 * @type  1 普通  2队伍 3帮派 4阵营  5世界  、、、、、、6系统   7个人 8交易
		 * @cShow 显示区域
		 */
		private function canShow(type:int, cShow:int):Boolean
		{
			switch (cShow)
			{
				case 1: //全部
					if (type != GE_REN)
						return true;
					break;
				case 2:
					if (type == 7 || type == 2 || type == 3 || type == 6)
					{
						return true;
					}
					break;
				case 3: //普通
					if (type == PU_TONG || type == XI_TONG)
					{
						return true;
					}
					break;
				case 4: //队伍
					if (type == DUI_WU)
					{
						return true;
					}
					break;
				case 5: //帮派
					if (type == BANG_PAI)
					{
						return true;
					}
					break;
				case 6: //交易
					if (type == JIAO_YI)
					{
						return true;
					}
					break;
				case 7: //世界
					if (type == SHI_JIE || type == XI_TONG)
					{
						return true;
					}
					break;
				case 8: //系统
					if (type == XI_TONG)
					{
						return true;
					}
					break;
			}
			return false;
		}

		/**
		 *	拖动装备到聊天框，为保证发送的装备正常显示悬浮
		 *  在执行以下操作，删除聊天发送内容
		 *  【包裹整理，换位置，移入仓库，出售，销毁 】
		 *   @andy 2012-09-19
		 */
		public function clearChatSend(itemName:String=null):void
		{
			if (itemName == null || MainChat.chatData[itemName] != null)
			{
				mc["txtChat"].text="";
				MainChat.chatData={};
			}
		}

		/**
		 *	改变聊天内容显示的高度
		 *  2013-01-26 andy
		 */
		private function changeHeight(rate:int=1):void
		{
			mc["sp"].height=rate * chatHeight;
			if (rate == 1)
			{
				mc["sp"].y=mc["sp"].y + chatHeight;
				mc["mc_wenxin"].y=mc["mc_wenxin"].y+chatHeight;
//				mc["Clist"].y=mc["Clist"].y+chatHeight;
//				mc["mc_infoHeight"].y=mc["mc_infoHeight"].y+chatHeight;
				mc["mc_chat_bg"].height=mc["mc_chat_bg"].height - chatHeight;
				btnLongYoff=0;
			}
			else
			{
				mc["sp"].y=mc["sp"].y - chatHeight;
				mc["mc_wenxin"].y=mc["mc_wenxin"].y-chatHeight;
//				mc["Clist"].y=mc["Clist"].y-chatHeight;
//				mc["mc_infoHeight"].y=mc["mc_infoHeight"].y-chatHeight;
				mc["mc_chat_bg"].height=mc["mc_chat_bg"].height + chatHeight;
				btnLongYoff=-chatHeight;
			}
			btnClick(channelShow);
			this.stage.dispatchEvent(new Event(Event.RESIZE));
		}
	}
}
