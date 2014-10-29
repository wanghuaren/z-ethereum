package ui.base.jineng
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_SkillResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.component.SelectedButton;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	import engine.utils.HashMap;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import netc.Data;
	import netc.dataset.SkillShortSet;
	import netc.packets2.StructShortKey2;
	import netc.packets2.StructSkillItem2;
	
	import nets.packets.PacketCSShortKeySet;
	import nets.packets.PacketSCShortKeySet;
	
	import ui.base.npc.NpcHotShop;
	import ui.base.npc.NpcShop;
	import ui.base.renwu.renwuEvent;
	import ui.base.zudui.DuiWu;
	import ui.frame.ImageUtils;
	import ui.frame.UIWindow;
	
	import world.FileManager;
	import world.WorldDispatcher;

	/**
	 * @author  suhang
	 * @version 2011-12
	 * 技能主面板
	 */
	public final class Jineng extends UIWindow
	{
		//主动技能学习等级
		public static var skillUseLevel1:int=5;
		public static var skillUseLevel2:int=10;
		public static var skillUseLevel3:int=20;
		public static var skillUseLevel4:int=30;
		//被动技能学习等级
		public static var skillBeiDongLevel1:int=10;
		public static var skillBeiDongLevel2:int=25;
		public static var skillBeiDongLevel3:int=35;
		public static var skillBeiDongLevel4:int=45;
		//主动技能按钮组
		private var sb1:SelectedButton;
		private var sb2:SelectedButton;
		private var sb3:SelectedButton;
		private var sb4:SelectedButton;

		private var currBtn:MovieClip;

		//public static var skillList:HashMap=new HashMap();
		public static var skillDataList:HashMap=new HashMap();
		public static var skillIdArr:Array=new Array;

		//已学习技能列表
		public static function get studySkillList():Vector.<StructSkillItem2>
		{
			return Data.skill.getSkillList(0);
		}

		public function Jineng()
		{
			blmBtn=2;
//			super(getLink("win_ji_neng"));
			uiRegister(PacketSCShortKeySet.id, ShortKeySet);
		}

		public static var _instance:Jineng=null;

		public static function get instance():Jineng
		{
			if (null == _instance)
			{
				_instance=new Jineng();
			}
			return _instance;
		}

		// 面板初始化
		override protected function init():void
		{
			super.init();
			mcHandler({name: "cbtn1"});
			//按钮初始化
			sb1=new SelectedButton(mc["content1"]["select1"]);
			sb2=new SelectedButton(mc["content1"]["select2"]);
			sb3=new SelectedButton(mc["content1"]["select3"]);
			sb4=new SelectedButton(mc["content1"]["select4"]);

			mc["content1"]["select1"]["level"].text=skillUseLevel1 + "";
			mc["content1"]["select2"]["level"].text=skillUseLevel2 + "";
			mc["content1"]["select3"]["level"].text=skillUseLevel3 + "";
			mc["content1"]["select4"]["level"].text=skillUseLevel4 + "";
			if (Data.myKing.level < skillUseLevel1)
			{
				setUnEnable(mc["content1"]["select1"], skillUseLevel1);
			}
			else
			{
				setEnable(mc["content1"]["select1"]);
			}
			if (Data.myKing.level < skillUseLevel2)
			{
				setUnEnable(mc["content1"]["select2"], skillUseLevel2);
			}
			else
			{
				setEnable(mc["content1"]["select2"]);
			}
			if (Data.myKing.level < skillUseLevel3)
			{
				setUnEnable(mc["content1"]["select3"], skillUseLevel3);
			}
			else
			{
				setEnable(mc["content1"]["select3"]);
			}
			if (Data.myKing.level < skillUseLevel4)
			{
				setUnEnable(mc["content1"]["select4"], skillUseLevel4);
			}
			else
			{
				setEnable(mc["content1"]["select4"]);
			}

			if (Data.myKing.level < skillBeiDongLevel1)
			{
				mc["content1"]["bd1"].visible=false;
			}
			else
			{
				mc["content1"]["bd1"].visible=true;
			}
			if (Data.myKing.level < skillBeiDongLevel2)
			{
				mc["content1"]["bd2"].visible=false;
			}
			else
			{
				mc["content1"]["bd2"].visible=true;
			}
			if (Data.myKing.level < skillBeiDongLevel3)
			{
				mc["content1"]["bd3"].visible=false;
			}
			else
			{
				mc["content1"]["bd3"].visible=true;
			}
			if (Data.myKing.level < skillBeiDongLevel4)
			{
				mc["content1"]["bd4"].visible=false;
			}
			else
			{
				mc["content1"]["bd4"].visible=true;
			}
			mc["content1"]["bd1"].mouseChildren=true;
			mc["content1"]["bd2"].mouseChildren=true;
			mc["content1"]["bd3"].mouseChildren=true;
			mc["content1"]["bd4"].mouseChildren=true;
			mc["content1"]["bd1"]["uil"].mouseEnabled=false;
			mc["content1"]["bd1"]["uil"].mouseChildren=false;
			mc["content1"]["bd2"]["uil"].mouseEnabled=false;
			mc["content1"]["bd2"]["uil"].mouseChildren=false;
			mc["content1"]["bd3"]["uil"].mouseEnabled=false;
			mc["content1"]["bd3"]["uil"].mouseChildren=false;
			mc["content1"]["bd4"]["uil"].mouseEnabled=false;
			mc["content1"]["bd4"]["uil"].mouseChildren=false;

			mc["content1"]["quxiao1"].visible=false;
			mc["content1"]["quxiao2"].visible=false;
			mc["content1"]["quxiao3"].visible=false;
			mc["content1"]["quxiao4"].visible=false;

			sysAddEvent(Data.skillShort, SkillShortSet.SKILLSHORTCHANGE, skillShortChange);

			skillShortChange(new DispatchEvent(SkillShortSet.SKILLSHORTCHANGE, Data.skillShort.contentList));

			//学习新技能
			sysAddEvent(WorldDispatcher.instance, WorldDispatcher.StudyNewSkill, StudyNewSkill);
			//队伍解散
			sysAddEvent(renwuEvent.instance, renwuEvent.DuiWuDeleteAll, DuiWuDeleteAll);

		}

		private function setUnEnable(mcObj:Object, lv:int):void
		{
			StringUtils.setUnEnable(mcObj);
			mcObj["txt"].text=lv + Lang.getLabel("20001_jineng_jiesuo");
		}

		private function setEnable(mcObj:Object):void
		{
			StringUtils.setEnable(mcObj);
			mcObj["txt"].text=Lang.getLabel("20001_jineng_xuanze");
		}

		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			//if(JinengBeiDong._instance!=null&&JinengBeiDong._instance.parent!=null)JinengBeiDong._instance.mcHandler(target);
			//if(JinengZhuDong._instance!=null&&JinengZhuDong._instance.parent!=null)JinengZhuDong._instance.mcHandler(target);
			if (target.name.indexOf("select") == 0)
			{
				//var jzd:JinengZhuDong = JinengZhuDong.instance(callback);
				//jzd.open();
				currBtn=target as MovieClip;

					//jzd.x=295;
					//jzd.y=3;
					//Jineng._instance.addChild(jzd);
					//if(jzd.getChildByName("moveBar"))jzd.removeChild(jzd.getChildByName("moveBar"));

					//setTimeout(function():void{
					//},100);
			}
			if (target.name.indexOf("bd") == 0)
			{
				//var jbd:JinengBeiDong = JinengBeiDong.instance(callback2);
				//jbd.open();
				currBtn=target.parent as MovieClip;

					//jbd.x=Jineng._instance.width - 8;
					//jbd.y=3;
					//Jineng._instance.addChild(jbd);
					//if(jbd.getChildByName("moveBar"))jbd.removeChild(jbd.getChildByName("moveBar"));
			}
			if (target.name.indexOf("quxiao") == 0)
			{
				selectSkill(int(target.name.substr(6, 1)), 0);
					//if(JinengBeiDong._instance!=null&&JinengBeiDong._instance.parent!=null)JinengBeiDong._instance.winClose();
					//if(JinengZhuDong._instance!=null&&JinengZhuDong._instance.parent!=null)JinengZhuDong._instance.winClose();
			}
			switch (target.name)
			{
				case "cbtn1":
					mc["content1"].visible=true;
					mc["content2"].visible=false;
					break;
				case "cbtn2":
					//	UI_index.UIAct.dispatchEvent(new DispatchEvent(UIActMap.EVENT_NOT_OPEN));return;
					mc["content2"].visible=true;
					mc["content1"].visible=false;

					//if(JinengBeiDong._instance!=null&&JinengBeiDong._instance.visible == true){
					//	JinengBeiDong._instance.winClose();
					//}
					//if(JinengZhuDong._instance!=null&&JinengZhuDong._instance.visible == true){
					//	JinengZhuDong._instance.winClose();
					//}

					showZF(DuiWu.ZFSelectedID);
					break;
				case "btn_jnssd":
					NpcShop.instance().setshopId(NpcHotShop.JINENG_BOOK_SHOP_ID);
					break;
				default:
					break;
			}
		}

		//显示阵法
		private function showZF(id:int):void
		{
			var isFirst:Boolean=false;
			if (mc["content2"]["ZFskill1"].data == null)
				isFirst=true;
			var ZFVec:Vector.<Pub_SkillResModel>=DuiWu.ZFVec;
			var ZFskill:MovieClip;
			for (var i:int=0; i < ZFVec.length; i++)
			{
				ZFskill=mc["content2"]["ZFskill" + (i + 1)];
				if (isFirst)
				{
					ZFskill.mouseEnabled=true;
					ZFskill.mouseChildren=false;
					ZFskill.data=ZFVec[i];
//					ZFskill["uil"].source=FileManager.instance.getSkillIconSById(ZFVec[i].skill_id);
					ImageUtils.replaceImage(ZFskill,ZFskill["uil"],FileManager.instance.getSkillIconSById(ZFVec[i].skill_id));
					CtrlFactory.getUIShow().addTip(ZFskill);
				}
				if (id == ZFVec[i].skill_id)
				{
					ZFskill["select"].gotoAndStop(2);
				}
				else
				{
					ZFskill["select"].gotoAndStop(1);
				}
				var study:Boolean=false;
				for each (var skill:StructSkillItem2 in studySkillList)
				{
					if (skill.skillId == ZFVec[i].skill_id)
					{
						study=true;
						break;
					}
				}
				if (study)
				{
					StringUtils.setEnable(ZFskill);
				}
				else
				{
					StringUtils.setUnEnable(ZFskill, true);
				}
			}
		}

		private function callback(skill:Pub_SkillResModel):void
		{
			SkillShort.setFlyStartPostion(currBtn);
			selectSkill(int(currBtn.name.substr(6, 1)), skill.skill_id);
		}

		/**
		 *	选择技能学习
		 */
		public function selectSkill(pos:int, objid:int, fromPos:int=0, flag:int=0):void
		{
			var vo:PacketCSShortKeySet=new PacketCSShortKeySet();
			vo.from_pos=fromPos;
			vo.to_pos=pos;
			vo.objid=objid;
			vo.flag=flag;
			uiSend(vo);
		}

		/**
		 * 放置道具到快捷栏
		 * @param pos
		 * @param objid
		 * @param fromPos
		 * @param flag
		 */
		public function selectItem(pos:int, objid:int, fromPos:int=0, flag:int=0):void
		{
			var vo:PacketCSShortKeySet=new PacketCSShortKeySet();
			vo.from_pos=fromPos;
			vo.to_pos=pos;
			vo.objid=objid;
			vo.objtype=1;
			vo.flag=flag;
			uiSend(vo);

//			//如果目标位置是1-4，则附带更新到对应的挂机技能配置中
//			if (pos>8){
//				var vo1:PacketCSShortKeySet=new PacketCSShortKeySet();
//				vo1.from_pos=fromPos;
//				vo1.to_pos=pos+8;
//				vo1.objid=objid;
//				vo.objtype = 1;
//				vo1.flag = 0;
//				uiSend(vo1);
//			}
		}

		private function callback2(skill:Pub_SkillResModel):void
		{
			var pos:int=int(currBtn.name.substr(2, 1)) + 4;
			var objid:int=skill ? skill.skill_id : 0;
			selectSkill(pos, objid);
		}

		private function ShortKeySet(p:IPacket):void
		{
			if (showResult(p))
			{
				JiNengMain.instance.refresh();
			}
		}

		//技能数据变化
		private function skillShortChange(e:DispatchEvent):void
		{
			var vec:Vector.<StructShortKey2>=e.getInfo as Vector.<StructShortKey2>;
			var uilMC:MovieClip;
			for (var i:int=0; i < vec.length; i++)
			{
				var pos:int=vec[i].pos;
				if (pos > 0 && pos < 5)
				{
					if (!vec[i].del && vec[i].id != 0)
					{
						uilMC=mc["content1"]["zd" + pos];
						uilMC["uil"].unload();
						if (vec[i].id != 0){
//							uilMC["uil"].source=FileManager.instance.getSkillIconSById(vec[i].id);
							ImageUtils.replaceImage(uilMC,uilMC["uil"],FileManager.instance.getSkillIconSById(vec[i].id));
						}
						this["sb" + pos].selected=true;
						this["sb" + pos].label=XmlManager.localres.getPubSkillXml.getResPath(vec[i].id)["skill_name"];
						//uilMC.data=Jineng.skillList.getValue(vec[i].id);

						uilMC.data=Data.skill.getSkill(vec[i].id);

						CtrlFactory.getUIShow().addTip(uilMC);
						mc["content1"]["quxiao" + pos].visible=true;
					}
					else
					{
						uilMC=mc["content1"]["zd" + pos];
						uilMC["uil"].unload();
						uilMC.data=null;
						CtrlFactory.getUIShow().removeTip(uilMC);
						this["sb" + pos].selected=false;
						if (int(this["sb" + pos].label.substr(0, 1)) == 0)
							this["sb" + pos].label=Lang.getLabel("20001_jineng_xuanze");
						mc["content1"]["quxiao" + pos].visible=false;
					}
				}
				if (pos > 4 && pos < 9)
				{
					if (!vec[i].del)
					{
						uilMC=mc["content1"]["bd" + (pos - 4)];
						uilMC["uil"].unload();
						if (vec[i].id != 0){
//							uilMC["uil"].source=FileManager.instance.getSkillIconSById(vec[i].id);
							ImageUtils.replaceImage(uilMC,uilMC["uil"],FileManager.instance.getSkillIconSById(vec[i].id));
						}
						uilMC.data=Data.skill.getSkill(vec[i].id);

						CtrlFactory.getUIShow().addTip(uilMC);
					}
					else
					{
						uilMC=mc["content1"]["bd" + (pos - 4)];
						uilMC["uil"].unload();
						uilMC.data=null;
						CtrlFactory.getUIShow().removeTip(uilMC);
					}
				}
			}
		}

		public function levelUp():void
		{
			if (this.parent != null)
			{
				init();
			}
		}

		private function StudyNewSkill(e:DispatchEvent):void
		{
			showZF(DuiWu.ZFSelectedID);
		}

		private function DuiWuDeleteAll(e:DispatchEvent):void
		{
			showZF(0);
		}

		// 窗口关闭事件
		override protected function windowClose():void
		{
			super.windowClose();
			//if(JinengBeiDong._instance!=null&&JinengBeiDong._instance.parent!=null)JinengBeiDong._instance.winClose();
			//if(JinengZhuDong._instance!=null&&JinengZhuDong._instance.parent!=null)JinengZhuDong._instance.winClose();
		}

		override public function open(must:Boolean=false, type:Boolean=true):void
		{
			super.open(must, type);
		}

		public function addNewGuestTip(tip:Sprite, station:int):void
		{
			if (0 == station)
			{
				tip.x=mc["content1"]["select1"].x + 120;
				tip.y=mc["content1"]["select1"].y;

				mc["content1"]["select1"].parent.addChild(tip);
			}
			else if (1 == station)
			{
				tip.x=400;
				tip.y=140;
			}
			else if (2 == station)
			{
				tip.x=mc["btnQiangHua"].x + 40;
				tip.y=mc["btnQiangHua"].y;
			}




		}


		override public function getID():int
		{
			return 1002;
		}

		override public function winClose():void
		{
			super.winClose();

		}

		/**
		 *	是不是新技能
		 *  @2012-10-25 andy
		 */
		public function isNewSkill(skillItem:StructSkillItem2):Boolean
		{
			var ret:Boolean=false;
			if (studySkillList != null)
			{
				for each (var item:StructSkillItem2 in studySkillList)
				{
					if (skillItem.skillId == item.skillId)
					{
						item.skillLevel=skillItem.skillLevel;
						item.skillExp=skillItem.skillExp;
						ret=true;
						break;
					}
				}
			}

			if (!ret)
			{
				studySkillList.push(skillItem);
			}



			return ret;
		}


		/**
		 * 通过 技能ID 来判断该技能是否已经学习了
		 * @param skillId
		 * @return
		 *
		 */
		public function hasStudySkill(skillId:int):Boolean
		{
			var _ret:Boolean=false;
			var list:Vector.<StructSkillItem2>=Data.skill.getLearnedSkillList();
			if (list != null)
			{
				for each (var item:StructSkillItem2 in list)
				{
					if (skillId == item.skillId)
					{
						_ret=true;
						break;
					}
				}
			}

			return _ret;
		}

		/**
		 * 通过技能书ID查找对应的技能ID
		 * @param bookID
		 * @return  技能ID
		 *
		 */
		public function checkSkillID(bookID:int):int
		{
			var _skillID:int=0;
			var _ToolsResModel:Pub_ToolsResModel=XmlManager.localres.getToolsXml.getResPath(bookID) as Pub_ToolsResModel;
			_skillID=_ToolsResModel.skill_id;
//			var _Npc_FuncResModel:Pub_Npc_FuncResModel = XmlManager.localres.getNpcFuncXml.getResPath(_ToolsResModel.func_id);
//			if(null != _Npc_FuncResModel)
//			{
//				_skillID  = _Npc_FuncResModel.func_para1;
//			}
			return _skillID;
		}

	}
}





