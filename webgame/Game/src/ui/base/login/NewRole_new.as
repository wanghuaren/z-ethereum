package ui.base.login
{
	import com.lab.config.Global;
	import com.lab.core.BasicObject;
	import com.lab.events.CustomEvent;
	import com.lab.events.SceneEvent;
	
	import common.config.GameIni;
	import common.config.PubData;
	import common.config.XmlConfig;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	
	import engine.load.Gamelib;
	import engine.load.GamelibS;
	import engine.support.IPacket;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.utils.setTimeout;
	
	import main.Game_main;
	import main.Main;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.StructDCRoleList2;
	
	import nets.packets.PacketCDRoleList;
	import nets.packets.PacketCDRoleNew;
	import nets.packets.PacketCWRoleSelect;
	import nets.packets.PacketDCRoleList;
	import nets.packets.PacketDCRoleNew;
	import nets.packets.PacketSCCloseModules;
	import nets.packets.PacketSCPlayerData;
	import nets.packets.PacketSCPlayerDataMore;
	import nets.packets.PacketSCRoleSelect;
	import nets.packets.StructDCRoleList;
	
	import scene.display.NowLoading;
	import scene.manager.SceneManager;
	
	import ui.frame.WindowModelClose;
	import ui.view.view6.GameAlert;
	import ui.view.view6.GameAlertNotTiShi;
	
	import world.WorldDispatcher;
	import world.WorldEvent;

	/**
	 * 2011.10.25
	 * @author suhang
	 * D:\workspace\FlashProject\trunk\SwordLegend\fla\game_main.html
	 */
	public class NewRole_new extends Sprite
	{

		private static var _instance:NewRole_new=null;

		private var m_ui:MovieClip=null;

		private var m_gamelib:Gamelib=new Gamelib();

		private static const ROLE_NUM:int=3;

		//当前选择那一个
		private var m_selectIdx:int=0;

		public static var sysSet:int=0; //系统设置

		public static function get instance():NewRole_new
		{
			if (_instance == null)
			{
				_instance=new NewRole_new();
			}
			return _instance;
		}

		public function NewRole_new()
		{

		}

		private function _onMouseEventOver(e:MouseEvent=null):void
		{
			m_ui['mcBtnAutoName'].visible=true;
		}

		private function _onMouseEventOut(e:MouseEvent=null):void
		{
			m_ui['mcBtnAutoName'].visible=false;
		}

		public function init():void
		{
			if (null == m_ui)
			{
				var _ui:MovieClip=m_gamelib.getswflink("game_newrole", "mc_create_newrole") as MovieClip;
				m_ui=_ui['mcPanel'];
				this.addChild(_ui);

				m_ui['mcBar']['btnAutoName'].addEventListener(MouseEvent.MOUSE_OVER, _onMouseEventOver);
				m_ui['mcBar']['btnAutoName'].addEventListener(MouseEvent.MOUSE_OUT, _onMouseEventOut);
				m_ui['mcBar']['createMask'].mouseEnabled=false;
			}
			m_ui['mcBtnAutoName'].visible=false;
			_randomSelected();
			m_ui['mcBar']["btnFanhui"].visible=true;
			if (SelectRole.getInstance().m_rolelist == null || SelectRole.getInstance().m_rolelist.length < 1)
			{
				m_ui['mcBar']["btnFanhui"].visible=false;
			}
			for (var i:int=0; i < ROLE_NUM; ++i)
			{
				m_ui['mc_head_' + i].mouseChildren=false;
				m_ui['mc_head_' + i].addEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);
				m_ui['mc_head_' + i].addEventListener(MouseEvent.MOUSE_OVER, _onMouseOver);
				m_ui['mc_head_' + i].addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			}
			m_ui.addEventListener(MouseEvent.CLICK, _onUIMouseClick);
			canCreate=true;
			if (m_ui["mcBar"]["username"].hasEventListener(TextEvent.TEXT_INPUT) == false)
				m_ui["mcBar"]["username"].addEventListener(TextEvent.TEXT_INPUT, usernameInputHandler);
		}

		private function usernameInputHandler(e:TextEvent):void
		{
			isMyName=true;
		}

		private function _nameToIdx(name:String):int
		{
			var _idx:int=-1;
			switch (name)
			{
				case "mc_head_0":
					_idx=0;
					break;
				case "mc_head_1":
					_idx=1;
					break;
				case "mc_head_2":
					_idx=2;
					break;
				case "mc_head_3":
					_idx=3;
					break;
				default:
					break;
			}
			return _idx;
		}

		private function _onMouseOut(e:MouseEvent=null):void
		{
			var _name:String=e.target.name;
			var _idx:int=_nameToIdx(_name);
			if (_idx < 0)
			{
				return;
			}

			if (m_selectIdx == _idx)
			{
				return;
			}

			m_ui['mc_head_' + _idx].gotoAndStop(1);

		}

		private function _onMouseOver(e:MouseEvent=null):void
		{
			var _name:String=e.target.name;
			var _idx:int=_nameToIdx(_name);
			if (_idx < 0)
			{
				return;
			}

			if (m_selectIdx == _idx)
			{
				return;
			}
			m_ui['mc_head_' + _idx].gotoAndStop(2);

		}

		private function _onMouseUp(e:MouseEvent=null):void
		{
			var _name:String=e.target.name;
			var _idx:int=_nameToIdx(_name);
			if (_idx < 0)
			{
				return;
			}

			if (m_selectIdx == _idx)
			{
				return;
			}

			selected=_idx;
		}

		private var canCreate:Boolean=true; //能够点击创建
		/**
		 * 职业 3 战士 4法师 1 道士 6 刺客
		*道士男：10001
		*道士女：10004
		*法师男：10002
		*法师女：10005
		*战士男：10003
		*战士女：10006
		**/
		private var headlist:Array=[0, [0, 10001, 10004], 2, [0, 10003, 10006], [0, 10002, 10005]];

		private function _onUIMouseClick(e:MouseEvent=null):void
		{
			var _name:String=e.target.name;
			switch (_name)
			{
				case "btnCreate":
					var p_ui_index:Sprite=GamelibS.getswflink("game_index", "ui_index") as Sprite;
					var createNewRoleHandler:Function=function(e:Event):void
					{
						if (p_ui_index == null)
						{
							p_ui_index=GamelibS.getswflink("game_index", "ui_index") as Sprite;
							return;
						}
						else
						{
							instance.removeEventListener(Event.ENTER_FRAME, createNewRoleHandler);
							if (canCreate)
							{
								var username:String=m_ui["mcBar"]["username"].text;
								if (username != "")
								{
									var len:int=StringUtils.getStringLengthByChar(m_ui["mcBar"]["username"].text)

									if (len > 12)
									{
										(new GameAlert).ShowMsg(Lang.getLabel("20012_NewRole"), 2);
									}
									else if (len < 2)
									{
										(new GameAlert).ShowMsg(Lang.getLabel("20007_NewRole"), 2);
									}
									else
									{
										DataKey.instance.register(PacketDCRoleNew.id, DCDbError);
										var vo:PacketCDRoleNew=new PacketCDRoleNew();
										vo.accountID=PubData.accountID;
										vo.icon=headlist[metier][affirmSex];
										vo.metier=metier;
										vo.rolename=m_ui["mcBar"]["username"].text;
										vo.sex=affirmSex;
										canCreate=false;
										DataKey.instance.send(vo);

									}
								}
								else
								{
									(new GameAlert).ShowMsg(Lang.getLabel("20007_NewRole"), 2);
								}
							}
						}
					}
					if (this.hasEventListener(Event.ENTER_FRAME) == false)
					{
						this.addEventListener(Event.ENTER_FRAME, createNewRoleHandler);
					}
					break;
				case "btnAutoName":
					this.btnAutoName(true);
					break;
				case "mc_role_0":
					affirmSex=1;
					chooseSex(affirmSex);
					btnAutoName();
					break;
				case "mc_role_1":
					affirmSex=2;
					chooseSex(affirmSex);
					btnAutoName();
					break;
				case "btnFanhui":
					Main.instance().Layer0.addChild(SelectRole.getInstance());
					SelectRole.getInstance().init();
					if (NewRole_new.instance.parent != null)
						NewRole_new.instance.parent.removeChild(NewRole_new.instance);
					break;
				default:
					break;
			}
		}

		public function resize(e:Event=null):void
		{
			if (null != m_ui)
			{
				m_ui.x=((GameIni.MAP_SIZE_W - m_ui.width) >> 1) + 50;
				m_ui.y=((GameIni.MAP_SIZE_H - m_ui.height) >> 1) + 50;
			}
		}

		//开始游戏
		public function beginGame(bo:Boolean):void
		{
			DataKey.instance.register(PacketSCPlayerDataMore.id, responsePlayerDataMore);
			DataKey.instance.register(PacketSCPlayerData.id, responsePlayerData);
			//2013-03-11 andy 运营商控制功能
			DataKey.instance.register(PacketSCCloseModules.id, SCCloseModulesReturn);
			DataKey.instance.register(PacketSCRoleSelect.id, CRoleSelect);
			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO3, "4,A"));
			//早点初始化NowLoading加监听
			NowLoading.getInstance().show(true);
			Game_main.instance.hasRoleHandler(0);
			beginGame2(bo);
		}

		/**
		 *	运营商关闭模块
		 *  2013-03-11 andy
		 */
		private function SCCloseModulesReturn(p:PacketSCCloseModules):void
		{
			WindowModelClose.data=p.modules;
			PubData.isDeal=WindowModelClose.isOpen(WindowModelClose.IS_DEAL);
		}

		//判断数据加载好后再执行开始
		private function beginGame2(bo:Boolean):void
		{
			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO3, "4,B"));
			var csrs:PacketCWRoleSelect=new PacketCWRoleSelect();
			csrs.roleID=PubData.roleID;
			csrs.allow_pk_show=bo ? 1 : 0;
			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO, Lang.getLabel("50008_NewRole_new")));
			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO3, "5"));
			DataKey.instance.send(csrs);
			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO3, "4,C"));
		}


		// 选择角色登录界面
		public var mcLogin:MovieClip=null;

		private function DCDbError(p:IPacket):void
		{
			DataKey.instance.remove(PacketDCRoleNew.id, DCDbError);
			var pdcr:PacketDCRoleNew=p as PacketDCRoleNew;
			if (pdcr.tag == 0)
			{
				DataKey.instance.register(PacketSCPlayerDataMore.id, responsePlayerDataMore);
				DataKey.instance.register(PacketSCPlayerData.id, responsePlayerData);
				DataKey.instance.register(PacketSCRoleSelect.id, CRoleSelect);

				queryRoleList();

				if (mcLogin != null)
				{
					mcLogin.gotoAndStop(1);
					mcLogin["message"].gotoAndStop(1);
					mcLogin["message"]["id_"].text="";
					mcLogin["message"]["name_"].text="";
					mcLogin["message"]["level_"].text="";
					mcLogin["message"]["metier_"].text="";
				}
			}
			else
			{
				(new GameAlert).ShowMsg(Lang.getServerMsg(pdcr.tag).msg, 2);
				canCreate=true;
			}
		}

		public function queryRoleList():void
		{
			DataKey.instance.register(PacketDCRoleList.id, CRoleList);
			var svrList:PacketCDRoleList=new PacketCDRoleList();
			svrList.accountID=PubData.accountID;

			//WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO3,"3 - 角色列表"));
			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO3, "3"));

			DataKey.instance.send(svrList);
		}


		private var show_pk:int=1;

		/**
		 * 创建成功后再查询一次 得到ID
		 * */
		private function CRoleList(p:IPacket):void
		{
			var value:PacketDCRoleList=p as PacketDCRoleList;
			var arr:Vector.<StructDCRoleList2>=value.arrItemroleList; //StructDCRoleList

			//WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO3,"4 - 角色列表返回," + arr.length.toString()));
			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO3, "4," + arr.length.toString()));

			if (arr.length > 0)
			{
				var sdc:StructDCRoleList=arr[(arr.length - 1)] as StructDCRoleList;
				show_pk=sdc.show_pk;
				PubData.roleID=sdc.userid;
				PubData.ico=sdc.king_icon;
				//PubData.card = sdc.player_mini;
				PubData.level=sdc.king_level;
				PubData.jobNO=sdc.king_metier;
				PubData.uname=sdc.king_name;
				PubData.job=XmlRes.GetJobNameById(sdc.king_metier);
				PubData.s0=sdc.s0;
				PubData.s1=sdc.s1;
				PubData.s2=sdc.s2;
				PubData.s3=sdc.s3;
				PubData.metier=sdc.king_metier;
				PubData.sex=sdc.king_sex;

				//PubData.data=sdc.data;
				if (sdc.create_date > 20110101)
				{
					PubData.createDate=sdc.create_date;
				}

				//初始化高清极速配置信息
				GameIni.setQualityData(sdc.data.para1);

				//初始话 Alert 窗口是否需要再提示
				GameAlertNotTiShi.instance.setConfig(sdc.data.para2);

				GameIni.MAP_ID=sdc.mapid;

				sysSet=sdc.sys_config;
				while (this.numChildren > 0)
				{
					this.removeChildAt(0);
				}
				beginGame(true);
			}
			else
			{
				trace("创建失败");
			}
		}

		/**
		 * 随机职业
		 */
		private function _randomSelected():void
		{
			selected=Math.random() * 3;
		}

		private function set selected(idx:int):void
		{
			m_selectIdx=idx;
			for (var i:int=0; i < ROLE_NUM; ++i)
			{
				if (i == m_selectIdx)
				{
					m_ui['mc_head_' + i].gotoAndStop(2);
				}
				else
				{
					m_ui['mc_head_' + i].gotoAndStop(1);
				}
			}

			btnAutoName();
		}

		/**
		 * 随机职业 3战士 4法师 1道士
		 */
		private function get metier():int
		{
			var _idx:int=-1;
			switch (m_selectIdx)
			{
				case 0:
					_idx=3;
					break;
				case 1:
					_idx=4;
					break;
				case 2:
					_idx=1;
					break;
				case 3:
					_idx=6;
					break;
				default:
					break;
			}

			return _idx;
		}
		private var affirmSex:int=-1;

		/**
		 * 2 女 1男
		 * */
		private function get sex():int
		{
			if (Math.random() > 0.5)
			{
				return 2
			}
			else
			{
				return 1;
			}
		}

		//是否是自己输入的名字【创建角色自己输入的名字切换角色名字不随机】
		private var isMyName:Boolean=false;
		private var secname1:Array;
		private var secname2:Array;
		private var secname3:Array;
		private var secname4:Array;
		private var secname5:Array;
		private var secname6:Array;
		private var secname7:Array;


		/**
		 *	随机获得名字
		 */
		private function btnAutoName(changeNameWill:Boolean=false):void
		{
			//2012-11-09 andy 自己填写的名字不变化
			if (this.isMyName&&changeNameWill==false)
				return;
			setTimeout(function():void
			{
				if (secname1 == null)
				{
					if (XmlConfig.KINGNAMEXML == null || XmlManager.localres.getPubKingnameXml.contentData.contentXml.length == 0)
					{
						btnAutoName();
						return;
					}
					secname1=XmlManager.localres.getPubKingnameXml.getResPath2(1) as Array;
					secname2=XmlManager.localres.getPubKingnameXml.getResPath2(2) as Array;
					secname3=XmlManager.localres.getPubKingnameXml.getResPath2(3) as Array;
					secname4=XmlManager.localres.getPubKingnameXml.getResPath2(4) as Array;
					secname5=XmlManager.localres.getPubKingnameXml.getResPath2(5) as Array;
					secname6=XmlManager.localres.getPubKingnameXml.getResPath2(6) as Array;
					secname7=XmlManager.localres.getPubKingnameXml.getResPath2(7) as Array;
				}
				var randType:int=3; //int(Math.random() * 3);
				var rand:Number=Math.random();
				if(rand<0.3)randType=2;
				
				
				if (affirmSex < 0)
					affirmSex=sex;
				if (affirmSex == 1)
				{
					//男角色名字随机规则为：1+2或4+5或7
					if (randType == 1)
					{
						m_ui["mcBar"]["username"].text=secname4[int(Math.random() * (secname4.length))].para + secname5[int(Math.random() * (secname5.length))].para;
					}
					else if (randType == 2)
					{
						m_ui["mcBar"]["username"].text=secname7[int(Math.random() * (secname7.length))].para;
					}
					else
					{
						m_ui["mcBar"]["username"].text=secname1[int(Math.random() * (secname1.length))].para + secname2[int(Math.random() * (secname2.length))].para;
					}
				}
				else
				{
					//女角色名字随机规则为：1+3或4+6或7
					if (randType == 1)
					{
						m_ui["mcBar"]["username"].text=secname4[int(Math.random() * (secname4.length))].para + secname6[int(Math.random() * (secname6.length))].para;
					}
					else if (randType == 2)
					{
						m_ui["mcBar"]["username"].text=secname7[int(Math.random() * (secname7.length))].para;
					}
					else
					{
						m_ui["mcBar"]["username"].text=secname1[int(Math.random() * (secname1.length))].para + secname3[int(Math.random() * (secname3.length))].para;
					}
				}
				chooseSex(affirmSex);
				m_ui["mc_role_0"].mouseChildren=m_ui["mc_role_1"].mouseChildren=false;
				m_ui["mc_role_0"]["uil"].source="GameRes/uiskin/game_newrole/metier" + m_selectIdx + "0.swf";
				m_ui["mc_role_1"]["uil"].source="GameRes/uiskin/game_newrole/metier" + m_selectIdx + "1.swf";
			}, 200);
		}

		private function chooseSex(m_sex:int):void
		{
			m_ui["mc_role_0"]["mcSelected"].visible=false;
			CtrlFactory.getUIShow().setColor(m_ui["mc_role_0"]);
			m_ui["mc_role_1"]["mcSelected"].visible=false;
			CtrlFactory.getUIShow().setColor(m_ui["mc_role_1"]);

			m_ui["mc_role_" + (m_sex == 2 ? 1 : 0)]["mcSelected"].visible=true;
			CtrlFactory.getUIShow().setColor(m_ui["mc_role_" + (m_sex == 2 ? 1 : 0)], 1);
			//发光
//			var gl:GlowFilter=new GlowFilter(0xffa800, .75, 32, 32, 2, BitmapFilterQuality.LOW, false, false);
//			if (m_sex == 1)
//			{
//				m_ui["mc_role_0"]["uil"].filters=[gl];
//				m_ui["mc_role_1"]["uil"].filters=null;
//			}
//			else
//			{
//				m_ui["mc_role_1"]["uil"].filters=[gl];
//				m_ui["mc_role_0"]["uil"].filters=null;
//			}
		}

		private function destorySecname():void
		{
			for (var m_i:int=1; m_i < 8; m_i++)
			{
				for (var m_n:String in this["secname" + m_i])
				{
					this["secname" + m_i][m_n]=null;
				}
				this["secname" + m_i]=null;
			}
		}
		public static var loginTimes:int=0; //登录次数

		// 选定角色,进入游戏主界面
		public function CRoleSelect(p:IPacket):void
		{

			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO3, "6"));

			DataKey.instance.remove(PacketSCRoleSelect.id, CRoleSelect);
			var vo:PacketSCRoleSelect=p as PacketSCRoleSelect;
			if (vo.tag != 0)
			{
				(new GameAlert).ShowMsg(Lang.getServerMsg(vo.tag).msg, 2);
				return;
			}
			Data.myKing.roleID=PubData.roleID;

			Data.myKing.mapx=vo.mapx;
			Data.myKing.mapy=vo.mapy;

			Data.myKing.mapid=vo.mapid;

			var obj:Object=new Object;

			obj.map_id=vo.mapid + "";
			obj.userid=PubData.roleID;



			loginTimes=vo.logintimes;

			//MYKING.UpdateKingData = obj;
			SceneManager.instance.setCurrentMapId(vo.mapid, 0);
			isCanIn=true;
			
			if (isGetePlayerData && isGetePlayerDataMore)
			{
				isCanIn=false;
				PubData.mainUI.ShowIndexUI();
				destorySecname();
			}
			//玩家信息更新，同步更新对应的地图信息
//			var info:Object = {};
//			info.mapId = vo.mapid;
//			info.userId = vo.userid;
//			info.mapx = vo.mapx;
//			info.mapy = vo.mapy;
			Global.userX = vo.mapx;
			Global.userY = vo.mapy;
			BasicObject.messager.dispatchEvent(new CustomEvent(SceneEvent.SCENE_INIT,vo.mapid));
		}
		private var isCanIn:Boolean=false;
		private var isGetePlayerData:Boolean=false;
		private var isGetePlayerDataMore:Boolean=false;

		public function responsePlayerDataMore(p:IPacket):void
		{
			isGetePlayerDataMore=true;
			if (isCanIn && isGetePlayerData)
			{
				isGetePlayerDataMore=false;
				isCanIn=false;
				PubData.mainUI.ShowIndexUI();
				destorySecname();
			}
		}

		public function responsePlayerData(p:IPacket):void
		{
			isGetePlayerData=true;
			if (isCanIn && isGetePlayerDataMore)
			{
				isCanIn=false;
				isGetePlayerData=false;
				PubData.mainUI.ShowIndexUI();
				destorySecname();
			}
		}
	}
}
