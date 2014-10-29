package ui.view.view1.buff
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_SkillResModel;
	import common.config.xmlres.server.Pub_Skill_BuffResModel;
	import common.config.xmlres.server.Pub_VipResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.clock.GameClock;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.net.drm.AddToDeviceGroupSetting;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.*;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import org.osmf.net.StreamingURLResource;
	
	import scene.action.Action;
	import scene.action.FightAction;
	import scene.action.hangup.GamePlugIns;
	import scene.king.King;
	
	import ui.base.mainStage.UI_index;
	import ui.frame.ItemManager;
	import ui.view.view1.doubleExp.DoubleExp;
	import ui.view.view2.other.ControlButton;
	
	import world.FileManager;
	import world.WorldEvent;

	/**
	 * @author suhang
	 * @create 2012-2-10
	 * 游戏buff控制类
	 */
	public class GameBuff
	{
		private var myBuff:Sprite=null;
		private var myBuffVec:Vector.<StructBuff2>=new Vector.<StructBuff2>;

		private var hbBuffVec:Vector.<StructBuff2>=new Vector.<StructBuff2>;

		private var npcBuffVec:Vector.<StructBuff2>=new Vector.<StructBuff2>;

		private var buffCDTimer:Timer=new Timer(1000);

		public function GameBuff()
		{
			if (myBuff == null)
				myBuff=new Sprite();
			//myBuff.x = 103;
			//myBuff.y = 79;
			myBuff.x=92;
			myBuff.y=107;

			UI_index.indexMC_character.addChildAt(myBuff, 0);

			DataKey.instance.register(PacketSCObjBuffList.id, SCObjBuffList);
//			setTimeout(function():void{
//				var vo:PacketCSObjBuffList = new PacketCSObjBuffList();
//				vo.objid = 0;
//				DataKey.instance.send(vo);
//			},5000);
			DataKey.instance.register(PacketSCBuffNew.id, SCBuffNew);
			DataKey.instance.register(PacketSCBuffDelete.id, SCBuffDelete);
			DataKey.instance.register(PacketSCBuffUpdate.id, SCBuffUpdate);
			buffCDTimer.addEventListener(TimerEvent.TIMER, updateBuffTime);
			buffCDTimer.start();
		}

		private function updateBuffTime(e:TimerEvent):void
		{
			for each (var bf:StructBuff2 in myBuffVec)
			{
				if (bf.buffid != DoubleExp.BUF && bf.buffid != ControlButton.BUFID)
				{
					if (bf.needtime > 0)
					{
						bf.needtime--;
						upd(bf);
					}
				}
			}
		}

		private static var m_instance:GameBuff=null;

		public static function getInstance():GameBuff
		{
			if (null == m_instance)
			{
				m_instance=new GameBuff();
			}
			return m_instance;
		}

		public function npcBuffDelete():void
		{
			while (npcBuffVec.length > 0)
				npcBuffVec.pop();
		}

		public function hbBuffDelete():void
		{
			while (hbBuffVec.length > 0)
				hbBuffVec.pop();
		}

		/**
		 * 通过 buffid 判断是否当前该Buff正在释放当中
		 * @param buffID
		 * @return
		 *
		 */
		public function isBuffingByID(buffID:int):Boolean
		{
			var _ret:Boolean=false;
			var _length:int=myBuffVec.length;

			var _item:StructBuff2=null;
			for (var i:int=0; i < _length; ++i)
			{
				_item=myBuffVec[i];
				if (_item.buffid == buffID)
				{
					_ret=true;
					break;
				}
			}


			return _ret;
		}

		private function SCObjBuffList(p:IPacket):void
		{
			var value:PacketSCObjBuffList=p as PacketSCObjBuffList;
			if (value.objid == Data.myKing.objid)
			{ //自己
				myBuffVec=value.arrItemlist;
				showBuff(1);
			}
			else if (value.objid == UI_index.indexMC["NPCStatus"].objid)
			{ //npc和怪物
				npcBuffVec=value.arrItemlist;
				showBuff(3);
			}
		}

		//1:自己  2：伙伴  3：npc和怪物
		private function showBuff(type:int):void
		{
			var bufficon:BuffIcon;
			var buff:Sprite;
			var buffArr:Vector.<StructBuff2>;

			switch (type)
			{
				case 1:
					buff=myBuff;
					buffArr=myBuffVec;
					break;
				case 2:
					//buff = UI_index.indexMC["mc_pet"]["buff"];
					buff=UI_index.indexMC_pet["buff"];
					buffArr=hbBuffVec;
					break;
				case 3:
					return;
					buff=UI_index.indexMC["NPCStatus"]["buff"];
					buffArr=npcBuffVec;
					break;
			}

			while (buff.numChildren > 0)
			{
				buff.removeChildAt(0);
			}
			if (buffArr == null)
				return;

			var len:int=buffArr.length;
			for (var i:int=0; i < len; i++)
			{
				addOne(buffArr[i], type, i);
			}
		}
		private var m_inteval:uint;

		/**
		 *	增加buff 【直接添加在后面，不刷新】
		 */
		private function SCBuffNew(p:IPacket):void
		{
			var value:PacketSCBuffNew=p as PacketSCBuffNew;
//项目修改			var psb:Pub_Skill_BuffResModel = Lib.getObj(LibDef.PUB_SKILL_BUFF, value.buff.buffid.toString());
			var psb:Pub_Skill_BuffResModel=XmlManager.localres.getPubSkillBuffXml.getResPath(value.buff.buffid) as Pub_Skill_BuffResModel;
			if (psb.effect == 25) //魔法盾buff不显示
				return;
			var type:int;
			var buffArr:Vector.<StructBuff2>;
			var hasBuff:Boolean=false;
			if (value.objid == Data.myKing.objid)
			{ //自己
				buffArr=myBuffVec;
				type=1;
			}
			else if (value.objid == UI_index.indexMC["NPCStatus"].objid)
			{ //npc和怪物
				buffArr=npcBuffVec;
				type=3;
			}
			if (buffArr == null)
				return;

			var len:int=buffArr.length;
			for (var i:int=0; i < len; i++)
			{
				if (buffArr[i].buffid == value.buff.buffid)
				{
					buffArr[i]=value.buff;
					hasBuff=true;
					upd(value.buff);
				}
				if (value.buff.buffid == 300)
				{
					clearInterval(m_inteval);
					UI_index.indexMC_mrb["skill_icon"].visible=false;
					var skill_mode:Pub_SkillResModel=XmlManager.localres.SkillXml.getResPath(401106) as Pub_SkillResModel;
					var m_icon:String=FileManager.instance.getSkillIconSById(skill_mode.icon);
					var m_lastT:int=value.buff.needtime*1000;
					var m_mark:int=getTimer();
					Lang.addTip(UI_index.indexMC_mrb["skill_icon"], "lie_xian_readly", 115);
					m_inteval=setInterval(funcDelay, 1000);
					function funcDelay():void
					{
						if (m_lastT < 1)
						{
							clearInterval(m_inteval);
							UI_index.indexMC_mrb["skill_icon"].visible=false;
						}
						else
						{
							if (UI_index.indexMC_mrb["skill_icon"].uil.source != m_icon)
								UI_index.indexMC_mrb["skill_icon"].uil.source=m_icon;
							if (UI_index.indexMC_mrb["skill_icon"].txt.text != int(m_lastT/1000) + "秒")
								UI_index.indexMC_mrb["skill_icon"].txt.text=int(m_lastT/1000) + "秒";
						}
						m_lastT-=getTimer() - m_mark;
						m_mark=getTimer();
						if ((Data.myKing.king as King).hasBuff(28))
						{
							UI_index.indexMC_mrb["skill_icon"].visible=true;
						}else{
							clearInterval(m_inteval);
							UI_index.indexMC_mrb["skill_icon"].visible=false;
						}
					}
				}
			}
			if (hasBuff == false)
			{
				buffArr.push(value.buff);
				addOne(value.buff, type, buffArr.length - 1);
			}
		}

		private function SCBuffUpdate(p:PacketSCBuffUpdate2):void
		{
			if (p.objid == Data.myKing.objid)
			{ //自己
				for each (var bf:StructBuff2 in myBuffVec)
				{
					if (bf.buffid == p.buff.buffid)
					{
						bf.needtime=p.buff.needtime;
						bf.remainCapacity=p.buff.remainCapacity;
						upd(bf);
					}
				}
			}
		}

		/**
		 *	删除buff 【需要刷新一下，因为要排位置】
		 */
		private function SCBuffDelete(value:PacketSCBuffDelete2):void
		{

			var type:int;
			var buffArr:Vector.<StructBuff2>;
			if (value.objid == Data.myKing.objid)
			{ //自己
				buffArr=myBuffVec;
				type=1;
			}
			else if (value.objid == UI_index.indexMC["NPCStatus"].objid)
			{ //npc和怪物
				buffArr=npcBuffVec;
				type=3;
			}
			if (buffArr == null)
				return;

			for (var i:int=0; i < buffArr.length; i++)
			{
				if (buffArr[i].sn == value.buffsn || (0 == buffArr[i].sn && buffArr[i].buffid == value.buffsn))
				{
					buffArr.splice(i, 1);
				}
			}
			showBuff(type);
		}

		private var jxtmBuffID:Array=[1350, 1351, 1352, 1353, 1354, 1355, 1356, 1357, 1358, 1359];

		/**
		 * 自动施放剑心通明
		 * */
		public function addBuffJXTM():void
		{
			if (Data.myKing.metier == 2 && Data.skill.hasSkill(401209))
			{
				for each (var m_struct_buffer:StructBuff2 in myBuffVec)
				{
					if (jxtmBuffID.indexOf(m_struct_buffer.buffid) >= 0)
					{
						return;
					}
				}
				//剑心通明技能ID  401403
				Action.instance.fight.FA2_SEND(Data.myKing.king, 401209, 0, 0, 0, 0);
			}
		}

		private function upd(buff:StructBuff2):void
		{
			var psb:Pub_Skill_BuffResModel=XmlManager.localres.getPubSkillBuffXml.getResPath(buff.buffid) as Pub_Skill_BuffResModel;
			if (psb == null)
				return;
			if (buff == null)
				return;

			var len:int=myBuff.numChildren;

			for (var j:int=0; j < len; j++)
			{
				var bufficon:BuffIcon=myBuff.getChildAt(j) as BuffIcon;

				if (null != bufficon)
				{
					//----------------------------------------------

//					if (buff.buffid == bufficon.data.buffid && (buff.buffid == DoubleExp.BUF||buff.buffid ==ControlButton.BUFID))
					if (buff.buffid == bufficon.data.buffid && buff.needtime > 0)
					{
						var desc:String=psb.buff_desc.replace('#param', CtrlFactory.getUICtrl().formatTime2(buff.needtime));


						bufficon.tipParam=[desc];

					}


						//-----------------------------------------------
				}
			}


		}

		/**
		 *	增加一个新的图标 【解决增加新的buff时不全部刷新】
		 *  @2012-08-21 andy
		 */
		private function addOne(buff:StructBuff2, type:int, index:int):void
		{
			var psb:Pub_Skill_BuffResModel=XmlManager.localres.getPubSkillBuffXml.getResPath(buff.buffid) as Pub_Skill_BuffResModel;
			if (psb == null)
				return;
			if (buff == null)
				return;

			var bufficon:BuffIcon=type == 1 ? ItemManager.instance().getBuffIcon(buff.buffid) : ItemManager.instance().getBuffIconPet(buff.buffid);
			bufficon.icon=psb.icon;
			bufficon.data=buff;

//			if (buff.buffid == DoubleExp.BUF||buff.buffid ==ControlButton.BUFID)
//			{
			var desc:String=psb.buff_desc.replace('#param', CtrlFactory.getUICtrl().formatTime2(buff.needtime));
			bufficon.tipParam=[desc];
//
//			}
//			else
//			{
//				bufficon.tipParam=[psb.buff_desc];
//			}

			Lang.addTip(bufficon, "pub_param", 125);
			//显示第几个位置
			var showIndex:int=0;
			var iconW:int=22;
			if (type == 1)
			{
				if (this.hasSameBuff(myBuff, buff.buffid))
					return;
				showIndex=myBuff.numChildren;
				if (showIndex < 10)
				{
					bufficon.x=iconW * showIndex;
					bufficon.y=0;
				}
				else if (showIndex < 20)
				{
					bufficon.x=iconW * (showIndex - 10);
					bufficon.y=17;
				}
				else if (showIndex < 30)
				{
					return;
					bufficon.x=iconW * (showIndex - 20);
					bufficon.y=34;
				}
				else
				{
					return;
				}
				myBuff.addChild(bufficon);

			}
			else if (type == 2)
			{
				if (this.hasSameBuff(UI_index.indexMC_pet["buff"], buff.buffid))
					return;
				showIndex=UI_index.indexMC_pet["buff"].numChildren;
				if (showIndex < 3)
				{
					bufficon.x=iconW * showIndex;
					bufficon.y=0;
				}
				else if (showIndex < 8)
				{
					bufficon.x=iconW * (showIndex - 5);
					bufficon.y=17;
				}
				else
				{
					return;
				}
				UI_index.indexMC_pet["buff"].addChild(bufficon);
				trace("伙伴：", index, buff.buffid, "(x,y)", bufficon.x, bufficon.y);
			}
			else
			{

			}
		}

		/**
		 *	是否有相同的buff
		 */
		public function hasSameBuff(sprite:Sprite, buffId:int):Boolean
		{
			if (sprite == null)
			{
				sprite=myBuff;
			}
			var ret:Boolean=false;

			var len:int=sprite.numChildren;
			var buff:BuffIcon=null;
			for (var k:int=0; k < len; k++)
			{
				buff=sprite.getChildAt(k) as BuffIcon;
				if (buffId == buff.data.buffid)
				{
					ret=true;
					break;
				}
			}
			return ret;
		}

		/**
		 * 检查是否有结婚buff
		 * @return
		 *
		 */
		public function checkJieHunBuff(lvl:int=-1):String
		{
			var _ret:String="";
			var bid:int=lvl == 1 ? 16771 : lvl == 2 ? 16772 : lvl == 3 ? 16773 : 0;
			//自己的信息从buff里边取
			if (lvl == -1)
			{
				for each (var _item:StructBuff2 in myBuffVec)
				{
					if (_item.buffid == 16771 || _item.buffid == 16772 || _item.buffid == 16773)
					{
						bid=_item.buffid;
						break;
					}
				}
			}
			//bid=16771;
			var psb:Pub_Skill_BuffResModel=XmlManager.localres.getPubSkillBuffXml.getResPath(bid) as Pub_Skill_BuffResModel;
			if (psb != null)
			{
				_ret=psb.buff_desc;
			}
			return _ret;
		}

		/**
		 * 检查是否有VIP buff
		 * @return
		 *
		 */
		public function checkVipBuff(vip:int):String
		{
			var _ret:String="";
			var bid:int=0;
			var config:Pub_VipResModel=XmlManager.localres.VipXml.getResPath(vip) as Pub_VipResModel;
			if (config != null)
			{
				bid=config.buff_id;
			}
			//bid=16201;
			var psb:Pub_Skill_BuffResModel=XmlManager.localres.getPubSkillBuffXml.getResPath(bid) as Pub_Skill_BuffResModel;
			if (psb != null)
			{
				_ret=psb.buff_desc;
			}
			return _ret;
		}

	}
}
