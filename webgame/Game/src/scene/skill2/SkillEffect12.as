package scene.skill2
{
	import com.bellaxu.def.DepthDef;
	import com.bellaxu.def.LibDef;
	import com.bellaxu.lang.GameLang;
	import com.bellaxu.model.lib.Lib;
	import com.bellaxu.res.ResMc;
	import com.greensock.TweenLite;
	
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_Sys_EffectResModel;
	import common.utils.clock.GameClock;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import netc.Data;
	
	import scene.action.Action;
	import scene.action.BuffActionEnum;
	import scene.event.KingActionEnum;
	import scene.king.IGameKing;
	import scene.king.King;
	import scene.king.SkinBySkill;
	import scene.king.SkinParam;
	import scene.king.TargetInfo;
	import scene.manager.SceneManager;
	import scene.utils.MapCl;
	import scene.utils.MapData;
	
	import world.FileManager;
	import world.WorldEvent;
	import world.graph.WorldSprite;
	import world.model.file.BeingFilePath;
	import world.model.file.SkillFilePath;
	import world.type.BeingType;
	import world.type.ItemType;
	import world.type.WorldType;

	/**
	 * 介于技能效果和mc效果之间的一种
	 *
	 */
	public class SkillEffect12 extends WorldSprite implements ISkillEffect
	{
		public function DelHitArea():void
		{
			//
		}

		public function UpdHitArea():void
		{
			//
		}

		override public function get svr_stop_mapx():Number
		{
			//暂未设置
			return -1;
		}

		override public function get svr_stop_mapy():Number
		{
			//暂未设置
			return -1;
		}

		public static const SKILL_EFFECT_X:int=111;

		//
		//public var targetInfo:TargetInfo;
		public var targetId:uint;
		/**
		 * 技能资源ID
		 */
		private var m_nSkillModelId:int;
		
		public function get skillModelId():int
		{
			return m_nSkillModelId;
		}
		public var path:String;

		public function SkillEffect12()
		{

		}

		public function get skill_model():Pub_Sys_EffectResModel
		{
		//项目转换	return Lib.getObj(LibDef.PUB_SYS_EFFECT, path.toString());
			return XmlManager.localres.SysEffectXml.getResPath(path) as Pub_Sys_EffectResModel;
		}

		/**
		 * 方向 . 美术那边提供的效果不全，因此这里需要根据某些特效写死。
		 * @return
		 *
		 */
		public function get FX():String
		{
			var fx_:String;

			switch (path)
			{
				case "lvlUp":

					fx_="F1";

					break;
				case "booth_area":

					//fx_="F1";
					fx_="F2";

					break;

				case "qianghua_green":
				case "qianghua_blue":
				case "qianghua_orange":
				case "qianghua_purp":
				case "sudu":
					fx_="F1";

					break;

				case "spa_kissing":

					fx_="F2";

					break;
				
				
				case "yu_boat":
				case "yjf_sword":
 				
					
					fx_="F1";

					//
					var targetK:IGameKing=SceneManager.instance.GetKing_Core(this.targetId);

					if (null != targetK)
					{
						fx_=targetK.roleFX;
					}

					break;

				case "PKKinger":
					fx_="F1";
					break;

				case "huoBanJoin":
					fx_="F1";
					break;

				case "xiuLian":
					fx_="F1";
					break;

				case "soul":
					fx_="F1";
					break;

				case "virus":
					fx_="F1";
					break;

				case "sword":
					fx_="F1";
					break;

				case "godArm":
					fx_="F1";
					break;
				
				case "sneak_effect":
					fx_="F1";
					break;
				
				case "pk_ranshao":
					fx_="F1";
					break;
				
				case "wudi":
					fx_="F1";
					break;
				
				case "pet_skill1":					
				case "pet_skill2":
					fx_="F1";
					break;
				
				
				case "boss2_effect":
					fx_="F1";
					break;
				
				case "boss3_effect":
					fx_="F1";
					break;
				
				case "boss4_effect":
					fx_="F1";
					break;
				
				case "boss4_effect1":
					fx_="F1";
					break;

				case "effect_boss29":
					fx_="F1";
					break;

				case "effect_boss30":
					fx_="F1";
					break;

				case "effect_show1":
					fx_="F1";
					break;

				case "effect_show2":
					fx_="F1";
					break;

				case "zhenfa1": // 阵法特效 1
					fx_="F1";
					break;
				case "zhenfa2": // 阵法特效 2
					fx_="F1";
					break;
				case "zhenfa3": // 阵法特效 3
					fx_="F1";
					break;
				case "zhenfa4": // 阵法特效 4
					fx_="F1";
					break;
				case "zhenfa5": // 阵法特效 5
					fx_="F1";
					break;
				case "zhenfa6": // 阵法特效 6
					fx_="F1";
					break;
				case "zhenfa7": // 阵法特效 7
					fx_="F1";
					break;
				case BuffActionEnum.Defense_Attr:
					fx_="F1";
					break;
				default:
					throw new Error("can not switch source:" + path);
			}

			return fx_;
		}

		/**
		 * 动作
		 * @return
		 *
		 */
		public function get DZ():String
		{
			var dz_:String;

			switch (path)
			{
				case "lvlUp":

					dz_=KingActionEnum.DJ;

					break;

				case "booth_area":

					dz_=KingActionEnum.DJ;

					break;

				case "qianghua_green":
				case "qianghua_blue":
				case "qianghua_orange":
				case "qianghua_purp":
				case "sudu":

					dz_=KingActionEnum.DJ;

					break;

				case "spa_kissing":
					dz_=KingActionEnum.DJ;
					break;

				case "yu_boat":		
					dz_=KingActionEnum.DJ;
					break;
				
				case "yjf_sword":
				
					//dz_=KingActionEnum.PB;
					dz_=KingActionEnum.DJ;
					break;

				case "PKKinger":
					dz_=KingActionEnum.DJ;
					break;

				case "huoBanJoin":
					dz_=KingActionEnum.DJ;
					break;

				case "xiuLian":
					//美术关于这一块经常搞错
					//dz_ = KingActionEnum.XL;
					dz_=KingActionEnum.DJ;
					break;

				case "soul":
					dz_=KingActionEnum.GJ;
					break;

				case "virus":
					dz_=KingActionEnum.GJ;
					break;

				case "sword":
					dz_=KingActionEnum.DJ;
					break;
				case "godArm":
					dz_=KingActionEnum.DJ;
					break;
				
				
				case "sneak_effect":
					dz_=KingActionEnum.DJ;
					break;
				
				case "pk_ranshao":
					dz_=KingActionEnum.DJ;
					break;
				
				case "wudi":
					dz_=KingActionEnum.DJ;
					break;
				
				case "pet_skill1":
					dz_=KingActionEnum.DJ;
					break;
				
				case "pet_skill2":
					dz_=KingActionEnum.DJ;
					break;
				
				case "boss2_effect":
					dz_=KingActionEnum.DJ;
					break;
				
				case "boss3_effect":
					dz_=KingActionEnum.DJ;
					break;
				
				case "boss4_effect":
					dz_=KingActionEnum.DJ;
					break;
				
				case "boss4_effect1":
					dz_=KingActionEnum.DJ;
					break;

				case "effect_boss29":
					dz_=KingActionEnum.DJ;
					break;

				case "effect_boss30":
					dz_=KingActionEnum.DJ;
					break;

				case "effect_show1":
					dz_=KingActionEnum.DJ;
					break;

				case "effect_show2":
					dz_=KingActionEnum.DJ;
					break;

				case "zhenfa1": //阵法特效 1
					dz_=KingActionEnum.DJ;
					break;
				case "zhenfa2": //阵法特效 2
					dz_=KingActionEnum.DJ;
					break;
				case "zhenfa3": //阵法特效 3
					dz_=KingActionEnum.DJ;
					break;
				case "zhenfa4": //阵法特效 4
					dz_=KingActionEnum.DJ;
					break;
				case "zhenfa5": //阵法特效 5
					dz_=KingActionEnum.DJ;
					break;
				case "zhenfa6": //阵法特效 6
					dz_=KingActionEnum.DJ;
					break;
				case "zhenfa7": //阵法特效 7
					dz_=KingActionEnum.DJ;
					break;
				case BuffActionEnum.Defense_Attr:
					dz_=KingActionEnum.DJ;//默认为待机，临时修改为攻击D3 2014.5.7
					break;
				default:
					throw new Error("can not switch source:" + path);
			}

			return dz_;
		}

		/**
		 * 播放动画次数  0 表示无限次数播放， 1 表示只播放一次  2 表示两次，以此类推。
		 * @return
		 *
		 */
		public function get PC():int
		{
			var pc_:int;

			switch (path)
			{
				case "lvlUp":

					pc_=1;

					break;


				case "booth_area":

					pc_=0;

					break;

				case "qianghua_green":
				case "qianghua_blue":
				case "qianghua_orange":
				case "qianghua_purp":
				case "sudu":

					pc_=0;

					break;

				case "spa_kissing":
					pc_=0;
					break;

				case "yjf_sword":
				case "yu_boat":
					pc_=0;
					break;

				case "PKKinger":
					pc_=1;
					break;

				case "huoBanJoin":
					pc_=1;
					break;

				case "xiuLian":
					pc_=0;
					break;

				case "soul":
					pc_=0;
					break;

				case "virus":
					pc_=0;
					break;

				case "sword":
					pc_=0;
					break;

				case "godArm":
					pc_=0;
					break;

				case "zhenfa1": // 阵法  1
					pc_=0;
					break;

				case "zhenfa2": // 阵法  2
					pc_=0;
					break;


				case "zhenfa3": // 阵法  3
					pc_=0;
					break;


				case "zhenfa4": // 阵法  4
					pc_=0;
					break;


				case "zhenfa5": // 阵法  5
					pc_=0;
					break;


				case "zhenfa6": // 阵法  6
					pc_=0;
					break;


				case "zhenfa7": // 阵法  7
					pc_=0;
					break;
				
				case "sneak_effect":
					pc_=0;
					break;
				
				case "pk_ranshao":
					pc_=0;
					break;
				
				case "wudi":
					pc_=0;
					break;
				
				case "boss2_effect":
					pc_=0;
					break;
				
				case "boss3_effect":
					pc_=0;
					break;
				
				case "boss4_effect":
					pc_=0;
					break;
				
				case "boss4_effect1":
					pc_=0;
					break;

				case "effect_boss29":
					pc_=0;
					break;

				case "effect_boss30":
					pc_=0;
					break;

				case "effect_show1":
					pc_=0;
					break;

				case "effect_show2":
					pc_=0;
					break;
				case BuffActionEnum.Defense_Attr:
					pc_=1;
					break;
				default:
					throw new Error("can not switch source:" + path);
			}

			return pc_;

		}

		/**
		 * 动作做了一半要执行什么函数
		 * @return
		 *
		 */
		public function get POA():Function
		{
			var poa_:Function;

			switch (path)
			{
				case "lvlUp":

					poa_=null;

					break;

				case "booth_area":

					poa_=null;

					break;

				case "qianghua_green":
				case "qianghua_blue":
				case "qianghua_orange":
				case "qianghua_purp":
				case "sudu":

					poa_=null;

					break;

				case "spa_kissing":
					poa_=null;
					break;

				case "yjf_sword":
				case "yu_boat":
					poa_=null;
					break;

				case "PKKinger":
					poa_=null;
					break;

				case "huoBanJoin":
					poa_=null;
					break;

				case "xiuLian":
					poa_=null;
					break;

				case "soul":
					poa_=null;
					break;

				case "virus":
					poa_=null;
					break;

				case "sword":
					poa_=null;
					break;

				case "godArm":
					poa_=null;
					break;

				case "zhenfa1":
					poa_=null;
					break;

				case "zhenfa2":
					poa_=null;
					break;

				case "zhenfa3":
					poa_=null;
					break;

				case "zhenfa4":
					poa_=null;
					break;

				case "zhenfa5":
					poa_=null;
					break;

				case "zhenfa6":
					poa_=null;
					break;

				case "zhenfa7":
					poa_=null;
					break;
				case BuffActionEnum.Defense_Attr:
					poa_=null;
					break;
				default:
					throw new Error("can not switch source:" + path);
			}

			return poa_;


		}

		/**
		 * 动画移动时间，主要是 TweenLite 中参数使用
		 * @return
		 *
		 */
		public function get moveTime():int
		{
			var t:Number;

			switch (path)
			{
				case "pet_skill1":
				case "pet_skill2":
					t=SkillEffectManager.BiShaJi_Pet_MOVE_TIME;
					break;				
				
				case "PKKinger":
					t=SkillEffectManager.PKKinger_MOVE_TIME;
					break;

				case "huoBanJoin":
					t=SkillEffectManager.HOBANJOIN_MOVE_TIME;
					break;

				case "hpAdd":
					t=SkillEffectManager.HPADD_MOVE_TIME;
					break;

				case "mpAdd":
					t=SkillEffectManager.MPADD_MOVE_TIME;
					break;

				case "fuhuo":
					t=SkillEffectManager.FUHUO_MOVE_TIME;
					break;

				case "lvlUp":
					t=SkillEffectManager.LVLUP_MOVE_TIME;
					break;

				case "caiJi":
					t=SkillEffectManager.CAIJI_MOVE_TIME;
					break;
				case BuffActionEnum.Defense_Attr:
					t = 1.5;
					break;
				default:
					throw new Error("can not switch source:" + path);
			}

			return t;
		}

		/**
		 * 本类不需要objid
		 */
		override public function get name2():String
		{
			return "";
		}

		/**
		 * @private
		 */
		override public function set name2(value:String):void
		{
			//_name2 = value;
		}

		override public function get mapy():Number
		{
			return 0;
		}

		override public function get mapx():Number
		{
			return 0;
		}

		override public function set mapy(value:Number):void
		{
			//_mapy = value;
		}

		override public function set mapx(value:Number):void
		{
			//_mapx = value;
		}



		public function init():void
		{
			this.mouseEnabled=this.mouseChildren=false;
			this.visible=true;
			this.depthPri = DepthDef.NORMAL;
		}

		//public function setData(targetInfo_:TargetInfo):void
		/**
		 * 设置目标对象的 objid 和  特效类型的字符串 例如： 修炼特效 --> "xiuLian"
		 * @param targetId_    对象的 objid
		 * @param path_        特效类型的字符串
		 *
		 */
		public function setData(targetId_:uint, path_:String):void
		{
			this.targetId=targetId_;
			//this.targetInfo = targetInfo_.clone();
			this.path=path_;
			//海战：自身背后的强化光对其他玩家不可见
			if (targetId != Data.myKing.objid && SceneManager.instance.isAtSeaWar())
			{
				this.visible=false;
			}
		}

		public function get target_info():TargetInfo
		{
			return null;
		}

		public function get isMe():Boolean
		{
			return false;
		}

		public function get isMePet():Boolean
		{
			return false;
		}

		public function get isMeMon():Boolean
		{
			return false;
		}

		/**
		 * 创建效果文件
		 */
		public function One_CreateEffect():void
		{
			//自身			
			var d:DisplayObject=getDisplayContent();

			//自身效果,如没有,d可为null

			if (null == d)
			{
				return;
			}

			this.addChild(d);
		}


		/**
		 * 增加到人物身上
		 */
		public function Two_AddChild():void
		{
			var GameKing:IGameKing=SceneManager.instance.GetKing_Core(this.targetId);

			if (null == GameKing)
			{
				return;
			}

			
			
			this.y=0;
			this.x=0;
			specialPos=false;
			//指定添加到人物身上的位置
			switch (this.path)
			{
				case "lvlUp":
					GameKing.getSkin().effectUp.addChild(this);
					break;
				case "booth_area":

															this.y=-50;
					
					GameKing.getSkin().foot.addChild(this);
					break;

				case "spa_kissing":
					GameKing.getSkin().effectUp.addChild(this);
				break;
				
				case "sneak_effect":
					GameKing.getSkin().effectUp.addChild(this);
					break;				
				
				case "pk_ranshao":
					GameKing.getSkin().effectUp.addChild(this);
					break;
				
				case "wudi":
					GameKing.getSkin().effectUp.addChild(this);
					specialPos = true;
					Action.instance.fight.playSkillReleaseSoundEffect(401209);
					break;
				
				case "pet_skill1":
				case "pet_skill2":
					GameKing.getSkin().foot.addChild(this);
					specialPos=false;
					break;
				
				case "boss2_effect":
					GameKing.getSkin().effectUp.addChild(this);
					break;
				
				case "boss3_effect":
					GameKing.getSkin().foot.addChild(this);
					break;
				
				case "boss4_effect":
					GameKing.getSkin().foot.addChild(this);
					break;
				
				case "boss4_effect1":
					GameKing.getSkin().foot.addChild(this);
					break;

				case "effect_boss29":
					GameKing.getSkin().foot.addChild(this);
					break;
				case "effect_boss30":
					GameKing.getSkin().foot.addChild(this);
					break;
				case "effect_show1":
					GameKing.getSkin().foot.addChild(this);
					break;
				case "effect_show2":
					GameKing.getSkin().foot.addChild(this);
					break;
				case "PKKinger":
					GameKing.getSkin().effectUp.addChild(this);
					break;
				case "huoBanJoin":
					GameKing.getSkin().effectUp.addChild(this);
					break;
				case "yjf_sword":
				case "yu_boat":
				case "sword":
				case "godArm":
				
				case "sudu":
					Two_Sub_RefreshPos(GameKing);
					specialPos=true;
					break;
				
				case "qianghua_green":
				case "qianghua_blue":
				case "qianghua_orange":
				case "qianghua_purp":
					
					Two_Sub_RefreshPos(GameKing);
					//GameKing.getSkin().effectDown.addChild(this);
					break;
				
				case "zhenfa1":
					GameKing.getSkin().foot.addChild(this);
					break;
				case "zhenfa2":
					GameKing.getSkin().foot.addChild(this);
					break;
				case "zhenfa3":
					GameKing.getSkin().foot.addChild(this);
					break;
				case "zhenfa4":
					GameKing.getSkin().foot.addChild(this);
					break;
				case "zhenfa5":
					GameKing.getSkin().foot.addChild(this);
					break;
				case "zhenfa6":
					GameKing.getSkin().foot.addChild(this);
					break;
				case "zhenfa7":
					GameKing.getSkin().foot.addChild(this);
					break;
				case BuffActionEnum.Defense_Attr:
					GameKing.getSkin().effectUp.addChild(this);
					break;
				default:
					GameKing.getSkin().effectUp.addChild(this);
					break;
			}
			if (!specialPos&&skill_model)
			{
				this.x=skill_model.effect_pos.split(",")[0];
				this.y=skill_model.effect_pos.split(",")[1];
			}
			
			//
			if("yu_boat" == this.path)
			{
				Two_Sub_RefreshFx(GameKing,KingActionEnum.DJ);
				
			}else
			{
				Two_Sub_RefreshFx(GameKing);
			}
			
		}
		private var specialPos:Boolean=false;

		
		public function Two_Sub_RefreshFx(k:IGameKing,dz_:String = ""):void
		{
			//loop use
			var i:int;

			//调整方向
			var d:DisplayObject;

			for (i=0; i < this.numChildren; i++)
			{
				d=this.getChildAt(i);

				if (d as ResMc)
				{
					if("" == dz_)
					{
						MapCl.setFangXiang(d as ResMc, this.DZ, this.FX, k, this.PC);
					}
					else
					{
						MapCl.setFangXiang(d as ResMc, dz_, this.FX, k, this.PC);
					}
				}
				else if (d as SkinBySkill)
				{
					//
					if("" == dz_)
					{
						(d as SkinBySkill).setAction(this.DZ, this.FX, this.PC, null);
					
					}else
					{
						MapCl.setFangXiang(d as ResMc, dz_, this.FX, k, this.PC);
					}
				}

			} //end for	
		}

		private function Two_Sub_RefreshPos(k:IGameKing):void
		{

			if (null == k)
			{
				return;
			}

			var roleFx:String=k.roleFX;

			switch (roleFx)
			{
				case "F1":

					//--------------------- qiangHuaColor -------------------------------------------------------
					if ("qianghua_green" == this.path || "qianghua_blue" == this.path || "qianghua_orange" == this.path || "qianghua_purp" == this.path)
					{
						//飞行变身
						if (null != k.getSkin().filePath && 31000031 == k.getSkin().filePath.s2)
						{
							//this.y=k.getSkin().loading.contentHeight * -1 + 60;
						}
						else
						{
							//85是green元件的高度
							this.y=Action.instance.fight.GetRoleHeight(k) * -1 + 45;//85;
						}


						
						if (null == this.parent)
						{
							k.getSkin().effectDown.addChild(this);
						}
					}
					
					//--------------------------- sudu --------------------------
					if("sudu" == this.path)
					{
						if (null == this.parent)
						{
							this.y = -60;
							k.getSkin().effectUp.addChild(this);
						}
					}



					//--------------------- godArm --------------------------------------------------------------
					if ("godArm" == this.path)
					{
//						//同3
//						this.x =  (k.getSkin().loading.contentWidth - 5) * -1;
//						//95是剑的高度						
//						this.y = Action.instance.fight.GetRoleHeight(k) * -1 + 55 - 10;
//						
//						if(null == this.parent)
//						{
//							k.getSkin().effectDown.addChild(this);
//						}

					}

					//-------------------- sword --------------------------------------------------------------
					if ("sword" == this.path)
					{
						//同3
						this.x=63 - 10;//k.getSkin().loading.contentWidth - 10;
						//95是剑的高度
						this.y=Action.instance.fight.GetRoleHeight(k) * -1 + 10 - 10;

						//由于movie监听了removed_from_stage，因此只可用一层，即effectDown
						if (null == this.parent)
						{
							//k.getSkin().effectDown.addChild(this);
							k.getSkin().effectUp.addChild(this);
						}

					}
					//-------------------------yjf_sword-----------------------------------------

					if ("yjf_sword" == this.path)
					{
						this.x=0;

						//注意是加在foot上,该物件当前方向的高度/2
						this.y = 100;

						if (null == this.parent)
						{
							k.getSkin().foot.addChild(this);
						}

					}
					
					//-------------------------yu_boat-----------------------------------------
					
					if ("yu_boat" == this.path)
					{
						if(k.getSkin().hasHorse)
						{
							this.x=0;
							
							//注意是加在foot上,该物件当前方向的高度/2
							//this.y=176 / 2;
							this.y=0;
						
						}else
						{
							this.x=0;
						
							this.y=-186/2;
						}
						
						if (null == this.parent)
						{
							k.getSkin().foot.addChild(this);
						}
						
					}
					if ("wudi" == this.path)
					{
						this.y = -50;
						if ((k as King).onHorse())
						{
							if (k.roleZT == KingActionEnum.PB)
							{
								this.y = -35;
							}
							else
							{
								this.y = -40;
							}
						}
					}

					break;

				case "F2":

					//--------------------- qiangHuaColor -------------------------------------------------------
					if ("" == this.path || "qianghua_blue" == this.path || "qianghua_orange" == this.path || "qianghua_purp" == this.path)
					{
						//飞行变身
						if (null != k.getSkin().filePath && 31000031 == k.getSkin().filePath.s2)
						{
							//this.y=k.getSkin().loading.contentHeight * -1 + 60;
						}
						else
						{
							//85是green元件的高度
							this.y=Action.instance.fight.GetRoleHeight(k) * -1 + 45;
						}
						if (null == this.parent)
						{
							k.getSkin().effectDown.addChild(this);
						}
					}
					
					//--------------------------- sudu --------------------------
					if("sudu" == this.path)
					{
						if (null == this.parent)
						{
							this.y = -60;
							k.getSkin().effectUp.addChild(this);
						}
					}

					//--------------------- godArm --------------------------------------------------------------
//					if("godArm" == this.path)
//					{
//						this.x =  (k.getSkin().loading.contentWidth - 5) * -1;
//						//95是剑的高度
//						this.y = Action.instance.fight.GetRoleHeight(k) * -1 + 55 - 10;
//						
//						if(null == this.parent)
//						{
//							k.getSkin().effectDown.addChild(this);
//						}
//					}

					//-------------------- sword --------------------------------------------------------------
					if ("sword" == this.path)
					{
						this.x=63 - 10;//k.getSkin().loading.contentWidth - 10;
						//95是剑的高度
						this.y=Action.instance.fight.GetRoleHeight(k) * -1 + 10 - 10;

						//由于movie监听了removed_from_stage，因此只可用一层，即effectDown
						if (null == this.parent)
						{
							k.getSkin().effectUp.addChild(this);
						}
					}

					//-------------------------yjf_sword-----------------------------------------

					if ("yjf_sword" == this.path)
					{
						this.x = -50;

						//注意是加在foot上,该物件当前方向的高度/2
						this.y = 80;

						if (null == this.parent)
						{
							k.getSkin().foot.addChild(this);
						}

					}
					
					if ("yu_boat" == this.path)
					{
						if(k.getSkin().hasHorse)
						{
							this.x=160;
							
							//注意是加在foot上,该物件当前方向的高度/2
							if(10601001 == k.getSkin().filePath.s1){
							
								this.y=-30;
								
							}else{
								this.y= 0;
							}				
						
						}else
						{
							
							this.x=160;
							
							//注意是加在foot上,该物件当前方向的高度/2
							this.y=-100/2;
						
						}
						
						if (null == this.parent)
						{
							k.getSkin().foot.addChild(this);
						}
						
					}
					if ("wudi" == this.path)
					{
						this.y = -50;
						if ((k as King).onHorse())
						{
							if (k.roleZT == KingActionEnum.PB)
							{
								this.y = -45;
							}
						}
					}
					break;
				case "F3":

					//--------------------- qiangHuaColor -------------------------------------------------------
					if ("qianghua_green" == this.path || "qianghua_blue" == this.path || "qianghua_orange" == this.path || "qianghua_purp" == this.path)
					{
						//飞行变身
						if (null != k.getSkin().filePath && 31000031 == k.getSkin().filePath.s2)
						{
							//this.y=k.getSkin().loading.contentHeight * -1 + 60;
						}
						else
						{
							//85是green元件的高度
							this.y=Action.instance.fight.GetRoleHeight(k) * -1 + 45;
						}
						if (null == this.parent)
						{
							k.getSkin().effectDown.addChild(this);
						}
					}

					//--------------------------- sudu --------------------------
					if("sudu" == this.path)
					{
						if (null == this.parent)
						{
							this.y = -60;
							k.getSkin().effectUp.addChild(this);
						}
					}

					
					//--------------------- godArm --------------------------------------------------------------
//					if("godArm" == this.path)
//					{
//						this.x =  (k.getSkin().loading.contentWidth - 5) * -1;
//						//95是剑的高度
//						this.y = Action.instance.fight.GetRoleHeight(k) * -1 + 55 - 10;
//						
//						if(null == this.parent)
//						{
//							k.getSkin().effectDown.addChild(this);
//						}
//					}

					//-------------------- sword --------------------------------------------------------------
					if ("sword" == this.path)
					{
						this.x=63- 10;//k.getSkin().loading.contentWidth - 10;
						//95是剑的高度
						this.y=Action.instance.fight.GetRoleHeight(k) * -1 + 10 - 10;

						//由于movie监听了removed_from_stage，因此只可用一层，即effectDown
						if (null == this.parent)
						{
							k.getSkin().effectUp.addChild(this);
						}
					}

					//-------------------------yjf_sword-----------------------------------------

					if ("yjf_sword" == this.path)
					{
						this.x = -60;

						//注意是加在foot上,该物件当前方向的高度/2
						this.y = 60;

						if (null == this.parent)
						{
							k.getSkin().foot.addChild(this);
						}

					}
					
					if ("yu_boat" == this.path)
					{
						if(k.getSkin().hasHorse)
						{
							this.x=240;
							
							//注意是加在foot上,该物件当前方向的高度/2
							if(10601001 == k.getSkin().filePath.s1){
								this.y=-30;
							}else{
								this.y=30;//30;							
							}
							
						}else{
						
							this.x=240;
							
							//注意是加在foot上,该物件当前方向的高度/2
							this.y=-20;
							
						}
						
						if (null == this.parent)
						{
							k.getSkin().foot.addChild(this);
						}
					}
					if ("wudi" == this.path)
					{
						this.y = -50;
					}
					break;
				case "F4":

					//--------------------- qiangHuaColor -------------------------------------------------------
					if ("qianghua_green" == this.path || "qianghua_blue" == this.path || "qianghua_orange" == this.path || "qianghua_purp" == this.path)
					{
						//飞行变身
						if (null != k.getSkin().filePath && 31000031 == k.getSkin().filePath.s2)
						{
							//this.y=k.getSkin().loading.contentHeight * -1 + 60;
						}
						else
						{
							//85是green元件的高度
							this.y=Action.instance.fight.GetRoleHeight(k) * -1 + 45;
						}
						if (null == this.parent)
						{
							k.getSkin().effectDown.addChild(this);
						}
					}
					
					//--------------------------- sudu --------------------------
					if("sudu" == this.path)
					{
						if (null == this.parent)
						{
							this.y = -60;
							k.getSkin().effectUp.addChild(this);
						}
					}


					//--------------------- godArm --------------------------------------------------------------
//					if("godArm" == this.path)
//					{
//						this.x =  (k.getSkin().loading.contentWidth - 5) * -1;
//						//95是剑的高度
//						this.y = Action.instance.fight.GetRoleHeight(k) * -1 + 55 - 10;
//						
//						if(null == this.parent)
//						{
//							k.getSkin().effectDown.addChild(this);
//						}
//					}

					//-------------------- sword --------------------------------------------------------------
					if ("sword" == this.path)
					{
						this.x=63 - 10;//k.getSkin().loading.contentWidth - 10;
						//95是剑的高度
						this.y=Action.instance.fight.GetRoleHeight(k) * -1 + 10 - 10;

						//由于movie监听了removed_from_stage，因此只可用一层，即effectDown
						if (null == this.parent)
						{
							k.getSkin().effectUp.addChild(this);
						}
					}
					//-------------------------yjf_sword-----------------------------------------

					if ("yjf_sword" == this.path)
					{
						
						this.x =  -30;

						//注意是加在foot上,该物件当前方向的高度/2
						this.y =  60;						

						if (null == this.parent)
						{
							k.getSkin().foot.addChild(this);
						}

					}

					
					
					if ("yu_boat" == this.path)
					{
						if(k.getSkin().hasHorse)
						{
							this.x=180;
							
							if(10601001 == k.getSkin().filePath.s1){
							
								this.y=20;
							}
							else{
							//注意是加在foot上,该物件当前方向的高度/2
							this.y=228/2;														
							}
						}else
						{
							
							this.x=180;
							
							//注意是加在foot上,该物件当前方向的高度/2
							this.y=50;
							
						}
						
						if (null == this.parent)
						{
							k.getSkin().foot.addChild(this);
						}
					}
					if ("wudi" == this.path)
					{
						this.y = -50;
					}

					break;

				case "F5":

					//--------------------- qiangHuaColor -------------------------------------------------------
					if ("qianghua_green" == this.path || "qianghua_blue" == this.path || "qianghua_orange" == this.path || "qianghua_purp" == this.path)
					{
						//飞行变身
						if (null != k.getSkin().filePath && 31000031 == k.getSkin().filePath.s2)
						{
							//this.y=k.getSkin().loading.contentHeight * -1 + 60;
						}
						else
						{
							//85是green元件的高度
							this.y=Action.instance.fight.GetRoleHeight(k) * -1 + 45;
						}
						if (null == this.parent)
						{
							k.getSkin().effectDown.addChild(this);
						}
					}
					
					//--------------------------- sudu --------------------------
					if("sudu" == this.path)
					{
						if (null == this.parent)
						{
							this.y = -60;
							k.getSkin().effectUp.addChild(this);
						}
					}


					//--------------------- godArm --------------------------------------------------------------
//					if("godArm" == this.path)
//					{
//						
//						//同7
//						this.x =  k.getSkin().loading.contentWidth - 5;
//						//95是剑的高度
//						this.y = Action.instance.fight.GetRoleHeight(k) * -1 + 55 - 10;
//						
//						//由于movie监听了removed_from_stage，因此只可用一层，即effectDown
//						if(null == this.parent)
//						{
//							k.getSkin().effectDown.addChild(this);
//						}
//						
//					}

					//-------------------- sword --------------------------------------------------------------
					if ("sword" == this.path)
					{
						//同7
						this.x=(63 - 10) * -1;//(k.getSkin().loading.contentWidth - 10) * -1;
						//95是剑的高度
						this.y=Action.instance.fight.GetRoleHeight(k) * -1 + 10 - 10;

						if (null == this.parent)
						{
							k.getSkin().effectUp.addChild(this);
						}

					}
					//-------------------------yjf_sword-----------------------------------------

					if ("yjf_sword" == this.path)
					{
						this.x=0;

						//注意是加在foot上,该物件当前方向的高度/2
						this.y = 80;

						if (null == this.parent)
						{
							k.getSkin().foot.addChild(this);
						}

					}
					
					//-------------------------yu_boat-----------------------------------------
					
					if ("yu_boat" == this.path)
					{
						
						if(k.getSkin().hasHorse)
						{
							this.x=0;
							
							//注意是加在foot上,该物件当前方向的高度/2
							this.y=228/2;							
							
						}else
						{
						
							this.x=0;
							
							//注意是加在foot上,该物件当前方向的高度/2
							this.y=80;
						
						}
						
						
						if (null == this.parent)
						{
							k.getSkin().foot.addChild(this);
						}
						
					}
					if ("wudi" == this.path)
					{
						if (k.roleZT == KingActionEnum.PB)
						{
							this.y = -55;
//							this.x = -2;
//							if ((k as King).onHorse())
//								this.y = -25;
						}else
						{
							this.y = -50;
//							this.x = 0;
//							if ((k as King).onHorse())
//								this.y = -20;
						}
					}
					break;

				case "F6":

					//--------------------- qiangHuaColor -------------------------------------------------------
					if ("qianghua_green" == this.path || "qianghua_blue" == this.path || "qianghua_orange" == this.path || "qianghua_purp" == this.path)
					{
						//飞行变身
						if (null != k.getSkin().filePath && 31000031 == k.getSkin().filePath.s2)
						{
							//this.y=k.getSkin().loading.contentHeight * -1 + 60;
						}
						else
						{
							//85是green元件的高度
							this.y=Action.instance.fight.GetRoleHeight(k) * -1 + 45;
						}
						if (null == this.parent)
						{
							k.getSkin().effectDown.addChild(this);
						}
					}
					
					//--------------------------- sudu --------------------------
					if("sudu" == this.path)
					{
						if (null == this.parent)
						{
							this.y = -60;
							k.getSkin().effectUp.addChild(this);
						}
					}


					//--------------------- godArm --------------------------------------------------------------
//					if("godArm" == this.path)
//					{
//						this.x =  k.getSkin().loading.contentWidth - 5;
//						//95是剑的高度
//						this.y = Action.instance.fight.GetRoleHeight(k) * -1 + 55 - 10;
//						
//						//由于movie监听了removed_from_stage，因此只可用一层，即effectDown
//						if(null == this.parent)
//						{
//							k.getSkin().effectDown.addChild(this);
//						}
//					}

					//-------------------- sword --------------------------------------------------------------
					if ("sword" == this.path)
					{
						this.x=(63 - 10) * -1;//(k.getSkin().loading.contentWidth - 10) * -1;
						//95是剑的高度
						this.y=Action.instance.fight.GetRoleHeight(k) * -1 + 10 - 10;

						if (null == this.parent)
						{
							k.getSkin().effectUp.addChild(this);
						}
					}

					//-------------------------yjf_sword-----------------------------------------

					if ("yjf_sword" == this.path)
					{
						this.x =  30;

						//注意是加在foot上,该物件当前方向的高度/2
						this.y = 99/2;

						if (null == this.parent)
						{
							k.getSkin().foot.addChild(this);
						}

					}
					
					if ("yu_boat" == this.path)
					{
						if(k.getSkin().hasHorse)
						{
							this.x=-200;
							
							if(10601001 == k.getSkin().filePath.s1){
								this.y=30;
							}else{
							//注意是加在foot上,该物件当前方向的高度/2
							this.y=228/2;							
							}
							
						}else
						{
							this.x=-180;
							
							//注意是加在foot上,该物件当前方向的高度/2
							this.y=60;
						
						}
						
						if (null == this.parent)
						{
							k.getSkin().foot.addChild(this);
						}
						
					}
					if ("wudi" == this.path)
					{
						this.y = -50;
					}
					break;
				case "F7":

					//--------------------- qiangHuaColor -------------------------------------------------------
					if ("qianghua_green" == this.path || "qianghua_blue" == this.path || "qianghua_orange" == this.path || "qianghua_purp" == this.path)
					{
						//飞行变身
						if (null != k.getSkin().filePath && 31000031 == k.getSkin().filePath.s2)
						{
							//this.y=k.getSkin().loading.contentHeight * -1 + 60;
						}
						else
						{
							//85是green元件的高度
							this.y=Action.instance.fight.GetRoleHeight(k) * -1 + 45;
						}
						if (null == this.parent)
						{
							k.getSkin().effectDown.addChild(this);
						}
					}

					//--------------------------- sudu --------------------------
					if("sudu" == this.path)
					{
						if (null == this.parent)
						{
							this.y = -60;
							k.getSkin().effectUp.addChild(this);
						}
					}

					
					//--------------------- godArm --------------------------------------------------------------
//					if("godArm" == this.path)
//					{
//						this.x =  k.getSkin().loading.contentWidth - 5;
//						//95是剑的高度
//						this.y = Action.instance.fight.GetRoleHeight(k) * -1 + 55 - 10;
//						
//						//由于movie监听了removed_from_stage，因此只可用一层，即effectDown
//						if(null == this.parent)
//						{
//							k.getSkin().effectDown.addChild(this);
//						}
//					}

					//-------------------- sword --------------------------------------------------------------
					if ("sword" == this.path)
					{
						this.x=(63 - 10) * -1;//(k.getSkin().loading.contentWidth - 10) * -1;
						//95是剑的高度
						this.y=Action.instance.fight.GetRoleHeight(k) * -1 + 10 - 10;

						if (null == this.parent)
						{
							k.getSkin().effectUp.addChild(this);
						}
					}

					//-------------------------yjf_sword-----------------------------------------

					if ("yjf_sword" == this.path)
					{
						this.x =  60;

						//注意是加在foot上,该物件当前方向的高度/2
						this.y = 60;

						if (null == this.parent)
						{
							k.getSkin().foot.addChild(this);
						}

					}
					
					if ("yu_boat" == this.path)
					{
						if(k.getSkin().hasHorse)
						{
							this.x=-220;
							
							//注意是加在foot上,该物件当前方向的高度/2
							
							if(10601001 == k.getSkin().filePath.s1){
								this.y=-30;
							}else{							
								this.y=30;//30;							
							}
							
						}else
						{
							this.x=-220;
							
							//注意是加在foot上,该物件当前方向的高度/2
							this.y=-30;
													
						}
						
						if (null == this.parent)
						{
							k.getSkin().foot.addChild(this);
						}
						
					}
					if ("wudi" == this.path)
					{
						this.y = -50;
					}
					break;

				case "F8":

					//--------------------- qiangHuaColor -------------------------------------------------------
					if ("qianghua_green" == this.path || "qianghua_blue" == this.path || "qianghua_orange" == this.path || "qianghua_purp" == this.path)
					{
						//飞行变身
						if (null != k.getSkin().filePath && 31000031 == k.getSkin().filePath.s2)
						{
							//this.y=k.getSkin().loading.contentHeight * -1 + 60;
						}
						else
						{
							//85是green元件的高度
							this.y=Action.instance.fight.GetRoleHeight(k) * -1 + 45;
						}
						if (null == this.parent)
						{
							k.getSkin().effectDown.addChild(this);
						}
					}
					
					//--------------------------- sudu --------------------------
					if("sudu" == this.path)
					{
						if (null == this.parent)
						{
							this.y = -60;
							k.getSkin().effectUp.addChild(this);
						}
					}


					//--------------------- godArm --------------------------------------------------------------
//					if("godArm" == this.path)
//					{
//						this.x =  k.getSkin().loading.contentWidth - 5;
//						//95是剑的高度
//						this.y = Action.instance.fight.GetRoleHeight(k) * -1 + 55 - 10;
//						
//						//由于movie监听了removed_from_stage，因此只可用一层，即effectDown
//						if(null == this.parent)
//						{
//							k.getSkin().effectDown.addChild(this);
//						}
//					}

					//-------------------- sword --------------------------------------------------------------
					if ("sword" == this.path)
					{
						this.x=(63 - 10) * -1;//(k.getSkin().loading.contentWidth - 10) * -1;
						//95是剑的高度
						this.y=Action.instance.fight.GetRoleHeight(k) * -1 + 10 - 10;

						if (null == this.parent)
						{
							k.getSkin().effectUp.addChild(this);
						}
					}
					//-------------------------yjf_sword-----------------------------------------

					if ("yjf_sword" == this.path)
					{
						this.x = 40;	

						//注意是加在foot上,该物件当前方向的高度/2
						this.y = 60;

						if (null == this.parent)
						{
							k.getSkin().foot.addChild(this);
						}

					}
					
					if ("yu_boat" == this.path)
					{
						if(k.getSkin().hasHorse)
						{
							this.x=-220;
							
							if(10601001 == k.getSkin().filePath.s1){
								this.y=-60;	
							}else{
							//注意是加在foot上,该物件当前方向的高度/2
							this.y=-20;							
							}
							
						}else
						{
							this.x=-200;
							
							//注意是加在foot上,该物件当前方向的高度/2
							this.y=-60;
						
						}
						
						if (null == this.parent)
						{
							k.getSkin().foot.addChild(this);
						}
						
					}
					if ("wudi" == this.path)
					{
						this.y = -50;
						if ((k as King).onHorse())
						{
							if (k.roleZT == KingActionEnum.PB)
							{
								this.y = -45;
							}
						}
					}
					break;

			}



		}



		/**
		 * 可看成是play
		 */
		public function Three_Move():void
		{
			//
			if ("sword" == path || 
				"godArm" == path || 
				"yjf_sword" == path ||
				"yu_boat" == path ||
				"qianghua_green" == path || 
				"qianghua_blue" == path || 
				"qianghua_orange" == path || 
				"qianghua_purp" == path ||
				"sudu" == path 
				||"wudi" == path
//				|| path == BuffActionEnum.Defense_Attr
			)
			{
				GameClock.instance.removeEventListener(WorldEvent.CLOCK__, Three_Sub_FrameHandler);
				GameClock.instance.addEventListener(WorldEvent.CLOCK__, Three_Sub_FrameHandler);

				return;
			}

			//一直显示，除非调用Four_MoveComplete
			if ("xiuLian" == path || 
				"soul" == path || 
				"virus" == path || 
				"sword" == path || 
				"godArm" == path || 
				"yjf_sword" == path || 
				"yu_boat" == path ||
				"spa_kissing" == path || 
				"effect_show1" == path || 
				"effect_show2" == path || 
				"zhenfa1" == path || 
				"zhenfa2" == path || 
				"zhenfa3" == path || 
				"zhenfa4" == path || 
				"zhenfa5" == path || 
				"zhenfa6" == path || 
				"zhenfa7" == path || 
				"qianghua_green" == path || 
				"qianghua_blue" == path || 
				"qianghua_orange" == path || 
				"qianghua_purp" == path || 
				"sudu" == path ||
				"booth_area" == path || 
				
				"boss2_effect" == path ||
				"boss3_effect" == path ||
				"boss4_effect" == path ||
				"boss4_effect1" == path ||
				
				"effect_boss29" == path || 
				"effect_boss30" == path ||
			
				"sneak_effect" == path ||
				"pk_ranshao" == path ||
				"wudi" == path 
//				||
//				path == BuffActionEnum.Defense_Attr
			)
			{
				return;
			}

			//
			TweenLite.to(this, moveTime, {onComplete: Four_MoveComplete}

				);
		}

		public function Three_Sub_FrameHandler(e:Event):void
		{
			var k:IGameKing=SceneManager.instance.GetKing_Core(this.targetId);

			if (null == k)
			{
				return;
			}
			if(k.s2.toString().indexOf("310")>=0){//变身状态下不显示系统buff特效
				visible = false;
			}
			else
			{
				visible = true;
			}
			this.Two_Sub_RefreshPos(k);

			if ("yjf_sword" == path ||
				"yu_boat" == path ||
				"godArm" == path)
			{
				//refresh fx
				this.Two_Sub_RefreshFx(k);
			}			

		}


		/**
		 * 飘血
		 */
		public function Four_MoveComplete():void
		{
			//
			GameClock.instance.removeEventListener(WorldEvent.CLOCK__, this.Three_Sub_FrameHandler);
			TweenLite.killTweensOf(this,true);
			//
			clear();

		}




		public function clear():void
		{
			var len:int=this.numChildren;

			var d:DisplayObject;
			for (var i:int=0; i < len; i++)
			{
				d=this.removeChildAt(0);

				if (d as SkinBySkill)
				{
					(d as SkinBySkill).removeAll();

				}
				else if (d as ResMc)
				{
					//(d as Movie).stop();
					(d as ResMc).close();
				}
			}

			//
			if (null != this.parent)
			{
				this.parent.removeChild(this);
			}
		}



		public function getDisplayContent():DisplayObject
		{
			var d:DisplayObject;
			var bfp:SkillFilePath;
			var npcId:int;

			switch (path)
			{
				case 'lvlUp':
					bfp=FileManager.instance.getSkill12FileByFileName("lvlUp");
					d=SkillEffectManager.instance.getPoolBy12(bfp);
					break;


				case "booth_area":

					bfp=FileManager.instance.getSkill12FileByFileName("booth_area");
					d=SkillEffectManager.instance.getPoolBy12(bfp);

					break;

				case "qianghua_green":

					bfp=FileManager.instance.getSkill12FileByFileName("qianghua_green");
					d=SkillEffectManager.instance.getPoolBy12(bfp);

					break;

				case "qianghua_blue":

					bfp=FileManager.instance.getSkill12FileByFileName("qianghua_blue");
					d=SkillEffectManager.instance.getPoolBy12(bfp);

					break;
				case "qianghua_orange":

					bfp=FileManager.instance.getSkill12FileByFileName("qianghua_orange");
					d=SkillEffectManager.instance.getPoolBy12(bfp);

					break;
				case "qianghua_purp":

					bfp=FileManager.instance.getSkill12FileByFileName("qianghua_purp");
					d=SkillEffectManager.instance.getPoolBy12(bfp);

					break;
				
				case "sudu":
					bfp=FileManager.instance.getSkill12FileByFileName("sudu");
					d=SkillEffectManager.instance.getPoolBy12(bfp);
					break;
				
				case "yjf_sword":

					bfp=FileManager.instance.getSkill12FileByFileName("yjf_sword");

					d=SkillEffectManager.instance.getPoolBy12(bfp);

					break;
				
				case "yu_boat":
					
					bfp=FileManager.instance.getSkill12FileByFileName("yu_boat");
					
					d=SkillEffectManager.instance.getPoolBy12(bfp);
					
					break;

				case "xiuLian":

					bfp=FileManager.instance.getSkill12FileByFileName("xiuLian");

					d=SkillEffectManager.instance.getPoolBy12(bfp);

					break;

				case "soul":

					bfp=FileManager.instance.getSkill12FileByFileName("soul");

					d=SkillEffectManager.instance.getPoolBy12(bfp);

					break;

				case "virus":

					bfp=FileManager.instance.getSkill12FileByFileName("virus");

					d=SkillEffectManager.instance.getPoolBy12(bfp);

					break;

				case "PKKinger":

					bfp=FileManager.instance.getSkill12FileByFileName("PKKinger");

					d=SkillEffectManager.instance.getPoolBy12(bfp);

					break;


				case "huoBanJoin":

					bfp=FileManager.instance.getSkill12FileByFileName("huoBanJoin");

					d=SkillEffectManager.instance.getPoolBy12(bfp);


					break;

				case "sword":

					bfp=FileManager.instance.getSkill12FileByFileName("sword");
					d=SkillEffectManager.instance.getPoolBy12(bfp);

					break;

				case "godArm":

					bfp=FileManager.instance.getSkill12FileByFileName("godArm");

					d=SkillEffectManager.instance.getPoolBy12(bfp);

					break;
				
				case "sneak_effect":
					
					bfp=FileManager.instance.getSkill12FileByFileName("sneak_effect");
					
					d=SkillEffectManager.instance.getPoolBy12(bfp);
					
					break;
				
				case "pk_ranshao":
					
					bfp=FileManager.instance.getSkill12FileByFileName("pk_ranshao");
					
					d=SkillEffectManager.instance.getPoolBy12(bfp);
					
					break;
				
				case "wudi":
					
					bfp=FileManager.instance.getSkill12FileByFileName("wudi");
//					bfp.loopFrame = 4;
					bfp.playTime = 1933;
					d=SkillEffectManager.instance.getPoolBy12(bfp);
					
					break;
				
				case "pet_skill1":
					
					bfp=FileManager.instance.getSkill12FileByFileName("pet_skill1");
					
					d=SkillEffectManager.instance.getPoolBy12(bfp);
					
					break;
				
				case "pet_skill2":
					
					bfp=FileManager.instance.getSkill12FileByFileName("pet_skill2");
					
					d=SkillEffectManager.instance.getPoolBy12(bfp);
					
					break;
				
				case "boss2_effect":
					
					bfp=FileManager.instance.getSkill12FileByFileName("boss2_effect");
					
					d=SkillEffectManager.instance.getPoolBy12(bfp);
					
					break;
				
				case "boss3_effect":
					
					bfp=FileManager.instance.getSkill12FileByFileName("boss3_effect");
					
					d=SkillEffectManager.instance.getPoolBy12(bfp);
					
					break;
				
				case "boss4_effect":
					
					bfp=FileManager.instance.getSkill12FileByFileName("boss4_effect");
					
					d=SkillEffectManager.instance.getPoolBy12(bfp);
					
					break;

				case "boss4_effect1":
					
					bfp=FileManager.instance.getSkill12FileByFileName("boss4_effect1");
					
					d=SkillEffectManager.instance.getPoolBy12(bfp);
					
					break;

				case "effect_boss29":

					bfp=FileManager.instance.getSkill12FileByFileName("effect_boss29");

					d=SkillEffectManager.instance.getPoolBy12(bfp);

					break;

				case "effect_boss30":

					bfp=FileManager.instance.getSkill12FileByFileName("effect_boss30");

					d=SkillEffectManager.instance.getPoolBy12(bfp);

					break;

				case "effect_show1":
					bfp=FileManager.instance.getSkill12FileByFileName("effect_show1");

					d=SkillEffectManager.instance.getPoolBy12(bfp);

					break;

				case "effect_show2":

					bfp=FileManager.instance.getSkill12FileByFileName("effect_show2");

					d=SkillEffectManager.instance.getPoolBy12(bfp);
					break;


				case "zhenfa1": // 阵法效果
					bfp=FileManager.instance.getSkill12FileByFileName("zhenfa1");
					d=SkillEffectManager.instance.getPoolBy12(bfp);
					break;
				case "zhenfa2": // 阵法效果
					bfp=FileManager.instance.getSkill12FileByFileName("zhenfa2");
					d=SkillEffectManager.instance.getPoolBy12(bfp);
					break;
				case "zhenfa3": // 阵法效果
					bfp=FileManager.instance.getSkill12FileByFileName("zhenfa3");
					d=SkillEffectManager.instance.getPoolBy12(bfp);
					break;
				case "zhenfa4": // 阵法效果
					bfp=FileManager.instance.getSkill12FileByFileName("zhenfa4");
					d=SkillEffectManager.instance.getPoolBy12(bfp);
					break;
				case "zhenfa5": // 阵法效果
					bfp=FileManager.instance.getSkill12FileByFileName("zhenfa5");
					d=SkillEffectManager.instance.getPoolBy12(bfp);
					break;
				case "zhenfa6": // 阵法效果
					bfp=FileManager.instance.getSkill12FileByFileName("zhenfa6");
					d=SkillEffectManager.instance.getPoolBy12(bfp);
					break;
				case "zhenfa7": // 阵法效果
					bfp=FileManager.instance.getSkill12FileByFileName("zhenfa7");
					d=SkillEffectManager.instance.getPoolBy12(bfp);
					break;
				case BuffActionEnum.Defense_Attr://防御力增强效果(魔龙战甲)
					bfp=FileManager.instance.getSkill12FileByFileName(path);
					d=SkillEffectManager.instance.getPoolBy12(bfp);
					break;
				default:
					throw new Error("can not switch source:" + path);
			}
			return d;
		}

		public function get hasSkinBySkillAndRoleLoaded():Boolean
		{
			//loop use
			var i:int;

			//调整方向
			var d:DisplayObject;

			for (i=0; i < this.numChildren; i++)
			{
				d=this.getChildAt(i);

				if (d as ResMc)
				{
					return true;

				}
				else if (d as SkinBySkill)
				{
					if (null != (d as SkinBySkill).getRole())
					{
						return true;
					}
				}

			} //end for

			return false;
		}
	}
}
