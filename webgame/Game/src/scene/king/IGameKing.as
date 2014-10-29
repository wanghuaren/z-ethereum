package scene.king {
	import flash.geom.Point;
	
	import netc.dataset.GuildInfo;
	
	import world.IWorld;
	import world.WorldPoint;
	import world.model.file.BeingFilePath;

	public interface IGameKing extends IWorld
	{	
		
		/**
		 * 显示部分
		 * 效果
		 */ 
		function checkMouseEnable():void;
		
		function checkFootEffect():void;
		
		function CenterAndShowMap():void;
		
		function CenterAndShowMap2():void;
		
			
		//function getEffectBody() : IGameEffect;

		function get roleAngle():int		
		
		function set roleAngle(value:int):void
			
		function get roleFX():String;	
		
		function set roleFX(value:String):void;
		
		function get roleZT():String;
		
		function set roleZT(value:String):void;
						
		function get mouseClicked():Boolean;
		
		function set mouseClicked(value:Boolean):void;		
		
		function get hasBeAttacked():Boolean;
		
		function set hasBeAttacked(value:Boolean):void;
		
		function get isBoat():Boolean;
			
		/**
		 * 声音部分
		 * 
		 */ 
		function setKingSound(Attack : String, Hurt : String, Death : String,Shout:String) : void;
		
		function playSoundShout():void;
		
		function playSoundAttack():void;
		
		function playSoundHurt():void;
		
		function playSoundDeath():void;
		
		/**
		 * 数据部分
		 */ 		
		function get qianMing():String;
		
		function get grade():int;	
		
		function set grade(value:int):void;		
				
		
	    function get getKingFX():int;
		
		function setKingData(roleID:int, 
											  objid:uint,
											  name : String, 
											  sex:int,
											  metier : int ,
											  level:int,
											  hp:int,
											  maxhp:int,
											  camp:int,
											  campName:int,
											  mapx : int, 
											  mapy : int,
											  masterId:int,
											  masterName:String,
											  mapzonetype:int,
											  grade:int,
		                                      isMe_:Boolean=false) : void;		

		function setKingSkin(value:BeingFilePath) : void;
		function setKingSkinData(s0:int,s1:int,s2:int,s3:int):void;
		
		function get s0():int;
		function get s1():int;
		function get s2():int;
		function get s3():int;
		
		function setKingSkill(metier:int): void;
		
		function setGradeTitle(value:String):void;
		
		function setCanDriveOff(value:Boolean):void;
		
		function get canDriveOff():Boolean;
		
		function get gradeTitle():String;
		
		/**
		 *  zt 状态
		 *  fx 方向
		 */ 
		function get skin_attack_to_target_delay():int;
		
		function setKingAction(zt : String,fx : String = null,skill:int=-1,targetInfo:TargetInfo=null,needShowAction:Boolean=false) : void;
		function setKingMoveTarget(path:Point,curPo:Point=null,isjump:int=0,zt:String=null) : void;
		
		function set setKingMoveWay(way:Array) : void;
				function get getTargetPoint():Point;
		
		
		//
		function get wayPoint():Point;
		
		function get curPoint():Point;
		
		
		function get hasPower():Boolean;
		
		
		function setKingMoveStop(stand:Boolean=false) : void;
		
		function setLastServerMoveStop(stop_mapx:int,stop_mapy:int):void
		function setKingPosXY(px : Number,py : Number) : void;

		//function getEffectFoot() : IGameEffect ;		
		function getSkin():Skin ;
		
		function getSkill():SkillInfo;
		
		function getPet():PetInfo;
		
		function getMon():MonInfo;
		
		
		
		//IGameKingData
		//function initKingData() : void;
		
		//function get getKing() : King;
		
		//function set setKing(king : King) : void;
		
		function get roleID() : int;
		
		function get objid():uint;
		
		function get dbID() : int;
		
		function set dbID(id : int) : void;
		
		
		function get qiangZhi_show_name():Boolean;
		
		function get qiangZhi_noshow_level():Boolean;
		
		
		function get isMe() : Boolean;
		
		function get isMeTeam() : Boolean;
		
		function get isMePet() : Boolean;
		
		function get isMeMon():Boolean;
		
		function get getKingGroup() : int;
		
		function set setKingGroup(group : int) : void;
				
		
		/**
		 * 军阶
		 */ 
		function get ploit() : int;
		function set setPloitByInit(value : int) : void;
		function set setPloit(value : int) : void;
		
		/**
		 * 阵营
		 * 判断专用
		 */
		function get camp() : int;
		function set setCamp(value : int) : void;
		
		function get isSameCampId():Boolean;
		
		/**
		 * 用于显示阵营名称
		 */		
		function get campName():int;
		function set setCampName(value:int):void;
		
		
		
		function get level() : int ;
		function set setLevel(n : int) : void ;
		
		
		
		function set setMetier(metier:int):void
		/**
		 * 职业 3 战士 4法师 1 道士 6 刺客
		 * */
		function get metier():int;
		
		
		
		function set setBuff(value : int) : void;
		
		function get buff() : int;		
				
		
		
		function set setSex(value : int) : void;
		
		function get sex() : int;
		
				
		
		function get masterName():String;
		
		function get masterId():int;
		
		function  setMasterName(valueId:int,value:String):void;
		
		function  set updMasterName(value:String):void;
		
				
		/**
		 * 
		 * @return 是否处于战斗中
		 * 
		 */
		function get inCombat():Boolean;
		/**
		 * 
		 * @param 是否处于战斗中
		 * 
		 **/		
		function set inCombat(value:Boolean):void;

		function get isFirstInCombat():Boolean;
		
		function set isFirstInCombat(value:Boolean):void;
		
		
		function set setTeamId(n : int) : void;
		
		function get teamId() : int;
		
		
				
		function set setTeamListID(id : int) : void;
		
		function get getTeamListID() : int;
		
		
		
		function set setTeamleader(n : int) : void ;
		
		function get teamleader() : int ;
		
		
		function set setBoothName(value : String) : void;
		
		function setBoothNameByInit(value:String):void;
		
		function get getBoothName():String;
		
		function set setKingName(value : String) : void;
		
		function get getKingName() : String ;
				
		function set setNpcType(type : int) : void;
		
		function get getKingType() : int;
								
		function set setVisible(bo : Boolean) : void;
		
		function get getVisible() : Boolean;
		
		function localToGlobal(point:Point):Point;
		
		function globalToLocal(point:Point):Point;
		
		
		function get hp() : int ;
		function set hp(value:int):void;
		function set setHp(n : int) : void ;
		
		function setHpByinit(hp_:int,maxHp_:int):void;		
		
		function get mp() : int ;
		
		function set setMp(n : int) : void ;
		
		
		
		function get maxHp() : int ;
		
		function set setMaxHp(n : int) : void;
		
		
		
		function get maxMp() : int ;
		
		function set setMaxMp(n : int) : void ;
		
		
		
		function set setHeadIcon(icon : String) : void;
		
		function get getHeadIcon() : String;
		
		//function set name(names : String) : void;
		
		//function get name() : String;
		
		//function set name2(names : String) : void;
		
		//function get name2() : String;
		
		
		function get getSkinLoaded() : Boolean;		
		
		
		function set setSpeed(n : Number) : void;
		
		function get speed() :int;	
		
		
		
		function set setExp(n : int) : void ;
		
		function get exp() : int ;
		
		
		
		function set setVIP(vip : int) : void ;
		
		function setVIPByInit(vip:int):void;
		
		function get vip() : int ;				
		
		function setYellowVip(type:int,lvl:int,qqyellowvip:int):void;
		
		function setYellowVipByInit(type:int,lvl:int,qqyellowvip:int):void;
		
		function get yellowVip():Array;
		
		function get qqyellowvip():int;		
		
		function set3366Lvl(lvl:int):void;
		
		function get qq3366Lvl():int;
		
		
		
		function set setExercise(value : int) : void ;
		
		function setExerciseByInit(value:int):void;
		
		function get exercise() : int ;
		
		
		
		function set setCoupleid(value:int):void;
		
		function setCoupleidByInit(value:int):void;
		
		function get coupleid() : int ;
		
		function get coupleidName():String;
		
		
		function get isOfflineXiuLian():Boolean;
		
		function get isKissing():Boolean;
		
		/**
		 * 摆摊
		 */			
		function get isBooth():Boolean;
		
		/**
		 * 跳跃
		 */ 
		function get isJump():Boolean;
		
		/**
		 * 是否为躲猫猫中的鬼
		 */ 
		function get isGhost():Boolean;
		
		function get isStun():Boolean;
		
		function get isGhost2():Boolean;
	
		function get isQianXing():Boolean;
		
		function get isD4():Boolean;
		
		function set setColor(color : int) : void ;
		
		function get getColor() : int ;
		
				
		function get outLook():int;
		
		function set outLook(value:int):void;
		
		
		function get pk():int;
		
		function set setPk(value:int):void;
		
		function setPkByInit(value:int):void;
		
		
		
		function get pkValue():int;
		
		function get isPkEnvir():Boolean;
		
		function set setPkValue(value:int):void;
		
		function set setPkValueInit(value:int):void;
		
		
		
		
		
		function set r1(value:int):void;
		
		function get qiangHuaColor():String;
		
		function get mapZoneType():int;
		
		function set setMapZoneType(value:int):void;
		
		
		
		function get fightInfo():FightInfo;
		
		function setFightInfo(source:String,target_objid:uint,target_p:WorldPoint = null):void;
		
		
		
		
		function get talkInfo():TalkInfo;
		
		function setTalkInfo(source:String,target_objid:uint,target_p:WorldPoint = null):void;
		
		
		function get xiuLianInfo():XiuLianInfo;
		
		
		//king内部更新变量，不提外部set方法
		function get CSAttackLock() :Boolean;
				
		/**
		 * 称号
		 */
		function set setTitle(title : int) : void ;
		
		function get title() :Array ;
				
		/**
		 * 西游
		 */
		function set setIsXiYou(value:int):void;
		
		function get isXiYou():Boolean;
		
		
		//家族
		function get guildInfo():GuildInfo; 
		
		function setGuildInfo(guildId:int,guildName:String,guildDuty:int,guildWang:int):void;
		
		//鼠标点击无反映
		function get selectable():Boolean;
		
		function set setSelectable(value:Boolean):void;		
		
		
		function SendPlayerRemoveScene():void;
		
		function mustDie():void;
		
		function delayDie():void;
		
		function checkDieState():void;
		
		function get wifename():String;
	}
}
