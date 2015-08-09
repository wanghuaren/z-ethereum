package ui.base.jiaose
{

	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.config.xmlres.server.Pub_WingResModel;
	import common.managers.Lang;
	import common.utils.ControlTip;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.bit.BitUtil;
	
	import engine.event.DispatchEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import model.Chibang.ChibangModel;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.BeiBaoSet;
	import netc.dataset.JiaoSeSet;
	import netc.dataset.MyCharacterSet;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSEquipAll;
	import nets.packets.PacketCSSetFachionShow;
	import nets.packets.PacketCSUnEquipItem;
	import nets.packets.PacketSCEquipAll;
	import nets.packets.PacketSCSetFachionShow;
	import nets.packets.PacketSCUnEquipItem;
	
	import scene.action.Action;
	
	import ui.base.beibao.BeiBao;
	import ui.base.mainStage.UI_index;
	import ui.frame.Image;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIPanel;
	import ui.frame.WindowName;
	import ui.view.jingjie.JingJiePanel;
	import ui.view.view1.buff.GameBuff;
	import ui.view.view2.liandanlu.LianDanLu;
	import ui.view.view4.chibang.ChiBang;
	import ui.view.view4.shenbing.Shenbing;
	import ui.view.view4.soar.SoarPanel;
	import ui.view.zuoqi.ZuoQiMain;
	
	import world.FileManager;

	/**
	 * 角色
	 * @andy wang 2011－12－07
	 * @andy 2012-07-02 伙伴合并，炼骨坐骑分离
	 * @andy 2013-12-17 3000万改版
	 */
	public class JiaoSe extends UIPanel
	{
		private var tf:TextFormat;
		private var arrEquipLimit:Array;
		private var arrEquipNextLevel:Array=null;

		private static var _instance:JiaoSe;

		public static const EQUIP_COUNT:int=16;

		public static function getInstance(reload:Boolean=false):JiaoSe
		{
			if (_instance == null && reload == false)
			{
				_instance=new JiaoSe();
			}
			return _instance;
		}

		public function JiaoSe()
		{
			super(getLink(WindowName.win_jue_se));
		}



		override public function init():void
		{
			super.init();
			super.sysAddEvent(Data.beiBao, BeiBaoSet.ROLE_EQUIP_UPDATE, roleEquipUpdate);
			super.sysAddEvent(Data.myKing, MyCharacterSet.HP_UPDATE, basicUpdate);
			super.sysAddEvent(Data.myKing, MyCharacterSet.MP_UPDATE, basicUpdate);
			super.sysAddEvent(Data.myKing, MyCharacterSet.EXP_UPDATE, basicUpdate);
			super.sysAddEvent(Data.myKing, MyCharacterSet.LEVEL_UPDATE, basicUpdate);
			super.sysAddEvent(Data.myKing, MyCharacterSet.ATT_UPDATE, basicUpdate);
			super.sysAddEvent(Data.myKing, MyCharacterSet.FIGHT_VALUE_UPDATE, basicUpdate);
			super.sysAddEvent(Data.myKing, MyCharacterSet.SKIN_UPDATE, skinUpdate);
			super.blmBtn=2;
			super.sysAddEvent(mc, MouseEvent.MOUSE_OVER, overHandle);
			super.sysAddEvent(mc, MouseEvent.MOUSE_OUT, overHandle);
			
			DataKey.instance.register(PacketSCSetFachionShow.id,showShiZhuangReturn);

			mc["mc_title"].visible=false;
			mc["btnFly"].buttonMode=true;
			//	mc["btnSetTitle"].visible=Data.myKing.Title > 0;
			//2014-09-01 策划说暂不显示称号设置按钮
			mc["btnSetTitle"].visible=false;
			//初始化时装展示
			mc["fuXuanBtn"].selected = (BitUtil.getBitByPos(Data.myKing.SpecialFlag, 13) == 1);

			setPlayEquipEffect();
			JiaoSeAtt.getInstance().setMc(mc as MovieClip);
			var wifename:String=Data.myKing.king.wifename;
//			var wifename:String="";
			//Data.myKing.wifeTime=20140301;

			//已经结婚
			if (wifename != "")
			{
				mc["mc_wife"]["txt_wife"].htmlText=Lang.getLabel("pub_pei_ou") + " " + wifename;
				var wifeDate:Date=StringUtils.iDateToDate(Data.myKing.wifeTime);
				var cha:int=int((Data.date.nowDate.time - wifeDate.time) / (1000 * 24 * 3600));
				mc["mc_wife"].tipParam=[wifename, wifeDate.fullYear, (wifeDate.month + 1), wifeDate.date, cha];
				Lang.addTip(mc["mc_wife"], "10033_jiaose", 150);
			}
			else
			{
				mc["mc_wife"]["txt_wife"].htmlText="";
				Lang.removeTip(mc["mc_wife"]);
			}
			//暂时屏蔽
			mc["mc_wife"].visible=false;
			mc["btnJie"].visible=false;

			tf=new TextFormat();


			//2012-10-23 装备部位增加开放等级限制
			if (arrEquipLimit == null)
			{
				arrEquipLimit=Lang.getLabelArr("arrEquipLimit");
			}

			show();
//			btnTip();
			
			var currWing:Pub_WingResModel=XmlManager.localres.getWingXml.getResPath(Data.myKing.winglvl) as Pub_WingResModel;
			mc["btnFly"].gotoAndStop(currWing.wing_sort);
		}

		/**玩家身上的装备 左边的一列*/

		// 面板双击事件
		override public function mcDoubleClickHandler(target:Object):void
		{
			var name:String=target.name;
			if (name.indexOf("equip_item") >= 0)
			{
				if (target.data != null)
				{
					//2013-01-18 翅膀不让脱下
					//if(target.data.sort!=22)
					equipOff(target.data.pos);
				}
			}
		}

		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var name:String=target.name;

			//点住shift不放，然后点击物品直接把物品放到左下角聊天框
			if (name.indexOf("equip_item") >= 0 && target.data != null)
			{
				if (UI_index.shift_)
					BeiBao.getInstance().txtChat(target.data, UI_index.chat["txtChat"]);
				return;
			}

			switch (name)
			{
				case "btnYiJian":
				case "btnYiJian2":
					yiJian();
					break;
				case "btnSetTitle":
				case "btnCloseTitle":
					//设置称号
					mc["mc_title"].visible=!mc["mc_title"].visible;
					break;
				case "btnUsed":
					//使用称号
					JiaoSeTitle.getInstance().setTitle(mc["mc_title"]["mc_cmb"].curData, 1);
					break;
				case "btnUsedNot":
					//使用称号
					JiaoSeTitle.getInstance().setTitle(mc["mc_title"]["mc_cmb"].curData, 0);
					break;
				case "btnFly":
					//翅膀
					ChiBang.getInstance().open();
					break;
				case "fuXuanBtn":
					showShiZhuang();
				default:
					break;
			}

		}
		private function showShiZhuangReturn(p:PacketSCSetFachionShow):void
		{
			//时装是否显示
			if(p.tag == 0)
			{
				mc["fuXuanBtn"].selected =!mc["fuXuanBtn"].selected;
			}
		}
		/**
		 * 时装显示消息
		 */		
		private function showShiZhuang():void
		{
			var boo:Boolean = mc["fuXuanBtn"].selected;
			var client:PacketCSSetFachionShow = new PacketCSSetFachionShow();
			if(boo)
			{
				client.value = 0;
			}
			else
			{
				client.value = 1;
			}
			uiSend(client);
		}
		
		/**
		 *	界面显示
		 */
		private function show(obj:Object=null):void
		{
			clearEquipItem();

			mc["txt_mingZi"].text=Data.myKing.name;

			basicUpdate();
			skinUpdate();
			showBgWord();
			var _loc1:Array=Data.beiBao.getRoleEquipList();
			_loc1.forEach(callback1);


			addDefaultEquipTip();

		}

		private function showBgWord():void
		{
			for (var i:int=0; i < 16; i++)
			{
				if (mc.getChildByName("txt_metierAttName" + i))
				{
					mc["txt_metierAttName" + i].visible=true;
				}
			}
		}

		//列表中条目处理方法
		private function callback1(itemData:StructBagCell2, index:int, arr:Array):void
		{
			var pos:int=Data.beiBao.getEquipPos(itemData.pos);
			var sprite:MovieClip=mc.getChildByName("equip_item" + pos) as MovieClip;
			if (sprite == null)
				return;

			if (itemData == null)
				return;

			sprite.mouseChildren=false;
			sprite.data=itemData;
			LianDanLu.instance().showStar(sprite["txt_strong_level"], itemData.equip_strongLevel);
//			sprite["uil"].source=itemData.icon;
			ImageUtils.replaceImage(sprite, sprite["uil"], itemData.icon);
			if (mc.hasOwnProperty("txt_metierAttName" + pos))
				mc["txt_metierAttName" + pos].visible=false;
			ItemManager.instance().setEquipFace(sprite);
			CtrlFactory.getUIShow().addTip(sprite);
			sprite["lengque"].gotoAndStop(37);
		}


		/**************通信*****************/

		/**
		 *	 脱下装备【主角】
		 */
		public function equipOff(pos:int):void
		{
			this.uiRegister(PacketSCUnEquipItem.id, equipOffReturn);
			var cleint:PacketCSUnEquipItem=new PacketCSUnEquipItem();
			cleint.srcindex=pos;
			uiSend(cleint);
		}

		private function equipOffReturn(p:PacketSCUnEquipItem):void
		{
			if (super.showResult(p))
			{
			}
			else
			{

			}
		}


		/**
		 *	 一键装备
		 */
		private function yiJian():void
		{
			this.uiRegister(PacketSCEquipAll.id, yiJianReturn);
			var client:PacketCSEquipAll=new PacketCSEquipAll();
			client.pos=0;
			this.uiSend(client);
		}

		private function yiJianReturn(p:PacketSCEquipAll):void
		{
			if (super.showResult(p))
			{
				addDefaultEquipTip();

			}
			else
			{

			}
		}


		//窗口关闭事件
		override public function windowClose():void
		{
			super.windowClose();
		}

		/**
		 *	身上装备有变化
		 */
		private function roleEquipUpdate(e:DispatchEvent=null):void
		{
			show();
			playEquipEffect();
		}

		/**
		 *	基本属性有变化
		 */
		private function basicUpdate(e:DispatchEvent=null):void
		{
			JiaoSeAtt.getInstance().refresh();

		}

		/**
		 *	皮肤有变化
		 */
		private function skinUpdate(e:DispatchEvent=null):void
		{
			//获得衣服ID
			var equipId:int=0;
			;
			for each (var yifu:StructBagCell2 in Data.beiBao.getRoleEquipList())
			{
				if (yifu.equip_type == JiaoSeSet.EQUIPTYPE_CLOTHES)
				{
					equipId=yifu.itemid;
				}
			}

			var skin:Sprite=FileManager.instance.getWindowSkinUrl(Data.myKing.s0, Data.myKing.s1, Data.myKing.s2, Data.myKing.s3, Data.myKing.sex, Data.myKing.metier, Data.myKing.roleID, equipId);
			while (JiaoSeMain.getInstance().mc["m_role"].numChildren > 0)
				JiaoSeMain.getInstance().mc["m_role"].removeChildAt(0);
			JiaoSeMain.getInstance().mc["m_role"].addChild(skin);

			if (mc["mc_guang_huan"] != null)
			{
				var str:String=Action.instance.qiangHua.getColor(Data.myKing.roleID).replace(".swf", "ZS.swf");
				mc["mc_guang_huan"].source=str.substring(str.indexOf("GameRes"));
			}
		}

		/**
		 *	包裹显示CD冷却时间
		 */
		public static function showCD(cdKey:int, frame:int):void
		{
			//【注】为了保证组件在关闭状态下被系统垃圾回收，_instance变量会被置为NULL；
			//如果不对_instance进行判定，则每次接口调用getInstance()都会导致_instance实例被自动创建，违背了现有垃圾回收的设计方案
			if (_instance == null)
			{
				return;
			}
			var child:MovieClip;
			var i:int=0;
			if (JiaoSeMain.getInstance().isOpen && JiaoSeMain.getInstance().type == 1)
			{
				for (i=1; i <= BeiBaoSet.ZHUANGBEI_MAX; i++)
				{
					child=JiaoSe.getInstance().mc.getChildByName("equip_item" + i) as MovieClip;
					if (child != null && child.data != null && child.data is StructBagCell2 && (child.data as StructBagCell2).cooldown_id == cdKey)
					{
						//2012-10-24 
						//child.mouseEnabled=false;
						if (child["lengque"] == null)
							return;
						child["lengque"].gotoAndStop(frame);
						if (frame == 36)
						{
							child["lengque"].gotoAndStop(37);
								//child.mouseEnabled=true;
						}
					}
				}
			}
		}

		/**************内部使用方法**********/
		/**
		 *	清理装备
		 */
		private function clearEquipItem():void
		{
			var _loc1:*;
			var level:int=Data.myKing.level;

			for (i=1; i <= BeiBaoSet.ZHUANGBEI_MAX; i++)
			{
				_loc1=mc.getChildByName("equip_item" + i);
				if (_loc1)
				{
					_loc1["uil"].unload();
					_loc1["bg"].mouseEnabled=_loc1["bg"].mouseChildren=false;
					_loc1["uil"].mouseEnabled=_loc1["uil"].mouseChildren=false;
					_loc1["mc_color"].mouseEnabled=_loc1["mc_color"].mouseChildren=false;
					ImageUtils.cleanImage(_loc1);

					_loc1.data=null;
					ItemManager.instance().setEquipFace(_loc1, false);
					if (arrEquipLimit != null)
					{
						_loc1["mc_lock"].visible=level < arrEquipLimit[i];
						_loc1["mc_lock"]["txt_lock"].text=arrEquipLimit[i];
						_loc1["mc_lock"]["txt_lock"].mouseEnabled=false;
					}
					_loc1["mc_bind"].visible=false;
					_loc1["txt_strong_level"].text="";
				}
			}
		}

		/**
		 *	鼠标悬浮
		 */
		private var mc_tip:MovieClip=null;
		private function overHandle(me:MouseEvent):void
		{
			var target:Object=me.target;
			var name:String=target.name;
			if(mc_tip==null){
				mc_tip=JiaoSeMain.getInstance().mc["mc_tip"];
				mc_tip.mouseEnabled=mc_tip.mouseChildren=false;
			}
			switch (me.type)
			{
				case MouseEvent.MOUSE_OVER:
					if (name=="btnVip" ||name=="btnMa" ||name=="btnLong" ||name=="btnZhuan" ||name=="btnJie" ||
						name=="btnFly" ||name=="btnBing"
					){
						
						mc_tip.visible=true;
						mc_tip.x=target.x+20;
						mc_tip.y=target.y+20;
						var tip_content:String="";
						var level:int=0;
						mc_tip["txt_att_title"].text="";
						mc_tip["txt_att"].text="";
						var isHaveAtt:Boolean=true;
						if(name=="btnVip"){
							mc_tip.gotoAndStop(1);
							if(Data.myKing.Vip==0){
								mc_tip["txt_level"].text="当前不是至尊会员";
								isHaveAtt=false;
							}else{
								mc_tip["txt_level"].text="至尊会员"+Data.myKing.Vip+"级";
								mc_tip["txt_att_title"].text="至尊会员为角色加成属性";
								tip_content=GameBuff.getInstance().checkVipBuff(Data.myKing.Vip);
								mc_tip["txt_att"].htmlText=tip_content.substr(tip_content.indexOf("<br/>")+5,tip_content.length);
							}
						}else if(name=="btnMa"){
							mc_tip.gotoAndStop(2);
							tip_content=ZuoQiMain.getInstance().getCurAtt(Data.zuoQi.getHorseList().arrItemhorselist)
							if(tip_content==""){
								mc_tip["txt_level"].text="当前未强化坐骑";
								isHaveAtt=false;
							}else{
								level=Data.zuoQi.getHorseList().arrItemhorselist[0].curStrong;
								mc_tip["txt_level"].text="坐骑"+Math.ceil(level/10)+"阶"+(level%10==0?10:level%10)+"星";
								mc_tip["txt_att_title"].text="坐骑为角色加成属性";
								mc_tip["txt_att"].htmlText=tip_content;
							}
						}else if(name=="btnLong"){
							mc_tip.gotoAndStop(3);
							tip_content=JingJiePanel.instance().getCurAtt(Data.myKing.dragPoint);
							if(tip_content==""){
								mc_tip["txt_level"].text="当前未修炼龙脉";
								isHaveAtt=false;
							}else{
								level=Data.myKing.dragPoint;
								mc_tip["txt_level"].text="龙脉"+Math.ceil(level/10)+"等"+(level%10==0?10:level%10)+"阶";
								mc_tip["txt_att_title"].text="龙脉为角色加成属性";
								mc_tip["txt_att"].htmlText=tip_content;
							}
						}else if(name=="btnZhuan"){
							mc_tip.gotoAndStop(4);
							tip_content=SoarPanel.getInstance().getCurAtt(Data.myKing.soarlvl);
							if(tip_content==""){
								mc_tip["txt_level"].text="当前未转生";
								isHaveAtt=false;
							}else{
								level=Data.myKing.soarlvl;
								mc_tip["txt_level"].text="转生"+Math.ceil(level/10)+"转"+(level%10==0?10:level%10)+"阶";
								mc_tip["txt_att_title"].text="转生为角色加成属性";
								mc_tip["txt_att"].htmlText=tip_content;
							}
						}else if(name=="btnJie"){
							mc_tip.gotoAndStop(5);
							tip_content=GameBuff.getInstance().checkJieHunBuff();
							if(tip_content==""){
								mc_tip["txt_level"].text="当前未结婚";
								isHaveAtt=false;
							}else{
								mc_tip["txt_level"].text="已结婚";
								mc_tip["txt_att_title"].text="结婚为角色加成属性";
								mc_tip["txt_att"].htmlText=tip_content.substr(tip_content.indexOf("<br/>")+5,tip_content.length);
							}
						}else if(name=="btnBing"){
							mc_tip.gotoAndStop(6);
							tip_content=Shenbing.getInstance().getCurAtt(Data.myKing.godlvl);
							if(tip_content==""){
								mc_tip["txt_level"].text="当前未锻造神兵";
								isHaveAtt=false;
							}else{
								level=Data.myKing.godlvl;
								mc_tip["txt_level"].text="神兵"+Math.ceil(level/10)+"阶"+(level%10==0?10:level%10)+"星";
								mc_tip["txt_att_title"].text="神兵为角色加成属性";
								mc_tip["txt_att"].htmlText=tip_content;
							}
						}else if(name=="btnFly"){
							mc_tip.gotoAndStop(7);
							tip_content=ChiBang.getInstance().getCurAtt(Data.myKing.winglvl);
							if(tip_content==""){
								mc_tip["txt_level"].text="当前未升阶翅膀";
								isHaveAtt=false;
							}else{
								level=Data.myKing.winglvl;
								mc_tip["txt_level"].text="翅膀"+Math.ceil(level/10)+"阶"+(level%10==0?10:level%10)+"星";
								mc_tip["txt_att_title"].text="翅膀为角色加成属性";
								mc_tip["txt_att"].htmlText=tip_content;
							}
							mc_tip.x=target.x-20;
							mc_tip.y=target.y+50;
						}else{
						
						}
						mc_tip["mc_bg"].height= isHaveAtt?317:155;
					}
					else
					{

					}
					break;
				case MouseEvent.MOUSE_OUT:
					if (name=="btnVip" ||name=="btnMa" ||name=="btnLong" ||name=="btnZhuan" ||name=="btnJie" ||
						name=="btnFly" ||name=="btnBing"
					){
						mc_tip.visible=false;
					}
					else
					{

					}
					break;
				default:
					break;
			}

		}

		/**
		 * 按鈕懸浮 2014-08-18
		 *
		 */
		private function btnTip():void
		{
			var tip_content:String="";
			mc["btnVip"].mouseChildren=false;
			tip_content=GameBuff.getInstance().checkVipBuff(Data.myKing.Vip);
			mc["btnVip"].tipParam=[tip_content == "" ? "<font color='#ff9600'>至尊会员</font><br/>成为至尊会员可获得高额攻击属性加成！" : tip_content];
			Lang.addTip(mc["btnVip"], "10035_jiaose", 150);

			mc["btnMa"].mouseChildren=false;
			mc["btnMa"].tipParam=[ZuoQiMain.getInstance().getCurAtt(Data.zuoQi.getHorseList().arrItemhorselist)];
			Lang.addTip(mc["btnMa"], "10036_jiaose", 150);

			mc["btnLong"].mouseChildren=false;
			mc["btnLong"].tipParam=[JingJiePanel.instance().getCurAtt(Data.myKing.dragPoint)];
			Lang.addTip(mc["btnLong"], "10037_jiaose", 150);

			mc["btnZhuan"].mouseChildren=false;
			mc["btnZhuan"].tipParam=[SoarPanel.getInstance().getCurAtt(Data.myKing.soarlvl)];
			Lang.addTip(mc["btnZhuan"], "10038_jiaose", 150);

			mc["btnJie"].mouseChildren=false;
			tip_content=GameBuff.getInstance().checkJieHunBuff();
			mc["btnJie"].tipParam=[tip_content == "" ? "<font color='#ff9600'>结婚</font><br/>结婚后您和您的配偶都会获得属性提升！" : tip_content];
			Lang.addTip(mc["btnJie"], "10039_jiaose", 150);

			mc["btnFly"].mouseChildren=false;
			mc["btnFly"].tipParam=[ChiBang.getInstance().getCurAtt(Data.myKing.winglvl)];
			Lang.addTip(mc["btnFly"], "10040_jiaose", 150);

		}



		/**
		 * 2012-06-11
		 * 增加默认武器悬浮
		 */
		private function addDefaultEquipTip():void
		{
			var posName:String;
			for (i=1; i <= 16; i++)
			{
				child=mc.getChildByName("equip_item" + i) as MovieClip;
				if (child == null)
					continue;
				if (child.data == null)
				{
					posName=XmlRes.GetEquipTypeName(i, "desc");
					child.tipParam=[posName];
					Lang.addTip(child, "pub_param", ControlTip.INDEX_TIP_WIDTH);
				}
				else
				{
					Lang.removeTip(child);
				}
			}
		}

		/**
		 *	2012-07-31
		 *  是否可以升级
		 *  家装备穿戴等级为1级时 玩家等级≥20级 ，做箭头显示
		 玩家装备穿戴等级为20级时 玩家等级≥40级 ，做箭头显示
		 玩家装备穿戴等级为40级时 玩家等级≥60级 ，做箭头显示
		 玩家装备穿戴等级为60级时 玩家等级≥80级 ，做箭头显示
		 玩家装备穿戴等级为80级时 玩家等级≥100级 ，做箭头显示
		 */
		public function isUpEquip(equipLevel:int=1, level:int=1):Boolean
		{
			if (arrEquipNextLevel == null)
			{
				arrEquipNextLevel=Lang.getLabelArr("arrEquipNextLevel");
			}
			var nextLevel:int=arrEquipNextLevel[equipLevel];

			if (level > equipLevel && level >= nextLevel)
			{
				return true;
			}
			else
			{
				return false;
			}
		}

		/**
		 *	总战力值
		 */
		public static function getZhanLiTotal():int
		{
			var ret:int=Data.myKing.FightValue;
//			var hb:PacketSCPetData2=Data.huoBan.getPetByPos(PetModel.getInstance().getFightPos());
//			if (hb != null)
//			{
//				ret+=hb.FightValue;
//			}


			return ret;
		}

		/**
		 *	角色身上的装备孔是否有装备 2013-09-22
		 */
		public static var arrRoleEquipStatus:Array=[];

		/**
		 *	播放特效设置
		 */
		private function setPlayEquipEffect():void
		{
			return;
			var _loc1:Array=Data.beiBao.getRoleEquipList();
			for (var h:int=0; h < 16; h++)
			{
				arrRoleEquipStatus[h]=0;
			}
			for each (var equip:StructBagCell2 in _loc1)
			{
				arrRoleEquipStatus[Data.beiBao.getEquipPos(equip.pos) - 1]=1;
			}
		}

		/**
		 *	播放特效比较
		 */
		private function playEquipEffect():void
		{
			var _loc1:Array=Data.beiBao.getRoleEquipList();
			var now:Array=[];
			for (var h:int=0; h < 16; h++)
			{
				now[h]=0;
			}
			for each (var equip:StructBagCell2 in _loc1)
			{
				now[Data.beiBao.getEquipPos(equip.pos) - 1]=1;
			}

			//比骄
			for (var n:int=0; n < 16; n++)
			{
				if (arrRoleEquipStatus[n] == 0 && now[n] == 1)
				{
					//					mc["equip_item"+(n+1)]["mc_effect"].play();
				}
			}
			arrRoleEquipStatus=now;
		}
		
		/**
		 * 战力值转换成图片 2014－11－24 
		 * @param fightValue
		 * 
		 */		
		public function setFightValueIcon(fightValue:int,where:String="js",cellWidth:int=20):Sprite{
			var ret:Sprite=new Sprite();
			var chars:String=fightValue.toString();
			var char:String="";
			var font:MovieClip;
			for(var m:int=0;m<chars.length;m++){
				font= where=="js"?ItemManager.instance().getZLJS(m) as MovieClip:ItemManager.instance().getZLSB(m) as MovieClip;
				char=chars.charAt(m);
				font.gotoAndStop(int(char)+1);
				font.x=m*cellWidth;
				ret.addChild(font);
			}
			return ret;
		}

	}
}






