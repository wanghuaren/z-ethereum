package scene.kingname
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_NpcResModel;
	import common.managers.Lang;
	import common.utils.StringUtils;
	import common.utils.bit.BitUtil;
	import common.utils.clock.GameClock;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.*;
	
	import model.qq.YellowDiamond;
	
	import netc.Data;
	
	import sample.Astar.Fabort;
	
	import scene.action.Action;
	import scene.event.KingActionEnum;
	import scene.king.King;
	import scene.king.Skin;
	import scene.manager.SceneManager;
	import scene.skill2.WaftNumType;
	
	import ui.view.view2.other.XuanShangDuiHuan;
	
	import world.WorldEvent;
	import world.WorldFactory;
	import world.type.BeingType;
	import world.type.ItemType;

//fux sprite更轻量
	public class KingHeadName extends Sprite
	{
		public function get _kingName():String
		{
			//return "哇卡呀";
			if (null != this.king)
			{
				return this.king.getKingName;
			}
			return "";
		}
		private var _boothName:String;

		/**
				 * 所属主人
				 */
		//private var _kingMasterName:String;
		public function get _kingMasterName():String
		{
			if (null != this.king)
			{
				return this.king.masterName;
			}
			return "";
		}
		private var _kingNameColor:String;
		/**
				 *
				 */
		private var _headPartList:Array;
		private var _$qqyellowvip:int;

		public function KingHeadName():void
		{
		}

		public function init():void
		{
			this.mouseChildren=this.mouseEnabled=false;
			this.cacheAsBitmap=true;
			kname_htmlText="";
			_boothName="";
			_$qqyellowvip=0;
			_kingNameColor="#fff5d2";
			if (null != TxtName)
				this.kname.htmlText="";
			if (null != TxtName)
				this.knameVipVip.gotoAndStop(1);
			_kissTimeRun=false;
			_kissTimeCount=0;
			m_nCurrHp=-1;
			this.addEventListener(Event.REMOVED_FROM_STAGE, WorldFactory.HEAD_NAME_REMOVED_FROM_STAGE);
		}

		public function set setLoadPress(num:int):void
		{
			if (null == this.king)
			{
				return;
			}
			var waitStr:String="";
//test
			//num = 50;
			if (num == 0)
			{
				//waitStr="<font color='#FFFFFF'>" + Lang.getLabel("30003_loadPress") + "</font>";
				refreshKname("", waitStr);
//setLoadingState(true);
			}
			else if (num <= 99)
			{
				//waitStr="<font color='#FFFFFF'>" + Lang.getLabel("30003_loadPress") + "(" + num + "%)</font>";
//waitStr="<font color='#FFFFFF'>" + Lang.getLabel("30003_loadPress") + "</font>";
				refreshKname("", waitStr);
//setLoadingState(true);
			}
			else
			{
				refreshKname();
//setLoadingState(false);
				this.king.getSkin().UpdOtherColor();
			}
		}

		private function refreshKname_Sub_VipVip():void
		{
			var vipType:int=this.kingVipVip; //Data.myKing.VipVip;
			var vipTestType:int; // = Data.myKing.TestVIP;
			if (0 == vipType && 0 == vipTestType)
			{
				vipType=5;
			}
			else if (0 == vipType && 0 != vipTestType)
			{
				vipType=4;
			}
			if (5 == vipType)
			{
				if (1 != knameVipVip.currentFrame)
				{
					this.knameVipVip.gotoAndStop(1);
				}
			}
			else if (4 == vipType)
			{
				if (3 != knameVipVip.currentFrame)
				{
					this.knameVipVip.gotoAndStop(3);
				}
			}
			else if (0 == vipType)
			{
				if (1 != knameVipVip.currentFrame)
				{
					this.knameVipVip.gotoAndStop(1);
				}
			}
			else if (vipType > 0 && vipType < 4)
			{
				if ((vipType + 1) != knameVipVip.currentFrame)
				{
					this.knameVipVip.gotoAndStop(vipType + 1);
				}
			}
			else
			{
				if (1 != knameVipVip.currentFrame)
				{
					this.knameVipVip.gotoAndStop(1);
				}
			}
//pos
			if (this.kname.textHeight > 35)
			{
				this.knameVipVip.y=-20; //-20;
			}
			else if (this.kname.textHeight > 25)
			{
				this.knameVipVip.y=-20; //-20;
			}
			else
			{
				this.knameVipVip.y=-24;
			}
		}
		/**
				 * 前缀和后缀
				 * 调用本函数后要刷新颜色
				 */
		private var kname_htmlText:String;

		public function refreshKname(frontStr:String="", endStr:String=""):void
		{
			var kname_htmlText_2:String=frontStr + this.kingName + endStr;
			if (kname_htmlText != kname_htmlText_2)
			{
				kname.htmlText=kname_htmlText=kname_htmlText_2;
				if (kname.textHeight < 20)
				{
					kname.y=kname.textHeight * -1 + 2;
				}
				else
				{
					kname.y=kname.textHeight * -1;
				}
			}
			refreshKname_Sub_VipVip();
		}

		private function setLoadingState(value:Boolean=true):void
		{
			//check
			if (null == this.king)
			{
				return;
			}
			var index:int=KingNameParam.LoadingHeadIndex;
			if (value)
			{
				LoadingHeadState.gotoAndStop(2);
				if (!this.contains(this.headPartList[index]))
				{
					this.addChild(this.headPartList[index]);
				}
			}
			if (!value)
			{
				if (hasLoadingHead())
				{
					LoadingHeadState.gotoAndStop(1);
					if (this.contains(this.headPartList[index]))
					{
						this.removeChild(this.headPartList[index]);
					}
				}
			}
		}

		private function showTxtName(isMouseOver:Boolean=false):void
		{
			//check
			if (null == this.king)
			{
				return;
			}
			var k:King=this.king;
//没被鼠标点击过
			//没被鼠标划过
			//alwaysShowHumanAndPetName为false时不包括本人
			var alwaysShowHumanAndPetName:Boolean=Action.instance.sysConfig.alwaysShowHumanAndPetName;
			var alwaysShowMonName:Boolean=Action.instance.sysConfig.alwaysShowMonName;
			if (k.name2.indexOf(BeingType.HUMAN) >= 0 && !alwaysShowHumanAndPetName && k.isMe && !k.inCombat)
			{
				return;
			}
			else if (k.name2.indexOf(BeingType.HUMAN) >= 0 && !alwaysShowHumanAndPetName && !k.isMe && !isMouseOver)
			{
				return;
			}
			else if (k.name2.indexOf(BeingType.PET) >= 0 && !alwaysShowHumanAndPetName && k.isMePet && !Data.myKing.InCombat)
			{
				return;
			}
			else if (k.name2.indexOf(BeingType.PET) >= 0 && !alwaysShowHumanAndPetName && !k.isMePet && !k.mouseClicked && !isMouseOver)
			{
				return;
			}
			else if (k.name2.indexOf(BeingType.MON) >= 0 && !k.qiangZhi_show_name)
			{
				if (!k.mouseClicked && !isMouseOver && !alwaysShowMonName && !k.isMeMon)
				{
					return;
				}
			}
			else if (k.name2.indexOf(BeingType.SKILL) >= 0)
			{
				return;
			}
			else if (k.name2.indexOf(ItemType.PICK) >= 0 && !k.getByPick().picking)
			{
				return;
			}
			refreshKname();
			//this.setKingNameColor = this.KingNameColor;
			var index:int=KingNameParam.TxtNameHeadIndex;
			if (!this.contains(this.headPartList[index]))
			{
				this.addChild(this.headPartList[index]);
			}
			this.headPartList[index].visible=true;
			//0表示和平模式，1表示阵营模式 2 家族模式
			if (k.pk > 0)
			{
				setPk(true, k.pk.toString());
			}
			if(Action.instance.sysConfig.alwaysHideChengHao==false)
				k.refreshTitle();
			if (k.vip > 0)
			{
				//this.setVip(true, k.vip);
			}
			YellowDiamond.getInstance().handleYellowDiamondMC2(this.yellowVip, this._$qqyellowvip);
			if (null != this.yellowVip && this.yellowVip.visible)
			{
				this.setYellowVip(true);
			}
			k.getSkin().UpdOtherColor();
		}

		private function showBloodBar(isMouseOver:Boolean=false):void
		{
			//check
			if (null == this.king)
			{
				return;
			}
			var k:King=this.king;
			if (k.isMe)
			{
				//战斗状态中才可以显
				if (!k.inCombat)
				{
					return;
				}
				return;
			}
			else if (k.isMePet)
			{
				if (0 == Data.myKing.InCombat)
				{
					return;
				}
			}
			else if (k.isMeMon)
			{
				if (0 == Data.myKing.InCombat)
				{
					return;
				}
			}
			else if (k.name2.indexOf(BeingType.NPC) >= 0)
			{
				//NPC无血条显示
				return;
			}
			else if (k.name2.indexOf(BeingType.MON) >= 0 && 0 == Data.myKing.hp)
			{
				//主角死亡后，怪物不显示血条
				return;
			}
			else if (k.name2.indexOf(BeingType.MON) >= 0 && 0 == this.king.hp)
			{
				return;
			}
			else if (k.name2.indexOf(BeingType.PET) >= 0 && !k.mouseClicked && !isMouseOver && !Action.instance.sysConfig.alwaysShowHumanAndPetName)
			{
				//没被鼠标点击过
				//没被鼠标划过
				return;
			}
			else if (k.name2.indexOf(BeingType.MON) >= 0 && !k.mouseClicked && !isMouseOver && !Action.instance.sysConfig.alwaysShowMonName && !k.hasBeAttacked && !k.qiangZhi_show_name)
			{
				//没被鼠标点击过
				//没被鼠标划过
				return;
			}
			else if (k.name2.indexOf(BeingType.HUMAN) >= 0 && !k.mouseClicked && !isMouseOver && !k.isMe)
			{
				//没被鼠标点击过
				//没被鼠标划过
				return;
			}
			else if (k.name2.indexOf(BeingType.RES) >= 0)
			{
				//资源无血条显示
				return;
			}
			else if (k.name2.indexOf(ItemType.PICK) >= 0)
			{
				//采集无血条显示
				return;
			}
			else if (k.name2.indexOf(BeingType.TRANS) >= 0)
			{
				//传送点无血条显示
				return;
			}
			else if (k.name2.indexOf(BeingType.SKILL) >= 0)
			{
				return;
			}
//火凤燎原符 skill强制没有
			if (k.name2.indexOf(BeingType.SKILL) >= 0 && null != k.getSkin().filePath)
			{
				if (k.getSkin().filePath.s2 == 30700003)
				{
					return;
				}
			}
			if (k.name2.indexOf(BeingType.SKILL) >= 0)
			{
				return;
			}
			BloodBar;
			var index:int=KingNameParam.BloodHeadIndex;
			if (!this.contains(this.headPartList[index]))
			{
				this.refreshBloodBar("initBloodBar");
				this.addChild(this.headPartList[index]);
			}
		}

		public function showTxtNameAndBloodBar(isMouseOver:Boolean=false):void
		{
			showTxtName(isMouseOver);
			showBloodBar(isMouseOver);
		}

		private function hideTxtName():void
		{
			//check
			if (null == this.king)
			{
				return;
			}
//本人名字一直显示
			//本人伙伴名字一直显示
			var k:King=this.king;
			var alwaysShowHumanAndPetName:Boolean=Action.instance.sysConfig.alwaysShowHumanAndPetName;
			var alwaysShowMonName:Boolean=Action.instance.sysConfig.alwaysShowMonName;
			if (k.name2.indexOf(BeingType.HUMAN) >= 0 && alwaysShowHumanAndPetName)
			{
				return;
			}
			else if (k.name2.indexOf(BeingType.MON) >= 0 && alwaysShowMonName)
			{
				return;
			}
			else if (k.isMe && !alwaysShowHumanAndPetName && k.inCombat)
			{
				return;
			}
			else if (k.isMePet && alwaysShowHumanAndPetName)
			{
				return;
			}
			else if (k.name2.indexOf(BeingType.PET) >= 0 && alwaysShowHumanAndPetName)
			{
				return;
			}
			else if (k.name2.indexOf(BeingType.MON) >= 0 && k.qiangZhi_show_name)
			{
				return;
			}
			else if (k.name2.indexOf(BeingType.MON) >= 0 && alwaysShowMonName)
			{
				return;
			}
			else if (k.mouseClicked)
			{
				//没被鼠标点击过
				return;
			}
			else if (k.name2.indexOf(BeingType.NPC) >= 0)
			{
				//npc始终显示
				return;
			}
			else if (k.name2.indexOf(BeingType.TRANS) >= 0)
			{
				//传送点始终显示
				return;
			}
			else if (k.name2.indexOf(ItemType.PICK) >= 0 && k.getByPick().picking)
			{
				//采集始终显示
				return;
			}
			else if (k.name2.indexOf(BeingType.FAKE_HUM) >= 0)
			{
				//假人始终显示				
				return;
			}
			var index:int=KingNameParam.TxtNameHeadIndex;
			if (this.headPartList[index])
				this.headPartList[index].visible=false;
//0表示和平模式，1表示阵营模式
			setPk(false);
			//this.setVip(false, k.vip);
			this.setYellowVip(false);
			setChengHao=[];
			k.getSkin().UpdOtherColor();
		}

		private function hideBloodBar():void
		{
			//check
			if (null == this.king)
			{
				return;
			}
			var k:King=this.king;
			if (k.isMe)
			{
				//战斗中要显示
				if (k.inCombat)
				{
					return;
				}
			}
			else if (k.isMePet)
			{
				if (1 == Data.myKing.InCombat)
				{
					return;
				}
			}
			else if (k.name2.indexOf(BeingType.PET) >= 0 && Action.instance.sysConfig.alwaysShowHumanAndPetName)
			{
				return;
			}
			else if (k.name2.indexOf(BeingType.MON) >= 0 && k.qiangZhi_show_name)
			{
				return;
			}
			else if (k.name2.indexOf(BeingType.MON) >= 0 && Action.instance.sysConfig.alwaysShowMonName)
			{
				return;
			}
			else if (k.name2.indexOf(BeingType.MON) >= 0 && k.mouseClicked && 0 != k.hp && 0 != Data.myKing.hp)
			{
				return;
			}
			else if (k.name2.indexOf(BeingType.MON) == -1 && k.mouseClicked)
			{
				//没被鼠标点击过
				return;
			}
//NPC无血条显示
			/*if(this.king.name2.indexOf(BeingType.NPC) >= 0)
			{
				return;
			}*/
			BloodBar;
			var index:int=KingNameParam.BloodHeadIndex;
			if (this.contains(this.headPartList[index]))
			{
				this.removeChild(this.headPartList[index]);
			}
		}

		public function setVisiblePartList(value:Boolean):void
		{
			for (var m_index:String in headPartList)
			{
				if (headPartList[m_index] as KingChengHaoHead != null)
				{
					headPartList[m_index].visible=value;
					break;
				}
			}
		}

		public function hideTxtNameAndBloodBar(isMouseOut:Boolean=false):void
		{
			hideTxtName();
			hideBloodBar();
		}

		/*public function hideTxtNameAndBloodBar():void
				{
					//check
					if(null == this.king)
					{
						return;
					}
		if(this.king.isMe)
					{
						//脱离战斗才不显
						if(king.inCombat)
						{
							return;
						}
		}
		//没被鼠标点击过
					if(this.king.mouseClicked)
					{
						return;
					}
		//npc始终显示
					if(this.king.name2.indexOf(BeingType.NPC) >= 0)
					{
						return;
					}
					TxtName;
					var index:int = KingNameParam.TxtNameHeadIndex;
		if(this.contains(this.headPartList[index]))
					{
						this.removeChild(this.headPartList[index]);
					}
					BloodBar;
		index = KingNameParam.BloodHeadIndex;
		if(this.contains(this.headPartList[index]))
					{
						this.removeChild(this.headPartList[index]);
					}
				}*/
		public function setBuffByZT(oldValue:int, currValue:int, KP:King):void
		{
//			if (1 == BitUtil.convertToBinaryArr(old)[16] && 0 == BitUtil.convertToBinaryArr(curr)[16])
			if (1 == oldValue && 0 == currValue)
			{
				KP.setKingAction(KingActionEnum.JN_To_DJ);
			}
		}

		public function setBuff(old:int, curr:int):void
		{
			var KP:King=this.king;
			if (null == KP)
			{
				return;
			}
			var i:int;
			var len:int;
//二进制
			var oldList:Array=BitUtil.convertToBinaryArr(old);
			var currList:Array=BitUtil.convertToBinaryArr(curr);
//---------------------------------
			setBuffByZT(oldList[16], currList[16], KP);
			//---------------------------------------
			len=currList.length;
			var none:Boolean=true;
			var old_tmp:int;
			var curr_tmp:int;
			for (i=0; i < len; i++)
			{
				//curr = parseInt(currList.substr(i,1));	
				curr_tmp=currList[i];
				if (0 != curr_tmp)
				{
					none=false;
					break;
				}
			}
//---------------------------------------------------
			if (none)
			{
				if (KP != null)
				{
					if (null != KingBuff)
					{
						KingBuff.gotoAndStop(1);
					}
					//魂效果				
					//Action.instance.soul.BuffUpdate(KP.objid, false);
					Action.instance.virus.BuffUpdate(KP.objid, false, KP);
					Action.instance.sword.BuffUpdate(KP.objid, false, KP);
					Action.instance.yuJianFly.BuffUpdate(KP.objid, false, KP);
					Action.instance.yuBoat.BuffUpdate(KP.objid, false, KP);
					Action.instance.sudu.BuffUpdate(KP.objid, false, KP);
					Action.instance.boss2Effect.BuffUpdate(KP.objid, false, KP);
					Action.instance.boss3Effect.BuffUpdate(KP.objid, false, KP);
					Action.instance.boss4Effect.BuffUpdate(KP.objid, false, KP);
					Action.instance.boss41Effect.BuffUpdate(KP.objid, false, KP);
					Action.instance.pk_ranshao.BuffUpdate(KP.objid, false, KP);
					Action.instance.wudi.BuffUpdate(KP.objid, false, KP);
					Action.instance.sneak.BuffUpdate(KP.objid, false, KP);
					Action.instance.defense_attr.BuffUpdate(KP.objid, false, KP);
					Action.instance.poison.BuffUpdate(KP.objid, false, KP);
					Action.instance.vertigo.BuffUpdate(KP.objid, false, KP);
				}
				return;
			}
			var hasSoul:Boolean=false;
			var hasVirus:Boolean=false;
			var hasSword:Boolean=false;
			var hasYJFSword:Boolean=false;
			var hasYUBoat:Boolean=false;
			var hasJiaSu:Boolean=false;
			var hasPkRanShao:Boolean=false;
			var hasWudi:Boolean=false;
			var hasDefenseAttr:Boolean=false;
			var hasSneak:Boolean=false;
			var hasPoison:Boolean=false;
			var hasVertigo:Boolean=false;
//			0017544: BUFF效果表增加新的身体展示效果 
//			描述 
//			18 家族BOSS2减伤效果 boss2_effect 身体
//			19 头顶效果
//			20 家族BOSS3脚下火焰 boss3_effect 脚下
//			21 家族BOSS4吸蓝光环 boss4_effect 脚下
//			22 家族BOSS4减少防御光环 boss4_effect1 脚下
//			GM命令：
//			@gm-debug@execcall@21@1@13801@0@
//			@gm-debug@execcall@21@1@13832@0@
//			@gm-debug@execcall@21@1@13820@0@
//			@gm-debug@execcall@21@1@13830@0@
//			@gm-debug@execcall@21@1@13831@0@ 
			var hasBoss2Effect:Boolean=false;
			//var has19:Boolean=false;
			var hasBoss3Effect:Boolean=false;
			var hasBoss4Effect:Boolean=false;
			var hasBoss41Effect:Boolean=false;
//魂
			//if("1" == currList.substr(24,1))
			if (1 == currList[32 - 1 - 24])
			{
				hasSoul=true;
			}
//if("1" == currList.substr(12,1))
			if (1 == currList[32 - 1 - 12])
			{
				hasVirus=true;
			}
//if("1" == currList.substr(0,1))
			//if("1" == currList[32-1-0])
			if (1 == currList[22])
			{
				hasSword=true;
			}
			if (1 == currList[15])
			{
				hasJiaSu=true;
			}
//if (1 == currList[23])
			if (1 == currList[10])
			{
				hasYJFSword=true;
			}
//if (1 == currList[10])
			if (1 == currList[9])
			{
				hasYUBoat=true;
			}
			if (1 == currList[17])
			{
				hasBoss2Effect=true;
			}
			if (1 == currList[18])
			{
			}
			if (1 == currList[19])
			{
				hasBoss3Effect=true;
			}
			if (1 == currList[20])
			{
				hasBoss4Effect=true;
			}
			if (1 == currList[21])
			{
				hasBoss41Effect=true;
			}
			if (1 == currList[23])
			{
				hasPkRanShao=true;
			}
			if (1 == currList[24])
			{
				//职业 3 战士 4法师 1 道士 6 刺客
				hasWudi=true;
				if (king && king.metier != 4) //非法师，不显示护盾效果
					hasWudi=false;
			}
			if (currList[26] == 1)
			{
				hasDefenseAttr=true;
			}
			if (currList[28] == 1)
			{
				hasPoison=true;
			}
			if (currList[1] == 1)
			{
				hasVertigo=true;
			}
			if (1 == currList[0])
			{
				hasSneak=true;
			}
//----------------------------------------
			var freshShow:int;
			for (i=0; i < len; i++)
			{
				//old = parseInt(oldList.substr(i,1));				
				//curr = parseInt(currList.substr(i,1));
				old=oldList[i];
				curr=currList[i];
//change
				if (1 == curr)
				{
					freshShow=i + 1; //len - i;
					if (0 == old && 1 == curr)
					{
						break;
					}
				}
			} //end for
//test
			//KingBuff.gotoAndStop(2);
			if (!isNeedFresh(freshShow))
			{
				//freshShow++;				
//强制判断
				if (1 == currList[24])
				{
					//24的优先级最高，它是一个倒数数字动画，它在时，不要切换到其它BUFF
					freshShow=26;
				}
				if (null != KingBuff)
				{
					KingBuff.gotoAndStop(freshShow);
				}
				else
				{
					this.KBH.is_v_null_use_this_gotoAndStop(freshShow);
				}
			}
//魂效果
			//Action.instance.soul.BuffUpdate(KP.objid, hasSoul,KP);
			Action.instance.virus.BuffUpdate(KP.objid, hasVirus, KP);
			Action.instance.sword.BuffUpdate(KP.objid, hasSword, KP);
			//Action.instance.yuJianFly.BuffUpdate(KP.objid, hasYJFSword,KP);
			Action.instance.yuBoat.BuffUpdate(KP.objid, hasYUBoat, KP);
			Action.instance.sudu.BuffUpdate(KP.objid, hasJiaSu, KP);
			Action.instance.boss2Effect.BuffUpdate(KP.objid, hasBoss2Effect, KP);
			Action.instance.boss3Effect.BuffUpdate(KP.objid, hasBoss3Effect, KP);
			Action.instance.boss4Effect.BuffUpdate(KP.objid, hasBoss4Effect, KP);
			Action.instance.boss41Effect.BuffUpdate(KP.objid, hasBoss41Effect, KP);
			Action.instance.pk_ranshao.BuffUpdate(KP.objid, hasPkRanShao, KP);
			Action.instance.wudi.BuffUpdate(KP.objid, hasWudi, KP);
			Action.instance.sneak.BuffUpdate(KP.objid, hasSneak, KP);
			Action.instance.defense_attr.BuffUpdate(KP.objid, hasDefenseAttr, KP);
			Action.instance.poison.BuffUpdate(KP.objid, hasPoison, KP);
			Action.instance.vertigo.BuffUpdate(KP.objid, hasVertigo, KP);
		}

		public function hasBuff(buffId:int):Boolean
		{
			var flag:int=BitUtil.getBitByPos(king.buff, buffId);
			return flag == 1;
		}

		/**
				 * 不是头上的BUFF图标
				 */
		public function isNeedFresh(show:int):Boolean
		{
			if (12 == show || 24 == show || 32 == show)
			{
				return true;
			}
			return false;
		}

		public function removeAll():void
		{
			_kissTimeRun=false;
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, kissTimeHandler);
			var len:int=headPartList.length;
			for (var i:int=0; i < len; i++)
			{
				headPartList[i]=null;
			}
			while (this.numChildren > 0)
			{
				this.removeChildAt(0);
			}
		}

//get
		public function get kname():TextField
		{
			return TxtName["Kname"];
		}

		public function get knameVipVip():MovieClip
		{
			return TxtName["KnameVipVip"];
		}

		public function get TxtName():MovieClip
		{
			var index:int=KingNameParam.TxtNameHeadIndex;
			if (null == this.headPartList[index])
			{
				this.headPartList[index]=WorldFactory.createKingTxtNameHead();
				this.headPartList[index].x=KingNameParam.TxtNameHeadPoint.x;
				this.headPartList[index].y=KingNameParam.TxtNameHeadPoint.y;
					//this.addChild(this.headPartList[index]);
			}
			return (this.headPartList[index] as KingTxtNameHead).v;
//return _txtName;
		}

//index 0
		public function get GongNengHeadState():MovieClip
		{
			var index:int=KingNameParam.GongNengHeadIndex;
			if (null == this.headPartList[index])
			{
//				(TxtName["Kname"].textWidth-headPartList[index].width)/2
				this.headPartList[index]=WorldFactory.createKingGongNengHead();
				this.headPartList[index].x=KingNameParam.GongNengHeadPoint.x;
				this.headPartList[index].y=KingNameParam.GongNengHeadPoint.y;
				this.addChild(this.headPartList[index]);
			}
			return (this.headPartList[index] as KingGongNengHead).v;
			//return txtName["GongNengHeadState"];
		}

		//inded 1
		public function get autoPath():MovieClip
		{
			var index:int=KingNameParam.AutoPathHeadIndex;
			if (null == this.headPartList[index])
			{
				this.headPartList[index]=WorldFactory.createKingAutoPathHead();
				this.headPartList[index].x=KingNameParam.AutoPathHeadPoint.x;
				this.headPartList[index].y=KingNameParam.AutoPathHeadPoint.y;
				this.addChild(this.headPartList[index]);
			}
			if (this.TxtName.height > 18)
			{
				this.headPartList[index].y=KingNameParam.AutoPathHeadPoint.y - this.TxtName.height / 2;
			}
			return (this.headPartList[index] as KingAutoPathHead).v;
			//return txtName["AutoPath"];
		}

		//index 2
		public function get autoFight():MovieClip
		{
			var index:int=KingNameParam.AutoFightHeadIndex
			if (null == this.headPartList[index])
			{
				this.headPartList[index]=WorldFactory.createKingAutoFightHead();
				this.headPartList[index].x=KingNameParam.AutoFightHeadPoint.x;
				this.headPartList[index].y=KingNameParam.AutoFightHeadPoint.y;
				this.addChild(this.headPartList[index]);
			}
			if (this.TxtName.height > 18)
			{
				this.headPartList[index].y=KingNameParam.AutoFightHeadPoint.y - this.TxtName.height / 2;
			}
			return (this.headPartList[index] as KingAutoFightHead).v;
			//return txtName["AutoPath"];
		}

//index 3
		public function get teamflag():MovieClip
		{
			var index:int=KingNameParam.TeamFlagHeadIndex;
			if (null == this.headPartList[index])
			{
				this.headPartList[index]=WorldFactory.createKingTeamFlagHead();
				this.headPartList[index].x=KingNameParam.TeamFlagHeadPoint.x;
				this.headPartList[index].y=KingNameParam.TeamFlagHeadPoint.y;
				this.addChild(this.headPartList[index]);
			}
			return (this.headPartList[index] as KingTeamFlagHead).v;
//return txtName["teamflag"];			
		}

		//index 4
		public function get TaskHeadState():MovieClip
		{
			var index:int=KingNameParam.TaskHeadIndex;
			if (null == this.headPartList[index])
			{
				this.headPartList[index]=WorldFactory.createKingTaskHead();
				this.headPartList[index].x=KingNameParam.TaskHeadPoint.x;
				this.headPartList[index].y=KingNameParam.TaskHeadPoint.y;
				this.addChild(this.headPartList[index]);
			}
			return (this.headPartList[index] as KingTaskHead).v;
//return txtName["TaskHeadState"];			
		}

		//index 5
		public function get KingShop():MovieClip
		{
			var index:int=KingNameParam.ShopHeadIndex;
			if (null == this.headPartList[index])
			{
				this.headPartList[index]=WorldFactory.createKingShopHead();
				this.headPartList[index].x=KingNameParam.ShopHeadPoint.x;
				this.headPartList[index].y=KingNameParam.ShopHeadPoint.y;
				this.addChild(this.headPartList[index]);
			}
			return (this.headPartList[index] as KingShopHead).v;
			//return txtName["KingShop"];
		}

		//index 6
		public function get KingChengHao():KingChengHaoHead
		{
			var index:int=KingNameParam.ChengHaoHeadIndex;
			if (null == this.headPartList[index])
			{
				this.headPartList[index]=WorldFactory.createKingChenghaoHead();
				this.headPartList[index].x=KingNameParam.ChengHaoHeadPoint.x;
				this.headPartList[index].y=KingNameParam.ChengHaoHeadPoint.y;
				//this.addChild(this.headPartList[index]);
				this.addChildAt(this.headPartList[index], 0);
			}
			//if (this.TxtName.height > 18)
			if (this.kname.height > 18)
			{
				this.headPartList[index].y=KingNameParam.ChengHaoHeadPoint.y - this.TxtName.height / 2;
			}
			else
			{
				this.headPartList[index].y=KingNameParam.ChengHaoHeadPoint.y;
			}
			return this.headPartList[index] as KingChengHaoHead;
		}

		//index 7
		public function get yellowVip():MovieClip
		{
			var index:int=KingNameParam.YellowVipHeadIndex
			if (null == this.headPartList[index])
			{
				this.headPartList[index]=WorldFactory.createKingYellowVipHead();
				this.headPartList[index].x=this.TxtName.x - kname.textWidth / 2 - 30; //26;
				this.headPartList[index].y=this.TxtName.y - 16; //20;
				this.addChild(this.headPartList[index]);
			}
			return (this.headPartList[index] as KingYellowVIPHead).v;
		}

		//index 8
		public function get KBH():KingBuffHead
		{
			var index:int=KingNameParam.BuffHeadIndex;
			if (null == this.headPartList[index])
			{
				this.headPartList[index]=WorldFactory.createKingBuffHead();
				this.headPartList[index].x=KingNameParam.BuffHeadPoint.x;
				this.headPartList[index].y=KingNameParam.BuffHeadPoint.y;
				this.addChild(this.headPartList[index]);
			}
			return (this.headPartList[index] as KingBuffHead);
		}

		//index 81
		public function get KingBuff():MovieClip
		{
			var index:int=KingNameParam.BuffHeadIndex;
			KBH;
			return (this.headPartList[index] as KingBuffHead).v;
		}

		//index 9
		public function get BloodBar():MovieClip
		{
			var index:int=KingNameParam.BloodHeadIndex;
			if (null == this.headPartList[index])
			{
				this.headPartList[index]=WorldFactory.createKingBloodHead();
				this.headPartList[index].x=KingNameParam.BloodHeadPoint.x;
				this.headPartList[index].y=KingNameParam.BloodHeadPoint.y;
					//this.addChild(this.headPartList[index]);
			}
			return (this.headPartList[index] as KingBloodHead).v;
		}

		//index 10
		public function get KingChat():MovieClip
		{
			var index:int=KingNameParam.ChatHeadIndex;
			if (null == this.headPartList[index])
			{
				this.headPartList[index]=WorldFactory.createKingChatHead();
				this.headPartList[index].x=KingNameParam.ChatHeadPoint.x;
				this.headPartList[index].y=KingNameParam.ChatHeadPoint.y;
				this.addChild(this.headPartList[index]);
			}
			return (this.headPartList[index] as KingChatHead).v;
		}

		//index 11
		public function get pk():MovieClip
		{
			var index:int=KingNameParam.PkHeadIndex
			if (null == this.headPartList[index])
			{
				this.headPartList[index]=WorldFactory.createKingPkHead();
				this.headPartList[index].x=this.TxtName.x - kname.textWidth / 2 - 20;
				this.headPartList[index].y=this.TxtName.y - 16;
				this.addChild(this.headPartList[index]);
			}
			return (this.headPartList[index] as KingPkHead).v;
		}

		//index 12
		public function get LoadingHeadState():MovieClip
		{
			var index:int=KingNameParam.LoadingHeadIndex;
			if (null == this.headPartList[index])
			{
				this.headPartList[index]=WorldFactory.createKingLoadingHead();
				this.headPartList[index].x=KingNameParam.LoadingHeadPoint.x;
				this.headPartList[index].y=KingNameParam.LoadingHeadPoint.y;
				this.addChild(this.headPartList[index]);
			}
			return (this.headPartList[index] as KingLoadingHead).v;
		}










		public function hasChengHao():Boolean
		{
			var index:int=KingNameParam.ChengHaoHeadIndex;
			if (null == this.headPartList[index])
			{
				return false;
			}
			return true;
		}

		public function hasYellowVip():Boolean
		{
			var index:int=KingNameParam.YellowVipHeadIndex;
			if (null == this.headPartList[index])
			{
				return false;
			}
			return true;
		}

		public function hasPk():Boolean
		{
			var index:int=KingNameParam.PkHeadIndex;
			if (null == this.headPartList[index])
			{
				return false;
			}
			return true;
		}

		public function hasLoadingHead():Boolean
		{
			var index:int=KingNameParam.LoadingHeadIndex;
			if (null == this.headPartList[index])
			{
				return false;
			}
			return true;
		}

		public function hasKingBuff():Boolean
		{
			var index:int=KingNameParam.BuffHeadIndex;
			if (null == this.headPartList[index])
			{
				return false;
			}
			return true;
		}

		public function hasKingChat():Boolean
		{
			var index:int=KingNameParam.ChatHeadIndex;
			if (null == this.headPartList[index])
			{
				return false;
			}
			return true;
		}

		public function hasAutoFight():Boolean
		{
			var index:int=KingNameParam.AutoFightHeadIndex;
			if (null == this.headPartList[index])
			{
				return false;
			}
			return true;
		}

		public function hasAutoPath():Boolean
		{
			var index:int=KingNameParam.AutoPathHeadIndex;
			if (null == this.headPartList[index])
			{
				return false;
			}
			return true;
		}
		public var bubbleTimeout:int;

		public function showBubbleChat(message:String):void
		{
			if (!hasKingChat())
			{
				KingChat;
			}
			var index:int=KingNameParam.ChatHeadIndex;
			if (!this.contains(this.headPartList[index]))
			{
				this.addChild(this.headPartList[index]);
			}
//check
			if (null == (this.headPartList[index] as KingChatHead).bg)
			{
				return;
			}
			(this.headPartList[index] as KingChatHead).msg=message;
//-136是bg.height的最大高度
			(this.headPartList[index] as KingChatHead).y=-136 + Math.abs((this.headPartList[index] as KingChatHead).bg.height - 136);
			/*trace("bg.height:",(this.headPartList[index] as KingChatHead).bg.height);
						trace((this.headPartList[index] as KingChatHead).y);
						*/
			clearTimeout(bubbleTimeout);
			bubbleTimeout=setTimeout(hideBubbleChat, 4000); //5000 //6000
		}

		public function hideBubbleChat():void
		{
			if (!hasKingChat())
			{
				return;
			}
			var index:int=KingNameParam.ChatHeadIndex;
			if (this.contains(this.headPartList[index]))
			{
				this.removeChild(this.headPartList[index]);
			}
			(this.headPartList[index] as KingChatHead).msg="";
		}





		public function get ChengHao():KingChengHaoHead
		{
			KingChengHao;
			var index:int=KingNameParam.ChengHaoHeadIndex;
			return this.headPartList[index];
		}


		/**
				 *
				 */
		private var _kissTimeRun:Boolean=false;
		private var _kissTimeCount:int=0;

		public function KissTimeStop():void
		{
			_kissTimeRun=false;
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, kissTimeHandler);
			this.refreshKname();
			this.setYellowVipPos();
		}

		public function KissTime(value:int):void
		{
			if (_kissTimeRun)
			{
				return;
			}
			var k:King=this.king;
			if (null == k)
			{
				return;
			}
			if (!k.isMe)
			{
				return;
			}
			if (value < 0)
			{
				value=1;
			}
			_kissTimeCount=value;
			_kissTimeRun=true;
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, kissTimeHandler);
		}

		private function kissTimeHandler(e:WorldEvent):void
		{
			_kissTimeCount--;
			if (_kissTimeCount == 0)
			{
				_kissTimeRun=false;
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, kissTimeHandler);
			}
			this.refreshKname();
			this.setYellowVipPos();
		}

		public function get kingVipVip():int
		{
			var k:King=this.king;
			if (null == k)
			{
				return 0;
			}
			return k.vip >> 16;
		}

		/**
				 *
				 */
		public function get kingName():String
		{
			var k:King=this.king;
			if (null == k)
			{
				return _kingName;
			}
			var monPrefix:String="";
			var needBold:Boolean=false;
			var c:String="<font color='" + this.KingNameColor + "'>";
			var d:String="</font>";
			var b:String="";
			if (k.name2.indexOf(BeingType.NPC) >= 0)
			{
				if ("" != _kingMasterName)
				{
					//return c + this._kingMasterName + Lang.getLabel("30006_petPrefix") + "\n" + _kingName + d;
					return c + this._kingMasterName + "\n" + _kingName + d;
				}
			}
			if (k.name2.indexOf(BeingType.MON) >= 0)
			{
				// 怪物类型  1=普通  2=精英  3=boss 
				//1.	怪物前缀显示：
				//	a)	格式：品质•XXX(目前只有精英、BOSS级别有前缀)
				//  b)	例如：
				//     精英•精细虫
				//     魔王•精细虫
				if (2 == k.grade)
				{
					monPrefix=""; //Lang.getLabel("30004_monPrefix");
					needBold=true;
				}
				else if (3 == k.grade)
				{
					monPrefix=""; //Lang.getLabel("30005_monPrefix");
					needBold=true;
				}
//isMeMon
				if ("" != _kingMasterName)
				{
					needBold=false;
//项目转换	var m_mod:Pub_NpcResModel = Lib.getObj(LibDef.PUB_NPC, k.dbID.toString());
					var m_mod:Pub_NpcResModel=XmlManager.localres.getNpcXml.getResPath(k.dbID) as Pub_NpcResModel;
					if (m_mod != null)
					{
						//30024_monPrefix改成了只有一个 “的”字
						b=c + this._kingMasterName + Lang.getLabel("30024_monPrefix") + m_mod.npc_monprefix + "\n" + monPrefix + _kingName + " " + k.level_displayName + d;
					}
				}
				else if ("" != k.gradeTitle)
				{
					b=c + k.gradeTitle + "\n" + monPrefix + _kingName + " " + k.level_displayName + d;
				}
				else
				{
					b=c + monPrefix + _kingName + " " + k.level_displayName + d;
				}
				if (needBold)
				{
					return "<b>" + b + "</b>";
						//return "<b>" + c + monPrefix + _kingName + " " + k.level.toString() + Lang.getLabel("30007_monPrefixEnd") + d +"</b>";
				}
//return c + monPrefix + _kingName + " " + k.level.toString() + Lang.getLabel("30007_monPrefixEnd") + d;
				return b;
			}
			if (k.name2.indexOf(BeingType.PET) >= 0)
			{
				return c + this._kingMasterName + Lang.getLabel("30006_petPrefix") + "\n" + _kingName + d;
			}
			if (k.name2.indexOf(BeingType.HUMAN) >= 0 || k.name2.indexOf(BeingType.FAKE_HUM) >= 0)
			{
				b="";
				var campName:String="";
				var b1:String="";
				if (k.isBooth)
				{
					//异常处理
					if ("" == _boothName)
					{
						_boothName=_kingName + "的摊位";
					}
					b+="<font color='#ffc000'>" + _boothName + "</font>\n";
//暂不隐藏称号，头上的摆摊中移至屏幕中间，和战斗状态相似
				}
				if (k.ploit > 0)
				{
					b+=XuanShangDuiHuan.getJunJieName(k.ploit) + "\n";
				}
				if (k.guildInfo.GuildId > 0 && !k.isBooth && 8 != k.camp && 9 != k.camp)
				{
					if (k.guildInfo.isGuildWang)
					{
						b1=Lang.getLabel("300031_jzWang"); //"[皇城]";
					}
					if (k.guildInfo.isFuZuZhang || k.guildInfo.isZuZhang)
					{
						//ffc000
						b+="<font color='#a2eafc'>" + b1 + k.guildInfo.GuildName + " " + k.guildInfo.GuildDutyName + "</font>\n";
					}
					else
					{
						b+="<font color='#a2eafc'>" + b1 + k.guildInfo.GuildName + "</font>\n";
					}
				}
//太已，通天
				//大海战朱雀，玄武等
				if (2 == k.campName || 3 == k.campName &&
					//8 != k.camp && 9  != k.camp &&
					13 != k.camp && 14 != k.camp && 15 != k.camp)
				{
					//太乙2
					//if(2 == k.camp)
					if (2 == k.campName)
					{
						campName="<b><font color='#00d8ff'>[" + Lang.getLabel("pub_tai_yi") + "]</font></b>";
					}
					else if (3 == k.campName) //通天3//if(3 == k.camp)
					{
						campName="<b><font color='#ff9000'>[" + Lang.getLabel("pub_tong_tian") + "]</font></b>";
					}
				}
				if (8 == k.camp || 9 == k.camp)
				{
//替换玩家名称为势力名称，并隐藏阵营标识、家族名称、称号信息。
					//分配到势力A的玩家，名称被替换为[秦阳军]，颜色#20fff5。
					//分配到势力B的玩家，名称被替换为[叛军]，颜色#ec892b 。
					if (8 == k.camp)
					{
						campName="<b><font color='#20fff5'>[" + Lang.getLabel("pub_camp_8") + "]</font></b>";
					}
					if (9 == k.camp)
					{
						campName="<b><font color='#ec892b'>[" + Lang.getLabel("pub_camp_9") + "]</font></b>";
					}
				}
//campName服务器改不了，只能2或3
				//大海战朱雀，玄武等
				if (13 == k.camp)
				{
					campName="<b><font color='#27e9f5'>[" + Lang.getLabel("pub_camp_13") + "]</font></b>";
				}
				else if (14 == k.camp)
				{
					campName="<b><font color='#ff5a00'>[" + Lang.getLabel("pub_camp_14") + "]</font></b>";
				}
				else if (15 == k.camp)
				{
					campName="<b><font color='#ffe84e'>[" + Lang.getLabel("pub_camp_15") + "]</font></b>";
				}
				if (8 == k.camp || 9 == k.camp || 13 == k.camp || 14 == k.camp || 15 == k.camp)
				{
					if (k.isMe)
					{
						setVisiblePartList(true);
					}
					else
					{
						setVisiblePartList(false);
					}
				}
				else if(Action.instance.sysConfig.alwaysHideChengHao==false)
				{
					setVisiblePartList(true);
				}
				if (k.isKissing)
				{
					//主动
					if (3 == k.exercise)
					{
						if (k.coupleid > 0)
						{
							if (k.isMe)
							{
								monPrefix="(" + StringUtils.getStringJianhuaTime(this._kissTimeCount * 1000, false) + ")" + "\n";
							}
							return b + c + monPrefix + _kingName + "与" + k.coupleidName + "拥吻中……" + d;
						}
					}
//被动
					if (4 == k.exercise)
					{
						return "";
					}
				}
//如处于大海战地图,
				//应该根据所分配的势力，显示势力名称代替玩家的名称
				//2：隐藏玩家自身家族名称、阵营标识及称号
				var mapId:int=SceneManager.instance.currentMapId;
				if (20210065 == mapId)
				{
					if (!k.isMe)
					{
						return Lang.getLabel("pub_pk_shen_mi_ren");
					}
				}
				if (20200031 == mapId && (13 == k.camp || 14 == k.camp || 15 == k.camp))
				{
					return campName;
				}
				if (8 == k.camp || 9 == k.camp)
				{
					//if (!k.isMe)
					//{
					//return b + c + monPrefix + campName + "" + d;
					//}
				}
				return b + c + (k.gradeTitle==""?"":k.gradeTitle + "\n") + monPrefix + campName + _kingName + d;
			} //end if
			return c + monPrefix + _kingName + d;
		}

		/**
				 *
				 */
		public function get headPartList():Array
		{
			if (null == _headPartList)
			{
				_headPartList=[];
				var i:int;
				var len:int=KingNameParam.total_count;
				for (i=0; i < len; i++)
				{
					_headPartList[i]=null;
				} //end for
			}
			return _headPartList;
		}

		public function get KingNameColor():String
		{
			return _kingNameColor;
		}

		public function set KingNameColor(value:String):void
		{
			_kingNameColor=value;
		}

		public function set setBoothName(value:String):void
		{
			this._boothName=value;
			this.showTxtNameAndBloodBar();
		}

		public function set setTaskState(n:int):void
		{
			TaskHeadState.gotoAndStop(n + 1);
		}

		public function set setKingNameColor(color:String):void
		{
			KingNameColor=color;
			//GameColor.setTextColor(kname,color);
			this.refreshKname();
		}

		public function set setTeamflag(bo:Boolean):void
		{
			if (bo)
			{
				teamflag.visible=bo;
				teamflag.gotoAndStop(2);
			}
			else
			{
				teamflag.visible=bo;
				teamflag.gotoAndStop(1);
			}
		}

		/**
				 *
				 */
		public function set setChengHao(value:Array):void
		{
			if (null == this.king)
			{
				return;
			}
			var index:int=KingNameParam.ChengHaoHeadIndex;
			if (value.length > 0)
			{
				if (!hasChengHao())
				{
					this.KingChengHao;
				}
				this.KingChengHao;
				if (!this.contains(this.headPartList[index]))
				{
					//this.addChild(this.headPartList[index]);
					this.addChildAt(this.headPartList[index], 0);
				}
			}
			else
			{
				if (!hasChengHao())
				{
					return;
				}
				if (this.contains(this.headPartList[index]))
				{
					this.removeChild(this.headPartList[index]);
				}
			}
//setData
			(this.headPartList[index] as KingChengHaoHead).title=value;
		}

		public function setYellowVipPos():void
		{
			if (hasYellowVip())
			{
				var index:int=KingNameParam.YellowVipHeadIndex;
//30
				if (1 == this.yellowVip.currentFrame || 3 == this.yellowVip.currentFrame)
				{
					this.headPartList[index].x=this.TxtName.x - kname.textWidth / 2 - 30; //26;
					this.headPartList[index].y=this.TxtName.y - 16;
				}
				else if (5 == this.yellowVip.currentFrame)
				{
					this.headPartList[index].x=this.TxtName.x - kname.textWidth / 2 - 20; //26;
					this.headPartList[index].y=this.TxtName.y - 16;
				}
				else
				{
					this.headPartList[index].x=this.TxtName.x - kname.textWidth / 2 - 30 - 20; //26;
					this.headPartList[index].y=this.TxtName.y - 16;
				}
			}
		}

		public function installYellowVip($qqyellowvip:int, type:int, level:int):void
		{
			_$qqyellowvip=$qqyellowvip;
			if (null == this.king)
			{
				return;
			}
			YellowDiamond.getInstance().handleYellowDiamondMC2(this.yellowVip, $qqyellowvip);
			if (this.yellowVip.visible)
			{
				this.setYellowVip(true);
			}
			else
			{
				this.setYellowVip(false);
			}
		}

		public function setYellowVip(value:Boolean):void
		{
			if (null == this.king)
			{
				return;
			}
			var index:int=KingNameParam.YellowVipHeadIndex;
			if (value)
			{
				if (!hasYellowVip())
				{
					this.yellowVip;
				}
				if (!this.contains(this.headPartList[index]))
				{
					this.addChild(this.headPartList[index]);
				}
//repos
				//this.yellowVip.gotoAndStop(type);				
				//(this.yellowVip.getChildAt(0) as MovieClip).gotoAndStop(level);
				YellowDiamond.getInstance().handleYellowDiamondMC2(this.yellowVip, this._$qqyellowvip);
				this.setYellowVipPos();
			}
			else
			{
				if (!hasYellowVip())
				{
					return;
				}
				if (this.contains(this.headPartList[index]))
				{
					this.removeChild(this.headPartList[index]);
				}
			}
		}

		public function setPkColor(value:String):void
		{
			setKingNameColor=value;
		}

		/**
				 * 0和平1阵营 2家族 3 全体
				 */
		public function setPk(value:Boolean, value2:String=null):void
		{
			if (null == this.king)
			{
				return;
			}
			var index:int=KingNameParam.PkHeadIndex;
			if (value)
			{
				if (!hasPk())
				{
					this.pk;
				}
				if (null != value2 && this.pk != null)
				{
					this.pk.gotoAndStop(parseInt(value2));
				}
				if (!this.contains(this.headPartList[index]))
				{
					this.addChild(this.headPartList[index]);
				}
//repos
				//20
//				if (this.hasVip())
//				{
//					this.headPartList[index].x=this.TxtName.x - kname.textWidth / 2 - 20 - 30; //26;
//					this.headPartList[index].y=this.TxtName.y - 16;
//				}
//				else
//				{
//					this.headPartList[index].x=this.TxtName.x - kname.textWidth / 2 - 20;
//					this.headPartList[index].y=this.TxtName.y - 16;
//				}
				if (this.hasYellowVip())
				{
					if (1 == this.yellowVip.currentFrame)
					{
						this.headPartList[index].x=this.TxtName.x - kname.textWidth / 2 - 20 - 30; //26;
						this.headPartList[index].y=this.TxtName.y - 16;
					}
					else
					{
						this.headPartList[index].x=this.TxtName.x - kname.textWidth / 2 - 20 - 30 - 20; //26;
						this.headPartList[index].y=this.TxtName.y - 16;
					}
				}
				else
				{
					this.headPartList[index].x=this.TxtName.x - kname.textWidth / 2 - 20;
					this.headPartList[index].y=this.TxtName.y - 16;
				}
			}
			else
			{
				if (!hasPk())
				{
					return;
				}
				if (this.contains(this.headPartList[index]))
				{
					this.removeChild(this.headPartList[index]);
				}
			}
		}

		/**
				 * 自动战斗
				 */
		public function set setAutoFight(bo:Boolean):void
		{
			if (null == this.king)
			{
				return;
			}
			var index:int=KingNameParam.AutoFightHeadIndex;
			if (bo)
			{
				if (!hasAutoFight())
				{
					this.autoFight;
				}
				this.autoFight;
				if (!this.contains(this.headPartList[index]))
				{
					this.addChild(this.headPartList[index]);
				}
			}
			else
			{
				if (!hasAutoFight())
				{
					return;
				}
				if (this.contains(this.headPartList[index]))
				{
					this.removeChild(this.headPartList[index]);
				}
			}
		}

		/**
				 * 自动寻路
				 */
		public function get isAutoPath():Boolean
		{
			if (!hasAutoPath())
			{
				return false;
			}
			var index:int=KingNameParam.AutoPathHeadIndex;
			if (this.contains(this.headPartList[index]))
			{
				return true;
			}
			return false;
		}

		public function set setAutoPath(bo:Boolean):void
		{
			if (null == this.king)
			{
				return;
			}
			if (KingActionEnum.XL == this.king.roleZT)
			{
				return;
			}
			if (this.king.isGhost)
			{
				return;
			}
			var index:int=KingNameParam.AutoPathHeadIndex;
			if (bo)
			{
				if (!hasAutoPath())
				{
					this.autoPath;
				}
				this.autoPath;
				if (!this.contains(this.headPartList[index]))
				{
					this.addChild(this.headPartList[index]);
				}
				if (null != this.king)
				{
					if (this.king.isMe)
					{
						Action.instance.fight.ShowAutoRoadHead();
					}
				}
			}
			else
			{
				if (!hasAutoPath())
				{
					return;
				}
				if (this.contains(this.headPartList[index]))
				{
					this.removeChild(this.headPartList[index]);
				}
				if (null != this.king)
				{
					if (this.king.isMe)
					{
						Action.instance.fight.HideAutoRoadHead();
					}
				}
			}
		}
		private var m_nCurrHp:int=-1;

		/**
		 * showHp不是setHp
		 * 是不同步的，一般来说setHp比较早
		 *
		 * -1表示在addChild时初始化，值从king里读
		 */
		public function refreshBloodBar(source:String, num:int=0, hp:int=0, type:String=""):void
		{
			var k:King=this.king;
			if (null == k)
			{
				return;
			}
			if (m_nCurrHp == -1 || k.hp >= k.maxHp)
			{
				m_nCurrHp=k.hp;
			}
			if ("WaftNum" == source)
			{
				//nothing			
				m_nCurrHp-=num;
			}
			else
			{
				//保持数据同步				
				m_nCurrHp=k.hp;
			}
			var maxHp:int=k.maxHp;
			if ("initBloodBar" == source)
			{
				//refresh point
				BloodBar;
				var index:int=KingNameParam.BloodHeadIndex;
				(this.headPartList[index] as KingBloodHead).x=0;
			}
//check
			if (hp < 0)
			{
				hp=0;
			}
			if (m_nCurrHp < 0)
			{
				m_nCurrHp=0;
			}
//解决一个bug,即血条宽度为0时，如再减hp，会增加
			if (WaftNumType.HP_SUB == type && hp > 0 && k.hp == 0)
			{
				hp=0;
			}
			if (maxHp < 0)
			{
				maxHp=hp;
			}
			var barW:int;
			var emptyBarW:int;
			if (k.name2.indexOf(BeingType.HUMAN) >= 0 || k.name2.indexOf(BeingType.MON) >= 0 || k.name2.indexOf(BeingType.PET) >= 0 || k.name2.indexOf(BeingType.FAKE_HUM) >= 0)
			{
				if (null != BloodBar)
					BloodBar['txt_hp'].text=m_nCurrHp.toString() + "/" + maxHp.toString();
				//boss
				//boss现变为3
				if (3 == k.grade)
				{
					//BOSS怪物
					barW=Math.floor(KingNameParam.BLOOD_RED_BAR_BOSS_WIDTH * (m_nCurrHp / maxHp));
					emptyBarW=KingNameParam.BLOOD_RED_BAR_BOSS_WIDTH;
					if (null != BloodBar)
						(this.BloodBar["maskBar"] as MovieClip).x=(this.BloodBar["redBar"] as MovieClip).x=KingNameParam.BLOOD_RED_BAR_BOSS_WIDTH / 2 * -1;
					if (null != BloodBar)
						(this.BloodBar["emptyBar"] as MovieClip).x=KingNameParam.BLOOD_RED_BAR_BOSS_WIDTH / 2 * -1;
				}
				else
				{
					//普通
					barW=Math.floor(KingNameParam.BLOOD_RED_BAR_WIDTH * (m_nCurrHp / maxHp));
					emptyBarW=KingNameParam.BLOOD_RED_BAR_WIDTH;
					if (null != BloodBar)
						(this.BloodBar["maskBar"] as MovieClip).x=(this.BloodBar["redBar"] as MovieClip).x=KingNameParam.BLOOD_RED_BAR_WIDTH / 2 * -1;
					if (null != BloodBar)
						(this.BloodBar["emptyBar"] as MovieClip).x=KingNameParam.BLOOD_RED_BAR_WIDTH / 2 * -1;
				} //end if
				//保留最少1像素
				if (0 < hp && 1 > barW)
				{
					barW=1;
				}
				if (null != BloodBar)
					(this.BloodBar["maskBar"] as MovieClip).width=barW;
				if (null != BloodBar)
					(this.BloodBar["redBar"] as MovieClip).width=emptyBarW;
				if (null != BloodBar)
					(this.BloodBar["emptyBar"] as MovieClip).width=emptyBarW;
			} //end if
		}

		public function get king():King
		{
			if (null == this.parent)
				return null;
			var king:King=(this.parent as Skin).king;
			if (null == king)
				return null;
			return king;
		}
	}
}
