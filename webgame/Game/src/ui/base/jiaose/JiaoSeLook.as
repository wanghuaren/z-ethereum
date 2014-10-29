package ui.base.jiaose
{
	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_WingResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Utils3D;
	
	import netc.dataset.JiaoSeSet;
	import netc.packets2.PacketWCPlayerLookInfo2;
	import netc.packets2.StructBagCell2;
	import netc.packets2.StructGemInfo2;
	import netc.packets2.StructGemInfoPos2;
	
	import nets.packets.PacketCSPlayerLookInfo;
	import nets.packets.PacketWCPlayerLookInfo;
	
	import scene.action.Action;
	import scene.king.SkinByWin;
	
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.view.view2.liandanlu.LianDanLu;
	import ui.view.view4.chibang.ChiBang;
	
	import world.FileManager;
	import world.model.file.BeingFilePath;

	/**
	 * 角色【查看】
	 * andy 2012－04－10
	 */
	public class JiaoSeLook extends UIWindow
	{
		private var roleId:int=0;
		private var curItem:Object;
		private var curData:PacketWCPlayerLookInfo2;
		private var arrEquipLimit:Array;

		private var skin:SkinByWin;

		public static var _instance:JiaoSeLook;

		/**
		 *	@param roleId 角色ID，默认0为自己
		 *  @param tp     打开面板类型
		 *  @param must   是否必须打开面板
		 */
		public static function instance():JiaoSeLook
		{
			if (_instance == null)
			{
				_instance=new JiaoSeLook();
			}
			return _instance;
		}

		public function JiaoSeLook()
		{
			blmBtn=2;
			super(getLink("win_look"));
		}

		public function setRoleId(v:int=0):void
		{
			if (v == 0)
				v=PubData.roleID;
			roleId=v;
			type=1;
			super.open(true);
		}

		override protected function openFunction():void
		{
			init();
		}

		override protected function init():void
		{
			//this.visible=false;
			if (arrEquipLimit == null)
			{
				arrEquipLimit=Lang.getLabelArr("arrEquipLimit");
			}
			super.sysAddEvent(mc, MouseEvent.MOUSE_OVER, overHandle);
			super.sysAddEvent(mc, MouseEvent.MOUSE_OUT, overHandle);
			this.visible=false;
			type=1;
			getPlayerInfo();
		}

		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var name:String=target.name;

			switch (name)
			{
				case "cbtn1":

					break;
				case "cbtn2":
				
					break;
				default:
					break;

			}

		}

		/**
		 *	界面显示
		 */
		private function show(obj:Object=null):void
		{
			var path:BeingFilePath;
			//JiaoSeLookAtt.getInstance().refresh(type, curData, mc as MovieClip);
			
			switch (type)
			{
				case 1:
					//人物
					mc["mc_mingZi"]["txt_mingZi"].text=curData.name;
					mc["mc_guild"]["txt_guild"].text = curData.guildname;
					
					//
					Lang.addTip(mc["mc_mingZi"],"jiao_se_look1",120);					
					mc["mc_mingZi"].tipParam = [curData.name];
					
					if("" != curData.guildname)
					{
						Lang.addTip(mc["mc_guild"],"jiao_se_look2",120);
						mc["mc_guild"].tipParam = [curData.guildname];
					}
					
					
					var s0:int=curData.s0;
					var s1:int=curData.s1;
					var s2:int=curData.s2;
					var s3:int=curData.s3;
					
					var equipId:int=0;
					for each(var yifu:StructBagCell2 in curData.arrEquip){
						if(yifu.equip_type==JiaoSeSet.EQUIPTYPE_CLOTHES){
							equipId=yifu.itemid;
						}
					} 
					
					var skin:Sprite=FileManager.instance.getWindowSkinUrl(s0, s1, s2, s3, curData.sex, curData.metier, curData.role,equipId);
					while (mc["m_role"].numChildren > 0)
						mc["m_role"].removeChildAt(0);
					mc["m_role"].addChild(skin);
					
					mc["m_role"].mouseEnabled = false;
					
					if (mc["mc_guang_huan"] != null)
					{
						var str:String=Action.instance.qiangHua.getColor(curData.role).replace(".swf", "ZS.swf");
//						mc["mc_guang_huan"].source=str.substring(str.indexOf("GameRes"));
						ImageUtils.replaceImage(mc,mc["mc_guang_huan"],str.substring(str.indexOf("GameRes")));
					}

					clearEquipItem();
					var arr:Array=curData.arrEquip;
					arr.forEach(callback1);

					mc["btnFly"].mouseChildren=false;
					mc["btnFly"].tipParam=[ChiBang.getInstance().getCurAtt(curData.wingLevel,false)];
					Lang.addTip(mc["btnFly"],"10040_jiaose",150);
					var currWing:Pub_WingResModel=XmlManager.localres.getWingXml.getResPath(curData.wingLevel) as Pub_WingResModel;
					mc["btnFly"].gotoAndStop(currWing.wing_sort);
					break;
				case 2:
					//伙伴


					break;
				default:
					break;
			}

		}

		//列表中条目处理方法
		private function callback1(equip:StructBagCell2, index:int, arr:Array):void
		{
			child=mc["equip_item" + equip.pos];
			if (child == null)
				return;
			ItemManager.instance().setToolTipByData(child,equip);
			LianDanLu.instance().showStar(child["txt_strong_level"],equip.equip_strongLevel);
			child["lengque"].gotoAndStop(37);
		}


		/**************通信*****************/
		/**
		 *	 获得信息【全部信息，一次读取，防止该玩家掉线】
		 */
		private function getPlayerInfo():void
		{
			this.uiRegister(PacketWCPlayerLookInfo.id, getPlayerInfoReturn);
			var client:PacketCSPlayerLookInfo=new PacketCSPlayerLookInfo();
			client.role=roleId;
			this.uiSend(client);
		}

		private function getPlayerInfoReturn(p:PacketWCPlayerLookInfo2):void
		{
			if (p.role == 0)
			{
				Lang.showMsg(Lang.getClientMsg("10018_hao_you"));
				super.winClose();
			}
			else
			{
				this.visible=true;
				curData=p;
				curData.changeData();
				show();
			}
		}

		//窗口关闭事件
		override protected function windowClose():void
		{
			super.windowClose();

		}



		/**************内部使用方法**********/
		/**
		 *	清理装备
		 */
		private function clearEquipItem():void
		{
			var _loc1:*;
			var level:int=type == 1 ? curData.level : curData.pet_level;

			for (i=1; i <= 16; i++)
			{
				_loc1=mc.getChildByName("equip_item" + i);
				if (_loc1 == null)
					continue;
				if (_loc1["btnUpEquip"] != null)
					_loc1["btnUpEquip"].visible=false;
				_loc1["uil"].unload();
				_loc1.mouseChildren=false;
				_loc1.data=null;
				ItemManager.instance().setEquipFace(_loc1, false);
				ImageUtils.cleanImage(_loc1);

				_loc1["mc_lock"].visible=false;
				_loc1["mc_bind"].visible=false;
				_loc1["txt_strong_level"].text="";
				_loc1["lengque"].gotoAndStop(37);
			}
		}


		/**
		 *	鼠标悬浮
		 */
		private function overHandle(me:MouseEvent):void
		{
			var target:Object=me.target;
			var name:String=target.name;
			switch (me.type)
			{
				case MouseEvent.MOUSE_OVER:
					if (name.indexOf("cbtn") >= 0)
					{

					}
//					else if (name == "btnCangJingGe" || name == "btnJingJie" || name == "btnChongZhu" || name == "btnXingHun" || name == "btnMoWen" || name == "btnQiangHua")
//					{
//						TaoZhuang.getInstance().showFiveTip(mc as MovieClip, name, curData);
//					}
					else
					{

					}
					break;
				case MouseEvent.MOUSE_OUT:
					if (name.indexOf("cbtn") >= 0 && name != "cbtn" + type)
					{

					}

					else
					{
						if (type == 1)
						{
							
						}
					}
					break;
				default:
					break;
			}
		}

		/**
		 * 根据身上装备位置获得对应宝石列表 2014-05-14
		 *  @param equip_pos 身上显示位置
		 * 
		 */		
		public function getStoneByEquipPos(equip_pos:int,who:int=0):Vector.<StructGemInfo2>{
			if(this.curData==null)return null;
			var ret:Vector.<StructGemInfo2>=new Vector.<StructGemInfo2>();
			for each(var gem:StructGemInfoPos2 in this.curData.geminfo.arrItemgems){
				if(gem.pos==equip_pos){
					ret=gem.arrItemitems;
					break;
				}
			}
			//当前界面只有3个孔，服务端给4个孔数据
			if(ret.length>3)ret.pop();
			return ret;
		}
		/**
		 *  身上装备位 2014-06-10
		 *  @param 
		 * 
		 */		
		public function getPlayerEquip():Array{
			return this.curData.arrEquip;
		}

		override public function getID():int
		{
			return 1049;
		}
	}
}
