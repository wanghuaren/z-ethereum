package scene.king
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import scene.event.KingActionEnum;
	
	import world.model.file.BeingFilePath;
	
	public class JumpKing extends King
	{
		
		public function JumpKing()
		{
			init();
		}
		
		override public function init():void
		{						
			this._roleZT =  KingActionEnum.DJ;
			this._roleFX = "F1";
			this._roleAngle = 22;
			this._rolePC = 0;
			
			
			//由于是二进制判断，因此默认为0
			this.$buff = 0;
			
			this._targetInfo = null;
			
			this._byPickInfo = null;
			
			this._seList = null;
			
			this.curPoint = null;
			this.targetPoint = null;
			this._fightInfo = null;
			this._talkInfo = null;
			this._xiuLianInfo = null;
			
			this._grade = 0;
			this._title=0;
			
			this._pk = -1;
			
			$exercise = 0;
			
			// ...........
			//skin = null;
			// ...........
			
			$KingGroup=0;
			$teamId=0;
			$TeamListID=0;
			$KingName="";
			
			$inCombat = false;
			
			$NpcType=0;
			$metier=0;
			$hp=0;
			$maxHp=0;
			$mp=0;
			$maxMp=0;
			$roleID=0;
			
			this.initObjid();
			
			$HeadIcon="";
			$level=0;
			$speed=0;
			//$SoundAttack=null;
			//$SoundHurt=null;
			//$SoundDeath=null;
			$exp=0;
			$vip=0;
			
			$underWrite = 0;			
			$underWrite_p1 = 0;
			$underWrite_p2 = 0;
			
			if (!this.hasEventListener(Event.REMOVED_FROM_STAGE))
			{
				this.addEventListener(Event.REMOVED_FROM_STAGE, removeStage);
			}
			
			
		}
		
		
		override public function setKingData(role_id:int, 
											 objid_:uint, 
											 role_name:String, 
											 role_sex:int, 
											 role_metier:int,
											 role_level:int,
											 role_hp:int,
											 role_maxhp:int,
											 role_camp:int,	
											 role_camp_name:int,
											 role_mapx:int, 
											 role_mapy:int,
											 masterId:int,
											 masterName:String,
											 mapzonetype:int,
											 monster_grade:int,
											 isMe_:Boolean=false):void
		{
			
			this.$roleID=role_id;
			
			this.objid=objid_;
			
			this.$KingName = role_name;
			
			this.$sex = role_sex;
			
			this.$metier = role_metier;
			
			this.$level = role_level;
			
			this.$hp = role_hp;
			
			this.$maxHp = role_maxhp;
			
			this.$Camp = role_camp;
			
			this.$CampName = role_camp_name;
			
			this.$MasterId = masterId;
			
			this.$MasterName = masterName;
			
			this.mapx = role_mapx;
			this.mapy = role_mapy;	
			
			this.svr_stop_mapx = role_mapx;
			this.svr_stop_mapy = role_mapy;
			
			this._mapZoneType = mapzonetype;
			
			this._grade = monster_grade;			
			
		}
		
		override public function setKingSkin(filePath:BeingFilePath):void
		{
			//
			this.getSkin().setSkin(filePath);	
		}
		
		override public function UpdateSkin():void
		{
			this.getSkin().UpdateSkin();
			
		}
		
		override public function setKingAction(zt:String, fx:String=null, skill:int=-1, targetInfo:TargetInfo=null,needShowAction:Boolean=false):void
		{		
			
			//
			if (null == zt)
			{
				zt = this.roleZT;
			}
			
			//
			if (null == fx)
			{
				fx = this.roleFX;
			}
			
			//
			this._roleZT=zt;
			this._roleFX=fx;
			
			this.getSkin().setAction(zt, fx,0,null);
			
		}
		
		public function removeStage(e:Event):void
		{
			removeAll();
		}
	}
}