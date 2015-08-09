/**
 * Copyright the company of XiHe, all rights reserved.
 */
package ui.view.skill
{
	import com.engine.utils.HashMap;
	
	import common.config.xmlres.XmlManager;
	import common.utils.CtrlFactory;
	
	import engine.load.GamelibS;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	import netc.packets2.StructSkillItem2;
	
	import ui.base.jineng.SkillShort;
	import ui.frame.ImageUtils;
	import ui.frame.UIWindow;

	/**
	 * @author liuaobo
	 * @create date 2013-8-8
	 */
	public class SkillSelecter extends UIWindow
	{
		private static var _instance:SkillSelecter=null;
		/**
		 * 技能快捷栏数量
		 */
		public static const LIMIT:int=14; //十二个技能，不包含13
		public static const HLIMIT:int=5; //技能选择栏横向个数
		public static const HLIMIT_BIG:int=4; //技能兰横向大图标个数
		public static const OrigH:int=100; //技能选择栏背景初始高度
		public static const BG_STEP:int=42; //技能选择栏背景每增加一行纵向高度增量
		public static const OFFSET_X_UP_SKIIL_SHORT:int=-60; //技能选择框距离技能快捷栏的纵向偏移量
		public static const ITEM_HSPACE:int=4; //-4,1
		public static const ITEM_VSPACE:int=1; //-5
		public static const BG_HSPACE:int=4; //6
		public static const BG_VSPACE:int=4;
		public static const BG_X:int=13; //30,13
		public static const BG_Y:int=36; //46
		public static const ITEM_X:int=13; //17,13
		public static const ITEM_Y:int=38; //50,48

		public static const ITEM_BIG_X:int=14; //大图标X
		public static const ITEM_BIG_Y:int=40; //大图标Y
		public static const ITEM_BIG_HSPACE:int=3; //大图标之间空隙
		public static const BG_BIG_STEP:int=53; //技能选择栏背景每增加一行纵向高度增量
		public static const BG_BIG_Y:int=38; //-40
		public static const ITEM_BIG_WIDTH:int=52;
		public static const ITEM_BIG_HEIGHT:int=52;
		public static const ITEM_WIDTH:int=37;
		public static const ITEM_HEIGHT:int=38;
		//new defines
		public static var replacePos:int=0; //默认为0，表示丢弃，非有效值
		public static var replaceId:int=0; //替换的技能或者物品ID
		public static var replaceType:int=0; //默认为技能
		private static var CanInstallItems:Array=null;
		private static var CanInstallItemsConfig:String=null;
		private static var IsShowAll:Boolean=false; //是否显示技能和道具，默认全选，false代表只显示技能

		private var skillIconCache:Array=[];
		private var skillIconBgCache:Array=[];

		private var itemIconCache:Array=[];
		private var itemIconBgCache:Array=[];

		private var IconRecycle:Array=[];
		private var IconBgRecycle:Array=[];

		private var IconKey:HashMap=new HashMap();

		public static function getInstance():SkillSelecter
		{
			if (_instance == null)
			{
				_instance=new SkillSelecter();
			}
			return _instance;
		}

		public function SkillSelecter()
		{
			blmBtn=0;
			super(getLink("SkillSelecter"));
		}

		override protected function init():void
		{
			super.init();
//			this.renderSkill();
		}

		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var target_name:String=target.name;
		}

		public function chooseSkill(target:Object):void
		{
			var skillIcon:Sprite=null;
			if (target.name == "btnRemove")
			{
				SkillShort.getInstance().uninstall(replacePos, 1);
				return;
			}
			if (target.name!="item_hotKey15"&&target.name!="item_hotKey16"&&target.hasOwnProperty("data")&&target["data"] != null)
			{
				SkillShort.getInstance().installSkill(replacePos, StructSkillItem2(target["data"]).skill_id, 0, 1);
			}
		}


		//是否显示单攻,还是群攻
		public function renderSkill(isMono:Boolean):void
		{
			var skillIcon:Sprite=null;
			var skillIconBg:MovieClip=null;
			var row:int=0; //标签处于第几行
			var skillRow:int=0;
			var itemRow:int=0; //道具位于第几行
			//获取已学技能列表
			var learnedSkillList:Vector.<StructSkillItem2>=Data.skill.getLearnedAutoSkillList();
			var posToFrame:int=1; //根据位置跳转到的帧数
			var fromIndex:int=0;
			var len:int=0;
			var sitem:StructSkillItem2;
			var bitem:StructBagCell2;
			var tempIcon:Sprite;
			var tempIconBg:Sprite;
			len=skillIconCache.length;
			while (fromIndex < len)
			{
				sitem=StructSkillItem2(skillIconCache[fromIndex]["data"]);
				posToFrame=SkillShort.getInstance().getPosById(sitem.skill_id) + 1;
				skillIconCache[fromIndex]["key"].gotoAndStop(posToFrame);
				fromIndex++;
			}

			//============
			len=0;
			//============
			if (learnedSkillList.length > len)
			{
				//添加新的技能
				fromIndex=skillIconCache.length;
				len=learnedSkillList.length;
				//========
				fromIndex=0;
				while (mc.numChildren)
				{
					mc.removeChildAt(0);
				}
				var m_curIndex:int=0;
				//========
				while (fromIndex < len)
				{
					sitem=learnedSkillList[fromIndex];
					if (sitem.skill_isMono == isMono && sitem.skill_isAtk)
					{
					}
					else
					{
						fromIndex++;
						continue;
					}
					if (skillIconCache.length > m_curIndex)
					{
						skillIcon=skillIconCache[m_curIndex];
						skillIconBg=skillIconBgCache[m_curIndex];
					}
					else
					{
						skillIcon=GamelibS.getswflink("game_index", "SkillIconBigL") as Sprite;
						skillIconBg=GamelibS.getswflink("game_index", "SkillIconBgBigL") as MovieClip;
					}
					skillIcon.mouseChildren=false;
					skillIconBg.mouseChildren=skillIconBg.mouseEnabled=false;
					posToFrame=SkillShort.getInstance().getPosById(sitem.skill_id) + 1;
					skillIcon["key"].gotoAndStop(posToFrame);
					skillIcon.name="skill_SkillShort_" + m_curIndex;
					//					skillIcon["lengque"].visible = false;
//					skillIcon["uil"].source=sitem.icon;
					ImageUtils.replaceImage(skillIcon,skillIcon["uil"],sitem.iconX);
					skillIcon["data"]=sitem;

					CtrlFactory.getUIShow().addTip(skillIcon);
					mc.addChild(skillIconBg);
					mc.addChild(skillIcon);

					if (m_curIndex % HLIMIT_BIG == 0)
					{ //X坐标从头开始，换行
						//						skillIcon.x = ITEM_X;
						//						skillIconBg.x = BG_X;
						skillIcon.x=ITEM_BIG_X;
						skillIconBg.x=BG_X;
						row=int(m_curIndex / HLIMIT_BIG); //当前处于第几行
						if (row == 0)
						{
							skillIcon.y=ITEM_BIG_Y;
							skillIconBg.y=BG_BIG_Y;
						}
						else if (skillIconCache.length > m_curIndex - 1)
						{
							skillIcon.y=skillIconCache[m_curIndex - 1].y + ITEM_BIG_HEIGHT + ITEM_VSPACE;
							//							skillIconBg.y = skillIconBgCache[fromIndex-1].y + skillIconBgCache[fromIndex-1].height + BG_VSPACE;
							skillIconBg.y=skillIcon.y - 2;
						}
					}
					else if (skillIconCache.length > m_curIndex - 1)
					{ //同行
						skillIcon.x=skillIconCache[m_curIndex - 1].x + ITEM_BIG_HEIGHT + ITEM_BIG_HSPACE;
						//						skillIconBg.x = skillIconBgCache[fromIndex-1].x + ITEM_BIG_WIDTH + BG_HSPACE;
						skillIconBg.x=skillIcon.x - 1;
						skillIcon.y=skillIconCache[m_curIndex - 1].y;
						skillIconBg.y=skillIcon.y - 2;
					}
					skillIconCache.push(skillIcon);
					skillIconBgCache.push(skillIconBg);
					//TODO 添加监听事件

					m_curIndex++;

					fromIndex++;
				}
			}
			skillRow=skillIconCache.length == 0 ? 0 : int((skillIconCache.length - 1) / HLIMIT_BIG) + 1;

			if (IsShowAll)
			{
				if (CanInstallItemsConfig == null)
				{
					CanInstallItemsConfig=XmlManager.localres.ConfigXml.getResPath(105)["contents"]; //技能栏装配界面显示的道具
				}

				var canInstallItemList:Vector.<StructBagCell2>=Data.beiBao.getItemsForSkillShort(CanInstallItemsConfig);

				fromIndex=0;
				len=canInstallItemList.length;
				while (fromIndex < len)
				{
					skillIcon=this.itemIconCache[fromIndex];
					skillIconBg=this.itemIconBgCache[fromIndex];
					if (skillIcon == null)
					{
						if (this.IconRecycle.length > 0)
						{
							skillIcon=this.IconRecycle.shift();
							skillIconBg=this.IconBgRecycle.shift();
						}
						else
						{
							skillIcon=GamelibS.getswflink("game_index", "SkillIconSmallL") as Sprite;
							skillIconBg=GamelibS.getswflink("game_index", "SkillIconBgSmallL") as MovieClip;
							skillIcon.mouseChildren=false;
							skillIconBg.mouseChildren=skillIconBg.mouseEnabled=false;
								//						skillIcon["lengque"].visible = false;
						}
						if (skillIcon["data"].skill_isMono == isMono)
						{
							CtrlFactory.getUIShow().addTip(skillIcon);
							mc.addChild(skillIconBg);
							mc.addChild(skillIcon);
							this.itemIconCache.push(skillIcon);
							this.itemIconBgCache.push(skillIconBg);
						}
					}
					bitem=canInstallItemList[fromIndex];
					posToFrame=SkillShort.getInstance().getPosById(bitem.itemid) + 1;
					skillIcon["key"].gotoAndStop(posToFrame);
					skillIcon.name="item_SkillShort_" + fromIndex;
//					skillIcon["uil"].source=bitem.icon;
					ImageUtils.replaceImage(skillIcon,skillIcon["uil"],bitem.iconBig);
					skillIcon["data"]=bitem;

					if (fromIndex % HLIMIT == 0)
					{ //X坐标从头开始，换行
						skillIcon.x=ITEM_BIG_X;
						skillIconBg.x=BG_X;
						row=int(fromIndex / HLIMIT); //当前处于第几行

						if (row == 0)
						{
							if (skillRow == 0)
							{
								skillIcon.y=ITEM_BIG_Y;
								skillIconBg.y=BG_BIG_Y;
							}
							else
							{
								var tempIndex:int=skillIconCache.length - 1;
								skillIcon.y=skillIconCache[tempIndex].y + ITEM_BIG_HEIGHT + BG_VSPACE - 1;
								skillIconBg.y=skillIcon.y - 2;
							}
						}
						else
						{
							skillIcon.y=itemIconCache[fromIndex - 1].y + ITEM_HEIGHT + BG_VSPACE - 1;
							skillIconBg.y=itemIconBgCache[fromIndex - 1].y + itemIconBgCache[fromIndex - 1].height + BG_VSPACE;
						}
					}
					else
					{ //同行
						skillIcon.x=itemIconCache[fromIndex - 1].x + ITEM_WIDTH + ITEM_HSPACE;
						//					skillIconBg.x = itemIconBgCache[fromIndex-1].x + itemIconBgCache[fromIndex-1].width + BG_HSPACE;
						skillIconBg.x=skillIcon.x - 1;
						skillIcon.y=itemIconCache[fromIndex - 1].y;
						skillIconBg.y=itemIconBgCache[fromIndex - 1].y;
					}
					fromIndex++;
				}

				if (len < this.itemIconCache.length)
				{ //执行删除
					fromIndex=len;
					len=this.itemIconCache.length;
					while (fromIndex < len)
					{
						skillIcon=this.itemIconCache.pop();
						skillIconBg=this.itemIconBgCache.pop();
						mc.removeChild(skillIcon);
						mc.removeChild(skillIconBg);
						CtrlFactory.getUIShow().removeTip(skillIcon);
						this.IconRecycle.push(skillIcon);
						this.IconBgRecycle.push(skillIconBg);
						fromIndex++;
					}
				}

				skillIcon=null;
				skillIconBg=null;

				itemRow=itemIconCache.length == 0 ? 0 : int((itemIconCache.length - 1) / HLIMIT) + 1;
			}

			if (itemRow == 0)
				itemRow=1;
//			mc["back"].height = OrigH + skillRow*BG_BIG_STEP + (itemRow - 1)*BG_STEP;
			var px:int;
			var py:int;
//			if (IsShowAll){
			px=stage.mouseX;
			py=stage.mouseY;
			this.x=px - (this.width >> 1);
			this.y=py - this.height - 50;
//			}

			mc["back"].height=OrigH + skillRow * BG_BIG_STEP + (itemRow - 1) * BG_STEP;
//			mc["skillSelecter"].y = mc["mc_hotKey"].y - mc["skillSelecter"].height + OFFSET_X_UP_SKIIL_SHORT;
//			mc.visible = true;
			this.updateSkillIconSelected();
		}

		public override function winClose():void
		{
			super.winClose();
		}

		/**
		 * 更新要被替换的技能或者道具选中状态
		 *
		 */
		private function updateSkillIconSelected():void
		{
			if (replacePos == -1)
				return;
			var skillIcon:Sprite;
			for each (skillIcon in this.skillIconCache)
			{
				if (skillIcon["data"] != null)
				{
					if (replaceType == 0)
					{
						if (StructSkillItem2(skillIcon["data"]).skill_id == replaceId)
						{
							skillIcon["mc_selected"].gotoAndStop(2);
						}
						else
						{
							skillIcon["mc_selected"].gotoAndStop(1);
						}
					}
					else
					{
						skillIcon["mc_selected"].gotoAndStop(1);
					}
				}
			}
			for each (skillIcon in this.itemIconCache)
			{
				if (skillIcon["data"] != null)
				{
					if (replaceType == 1)
					{
						if (StructBagCell2(skillIcon["data"]).itemid == replaceId)
						{
							skillIcon["mc_selected"].gotoAndStop(2);
						}
						else
						{
							skillIcon["mc_selected"].gotoAndStop(1);
						}
					}
					else
					{
						skillIcon["mc_selected"].gotoAndStop(1);
					}
				}
			}
		}
	}
}
