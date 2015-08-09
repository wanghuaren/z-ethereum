package scene.king
{
	import com.bellaxu.mgr.TargetMgr;
	import com.bellaxu.res.ResMc;

	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_ModelResModel;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	import netc.Data;

	import scene.action.Action;
	import scene.action.PkModeEnum;
	import scene.event.KingActionEnum;
	import scene.human.GameHuman;
	import scene.kingname.KingHeadName;
	import scene.kingname.KingNameColor;
	import scene.skill2.ISkillEffect;
	import scene.utils.MapCl;

	import world.FileManager;
	import world.WorldEvent;
	import world.WorldFactory;
	import world.model.file.BeingFilePath;
	import world.type.BeingType;
	import world.type.ItemType;

	public class Skin extends Sprite
	{
		//点击区域
		private var m_nHitSprite:Sprite=new Sprite();
		public static const SKIN_NUM:int=4;

		/**
		 * 主显示
		 */
		public static const MAIN_DISPLAY_LAYER:int=2;

		/**
		 * 坐骑层
		 */
		public static const ZOJ_DISPLAY_LAYER:int=1;

		//skin
		public var skinLoaderList:Array;

		public var filePath:BeingFilePath;
		public var oldFilePath:BeingFilePath;

		private var _roleList:Array;

		//other
		//private var _headName:KingHeadName;
		private var _headNameList:Array;

		private var _roleFX:String;

		/**
		 * 技能层
		 * */
		private var _foot:Sprite;
		private var _rect:Sprite;
		private var _effectUp:Sprite;

		private var _changedList:Array;

		public function Skin()
		{
			init();
		}

		private function init():void
		{
			this.removeAll();
			m_nHitSprite.mouseEnabled=false;
			filePath=null;
			oldFilePath=null;
			_changedList=null;
			_roleFX="F1";

			skinLoaderList=[];

			var skLoader:SkinLoader;

			for (var i:int=0; i < SKIN_NUM; i++)
			{
				skLoader=new SkinLoader(i);
				skinLoaderList.push(skLoader);
			}

			_roleList=new Array();
			for (i=0; i < SKIN_NUM; i++)
			{
				_roleList[i]=null;
			}

			_headNameList=new Array();

			for (i=0; i < 1; i++)
			{
				_headNameList[i]=null;
			}
		}

		public function get changedList():Array
		{
			if (null == _changedList)
				_changedList=[false, false, false, false];
			return _changedList;
		}

		public function set changedList(value:Array):void
		{
			_changedList=value;
		}

		public function get king():King
		{
			return this.parent as King;
		}

		public function set king(nowking:King):void
		{
			if (null == nowking)
				return;
			nowking.addChild(this);
			//人物整体往下移 
			//TODO 需要增加高效的判断函数
			if (nowking.name2.indexOf(BeingType.HUMAN) >= 0)
				this.y=SkinParam.HUMAN_SKIN_DOWN;
			//TODO 需要增加高效的判断函数
			if (nowking.name2.indexOf(BeingType.MON) >= 0 || nowking.name2.indexOf(BeingType.PET) >= 0)
				this.y=SkinParam.HUMAN_SKIN_DOWN;
			//TODO 为何加这么多Sprite ？？？
			this.addChild(m_nHitSprite);
			m_nHitSprite.visible=false;
			this.addChild(foot);
			//this.addChild(effectDown);
			this.addChild(rect);
			//TODO 人物头上的显示信息需要优化
			this.addChild(effectUp);
			//effectDown.y=0;
			effectUp.y=0;

			var _KingHeadName:KingHeadName=getHeadName();
			this.addChild(_KingHeadName);
			_KingHeadName.mouseChildren=false;
			_KingHeadName.mouseEnabled=false;

			rect.y=0;
			rect.x=0;
			if (nowking.name2.indexOf(BeingType.SKILL) != -1)
			{
				rect.y=60;
			}

			this.mouseEnabled=this.mouseChildren=false;
		}


		public function setSkin(bfp:BeingFilePath):void
		{
//			if (null == this.getRole() && this.king != null)
//			{
//				this.addChild(this.loading);
//				//換裝時標記之前胡資源形象，等待 切換 場景時回收
//				if (bfp)
//				{
//					for (var j:int=0; j < 4; j++)
//					{
//						var path:String=bfp["swf_path" + j.toString()]
//						var arr:Array=path.split('/')
//						var key:String=arr[arr.length - 1].split('.')[0];
//					}
//				}
//				this.loading.Show(this.king.name2);
//			}
			if (null == this.filePath)
			{
				this.filePath=bfp;
				for (var i:int=0; i < SKIN_NUM; i++)
				{
					changedList[i]=true;
				}
			}
			else
			{
				var old:BeingFilePath=this.filePath.clone();
				changedList=this.filePath.compare(bfp);

				if (true == changedList[0] || true == changedList[1] || true == changedList[2] || true == changedList[3])
					oldFilePath=old;
			}
			if (filePath.s2 == 30120042) //皇城霸主
			{
				rect.x=30;
				rect.y=20;
			}
			//如果全没变化
			if (false == changedList[0] && false == changedList[1] && false == changedList[2] && false == changedList[3])
				return;
			this.UpdateAndLoadSkin();
		}


		private function UpdateAndLoadSkin():void
		{
			var k:King=this.king;
			if (null == k)
				return;
			var king_name2:String=k.name2;
			var king_isMe:Boolean=k.isMe;
			var king_isMePet:Boolean=k.isMePet;
			var i:int;
			var len:int=changedList.length;

			for (i=0; i < len; i++)
			{
				if (changedList[i] && "" == this.filePath["swf_path" + i.toString()])
					this.removeSkin(i);
			}

			//先加载主显示
			var skLoader:SkinLoader;
			if (changedList[Skin.MAIN_DISPLAY_LAYER])
			{
				changedList[Skin.MAIN_DISPLAY_LAYER]=false;

				if ("" != this.filePath["swf_path" + Skin.MAIN_DISPLAY_LAYER.toString()])
				{
					this.skinLoaderList[Skin.MAIN_DISPLAY_LAYER].removeEventListener(WorldEvent.PROGRESS_HAND, skinLoaderProgress, false);
					this.skinLoaderList[Skin.MAIN_DISPLAY_LAYER].removeEventListener(WorldEvent.COMPLETE_HAND, skinLoaderComplete, false);

					this.skinLoaderList[Skin.MAIN_DISPLAY_LAYER].addEventListener(WorldEvent.PROGRESS_HAND, skinLoaderProgress, false, 0, true);
					this.skinLoaderList[Skin.MAIN_DISPLAY_LAYER].addEventListener(WorldEvent.COMPLETE_HAND, skinLoaderComplete, false, 0, true);

					(this.skinLoaderList[Skin.MAIN_DISPLAY_LAYER] as SkinLoader).loading(king_name2, king_isMe, king_isMePet, this.filePath["xml_path" + Skin.MAIN_DISPLAY_LAYER.toString()]);
				}
			}
			else
			{
				for (i=0; i < len; i++)
				{
					if (changedList[i])
					{
						changedList[i]=false;

						if ("" != this.filePath["swf_path" + i.toString()])
						{
							this.skinLoaderList[i].removeEventListener(WorldEvent.PROGRESS_HAND, skinLoaderProgress, false);
							this.skinLoaderList[i].removeEventListener(WorldEvent.COMPLETE_HAND, skinLoaderComplete, false);

							this.skinLoaderList[i].addEventListener(WorldEvent.PROGRESS_HAND, skinLoaderProgress, false, 0, true);
							this.skinLoaderList[i].addEventListener(WorldEvent.COMPLETE_HAND, skinLoaderComplete, false, 0, true);

							(this.skinLoaderList[i] as SkinLoader).loading(king_name2, king_isMe, king_isMePet, this.filePath["xml_path" + i.toString()]);
						}
					}
				}
				//强制刷新
				skinLoaderComplete();
			}
		}

		public function DestroryLoadSkin():void
		{
			StopLoadSkin();
			for (var i:int=0; i < SKIN_NUM; i++)
			{
				if (null != this.skinLoaderList && this.skinLoaderList.length > i)
					this.getSkinLoader(i).destory();
			}
		}

		public function StopLoadSkin():void
		{
			for (var i:int=0; i < SKIN_NUM; i++)
			{
				if (null != this.skinLoaderList && this.skinLoaderList.length > i)
				{
					this.getSkinLoader(i).clearCallback();
				}
			}
		}

		private function removeSkin(layer:int):void
		{
			if (roleList[layer] != null)
			{
				var rm:ResMc=roleList[layer] as ResMc;
				trace("Skin::removeSkin---------", layer, rm.mcName);
				rm.close(false);
//				if (rm.parent != null)
//					rm.parent.removeChild(rm);
			}
			roleList[layer]=null;

		}

		public function skinLoaderProgress(e:WorldEvent):void
		{

			var layer:int=e.data["layer"];
			var arr:Array=e.data["data"];

			if (MAIN_DISPLAY_LAYER == layer)
			{
				var progressNum:int=arr[0];
				//性能优化
				if (progressNum < 5)
					this.getHeadName().setLoadPress=progressNum;
				else if (progressNum > 95)
					this.getHeadName().setLoadPress=progressNum;
			}
		}

		private function MainRoleLoadComplete():void
		{
//			this.loading.Hide();
			if (null == this.king)
				return;
			if (king is GameHuman)
			{
				this.renderHitSprite();
			}
			this.king.UpdHitArea();
			this.UpdateAndLoadSkin();
			this.UpdOtherColor();
			//this.updHeadNamePos(true);
			//再刷新一次,免得伙伴先进入视野时，找不到主人
			if (this.king.name2.indexOf(BeingType.PET) >= 0)
				setTimeout(UpdOtherColor, 2000);
		}

		public function skinLoaderComplete(e:WorldEvent=null):void
		{
			var k:King=this.king;
			if (null == k)
				return;
			if (null != e)
			{
				var layer:int=e.data["layer"];
				var role:ResMc=e.data["movie"];
				role.mouseEnabled=false;
				role.mouseChildren=false;
				role.rightHand=this.filePath.rightHand;
				removeSkin(layer);
				roleList[layer]=role;
			} //end if
			this.UpdateSkin();
			if (null != e)
			{
				if (Skin.MAIN_DISPLAY_LAYER == layer || Skin.ZOJ_DISPLAY_LAYER == layer)
				{
					if (Skin.MAIN_DISPLAY_LAYER == layer)
						this.MainRoleLoadComplete();
					this.updHeadNamePos(true);
				}
			}
			//RES的hp为0
			if (k.hp == 0 && k.name2.indexOf(BeingType.RES) == -1 && k.name2.indexOf(BeingType.TRANS) == -1)
			{
				//主动激发
				k.roleZT=KingActionEnum.Dead;
			}
			else
			{
				//主动激发
				k.roleFX=_roleFX;
			}
			//头部间隔
			UpdOtherPos();
		}

		private function updQuan():void
		{
			if (null == this.king)
				return;
			for (var i:int=0; i < this.foot.numChildren; i++)
			{
				var d:DisplayObject=this.foot.getChildAt(i);
				if ("TEnemyMC" == d.name)
				{
					TargetMgr.showCampMc(this.king, false);
					break;
				}
			}
		}

		private function updHeadNameColor():void
		{
			var k:King=this.king;

			if (null == k)
				return;
			//现由pkColor决定人的
			if (k.name2.indexOf(BeingType.HUMAN) >= 0)
			{
				//pk颜色最优先
				var _c_:String=KingNameColor.GetPKColor(k.pkValue);

				this.getHeadName().setKingNameColor=_c_;

				if (_c_ != KingNameColor.PK_RED_PLAYER)
				{
					//帮派模式
					var myGuildId:int=Data.myKing.GuildId;

					if (myGuildId > 0)
					{
						if (Data.myKing.PkMode == 2)
						{
							if (k.guildInfo.GuildId != myGuildId)
							{
								this.getHeadName().setKingNameColor=KingNameColor.NO_SAME_GUILD_PLAYER;
							}
						}
					}
					//阵营模式
					if (null != Data.myKing.king && PkModeEnum.Camp == Data.myKing.king.pk && !k.isSameCampId && !FileManager.instance.isSameCmap(Data.myKing.king.camp, k.camp))
					{
						this.getHeadName().setKingNameColor=KingNameColor.NO_SAME_GUILD_PLAYER;
					}
				}
			}
			else if (k.name2.indexOf(BeingType.PET) >= 0 && !Action.instance.fight.chkSameCamp(Data.myKing.king, k))
			{
				this.getHeadName().setKingNameColor=KingNameColor.PK_PLAYER;
			}
			else if (k.name2.indexOf(ItemType.PICK) >= 0)
			{
				//项目转换	var pmrm:Pub_ModelResModel = Lib.getObj(LibDef.PUB_MODEL, k.dbID.toString());
				var pmrm:Pub_ModelResModel=XmlManager.localres.PubModelXml.getResPath(k.dbID) as Pub_ModelResModel;
				var pmrm_color:int;
				if (null == pmrm)
					pmrm_color=0;
				else
					pmrm_color=pmrm.color;
				if (0 == pmrm_color)
					pmrm_color=1;
				this.getHeadName().setKingNameColor=KingNameColor.PICK[pmrm.color - 1];
			}
			else if (k.name2.indexOf(BeingType.MONSTER) >= 0)
			{
				if (k.name2.indexOf(BeingType.NPC) >= 0)
				{
					this.getHeadName().setKingNameColor=KingNameColor.NPC;
				}
				else if (k.name2.indexOf(BeingType.PET) >= 0)
				{
					this.getHeadName().setKingNameColor=KingNameColor.PET;
				}
				else if (k.name2.indexOf(BeingType.TRANS) >= 0)
				{
					this.getHeadName().setKingNameColor=KingNameColor.TRANS;
				}
//				else if (k.name2.indexOf(BeingType.FAKE_HUM) >= 0)
//				{
//					this.getHeadName().setKingNameColor=KingNameColor.SAME_CAMP_PLAYER;
//				}
				else
				{
					//根据npc_grade来
					if (null != Data.myKing.king && PkModeEnum.Camp == Data.myKing.king.pk && !k.isSameCampId && !FileManager.instance.isSameCmap(Data.myKing.king.camp, k.camp))
						this.getHeadName().setKingNameColor=KingNameColor.NO_SAME_GUILD_PLAYER;
					else if (15 == k.grade)
						this.getHeadName().setKingNameColor=KingNameColor.A15_MONSTER;
					else if (14 == k.grade)
						this.getHeadName().setKingNameColor=KingNameColor.A14_MONSTER;
					else if (13 == k.grade)
						this.getHeadName().setKingNameColor=KingNameColor.A13_MONSTER;
					else if (12 == k.grade)
						this.getHeadName().setKingNameColor=KingNameColor.A12_MONSTER;
					else if (11 == k.grade)
						this.getHeadName().setKingNameColor=KingNameColor.A11_MONSTER;
					else if (4 == k.grade)
						this.getHeadName().setKingNameColor=KingNameColor.SAME_CAMP_PLAYER;
					else if (3 == k.grade)
						this.getHeadName().setKingNameColor=KingNameColor.BOSS_MONSTER;
					else if (2 == k.grade)
						this.getHeadName().setKingNameColor=KingNameColor.ELITE_MONSTER;
					else if (1 == k.grade)
						this.getHeadName().setKingNameColor=KingNameColor.NORMAL_MONSTER;
					else if (0 <= k.grade)
						this.getHeadName().setKingNameColor=KingNameColor.NORMAL_MONSTER;
					else
						throw new Error("can not find npc_grade:" + k.grade.toString());
				}
			}

		}

		/**
		 * 强制更新外观
		 */
		public function UpdateSkin():void
		{
			var movie:ResMc=roleList[Skin.MAIN_DISPLAY_LAYER];

			if (movie != null)
			{
				this.addChild(foot);
				this.addChild(rect);
				this.addChild(effectUp);
				this.addChild(getHeadName());
				this.rect.addChild(movie);

				/**
				 * 0,预留
				 * 1,坐骑
				 * 2,角色(不用指定)
				 * 3,武器
				 * */
				movie.mattrix(roleList[0], 0);
				movie.mattrix(roleList[1], 1);
				movie.mattrix(roleList[3], 3);
				setType(this.king.name2, movie, king);
				if (roleList[1] != null)
				{
					if (roleList[1].mcName.indexOf("Main_31000110") >= 0)
					{
						king.roleZT=KingActionEnum.DJ;
					}
					else if (king.roleZT == KingActionEnum.PB)
					{
						king.roleZT=KingActionEnum.ZOJ_PB;
					}
					else if (king.roleZT == KingActionEnum.DJ)
					{
						king.roleZT=KingActionEnum.ZOJ_DJ;
					}
				}
				else
				{
					if (king.roleZT == KingActionEnum.ZOJ_PB)
					{
						king.roleZT=KingActionEnum.PB;
					}
					else if (king.roleZT == KingActionEnum.ZOJ_DJ)
					{
						king.roleZT=KingActionEnum.DJ;
					}
				}
				MapCl.setFangXiang(movie, king.roleZT, king._roleFX, king);
			}
		}

		private function setType(mKingName:String, mMovie:ResMc, _mine:King=null):void
		{
			if (mKingName.indexOf(BeingType.HUMAN) >= 0)
			{
				mMovie.isPlayer=true;
			}
			else if (mKingName.indexOf(BeingType.NPC) >= 0)
			{ //较特殊
				mMovie.isPlayer=false;
				mMovie.isNPC=true;
			}
			else if (mKingName.indexOf(BeingType.MONSTER) >= 0) // || this.king.name2.indexOf(ItemType.PICK) >= 0)
			{
				mMovie.isPlayer=false;
				mMovie.isMonster=true;
			}
			else if (mKingName.indexOf(ItemType.PICK) >= 0)
			{
				mMovie.isPick=true;
			}
			else if (mKingName.indexOf(BeingType.TRANS) >= 0)
			{
				mMovie.isTrans=true;
			}
			else
			{
				mMovie.isOther=true;
			}
			if (_mine != null && Data.myKing.king != null && Data.myKing != null && _mine.masterId == Data.myKing.king.roleID)
				mMovie.isMine=true;
		}

		/**
		 * isReCalculate重新计算
		 * 为true时强制刷新头部
		 */
		private function updHeadNamePos(isReCalc:Boolean=false):void
		{
			var KP:King=this.king;
			if (null == KP)
				return;
			//头部间隔			
			var movie:ResMc=roleList[Skin.MAIN_DISPLAY_LAYER];
			var zoj:ResMc=roleList[Skin.ZOJ_DISPLAY_LAYER];
			var headDistance:int=SkinParam.HEAD_DISTANCE; //20;
			var movieCenterXPadding:int=0; //20;
			var loadWidth:int=110; //loading.contentWidth;
			var loadHeight:int=SkinParam.contentHeight(KP.metier);
			var loadHeight_tmp:int=0;
			var kNameWidth:int=52; //headName.Kname.width = 52
			var loadByHeadHeight:int=(loadHeight + headDistance) * -1; //(loading.contentHeight + headDistance) * -1;
			var loadByHeadWidth:int=loadWidth / 2 - kNameWidth / 2;
			if (null == movie)
			{
				getHeadName().x=loadByHeadWidth;
				getHeadName().y=loadByHeadHeight;
				return;
			}
			//--------------------------------------------------------------------------------------------------------------
			if (this.king.name2.indexOf(BeingType.HUMAN) >= 0)
			{
				movie.isPlayer=true;
				//-偏移量
				if (loadByHeadWidth == getHeadName().x)
					getHeadName().x=0;
				if (0 == getHeadName().y || loadByHeadHeight == getHeadName().y || isReCalc)
				{
					if (null == zoj)
					{
						loadHeight_tmp=movie.height;
						if (0 == loadHeight_tmp)
							loadHeight_tmp=loadHeight;
						getHeadName().y=(loadHeight_tmp + headDistance) * -1;
					}
					else
					{
						loadHeight_tmp=movie.height;
						if (0 == loadHeight_tmp)
							loadHeight_tmp=loadHeight;
						getHeadName().y=(loadHeight_tmp + headDistance) * -1;
					}
				}
			}
			else if (this.king.name2.indexOf(BeingType.NPC) >= 0)
			{ //较特殊
				movie.isPlayer=false;
				movie.isNPC=true;
				//-偏移量
				if (loadByHeadWidth == getHeadName().x)
					getHeadName().x=0;
				if (0 == getHeadName().y || loadByHeadHeight == getHeadName().y)
				{
					loadHeight_tmp=movie.height;
					if (0 == loadHeight_tmp)
						loadHeight_tmp=SkinParam.contentHeightByNPC;
					getHeadName().y=(loadHeight_tmp + headDistance) * -1;
				}
			}
			else if (this.king.name2.indexOf(BeingType.MONSTER) >= 0) // || this.king.name2.indexOf(ItemType.PICK) >= 0)
			{
				movie.isPlayer=false;
				movie.isMonster=true;
				//-偏移量
				if (movie.dir != "F6" && movie.dir != "F7" && movie.dir != "F8")
					getHeadName().x=0;
				else
					getHeadName().x=0;
//				if (0 == getHeadName().y || loadByHeadHeight == getHeadName().y)
				getHeadName().y=(movie.height + headDistance) * -1;
			}
			else if (this.king.name2.indexOf(ItemType.PICK) >= 0)
			{
				if (movie.dir != "F6" && movie.dir != "F7" && movie.dir != "F8")
					getHeadName().x=0;
				else
					getHeadName().x=0;

				if (0 == getHeadName().y || loadByHeadHeight == getHeadName().y)
					getHeadName().y=(movie.height + headDistance) * -1;
				movie.isOther=true;
			}
			else
			{
				movie.isOther=true;
			}
		}

		private function updFootPos():void
		{
			//头部间隔			
			var movie:ResMc=roleList[Skin.MAIN_DISPLAY_LAYER];
			var footDistance:int=-10;
			if (null == this.king)
				return;
			if (null == movie)
			{
				foot.x=0; //this.loading.x;
				foot.y=footDistance;
				return;
			}
			if (this.king.name2.indexOf(BeingType.HUMAN) >= 0 && this.hasHorse)
			{
				foot.x=0;
				foot.y=30;
				return;
			}
			if (null != this.filePath && this.filePath.s2 == SkinParam.PKKING_RES)
			{
				foot.x=0;
				foot.y=-38;
				return;
			}
			foot.x=0;
			foot.y=footDistance;
		}

		public function ChkOther():void
		{
			chkRoleListMovieIsClose();
		}

		public function reload():void
		{
			if (null != this.filePath)
			{
				var filePathClone:BeingFilePath=this.filePath.clone();
				this.filePath=null;
				this.setSkin(filePathClone);
			}
		}

		/**
		 * 仅由king.followList的函数调用，防止变身不成功
		 */
		public function ChkXiYouSkin(followInd:int, bfp:BeingFilePath):void
		{
			if (null == this.king)
				return;
			if (this.king.isXiYou)
			{
				var movie:ResMc=roleList[Skin.MAIN_DISPLAY_LAYER];
				if (null != movie && null != this.filePath && false == changedList[0] && false == changedList[1] && false == changedList[2] && false == changedList[3])
				{
					if (movie.mcName.indexOf(SkinParam.XI_YOU_FOLLOW_SKIN_LIST[followInd]) == -1)
					{
						if (this.filePath.s2 == SkinParam.XI_YOU_FOLLOW_SKIN_LIST[followInd])
							this.filePath=null;
						this.setSkin(bfp);
					}
				}
			}
		}

		private function chkRoleListMovieIsClose():void
		{

			if (null != roleList)
			{
				var allEmpty:Boolean=true;
				var frameIsZero:Boolean=false;
				for (var j:int=0; j < SKIN_NUM; j++)
				{
					if (null != roleList[j])
						allEmpty=false;
				}
				if (null != roleList[Skin.MAIN_DISPLAY_LAYER])
				{
					if (null != this.king && this.king.name2.indexOf(BeingType.NPC) >= 0 && (roleList[Skin.MAIN_DISPLAY_LAYER] as ResMc).dir != this.king._roleFX && 0 == (roleList[Skin.MAIN_DISPLAY_LAYER] as ResMc).frames)
						frameIsZero=true;
				}
				if (allEmpty || frameIsZero)
					this.reload();
			}
		}

		public function UpdOtherPos():void
		{
			updHeadNamePos();
			updFootPos();
			if (null != this.king)
			{
				if (this.king.name2.indexOf(BeingType.HUMAN) >= 0 && this.hasHorse)
					this.y=SkinParam.HUMAN_SKIN_DOWN - SkinParam.RIDE_UP;
				if (this.king.name2.indexOf(BeingType.HUMAN) >= 0 && !this.hasHorse)
					this.y=SkinParam.HUMAN_SKIN_DOWN;
			}
		}

		public function UpdOtherColor(onlyHeadNameColor:Boolean=false):void
		{
			updHeadNameColor();
			if (!onlyHeadNameColor)
				updQuan();
		}
		private var hitMCX:int=0;

		public function setAction(ZT:String, FX:String, PlayCount:int, PlayOverAct:Function, Frame:int=0, midActionIndex:int=-1, midActionHandler:Function=null):void
		{
			if (null != FX)
				_roleFX=FX;

			var Gameking:IGameKing=this.king as IGameKing;

			if (null == Gameking)
				return;
			if (null == this.getRole())
				return;
			m_nHitSprite.scaleX=1;
			m_nHitSprite.x=hitMCX;
			if (hasHorse)
			{
				//改成switch效率更高
				switch (ZT)
				{
					case KingActionEnum.DJ:
						ZT=KingActionEnum.ZOJ_DJ;
						break;

					case KingActionEnum.PB:
					case KingActionEnum.ZL:
						ZT=KingActionEnum.ZOJ_PB;

						m_nHitSprite.scaleX=3;
						m_nHitSprite.x=hitMCX - m_nHitSprite.width * 0.3;

						break;
					case KingActionEnum.GJ:
					case KingActionEnum.GJ1:
					case KingActionEnum.GJ2:
					case KingActionEnum.JiNeng_GJ:
						//ZOJ_GJ动作被砍掉了
						//ZT=KingActionEnum.ZOJ_GJ;
						ZT=KingActionEnum.ZOJ_DJ;
						break;
					case KingActionEnum.Dead:
						ZT=KingActionEnum.ZOJ_Dead;
						break;
				}
				if (roleList[1]!=null&&roleList[1].mcName.indexOf("Main_31000110") >= 0)
				{
					ZT=KingActionEnum.DJ;
				}
			}
			//只用设主显示的方向
//			trace(ZT+","+FX)
			MapCl.setFangXiang(this.getRole(), ZT, FX, Gameking, PlayCount, PlayOverAct, Frame, midActionIndex, midActionHandler);
			UpdOtherPos();
		}

		private var _canShow:Boolean=true;


		public function visibleAll(see:Boolean=true):void
		{
			_canShow=!see;
			this.rect.visible=_canShow;
			this.effectUp.visible=_canShow;
		}

		public function get canShow():Boolean
		{
			return _canShow;
		}

		private function clearDc(dc:DisplayObjectContainer):void
		{
			var d:DisplayObject;
			while (dc.numChildren > 0)
			{
				d=dc.removeChildAt(0);
				if (d as ResMc)
				{
					(d as ResMc).close();
					if (null != (d as ResMc).parent)
						(d as ResMc).parent.removeChild(d);
				}
				else if (d as ISkillEffect)
				{
					(d as ISkillEffect).Four_MoveComplete();
				}
			}
		}

		public function removeAll():void
		{
			DestroryLoadSkin();
			var i:int;
			if (null != _headNameList)
			{
				for (i=0; i < 1; i++)
				{
					if (null != _headNameList[i])
					{
						if (null != (_headNameList[i] as DisplayObject) && null != (_headNameList[i] as DisplayObject).parent)
							(_headNameList[i] as DisplayObject).parent.removeChild((_headNameList[i] as DisplayObject));
					}
					_headNameList[i]=null;
				}
			}

			if (null != _roleList)
			{
				for (i=0; i < SKIN_NUM; i++)
				{
					if (null != _roleList[i])
					{
						(_roleList[i] as ResMc).close();
						if (null != _roleList[i].parent)
							_roleList[i].parent.removeChild(_roleList[i]);
					}
					_roleList[i]=null;
				}
			}
			var dc:DisplayObjectContainer;
			//---------------------------------------------------------------------------------------------------
			if (null != _effectUp)
			{
				dc=this.effectUp;
				clearDc(dc);
			}
			if (null != _rect)
			{
				dc=this.rect;
				clearDc(dc);
			}
			if (null != _foot)
			{
				dc=this.foot;
				clearDc(dc);
			}
			_effectUp=null;
			_rect=null;
			_foot=null;
			while (this.numChildren > 0)
			{
				this.removeChildAt(0);
			}
			//---------------------------------------------------------------------------------------------------
//			while(this.numChildren > 0)
//			{
//				d = this.removeChildAt(0);
//				
//				//
//				if(d as Movie)
//				{
//					(d as Movie).close();
//					
//				}else if(d as ISkillEffect)
//				{
//					(d as ISkillEffect).Four_MoveComplete();
//				}
//				
//				//--------------------------------
//				dc = d as DisplayObjectContainer;
//				
//				if(null != dc)
//				{
//					while(dc.numChildren > 0)
//					{
//						d2 = dc.removeChildAt(0);
//						
//						//
//						if(d2 as Movie)
//						{
//							(d2 as Movie).close();
//						}else if(d2 as ISkillEffect)
//						{
//							(d2 as ISkillEffect).Four_MoveComplete();
//						}
//						
//						
//					}
//				}
//				//--------------------------------
//			}
		}

		//------------------------ get 区  begin ---------------------------------------------------------------------------

		public function get roleList():Array
		{
			return _roleList;
		}

		public function getSkinLoader(INDEX:int):SkinLoader
		{
			if (SKIN_NUM > INDEX)
				return skinLoaderList[INDEX];
			throw new Error("INDEX out side array:" + INDEX);
			return null;
		}

		/**
		 * 主显示
		 */
		public function getRole():ResMc
		{
			var movie:ResMc=roleList[Skin.MAIN_DISPLAY_LAYER];
			return movie;
		}

		public function get hasHorse():Boolean
		{
			if (null == this.filePath)
				return false;
			return this.filePath.hasHorse;
		}


		public function get foot():Sprite
		{
			if (null == _foot)
			{
				_foot=new Sprite();
				_foot.mouseEnabled=_foot.mouseChildren=false;
			}

			return _foot;
		}

		/**
		 * 技能层 容器
		 *
		 * */
		public function get effectUp():Sprite
		{
			if (null == _effectUp)
				_effectUp=WorldFactory.createEffectUp();
			return _effectUp;
		}

		/**
		 * effectDown用foot代替
		 */
		public function get effectDown():Sprite
		{
			return this.effectUp;
		}

		public function getHeadName():KingHeadName
		{
			if (null == _headNameList[0])
				_headNameList[0]=WorldFactory.createKingHeadName();
			return _headNameList[0];
		}

		public function get rect():Sprite
		{
			if (null == _rect)
			{
				_rect=new Sprite();
				_rect.name="rect";
//				_rect.cacheAsBitmap = true;
				_rect.mouseEnabled=_rect.mouseChildren=false;
			}
			return _rect;
		}

		private function renderHitSprite():void
		{
			var role:ResMc=getRole();
			if (!role || !role.curBitmap)
				return;
			var x:int=role.curBitmap.x;
			var y:int=role.curBitmap.y;
			var width:int=role.width;
			var height:int=role.height;
			if (y == 0)
			{
				y=-height;
			}
//			if (m_nHitSprite.width == width && m_nHitSprite.height == height)
//			{
//				return;
//			}
			if (!m_nHitSprite)
				return;
			var g:Graphics=m_nHitSprite.graphics;
			m_nHitSprite.x=-width >> 1;
			m_nHitSprite.y=y;
			g.clear();
			g.beginFill(0);
			g.drawRect(0, 0, width, height);
			g.endFill();
			role.hitArea=m_nHitSprite;
			hitMCX=m_nHitSprite.x;
		}
		//------------------------ get 区  end ---------------------------------------------------------------------------
	}
}
