package ui.base.jineng
{
	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.clock.GameClock;
	import common.utils.component.ToolTip;
	import common.utils.drag.MainDrag;
	
	import engine.event.DispatchEvent;
	import engine.utils.HashMap;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.dataset.*;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import ui.base.jineng.Jineng;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.FileManager;
	import world.WorldEvent;

	public class JiNengMain extends UIWindow
	{
		public const AutoRefreshSecond:int=60;
		private var _curAutoRefresh:int=0;
//		
		private static var m_instance:JiNengMain;

		public static function get instance():JiNengMain
		{
			if (null == m_instance)
			{
				m_instance=new JiNengMain();
			}
			return m_instance;
		}

//		
		public function JiNengMain()
		{
			//blmBtn=3;
			//type=1;
			super(getLink(WindowName.win_ji_neng));
		}

		override protected function init():void
		{
			mc["ShortKey"].visible=false;
			for (var m_i:int=1; m_i <= 12; m_i++)
			{
				mc["ShortKey"]["key" + m_i].mouseChildren=false;
				mc["ShortKey"]["key" + m_i].buttonMode=true;
			}
			_regPc();
			_regDs();
			_regCk();
			this.getData();
			this.refresh();
		}

		private function _regCk():void
		{
			_curAutoRefresh=0;
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, daoJiShi);
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, daoJiShi);
		}

		private function daoJiShi(e:WorldEvent):void
		{
			_curAutoRefresh++;
			if (_curAutoRefresh >= AutoRefreshSecond)
			{
				_curAutoRefresh=0;
				//你的代码
				this.getData();
			}
		}

		private function _regDs():void
		{
			super.sysAddEvent(Data.myKing, MyCharacterSet.SKILL_POINT_UPD, SKILL_POINT_UPD_HAND);
			super.sysAddEvent(Data.skill, SkillSet.LIST_UPD, SkillList_UPD);
			//super.sysAddEvent(Data.myKing, MyCharacterSet.COIN_UPDATE, coinUpdate);
			//super.sysAddEvent(Data.myKing, MyCharacterSet.LEVEL_UPDATE, levelUpdate);
			//sysAddEvent(Data.myKing, MyCharacterSet.EXP2_ADD, exp2Update);
		}

		public function SKILL_POINT_UPD_HAND(e:DispatchEvent):void
		{
			this.refresh();
		}

		public function SkillList_UPD(e:DispatchEvent):void
		{
			this.refresh();
		}
		private var previousClick:Sprite;

		override public function mcHandler(target:Object):void
		{
			var keyNum:int=int(target.name.replace("key", ""));
			if (keyNum > 0 && keyNum < 13)
			{
				Jineng.instance.selectSkill(keyNum, (previousClick["data"] as StructSkillItem2).skill_id);
				mc["ShortKey"].visible=false;
			}
			else
			{
				switch (target.name)
				{
					case "key":
						mc["ShortKey"].x=mc.mouseX + 10;
						mc["ShortKey"].y=mc.mouseY + 10;
						mc["ShortKey"].visible=true;
						previousClick=target.parent as Sprite;
						break;
					case "btnVisible":
						mc["ShortKey"].visible=false;
						break;
					case "btnCancel":
						Jineng.instance.selectSkill(0, (previousClick["data"] as StructSkillItem2).skill_id);
						previousClick["key"]["key"]["gotoAndStop"](0);
						break;
				}
			}
		}

		private function _regPc():void
		{
			uiRegister(PacketSCSkillList.id, SCSkillList);
			uiRegister(PacketSCStudySkill.id, SCStudySkill);
			uiRegister(PacketSCQuerySkillInfo.id, SCQuerySkillInfo);
		}

		private function getData():void
		{
			var skList:Vector.<StructSkillItem2>=Data.skill.getSkillList(0, true);
			//		
			var j:int;
			var jLen:int=skList.length;
			for (j=0; j < jLen; j++)
			{
				var cs:PacketCSQuerySkillInfo=new PacketCSQuerySkillInfo();
				cs.skillid=skList[j].skill_id;
				uiSend(cs);
			}
		}

		public function SCQuerySkillInfo(p:PacketSCQuerySkillInfo2):void
		{
			//nothing
			this.refresh();
		}

		public function SCSkillList(p:PacketSCSkillList2):void
		{
			if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
				}
				else
				{
				}
			}
			this.refresh();
		}

		public function SCStudySkill(p:PacketSCStudySkill2):void
		{
			if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
				}
				else
				{
				}
			}
			this.refresh();
		}
		private var skItemList:Array;

		public function refresh():void
		{
			if (this.mc as MovieClip&&1 == (this.mc as MovieClip).currentFrame)
			{
				for (j=1; j <= 12; j++)
				{
					mc["item_ji_neng" + j.toString()].visible=false;
					mc["item_ji_neng" + j.toString()].gotoAndStop(1);
				}
				//
				var skList:Vector.<StructSkillItem2>=Data.skill.getSkillList(0, true);
				skItemList=new Array();
				var j:int;
				var jLen:int=skList.length;
				for (j=1; j <= 12; j++)
				{
					if (j <= jLen)
					{
						mc["item_ji_neng" + j.toString()].visible=true;
						skItemList.push(mc["item_ji_neng" + j.toString()]);
					}
				}
				skList.sort(viewSort);
				skList.forEach(callbackSkList);
				var firstItem:DisplayObject=this.getChildByName("item_ji_neng" + (0 + 1).toString());
				this.itemSelected(firstItem);
					//this.itemSelectedOther(firstItem);
			}
		}

		public function viewSort(a:Object, b:Object):int
		{
			var a_view_sort_id:int=parseInt(a.skillId);
			var b_view_sort_id:int=parseInt(b.skillId);
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

		private function callbackSkList(itemData:StructSkillItem2, index:int, itemDataList:Vector.<StructSkillItem2>):void
		{
			//			var d:DisplayObject=ItemManager.instance().getitem_ji_neng(itemData.skillId);
			var d:DisplayObject=skItemList[index];
			d["data"]=itemData;

			var o1:*=Data.skillShort.contentList
			var m_keyNum:int=0;
			for (var m_i:String in Data.skillShort.contentList)
			{
				var o:*=Data.skillShort.contentList[m_i]
				if (Data.skillShort.contentList[m_i].id == itemData.skill_id)
				{
					m_keyNum=Data.skillShort.contentList[m_i].pos
					break;
				}
			}
			if (m_keyNum > 12)
			{
				m_keyNum=0;
			}
			d["key"]["key"].gotoAndStop(m_keyNum + 1);
			d["key"]["key"].buttonMode=true;

			d['txt_skill_name'].text=itemData.skill_name;
			d['txt_skill_name'].mouseEnabled=false;
			//			
			var itemSkill:StructSkillItem2=Data.skill.getSkill(itemData.skill_id);
			if (null != itemSkill && itemSkill.hasStudy)
			{
				d['txt_skill_level'].text=itemData.skillLevel.toString(); //itemData.skillLevel + "/" + itemData.skillModel.max_level;
			}
			else
			{
				d['txt_skill_level'].text=Lang.getLabel("800008_JiNengMain");
			}
			if (itemData.isPassive)
			{
				d['txt_skill_level'].text="MAX";
				d["key"].visible=false;
			}
			d['txt_skill_level'].mouseEnabled=false;
			if (itemData.skill_curr_data == null)
			{
				d["bar"].scaleX=0;
				d["txt_jd"].text="0/0";
			}
			else
			{
				d["bar"].scaleX=itemData.skillExp / itemData.skill_curr_data.study_exp;
				if (d["bar"].scaleX < 0)
				{
					d["bar"].scaleX=0;
				}
				else if (d["bar"].scaleX > 1)
				{
					d["bar"].scaleX=1;
				}
				d["txt_jd"].text=itemData.skillExp + "/" + itemData.skill_curr_data.study_exp;
			}
//			d['uil'].source=itemData.icon;
			ImageUtils.replaceImage(d as DisplayObjectContainer,d["uil"],itemData.icon);
			d["key"].mouseChildren=false;
			//			
			//			d['mcSkillTip'].mouseEnabled = false;
			//			
			//			spContent.addChild(d)
			//悬浮信息
			//Lang.addTip(d,'yours_tip');
			//d.tipParam=[,]
			ToolTip.instance().addTip(d);
			//
			if (0 == itemData.skillLevel)
			{
				StringUtils.setUnEnable(d, true);
			}
			else
			{
				StringUtils.setEnable(d);
			}
			if (d["data"] != null)
			{
				//var sd:Object = Data.skill.getSkill(itemData.skill_id);
				//if (sd)
				if (itemSkill)
					MainDrag.getInstance().regDrag(d);
			}
		}

		override protected function windowClose():void
		{
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, daoJiShi);
			super.windowClose();
		}

		override public function get width():Number
		{
			return 627;
		}

		override public function get height():Number
		{
			return 542;
		}

		override public function getID():int
		{
			return 0;
		}
	}
}
