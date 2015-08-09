package ui.view.view1.fuben
{
	import common.config.GameIni;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_InstanceResModel;
	import common.managers.Lang;
	import common.utils.StringUtils;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import netc.Data;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import ui.frame.CheckPlayerMenu;
	import ui.frame.ImageUtils;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view1.desctip.GameTip;
	import ui.view.view1.desctip.WarningIcon;
	
	import world.FileManager;

	//我的队伍列表
	public class MyDuiWu extends UIWindow
	{
		/**
		 * 队伍id
		 */
		public static var signid:int;
		/**
		 * 副本ID
		 */
		private var m_instanceid:int;

		/**
		 * 副本名称
		 */
		private var m_instanceName:String;

		/**
		 * 副本掉落描述
		 */
		private var m_instanceDropDesc:String;

		/**
		 * 副本的最低要求玩家等级
		 */
		private var m_minLevel:int;

		/**
		 * 当前人数
		 */
		private var m_nowNum:int;

		/**
		 * 当前队伍最多多少人
		 */
		private var m_totalNum:int;
		
		/**
		 * 
		 */ 
		public var btnZoomClick:Boolean = false;

		private var selectedItem:Object=null;

		public function MyDuiWu(DO:DisplayObject=null)
		{			
			super(getLink(WindowName.win_wo_dui));
		}

		public static const ICONSN:int = 12345566;
		
		public static var _instance:MyDuiWu=null;

		public static function get instance():MyDuiWu
		{
			if (null == _instance)
			{
				_instance=new MyDuiWu();
			}

			return _instance;
		}
		
		override public function closeByESC():Boolean
		{
			return false;
		}
		
		override public function get height():Number
		{
			return 420;
		}
		
		override public function get width():Number
		{
			return 256;
		}

		// 面板初始化
		override protected function init():void
		{
			super.init();
			
			this.alpha = 1.0;
			
			btnZoomClick = false;
			
			this.rebuildMoveBar(320);
			
			this.x=FuBenDuiWu._instance.x + FuBenDuiWu._instance.width - 15;
			this.y=FuBenDuiWu._instance.y;
			
			//
			var value:Pub_InstanceResModel = XmlManager.localres.getInstanceXml.getResPath(FuBenDuiWu.groupid) as Pub_InstanceResModel;
			
			for(var k:int =5;k>=1;k--)
			{
				if(k <= value.max_num){
					
					mc["item" + k.toString()]["mc_hole"].visible = true;								
					
				}else{
					mc["item" + k.toString()]["mc_hole"].visible = false;	
				}
				
				mc["item"+k.toString()]["mc_hole"].mouseChildren = false;
			}

//			uiRegister(PacketSCLeftSign.id,SCLeftSign);
			uiRegister(PacketSCChangeStart.id, SCChangeStart);
			uiRegister(PacketSCKickPlayer.id, SCKickPlayer);
			uiRegister(PacketSCInstanceStart.id, SCInstanceStart);
			uiRegister(PacketSCKickLeftSign.id, SCKickLeftSign);
			uiRegister(PacketSCMapSend.id, SCMapChange);


		}
		
		public function SCMapChange(p:PacketSCMapSend):void
		{
			if(!this.btnZoomClick)
			{
				this.mcHandler(mc['btnZoom']);
			}
		
		}

		//当队伍人数发生变化时，刷新“副本难度显示”的怪物等级。
		//怪物等级计算公式：队伍最低玩家等级×0.8+队伍其他玩家平均等级×0.2
		//队伍其他玩家平均等级×0.2,这个其他指的是除了最低级玩家的其它玩家 
		private function showNanDu(sspi:Vector.<StructSignPlayerInfo2>):void
		{

			var value:Pub_InstanceResModel=XmlManager.localres.getInstanceXml.getResPath(m_instanceid) as Pub_InstanceResModel;
			
			if (0 == sspi.length)
			{
				return;
			}

			if (1 == sspi.length)
			{	
				if(null == value){
				mc["txt_nan_du"].text=Lang.getLabel("10108_myduiwu", [sspi[0].level.toString()]);
				}
				
				if(null != value)
				{
//					F.副本表.xlsx中的show_sort字段控制怪物等级类型：当
//					1.show_sort=1时，自适应怪物等级。
//					2.show_sort=2时，读取instance_level字段的相应数据。
					if(1 == value.show_sort)
					{
						mc["txt_nan_du"].text=Lang.getLabel("10108_myduiwu", [sspi[0].level.toString()]);
						
					}else
					{
						mc["txt_nan_du"].text=Lang.getLabel("10108_myduiwu", [value.instance_level.toString()]);
					
					}					
				}
				
				return;
			}

			var list:Array=[];

			var j:int=0;
			var jLen:int=sspi.length;

			for (j=0; j < jLen; j++)
			{
				list.push(sspi[j]);

			}

			list.sortOn(["level"], [Array.NUMERIC, Array.DESCENDING]);

			//
//			var result:Number=list[0]["level"] * 0.8;
			//======whr============
			list.shift();
			jLen=list.length;

//			var result:Number=list[0]["level"] * 0.8;

			var avg:int=0;
			for (j=0; j < jLen; j++)
			{
				avg+=list[j]["level"];
			}

			//
//			result+=(avg / (jLen - 1)) * 0.2;
			//============whr============
			var result:Number=avg / jLen;

			if(null == value)
			{
				mc["txt_nan_du"].text=Lang.getLabel("10108_myduiwu", [Math.floor(result).toString()]);
			}
			
			if(null != value)
			{
				//					F.副本表.xlsx中的show_sort字段控制怪物等级类型：当
				//					1.show_sort=1时，自适应怪物等级。
				//					2.show_sort=2时，读取instance_level字段的相应数据。
				if(1 == value.show_sort)
				{
					mc["txt_nan_du"].text=Lang.getLabel("10108_myduiwu", [Math.floor(result).toString()]);
					
				}else
				{
					mc["txt_nan_du"].text=Lang.getLabel("10108_myduiwu", [value.instance_level.toString()]);
					
				}					
			}
			
		}

		public function showMessage(pscpu:PacketSCPlayerListUpdate):void
		{
			var ssl:StructSignList2=pscpu.signlist;
			signid=ssl.signid;
			m_instanceid=ssl.instanceid;

			var sspi:Vector.<StructSignPlayerInfo2>=ssl.arrItemplayerlist;
			var nowNum:int=sspi.length;
			m_nowNum=nowNum;
			
			var value:Pub_InstanceResModel = XmlManager.localres.getInstanceXml.getResPath(FuBenDuiWu.groupid) as Pub_InstanceResModel;
			
			var total:int=value.max_num;//ssl.entertype < 3 ? ssl.entertype + 3 : 5;
			m_totalNum=total;

			//人数已经满了，不能再增加了。
			if (nowNum >= total)
			{
				if (mc.hasOwnProperty("btnComeHere") && null != mc["btnComeHere"])
				{
					StringUtils.setUnEnable(mc["btnComeHere"]);
				}
				
				//
				if (mc.hasOwnProperty("btnComeHere2") && null != mc["btnComeHere2"])
				{
					StringUtils.setUnEnable(mc["btnComeHere2"]);
				}
			}
			else
			{
				if (mc.hasOwnProperty("btnComeHere") && null != mc["btnComeHere"])
				{
					StringUtils.setEnable(mc["btnComeHere"]);
				}
				
				//
				if (mc.hasOwnProperty("btnComeHere2") && null != mc["btnComeHere2"])
				{
					StringUtils.setEnable(mc["btnComeHere2"]);
				}

			}

			//
			mc["renshu"].text=nowNum + "/" + value.max_num;
			//mc["renshu"].text=nowNum + "/" + total;
			var value:Pub_InstanceResModel=XmlManager.localres.getInstanceXml.getResPath(ssl.instanceid) as Pub_InstanceResModel;
			m_instanceName=value.instance_name;
			m_instanceDropDesc=value.drop_desc;
			m_minLevel=value.instance_level;
			mc["jiangli"].text=value.instance_name;
			
			var m:Pub_InstanceResModel = XmlManager.localres.getInstanceXml.getResPath(FuBenDuiWu.groupid) as Pub_InstanceResModel;
			
			var len:int=sspi.length;
			for (var i:int=0; i < len; i++)
			{
				if (i == 0)
				{
					if (sspi[0].roleid == Data.myKing.objid)
					{
						(mc as MovieClip).gotoAndStop(1);
						
						this.rebuildMoveBar(320);
						
						var entertype:int = 0;
							
						if (!(mc["mc_cmb"].hasEventListener(DispatchEvent.EVENT_COMB_CLICK)))
						{
							if(m.max_num <= 3){
								mc["mc_cmb"].addItems=[
									{label: 3 + Lang.getLabel("20010_fuben"), data: 0}, 
									//{label: 4 + Lang.getLabel("20010_fuben"), data: 1}, 
									//{label: 5 + Lang.getLabel("20010_fuben"), data: 2}, 
									{label: Lang.getLabel("20011_fuben"), data: 3}
								];
								
								entertype = 0;
							
							}else if(m.max_num <= 4)
							{
								mc["mc_cmb"].addItems=[
									{label: 3 + Lang.getLabel("20010_fuben"), data: 0}, 
									{label: 4 + Lang.getLabel("20010_fuben"), data: 1}, 
									//{label: 5 + Lang.getLabel("20010_fuben"), data: 2}, 
									{label: Lang.getLabel("20011_fuben"), data: 3}
								];
								
								entertype = 1;
							
							}else
							{
								mc["mc_cmb"].addItems=[
									{label: 3 + Lang.getLabel("20010_fuben"), data: 0}, 
									{label: 4 + Lang.getLabel("20010_fuben"), data: 1}, 
									{label: 5 + Lang.getLabel("20010_fuben"), data: 2}, 
									{label: Lang.getLabel("20011_fuben"), data: 3}
								];
							
								entertype = 2;
							}
							
							sysAddEvent(mc["mc_cmb"], DispatchEvent.EVENT_COMB_CLICK, cmbClickHandler);
							//mc["mc_cmb"].changeSelected(ssl.entertype);
							mc["mc_cmb"].changeSelected(entertype);
						}
					}
					else
					{
						(mc as MovieClip).gotoAndStop(2);
						
						this.rebuildMoveBar(320);
						
						if (ssl.entertype < 3)
						{
							mc["fangshi"].text=(ssl.entertype + 3) + Lang.getLabel("20010_fuben");
						}
						else
						{
							mc["fangshi"].text=Lang.getLabel("20011_fuben");
						}
					}
				}

//				mc["item" + (i + 1)]["uil"].source=FileManager.instance.getHeadIconSById(sspi[i].iconid);
				ImageUtils.replaceImage(mc["item" + (i + 1)],mc["item" + (i + 1)]["uil"],FileManager.instance.getHeadIconSById(sspi[i].iconid));
				mc["item" + (i + 1)]["username"].text=sspi[i].rolename.length > 6 ? sspi[i].rolename.substr(0, 5) + ".." : sspi[i].rolename;
				mc["item" + (i + 1)]["level"].text=sspi[i].level + Lang.getLabel("pub_ji");
				mc["item" + (i + 1)].data=sspi[i];
				mc["item" + (i + 1)].mouseChildren=false;
			}
			for (var z:int=sspi.length + 1; z < 6; z++)
			{
				mc["item" + z].gotoAndStop(1);
				mc["item" + z]["uil"].unload();
				mc["item" + z]["username"].text="";
				mc["item" + z]["level"].text="";
				mc["item" + z].data=null;
			}
			for (var j:int=total; j < 5; j++)
			{
				mc["item" + (j + 1)].gotoAndStop(2);
			}
			itemSelected(mc["item1"]);
			selectedItem=mc["item1"].data;
			//
			showNanDu(sspi);
		}

		private function cmbClickHandler(e:DispatchEvent):void
		{
			var vo:PacketCSChangeStart=new PacketCSChangeStart();
			vo.signid=signid;
			vo.entrytype=e.getInfo.data;
			uiSend(vo);
		}

		private function SCChangeStart(p:IPacket):void
		{
			showResult(p);
		}

		private function SCKickPlayer(p:IPacket):void
		{
			showResult(p);
		}

		private function SCInstanceStart(p:IPacket):void
		{
			if (showResult(p))
			{
				winClose();
				FuBenDuiWu._instance.winClose();
			}
		}

		private function SCKickLeftSign(p:IPacket):void
		{
			var value:PacketSCKickLeftSign=p as PacketSCKickLeftSign;
			if (value.signid == signid)
			{
				var vo:PacketCSLeftSign=new PacketCSLeftSign();
				vo.signid=signid;
				uiSend(vo);
				winClose();
			}
		}


		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);

			_openCheckPlayerMenu(target);

			if (target.name.indexOf("item") == 0)
			{
				if (target.hasOwnProperty("level") && target["level"].text != "" && target.name != "item")
				{
					itemSelected(target);
					selectedItem=target.data;
					return;
				}
			}
			switch (target.name)
			{
				case "btnZoom":
					
					btnZoomClick = true;
										
					var s:WarningIcon = GameTip.addTipButton(
						function(param:int):void
						{
							FuBenDuiWu.instance.open();
							MyDuiWu.instance.open();
							//var m_x:int = MyDuiWu.instance.x;
							//var m_y:int = MyDuiWu.instance.y;
							
							//MyDuiWu.instance.magnifyFrom(m_x,m_y);
						},
						10,
						Lang.getLabel("20071_FuBen"),ICONSN,ICONSN);
					
					//
					var s_x:int = GameIni.MAP_SIZE_W / 2 + 40 / 2;
					var s_y:int = GameIni.MAP_SIZE_W - 220;
					
					//
					this.shrinkTo(
						s_x,						
						s_y);
					
					//
					FuBenDuiWu.instance.winClose();
					
					break;
				
				case "closeWin":
					leaveDuiWu();
					break;
				case "btnGameStart":
					var vo:PacketCSInstanceStart=new PacketCSInstanceStart();
					vo.signid=signid;
					uiSend(vo);
					break;
				case "btnGoOut":
					if (selectedItem != null)
					{
						var voPscp:PacketCSKickPlayer=new PacketCSKickPlayer();
						voPscp.roleid=selectedItem.roleid;
						voPscp.signid=signid;
						uiSend(voPscp);
					}
					break;
				case "btnQuiteArm":
				case "btnQuiteArm2":
					alert.ShowMsg(Lang.getLabel("20009_fuben"), 4, null, function():void
					{
						var vo:PacketCSLeftSign=new PacketCSLeftSign();
						vo.signid=signid;
						uiSend(vo);
						winClose();
					});
					break;
				case "btnComeHere":
				case "btnComeHere2":
					_sayToWorld(m_instanceid, m_instanceName, signid, m_totalNum, m_nowNum, m_instanceDropDesc, m_minLevel);
					break;

				default:
					break;
			}
		}

		/**
		 * 向世界喊话： “你快回来~~~ 和我一起打副本!” ;
		 * @param instanceID      副本ID
		 * @param instanceName    副本名称
		 * @param signid          队伍ID
		 * @param totalNum        一个队伍最多少人
		 * @param nowNum          当前队伍人数
		 * @param drop_desc       奖励描述，副本表中的 drop_desc 字段
		 * @param level           副本的最低要求玩家等级
		 */
		private function _sayToWorld(instanceID:int, instanceName:String, signid:int, totalNum:int, nowNum:int, drop_desc:String, level:int):void
		{
			var _say:String=Lang.getLabel("40062_fuben_sayToWorld", [instanceName, nowNum, (totalNum - nowNum), drop_desc, instanceID, signid, level]);
			trace("副本向世界喊话：" + _say);

			var vo2:PacketCSSayWorld=new PacketCSSayWorld();
			vo2.content=_say;
			vo2.minlevel=level;
			uiSend(vo2);
		}

		private function leaveDuiWu():void
		{
			alert.ShowMsg(Lang.getLabel("20008_fuben"), 4, null, function():void
			{
				var vo:PacketCSLeftSign=new PacketCSLeftSign();
				vo.signid=signid;
				uiSend(vo);
				signid=0;
				winClose();
			});
		}
		
		public function LeftSignByWinClose():void
		{
			if(!btnZoomClick){
				if (signid != 0)
				{
					var vo:PacketCSLeftSign=new PacketCSLeftSign();
					vo.signid=signid;
					uiSend(vo);
				}}
		}

		// 窗口关闭事件
		override protected function windowClose():void
		{
			super.windowClose();
			
			//
			LeftSignByWinClose();

			//
			btnZoomClick = false;
			
			//新手引导  副本引导
			
		}

		private function _openCheckPlayerMenu(target:Object):void
		{
			var _name:String=target.name;
			var _data:Object=null;

			if (0 == _name.indexOf("item"))
			{
				_data=target.data;
				if (null == _data)
				{
					return;
				}

				if (Data.myKing.roleID == _data.roleid)
				{
					return;
				}

				CheckPlayerMenu.getInstance().setData(_data);
				CheckPlayerMenu.getInstance().setPosition((target as MovieClip).stage.mouseX, (target as MovieClip).stage.mouseY);
				CheckPlayerMenu.getInstance().open(true, false);
			}




		}


	}
}
