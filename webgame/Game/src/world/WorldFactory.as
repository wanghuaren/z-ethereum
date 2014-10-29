package world
{
	import engine.load.GamelibS;
	import engine.utils.FPSUtils;
	import engine.utils.HashMap;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import scene.human.GameDrop;
	import scene.human.GameHuman;
	import scene.human.GameLocalHuman;
	import scene.human.GameMonster;
	import scene.human.GameRes;
	import scene.king.IGameKing;
	import scene.king.King;
	import scene.king.Skin;
	import scene.king.SkinBySkill;
	import scene.kingfoot.KingEffectUp;
	import scene.kingname.KingAutoFightHead;
	import scene.kingname.KingAutoPathHead;
	import scene.kingname.KingBloodHead;
	import scene.kingname.KingBuffHead;
	import scene.kingname.KingChatHead;
	import scene.kingname.KingChengHaoHead;
	import scene.kingname.KingGongNengHead;
	import scene.kingname.KingHeadName;
	import scene.kingname.KingLoadingHead;
	import scene.kingname.KingPkHead;
	import scene.kingname.KingShopHead;
	import scene.kingname.KingTaskHead;
	import scene.kingname.KingTeamFlagHead;
	import scene.kingname.KingTxtNameHead;
	import scene.kingname.KingYellowVIPHead;
	import scene.manager.SceneManager;
	import scene.skill2.*;
	import scene.weather.WeaterEffect3BySoul;
	
	import world.graph.WorldSprite;
	import world.type.BeingType;
	import world.type.ItemType;
	import world.type.WeaterType;
	import world.type.WorldType;
	public class WorldFactory
	{
		private static var enterFrameShape:Shape=new Shape
		private static var _hpNumList:HashMap;
		private static var _faceList:HashMap;
		private static var _se2List:HashMap;
		private static var _se3List:HashMap;
		private static var _bufHeadList:HashMap;
		private static var _txtNameHeadList:HashMap;
		private static var _chatHeadList:HashMap;
		private static var _effectDiaoLuoList:HashMap;
		//private static var _chatList:HashMap;
		/**
		 * 聊天元件对象池
		 */
		/*public static function get chatList():HashMap
		{
			if(null == _chatList)
			{
				_chatList = new HashMap();
			}
			return _chatList;
		}*/
		/**
		 * 对象池
		 */ 
		private static var _humList2:Vector.<GameHuman>;
		private static var _monList2:Vector.<GameMonster>;
		private static var _resList2:Vector.<GameRes>;
		private static var _resList3:Vector.<GameDrop>;
		private static var _waftList:Vector.<WaftNumber>;
		public static function get waftList():Vector.<WaftNumber>
		{
			if(null == _waftList)
			{
				_waftList = new Vector.<WaftNumber>;
			}
			return _waftList;
		}
		public static function get humList2():Vector.<GameHuman>
		{
			if(null == _humList2)
			{
				_humList2 = new Vector.<GameHuman>;
			}
			return _humList2;
		}
		public static function get monList2():Vector.<GameMonster>
		{
			if(null == _monList2)
			{
				_monList2 = new Vector.<GameMonster>;
			}
			return _monList2;
		}
		public static function get resList2():Vector.<GameRes>
		{
			if(null == _resList2)
			{
				_resList2 = new Vector.<GameRes>;
			}
			return _resList2;
		}
		public static function get resList3():Vector.<GameDrop>
		{
			if(null == _resList3)
			{
				_resList3 = new Vector.<GameDrop>;
			}
			return _resList3;
		}
		/**
		 * 飘血数字对象池
		 */
		public static function get hpNumList():HashMap
		{
			if (null == _hpNumList)
			{
				_hpNumList=new HashMap();
			}
			return _hpNumList;
		}
		/**
		 *
		 */
		public static function get faceList():HashMap
		{
			if (null == _faceList)
			{
				_faceList=new HashMap();
			}
			return _faceList;
		}
		public static function get se2List():HashMap
		{
			if (null == _se2List)
			{
				_se2List=new HashMap();
			}
			return _se2List;
		}
		public static function get se3List():HashMap
		{
			if (null == _se3List)
			{
				_se3List=new HashMap();
			}
			return _se3List;
		}
		public static function get bufHeadList():HashMap
		{
			if (null == _bufHeadList)
			{
				_bufHeadList=new HashMap();
			}
			return _bufHeadList;
		}
		public static function get txtNameHeadList():HashMap
		{
			if (null == _txtNameHeadList)
			{
				_txtNameHeadList=new HashMap();
			}
			return _txtNameHeadList;
		}
		public static function get chatHeadList():HashMap
		{
			if (null == _chatHeadList)
			{
				_chatHeadList=new HashMap();
			}
			return _chatHeadList;
		}
		public static function get effectDiaoLuoList():HashMap
		{
			if (null == _effectDiaoLuoList)
			{
				_effectDiaoLuoList=new HashMap();
			}
			return _effectDiaoLuoList;
		}
		/**
		 *
		 */
		public static function createSprite():WorldSprite
		{
			return new WorldSprite;
		}
		public static function createDrop():IWorld
		{
			var item:IWorld;
			//
			var beingType:String = ItemType.DROP;
			var objid_:uint;
			//
			switch (beingType)
			{
				case ItemType.DROP:
					objid_=createObjid();
					if(0 == SceneManager.delKing_Core_Mode)
					{
						item=new GameDrop();
						(item as WorldSprite).objid = objid_;
						item.name=WorldType.WORLD + objid_.toString();
						item.name2=ItemType.DROP + objid_.toString();
					}
					else if(1 == SceneManager.delKing_Core_Mode)
					{
						if(resList3.length > 0)
						{
							item = resList3.shift();							
							(item as WorldSprite).objid = objid_;
						}else
						{
							item=new GameDrop();
							(item as WorldSprite).objid = objid_;
							item.name=WorldType.WORLD + objid_.toString();
							item.name2=ItemType.DROP + objid_.toString();
						}
					}
					break;
				default:
				throw new Error("can not find this itemType:" + beingType);
			}
			//
			item.init();
			//
			return item;
		}
		/**
		 * 创建生物
		 *
		 * 参数Example:BeingType.MONSTER
		 *
		 * public static function createBeing(beingType:String):IWorld
		 */
		public static function createBeing(beingType:String):IGameKing
		{
			var being:IGameKing;
			switch (beingType)
			{
				case BeingType.LOCAL_HUMAN:
					being = new GameLocalHuman();
					break;
				case BeingType.FAKE_HUM:
				case BeingType.HUMAN:
					if(0 == SceneManager.delKing_Core_Mode)
					{
						being=new GameHuman();
					}
					else
						if(1 == SceneManager.delKing_Core_Mode)
						{
							if(humList2.length > 0)
							{
								being = humList2.shift();							
							}else
							{
								being=new GameHuman();
							}
						}
					break;
				case BeingType.MONSTER:
				case BeingType.MON:
				case BeingType.PET:
				case BeingType.NPC:
				case BeingType.RES:
				case BeingType.TRANS:
				case BeingType.SKILL:
					if(0 == SceneManager.delKing_Core_Mode)
					{
						being=new GameMonster();
					}
					else
					if(1 == SceneManager.delKing_Core_Mode)
					{
						if(monList2.length > 0)
						{
							being = monList2.shift();							
						}else
						{
							being=new GameMonster();
						}
					}
					break;
				case ItemType.PICK:
					if(0 == SceneManager.delKing_Core_Mode)
					{
						being=new GameRes();
					}
					else
						if(1 == SceneManager.delKing_Core_Mode)
						{
							if(resList2.length > 0)
							{
								being = resList2.shift();							
							}else
							{
								being=new GameRes();
							}
						}
					break;
				default:
					throw new Error("can not find this beingType:" + beingType);
			}
			//
			being.init();
			//	
			return being;
		}
		protected static function onEnterFrameFunc(event:Event):void
		{
			if(itemHash.length)
			{
				var time:int=0
				var fps:Number=FPSUtils.fps
				if(fps<8)
				{
					time=2000+(Math.random()*1000>>0)
				}else if(fps>=8&&fps<15)
				{
					time=1000+(Math.random()*500>>0)
				}else if(fps>=15&&fps<24)
				{
					time=80+(Math.random()*60>>0)
				}else {
					time=10+(Math.random()*30>>0)
				}
				time=10+(Math.random()*30>>0)
				if(getTimer()-timeNum>time)
				{
					timeNum=getTimer();
					if(itemHash.length>15)
					{
						var n:int=5
						if(itemHash.length<50){
							n=5;
						}else if(itemHash.length>=50&&n<100)
						{
							n=3
						}else if(itemHash.length>100)
						{
							n=2
						}
						for (var i:int = 0; i < itemHash.length/n; i++) 
						{
							if(itemHash.length)
							{
								var tar:DisplayObject=itemHash.pop() as DisplayObject
//								SceneManager.instance.indexUI_GameMap_Body.addChild(tar);
							}
						}
					}else{
						for (var j:int = 0; j <12; j++) 
						{
							if(itemHash.length)
							{
								var tar:DisplayObject=itemHash.pop() as DisplayObject
//								SceneManager.instance.indexUI_GameMap_Body.addChild(tar);
							}
						}
					}
				}
			}
		}		
		private static var timeNum:int
		private static var itemHash:Array=[]
		public static function createObjid():uint
		{
			var objid_:uint;
			if (currentObjid == MAX_OBJID)
			{
				currentObjid=MIN_OBJID;
			}
			objid_=++currentObjid;
			return objid_;
		}
		/**
		 * 创建天空层物件
		 */
		public static function createWeater(weaterType:String):IWorld
		{
			var item:IWorld;
			var objid_:uint;
			switch (weaterType)
			{
				case WeaterType.SOUL:
					/*if(currentObjid == MAX_OBJID)
					{
						currentObjid = MIN_OBJID;
					}
					objid_ = ++currentObjid;	*/
					objid_=createObjid();
					item=new WeaterEffect3BySoul(objid_);
					item.name=WorldType.WORLD + objid_.toString();
					item.name2=WeaterType.SOUL + objid_.toString();
					break;
				default:
					throw new Error("can not find this WeaterType:" + weaterType);
			}
			//
			item.init();
			return item;
		}
		/**
		 * 创建非生物
		 *
		 */
		public static function createItem(itemType:String, SKILL_EFFECT_X:int=3):IWorld
		{
			var item:IWorld;
			var objid_:uint;
			var d:DisplayObject;
			switch (itemType)
			{
				case BeingType.TRANS:
					// item = new GameTrans();
					break;
				case ItemType.SKILL:
					if (currentObjid == MAX_OBJID)
					{
						currentObjid=MIN_OBJID;
					}
					if (2 == SKILL_EFFECT_X)
					{
						d=getNum(se2List, "se2");
						if (null == d)
						{
							item=new SkillEffect2();
						}
						else
						{
							item=d as IWorld;
						}
					}
					else if (3 == SKILL_EFFECT_X)
					{
						objid_=++currentObjid;
						d=getNum(se3List, "se3");
						if (null == d)
						{
							item=new SkillEffect3(objid_);
						}
						else
						{
							item=d as IWorld;
						}
						(item as WorldSprite).clearAndSetObjiid=objid_;
						item.name=WorldType.WORLD + objid_.toString();
						item.name2=ItemType.SKILL + objid_.toString();
					}
					else if (4 == SKILL_EFFECT_X)
					{
						objid_=++currentObjid;
						item=new SkillEffect31(objid_);
						item.name=WorldType.WORLD + objid_.toString();
						item.name2=ItemType.SKILL + objid_.toString();
					}
					else if (42 == SKILL_EFFECT_X)
					{
						objid_=++currentObjid;
						item=new SkillEffect32(objid_);
						item.name=WorldType.WORLD + objid_.toString();
						item.name2=ItemType.SKILL + objid_.toString();
					}
					else if (43 == SKILL_EFFECT_X)
					{
						objid_=++currentObjid;
						item=new SkillEffect33(objid_);
						item.name=WorldType.WORLD + objid_.toString();
						item.name2=ItemType.SKILL + objid_.toString();
					}
					else if (44 == SKILL_EFFECT_X)
					{
						objid_=++currentObjid;
						item=new SkillEffect34(objid_);
						item.name=WorldType.WORLD + objid_.toString();
						item.name2=ItemType.SKILL + objid_.toString();
					}
					else if (45 == SKILL_EFFECT_X)
					{
						objid_=++currentObjid;
						item=new SkillEffect35(objid_);
						item.name=WorldType.WORLD + objid_.toString();
						item.name2=ItemType.SKILL + objid_.toString();
					}
					else
					{
						throw new Error("can not find this itemType:" + itemType + " skillEffectX:" + SKILL_EFFECT_X);
					}
					break;
				default:
					throw new Error("can not find this itemType:" + itemType);
			}
			//
			item.init();
			return item;
		}
		/**
		 * 技能元件在屏幕上由客户端自行管理
		 * 服务端给出objid范围 0x 0E00 0000 - 0x 0F00 0000
		 *                        原 0x F000 0000 - 0x FFFF FFFF
		 * 达到最大值后重置
		 *
		 * objid范围变了
			#define ID_MIN_PLAYER 0x00000001
			#define ID_MAX_PLAYER 0x3FFFFFFF
			#define ID_MIN_MONSTER 0x40000000
			#define ID_MAX_MONSTER 0x40FFFFFF
			#define ID_MIN_RES 0x41000000
			#define ID_MAX_RES 0x41FFFFFF
			#define ID_MIN_DROPBOX 0x42000000
			#define ID_MAX_DROPBOX 0x42FFFFFF
			#define ID_MIN_WORLDDECORATE 0x43000000
			#define ID_MAX_WORLDDECORATE 0x43FFFFFF
			#define ID_MIN_PET 0x44000000
			#define ID_MAX_PET 0x44FFFFFF
			#define ID_MIN_SPECAIL 0x45000000
			#define ID_MAX_SPECAIL 0x45FFFFFF
		 */
		public static var currentObjid:uint=1073741824; //4026531840;
		public static const MIN_OBJID:uint=1073741824; //4026531840;
		public static const MAX_OBJID:uint=1610612736; //uint.MAX_VALUE;
		/**
		 * Being Part
		 *
		 */
		public static function createKingHeadName():KingHeadName
		{
			var hn:KingHeadName;
			//
			hn=new KingHeadName();
			hn.init();
			return hn;
		}
		public static function createKingTxtNameHead():KingTxtNameHead
		{
			var part:KingTxtNameHead;
			//
			part=new KingTxtNameHead();
			//part=getNum(txtNameHeadList, "txtNameHead") as KingTxtNameHead;
			//if (null == part)
			//{
			//	part=new KingTxtNameHead();
			//}
			part.init();
			return part;
		}
		public static function createKingTeamFlagHead():KingTeamFlagHead
		{
			var part:KingTeamFlagHead;
			//
			part=new KingTeamFlagHead();
			part.init();
			return part;
		}
		public static function createKingTaskHead():KingTaskHead
		{
			var part:KingTaskHead;
			//
			part=new KingTaskHead();
			part.init();
			return part;
		}
		public static function createKingShopHead():KingShopHead
		{
			var part:KingShopHead;
			//
			part=new KingShopHead();
			part.init();
			return part;
		}
		public static function createKingGongNengHead():KingGongNengHead
		{
			var part:KingGongNengHead;
			//
			part=new KingGongNengHead();
			part.init();
			return part;
		}
		public static function createKingChenghaoHead():KingChengHaoHead
		{
			var part:KingChengHaoHead;
			//
			part=new KingChengHaoHead();
//			part.init();
			return part;
		}
//		public static function createKingVipHead():KingVIPHead
//		{
//			var part:KingVIPHead;
//
//			//
//			part=new KingVIPHead();
//			part.init();
//
//			return part;
//		}
		public static function createKingYellowVipHead():KingYellowVIPHead
		{
			var part:KingYellowVIPHead;
			//
			part=new KingYellowVIPHead();
			part.init();
			return part;
		}
		public static function createKingPkHead():KingPkHead
		{
			var part:KingPkHead;
			//
			part=new KingPkHead();
			part.init();
			return part;
		}
		public static function createKingChatHead():KingChatHead
		{
			var part:KingChatHead;
			//
			//part=new KingChatHead();
			part = getNum(chatHeadList, "chatHead") as KingChatHead;
			if (null == part)
			{
				part=new KingChatHead();
			}
			part.init();
			return part;
		}
		public static function creatEffectDiaoLuo():MovieClip
		{
			var part:MovieClip;
			var libName:String="effect_diao_luo";
			//
			part=getNum(effectDiaoLuoList, libName) as MovieClip;
			if (null == part)
			{
				part=GamelibS.getswflink("game_utils", libName) as MovieClip;
				if(null != part)
				{
					part.name=libName;
				}
			}
			if(null != part)
			{
				part.gotoAndPlay(1);
			}
			return part;
		}
		public static function createKingBuffHead():KingBuffHead
		{
			var part:KingBuffHead;
			//
			part=getNum(bufHeadList, "bufHead") as KingBuffHead;
			if (null == part)
			{
				part=new KingBuffHead();
			}
			part.clearData();
			part.init();
			return part;
		}
		public static function createKingLoadingHead():KingLoadingHead
		{
			var part:KingLoadingHead;
			//
			part=new KingLoadingHead();
			part.init();
			return part;
		}
		public static function createKingAutoPathHead():KingAutoPathHead
		{
			var part:KingAutoPathHead;
			//
			part=new KingAutoPathHead();
			part.init();
			return part;
		}
		public static function createKingAutoFightHead():KingAutoFightHead
		{
			var part:KingAutoFightHead;
			//
			part=new KingAutoFightHead();
			part.init();
			return part;
		}
		public static function createKingBloodHead():KingBloodHead
		{
			var part:KingBloodHead;
			//
			part=new KingBloodHead();
			part.init();
			return part;
		}
		/*public static function createKingShadow():KingShadow
		{
			var sd:KingShadow;
			//
			sd = new KingShadow();
			sd.init();
			return sd;
		}*/
		//------------------------------------------------------------------------------------------------------
//		public static function createEffectDown():KingEffectDown
//		{
//			var kd:KingEffectDown;
//
//			//
//			kd=new KingEffectDown();
//			kd.init();
//
//			return kd;
//
//		}
		public static function createEffectUp():KingEffectUp
		{
			var ku:KingEffectUp;
			//
			ku=KingEffectUp.getKingEffectUp()
			if(ku)
			{
				ku.reset()
				ku.init();
			}else{
				ku=new KingEffectUp();
				ku.init();
			}
			return ku;
		}
		//------------------------------------------------------------------------------------------------------
//		public static function createLoadingKing():LoadingKing
//		{
//			var lk:LoadingKing;
//
//			//
//			lk=LoadingKing.getLoadingKing()
//			if(lk)
//			{
//				lk.reset();
//			}else{
//				lk=new LoadingKing();
//				
//			}
//			lk=new LoadingKing();
//			lk.init();
//
//			return lk;
//
//		}
		public static function createWaftNumber():WaftNumber
		{
			var skn:WaftNumber;
			if(waftList.length > 0)
			{
				skn = waftList.shift();
			}else{
				skn= new WaftNumber();
			}
			skn.init();
			return skn;
		}
		public static function createSkin():Skin
		{
			var sk:Skin;
			sk=new Skin();
			//
			//
			sk.init();
			return sk;
		}
		public static function createSkinBySkill():SkinBySkill
		{
			var sk:SkinBySkill;
			sk=new SkinBySkill();
			sk.init();
			return sk;
		}
		/**
		 * 回收区
		 *
		 */
		public static function WAFT_NUMBER_REMOVED_FROM_STAGE(e:Event):void
		{
			var w:WaftNumber=e.target as WaftNumber;
			w.removeAll();
			w.removeEventListener(Event.REMOVED_FROM_STAGE, WAFT_NUMBER_REMOVED_FROM_STAGE);
			//			
			waftList.push(w);
		}
		public static function KING_REMOVED_FROM_STAGE(e:Event):void
		{
			var k:King=e.target as King;
			k.removeAll();
			k.removeEventListener(Event.REMOVED_FROM_STAGE, KING_REMOVED_FROM_STAGE);
		}
		public static function KING_REMOVED_BY_MAP_CHANGE(k:King):void
		{			
			k.removeAll();
			k.removeEventListener(Event.REMOVED_FROM_STAGE, KING_REMOVED_FROM_STAGE);
		}
		public static function KING_REMOVED_FROM_STAGE2(k:King,body2:DisplayObjectContainer):void
		{			
			k.removeAll();
			//
			if(k.name2.indexOf(BeingType.HUMAN) >= 0)
			{
				humList2.push(k);
			}else if(k.name2.indexOf(BeingType.MONSTER) >= 0)
			{
				monList2.push(k);
			}else
			{	
				// if(k.name2.indexOf(ItemType.PICK) >= 0)
				resList2.push(k);
			}
			body2.addChild(k as DisplayObject);
			k.dispose();
		}
		public static function DelAll():void
		{
			var j:int=0;
			var k:King;
			for(j=0;j<humList2.length;j++)
			{
				k = humList2.pop();
				k.dispose();
			}
			for(j=0;j<monList2.length;j++)
			{
				k = monList2.pop();
				k.dispose();
			}
			for(j=0;j<resList2.length;j++)
			{
				k = resList2.pop();
				k.dispose();
			}
			k = null;
			//
			_humList2 = null;
			_monList2 = null;
			_resList2 = null;
		}
		public static function SKIN_REMOVED_FROM_STAGE(e:Event):void
		{
			var sk:Skin=e.target as Skin;
			sk.removeEventListener(Event.REMOVED_FROM_STAGE, SKIN_REMOVED_FROM_STAGE);
			//sk.removeAll();			
			//
			//if(null != sk.parent){
				//sk.parent.removeChild(sk);
			//}
			//
			//
		}
		public static function HEAD_NAME_REMOVED_FROM_STAGE(e:Event):void
		{
			var hn:KingHeadName=e.target as KingHeadName;
			hn.removeAll();
			hn.removeEventListener(Event.REMOVED_FROM_STAGE, HEAD_NAME_REMOVED_FROM_STAGE);
		}
		public static function DROP_EFFECT_REMOVED_FROM_STAGE(e:Event):void
		{
			var drp:MovieClip=e.target as MovieClip;
			drp.stop();
			drp.removeEventListener(Event.REMOVED_FROM_STAGE, DROP_EFFECT_REMOVED_FROM_STAGE);
			//
			addNum(effectDiaoLuoList, drp.name, drp);
		}
		public static function HP_NUM_REMOVED_FROM_STAGE(e:Event):void
		{
			var hp_num:DisplayObject=e.currentTarget as DisplayObject;
			if (null == hp_num)
			{
				return;
			}
			//
			hp_num.removeEventListener(Event.REMOVED_FROM_STAGE, HP_NUM_REMOVED_FROM_STAGE);
			//
			addNum(hpNumList, hp_num.name, hp_num);
		}
		public static function FACE_REMOVED_FROM_STAGE(e:Event):void
		{
			var face:DisplayObject=e.currentTarget as DisplayObject;
			if (null == face)
			{
				return;
			}
			//
			face.removeEventListener(Event.REMOVED_FROM_STAGE, FACE_REMOVED_FROM_STAGE);
			//
			addNum(faceList, face.name, face);
			if(face as WorldSprite) WorldSprite(face).dispose();
		}
		public static function SKILL_EF_2_REMOVED_FROM_STAGE(e:Event):void
		{
			var se2:DisplayObject=e.currentTarget as DisplayObject;
			if (null == se2)
			{
				return;
			}
			//
			se2.removeEventListener(Event.REMOVED_FROM_STAGE, SKILL_EF_2_REMOVED_FROM_STAGE);
			//
			addNum(se2List, "se2", se2);
			if(se2 as WorldSprite) WorldSprite(se2).dispose();
		}
		public static function SKILL_EF_3_REMOVED_FROM_STAGE(e:Event):void
		{
			var se3:DisplayObject=e.currentTarget as DisplayObject;
			if (null == se3)
			{
				return;
			}
			//
			se3.removeEventListener(Event.REMOVED_FROM_STAGE, SKILL_EF_3_REMOVED_FROM_STAGE);
			//
			addNum(se3List, "se3", se3);
			if(se3 as WorldSprite) WorldSprite(se3).dispose();
		}
		public static function BUF_HEAD_REMOVED_FROM_STAGE(e:Event):void
		{
			var bufHead:DisplayObject=e.currentTarget as DisplayObject;
			if (null == bufHead)
			{
				return;
			}
			//
			(bufHead as KingBuffHead).clearData();
			bufHead.removeEventListener(Event.REMOVED_FROM_STAGE, BUF_HEAD_REMOVED_FROM_STAGE);
			//
			addNum(bufHeadList, "bufHead", bufHead);
		}
		public static function TXTNAME_HEAD_REMOVED_FROM_STAGE(e:Event):void
		{
			var txtNameHead:DisplayObject=e.currentTarget as DisplayObject;
			if (null == txtNameHead)
			{
			return;
			}
			//
			//(bufHead as KingBuffHead).stopTimer();
			txtNameHead.removeEventListener(Event.REMOVED_FROM_STAGE, TXTNAME_HEAD_REMOVED_FROM_STAGE);
			//
			//addNum(txtNameHeadList, "txtNameHead", txtNameHead);
		}
		public static function CHAT_HEAD_REMOVED_FROM_STAGE(e:Event):void
		{
			var chatHead:DisplayObject=e.currentTarget as DisplayObject;
			if (null == chatHead)
			{
				return;
			}
			//
			//(bufHead as KingBuffHead).stopTimer();
			chatHead.removeEventListener(Event.REMOVED_FROM_STAGE, CHAT_HEAD_REMOVED_FROM_STAGE);
			//
			addNum(chatHeadList, "chatHead", chatHead);
		}
		/*public static function CONTROL_CHAT_REMOVED_FROM_STAGE(e:Event):void
		{
			var d:DisplayObject = e.currentTarget as DisplayObject;
			if(null == d)
			{
				return;
			}
			if("OnContent" ==  d.name)
			{
				return;
			}
			//
			d.removeEventListener(Event.REMOVED_FROM_STAGE, CONTROL_CHAT_REMOVED_FROM_STAGE);
			//
			addChat(chatList,d.name,d);
		}*/
		/**
		 * 聊天元件
		 */
		/*public static function createWinControlChat():DisplayObject
		{
			//
			var libName:String = "Win_control_chat";
			var d:DisplayObject = getChat(chatList,libName);
			if(null == d)
			{
				d = GamelibS.getswflink("game_index",libName);
				d.name = libName;
			}
			//
			d.removeEventListener(Event.REMOVED_FROM_STAGE, CONTROL_CHAT_REMOVED_FROM_STAGE);
			d.addEventListener(Event.REMOVED_FROM_STAGE, CONTROL_CHAT_REMOVED_FROM_STAGE);
			return d;
		}*/
		/**
		 *
		 */
		public static function createFace(n:String):DisplayObject
		{
			var libName:String=n;
			var d:DisplayObject=getNum(faceList, libName);
			var canNotGet:Boolean=false;
			if (null == d)
			{
				//注意不要用libface
				//坐标和内容,libface里的有问题
				//d = GamelibS.getswflink("game_login",libName);			
				d=GamelibS.getswflink("libface", libName);
				if (null == d)
				{
					canNotGet=true;
				}
				else
				{
					d.name=libName;
				}
			}
			//
			if (!canNotGet)
			{
				d.removeEventListener(Event.REMOVED_FROM_STAGE, FACE_REMOVED_FROM_STAGE);
				d.addEventListener(Event.REMOVED_FROM_STAGE, FACE_REMOVED_FROM_STAGE);
			}
			//
			return d;
		}
		/**
		 * 数字飘
		 */
		public static function createWaftNum(n:String, type:String, isMonster:Boolean,isBaoJi:Boolean,isMe:Boolean):DisplayObject
		{
			var nIndex:int;
			if ("#" == n)
			{
				nIndex=0xc;
			}
			else if ("+" == n)
			{
				nIndex=0xa;
			}
			else if ("-" == n)
			{
				//0xb是数组最大长度
				nIndex=0xb;
			}
			else
			{
				nIndex=parseInt(n);
			}
			//
			var libName:String;
			//
			switch (type)
			{
//				case WaftNumType.HP_ADD:
//
//					libName="player_hp_add_n" + nIndex.toString(16);
//
//					break;
				case WaftNumType.HP_SUB:
					if (isMonster)
					{
						if(isBaoJi)
						{
//							libName="player_hp_baoji_n" + nIndex.toString(16);
							libName="other_hp_sub_n" + nIndex.toString(16);
						}else
						{
							libName="monster_hp_sub_n" + nIndex.toString(16);
						}
					}
					else
					{
						if(isBaoJi)
						{
//							libName="player_hp_baoji_n" + nIndex.toString(16);
							libName="player_hp_sub_n" + nIndex.toString(16);
						}
						else if(isMe)
						{
							libName="player_hp_sub_n" + nIndex.toString(16);
						}
						else
						{
							libName="other_hp_sub_n" + nIndex.toString(16);
						}
					}
					break;				
//				case WaftNumType.HP_SUB_GEDA:
//					if (isMonster)
//					{
//						libName="monster_hp_sub_geda_n" + nIndex.toString(16);						
//					}
//					else
//					{
//						libName="player_hp_sub_geda_n" + nIndex.toString(16);
//					}
//					break;
//				case WaftNumType.MP_ADD:
//
//					libName="mp_n" + nIndex.toString(16);
//
//					break;
//				case WaftNumType.EXP_ADD:
//
//					libName="exp_n" + nIndex.toString(16);
//
//					break;
//
//				case WaftNumType.REN_ADD:
//
//					libName="ren_n" + nIndex.toString(16);
//
//					break;
				case WaftNumType.ATTACK_MISS:
					libName="attack_miss_n" + nIndex.toString(16);
					break;
//				case WaftNumType.LVLUP_LIFE_ADD:
//					libName="lvlup_life_n" + nIndex.toString(16);
//					break;
//				case WaftNumType.LVLUP_LING_LI_ADD:
//					libName="lvlup_ling_li_n" + nIndex.toString(16);
//					break;
//				case WaftNumType.LVLUP_BAOJI_ADD:
//					libName="lvlup_baoji_n" + nIndex.toString(16);
//					break;
//				case WaftNumType.LVLUP_ATTACK_ADD:
//					libName="lvlup_attack_n" + nIndex.toString(16);
//					break;
//				case WaftNumType.LVLUP_DEFEND_ADD:
//					libName="lvlup_defend_n" + nIndex.toString(16);
//					break;
//				case WaftNumType.LVLUP_DEFEND2_ADD:
//					libName="lvlup_defend2_n" + nIndex.toString(16);
//					break;
				default:
					//throw new Error("can not find " + type + " in WaftNumType!");
			}
			//
			var d:DisplayObject=getNum(hpNumList, libName);
			if (null == d)
			{
				//d = GamelibS.getswflink("libFight",libName);
				d=GamelibS.getswflink("tong_yong", libName);
				if(null != d){
				d.name=libName;
				}
			}
			//
			if(null != d){
				Object(d).mouseChildren=Object(d).mouseEnabled=false;
				d.cacheAsBitmap=true
				d.removeEventListener(Event.REMOVED_FROM_STAGE, HP_NUM_REMOVED_FROM_STAGE);
				d.addEventListener(Event.REMOVED_FROM_STAGE, HP_NUM_REMOVED_FROM_STAGE);
			}
			return d;
		}
		private static function getNum(list:HashMap, libName:String):DisplayObject
		{
			var d:DisplayObject
			if (list.containsKey(libName))
			{
				var subList:Array=list.get(libName);
				if (subList.length > 0)
				{
					d=subList.shift();
					d.visible=true;
					d.alpha=1.0;
					d.scaleX=d.scaleY=1;
					d.x=0;
					d.y=0;
				}
			}
			//结果有可能为null
			return d;
		}
		/*private static function getChat(list:HashMap,libName : String):DisplayObject
		{
			var d:DisplayObject
			if(list.containsKey(libName))
			{
				var subList:Array = list.get(libName);
				if(subList.length > 0)
				{
					d = subList.shift();
					d.visible = true;
					d.alpha = 1.0;
					d.scaleX=d.scaleY=1;
					d.x = 0;
					d.y = 0;
				}
			}
			//结果有可能为null
			return d;
		}*/
		/*private static function addChat(list:HashMap,libName : String,d:DisplayObject) : void
		{
			if(null == libName ||
				null == d)
			{
				return;
			}
			if("" == libName)
			{
				return;
			}
			//
			if(!list.containsKey(libName))
			{
				list.put(libName,[]);
			}
			var subList:Array = list.get(libName);
			subList.push(d);
		}*/
		private static function addNum(list:HashMap, libName:String, d:DisplayObject):void
		{
			if (null == libName || null == d)
			{
				return;
			}
			if ("" == libName)
			{
				return;
			}
			//			
			if (!list.containsKey(libName))
			{
				list.put(libName, []);
			}
			var subList:Array=list.get(libName);
			subList.push(d);
		}
	}
}
