package scene.skill2
{
	import com.bellaxu.def.DepthDef;
	import com.bellaxu.def.LayerDef;
	import com.greensock.TweenLite;
	
	import common.managers.Lang;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import scene.action.Action;
	import scene.human.GameHuman;
	import scene.human.GameLocalHuman;
	import scene.king.IGameKing;
	import scene.king.King;
	import scene.manager.SceneManager;
	
	import world.IWorld;
	import world.WorldFactory;
	import world.type.BeingType;

	
	public class WaftNumber extends Sprite implements IWorld
	{
		private static var instance:Array=[];
		
		public function DelHitArea():void
		{
			//本类不需要实现该方法
		}

		public function UpdHitArea():void
		{
			//本类不需要实现该方法
		}

		public function get svr_stop_mapx():Number
		{
			//暂未设置
			return -1;
		}

		public function get svr_stop_mapy():Number
		{
			//暂未设置
			return -1;
		}

		//
		public var oriW:Number;
		public var oriH:Number;
		public var oriX:Number;

		//
		private var _zoomIn:Number;

		//r = residual 还剩几次
		public var zoomFrameRCount:Number;

		public var upDistance:int;
		public var moveTime:Number;

		public function WaftNumber()
		{

					}

		public function get kingObjId():uint
		{
			return _kingObjId;
		}

		public function init():void
		{

			this.mouseChildren=this.mouseEnabled=false;
			this.visible=true;
			this.x=this.y=0;
		
			_kingObjId=0;
			this.alpha=1;
			scaleX=scaleY=1;
			
			_num=0;
			_type="";
			_otherParam=null;

			upDistance=35;

			moveTime=0.5; //1.0;

			oriW=0;
			oriH=0;
			oriX=0;
			_zoomIn=0;
			zoomFrameRCount=0;
			upDistance=0;
			moveTime=0;;
			
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, WorldFactory.WAFT_NUMBER_REMOVED_FROM_STAGE);
		}

				
		private var _kingObjId:uint;
		private var _num:int;
		private var _type:String;
		private var _otherParam:Object;

		public function get type():String
		{
			return _type;
		}
	
		public function setData(GameKing:IGameKing, num:int, type:String, otherParam:Object=null):void
		{
			if (null == GameKing)
			{
				_kingObjId=0;
			}
			else
			{
				_kingObjId=GameKing.objid;
			}

			_num=num;
			_type=type;
			_otherParam=otherParam;
		}


		public function show():void
		{
			if (0 == _kingObjId)
			{
				this.removeEventListener(Event.REMOVED_FROM_STAGE, WorldFactory.WAFT_NUMBER_REMOVED_FROM_STAGE);
				return;
			}

			//
			var GameKing:IGameKing=SceneManager.instance.GetKing_Core(_kingObjId);

			if (null == GameKing)
			{
				this.removeEventListener(Event.REMOVED_FROM_STAGE, WorldFactory.WAFT_NUMBER_REMOVED_FROM_STAGE);
				return;
			}

			//
			var currentMapId:int=SceneManager.instance.currentMapId;

			var noShowMap:Array=Lang.getLabelArr("WaftNumber_No_Show_Map");

			if (null != noShowMap)
			{
				for (var j:int=0; j < noShowMap.length; j++)
				{
					if (currentMapId == noShowMap[j])
					{
						if (_type.indexOf(WaftNumType.HP_SUB) == 0 || _type.indexOf(WaftNumType.ATTACK_MISS) == 0)// ||
							//_type.indexOf(WaftNumType.HP_ADD) == 0 ||
							//_type.indexOf(WaftNumType.MP_ADD) == 0)
						{
							this.visible=false;
						}
						break;
					}
				}

			}



			//同步更新血条
			//GameKing.setHp = GameKing.hp;
			GameKing.getSkin().getHeadName().hideTxtNameAndBloodBar();
			GameKing.getSkin().getHeadName().showTxtNameAndBloodBar();

			//
			var roleH:int=Action.instance.fight.GetRoleHeight(GameKing);
			var roleW:int=Action.instance.fight.GetRoleWidth(GameKing);
			//
			var isMonster:Boolean=false;
			var isBaoJi:Boolean=false;
			var isGeDang:Boolean=false;
			var isMe:Boolean=false;

			if (GameKing.name2.indexOf(BeingType.MONSTER) >= 0)
			{
				isMonster=true;
			}

			isMe=GameKing.isMe;

			if (null != _otherParam)
			{
				//bao ji和 ge dang只有一个
				if (_otherParam.hasOwnProperty("isBaoJi"))
				{
					isBaoJi=_otherParam["isBaoJi"];
				}

				if (_otherParam.hasOwnProperty("isGeDang"))
				{
					isGeDang=_otherParam["isGeDang"];
				}
			}

			// Number
			parseAndCreateNum(_num, _type, isMonster, isBaoJi, isGeDang, isMe);

			if (_type.indexOf("lvlup") == 0)
			{
				//	
				//this.y=(roleH - 10) * -1;
				this.y=(roleH - 10 + 30) * -1;
				this.x = 20;
				
				upDistance=100;
				moveTime=0.6;
					//upDistance = 100 + 110;
			}
			else if (_type.indexOf("exp_add") == 0)
			{
				this.y=(roleH + 50) * -1;
				upDistance=70; //35
				moveTime=0.8; //1.0;

			}
			else
			{
				this.y=(roleH + 50) * -1;
				upDistance=35;
				moveTime=0.8; //1.0;
			}

			//this.x = (roleW/2) * -1;
			//x坐标在onNumberStartHide会被修正一次
//			this.x=this.width * -1 + (Math.random() * 50);
			this.y+=10;
			
			var p:Point = new Point();
			p.x = this.x;
			p.y = this.y;
			p = GameKing.getSkin().effectUp.localToGlobal(p);
			p = LayerDef.effectLayer.globalToLocal(p);
			this.x = p.x;
			this.y = p.y;
			LayerDef.effectLayer.addChild(this);
//			GameKing.getSkin().effectUp.addChild(this);

//			TweenLite.to(this, 16, { x: (this.x+ 150*Math.random()-100),y: this.y - 30, useFrames: true, ease: Expo.easeOut, onComplete: willHide});

			switch (type)
			{
				case WaftNumType.LEVLE_UP_HP_ADD:
				case WaftNumType.LEVEL_UP_MP_ADD:
				case WaftNumType.LEVEL_UP_ATK1_ADD:
				case WaftNumType.LEVEL_UP_ATK2_ADD:
				case WaftNumType.LEVEL_UP_ATK3_ADD:
				case WaftNumType.LEVEL_UP_DEF1_ADD:
				case WaftNumType.LEVEL_UP_DEF2_ADD:
					TweenLite.to(this, 1.5, {y: (this.y - 120), alpha: 0.1, delay: 0, onComplete: onCompleteEnd});
					break;
				case WaftNumType.ATTACK_MISS:
//				case WaftNumType.HP_SUB_GEDA:
//					TweenLite.to(this, 1.5, {y: (this.y - 60), alpha: 0.1, delay: 0, onComplete: onCompleteEnd});
//					break;
				default:
					if (GameKing.hp>0)
					{
						(GameKing as King).hit();
					}
					if (isBaoJi)
					{
						this.x-=35;
						this.scaleX=0.7;
						this.scaleY=0.7;
						TweenLite.to(this, 0.6, {y: (this.y - 100), scaleX: 1.2, scaleY: 1.2, onComplete: this.fangda});
					}
					else
					{
						TweenLite.to(this, 2, {alpha: 0, physics2D: {velocity: this.getRandom(230, 245), angle: this.getRandom(280, 290), gravity: 400}, delay: 0, onComplete: onCompleteEnd});
					}
			}
		}

		public function fangda():void
		{
			TweenLite.killTweensOf(this);
			TweenLite.to(this, 0.5, {y: (this.y - 50), scaleX: 0.7, scaleY: 0.7, onComplete: onCompleteEnd});
		}

		public function getRandom(_arg1:Number, _arg2:Number):Number
		{
			return ((_arg1 + (Math.random() * (_arg2 - _arg1))));
		}

		private function willHide():void
		{
			//step2 停留显示一阵
			TweenLite.to(this, 0.8, {y: this.y - 10, scaleX: 1, scaleY: 1, onComplete: onCompleteEnd});
		}

		private function willHide2():void
		{
			//step3 逐渐消失 
			TweenLite.to(this, 0.1, {alpha: 0, onComplete: onCompleteEnd});
		}
		public static var lrOffset:int=50;

		// Action
		public function onCompleteEnd():void
		{
			TweenLite.killTweensOf(this, true);
//			SkillTrackReal.instance.mapObjLeave(_kingObjId);
			if (this.parent != null)
				this.parent.removeChild(this);
		}

		public function removeAll():void
		{
			var i:int;
			var len:int=this.numChildren;

			for (i=0; i < len; i++)
			{
				this.removeChildAt(0);
			}
			
			instance.push(this)
		}

		private function parseAndCreateNum(num:int, type:String, isMonster:Boolean, isBaoJi:Boolean, isGeDang:Boolean, isMe:Boolean):void
		{
//			type=WaftNumType.ATTACK_MISS;
			var numStr:String;
			switch (type)
			{
				case WaftNumType.HP_SUB:
					//test
//					isBaoJi = true;
					if (isBaoJi)
					{
						numStr="#" + "-" + num.toString();
					}
					else
					{
						numStr="-" + num.toString();
					}
					break;
//				case WaftNumType.HP_SUB_GEDA:
//					//只有“格挡”二字
//					numStr="#";
//					break;
				case WaftNumType.ATTACK_MISS:
					//只有“闪避”二字
					numStr="#";
					break;
				case WaftNumType.LEVLE_UP_HP_ADD:
				case WaftNumType.LEVEL_UP_MP_ADD:
				case WaftNumType.LEVEL_UP_ATK1_ADD:
				case WaftNumType.LEVEL_UP_ATK2_ADD:
				case WaftNumType.LEVEL_UP_ATK3_ADD:
				case WaftNumType.LEVEL_UP_DEF1_ADD:
				case WaftNumType.LEVEL_UP_DEF2_ADD:
					numStr="#" + "+" + num.toString();
					break;
				default:
					throw new Error("can not find " + type + " in WaftNumType!");

			}


			//
			var len:int=numStr.length;

			var num_sp_x:int=0;

			for (var s:int=0; s < len; s++)
			{
				var n:String=numStr.substr(s, 1);

				var numberSp:Sprite=WorldFactory.createWaftNum(n, type, isMonster, isBaoJi, isMe) as Sprite;

				if (null == numberSp)
				{
					continue;
				}

				//numberSp.x=24*s;
				numberSp.x=num_sp_x;

				//伤害数字间距略微缩小 
				if (type.indexOf("lvlup_") == 0)
				{
					num_sp_x+=numberSp.width + 10;

				}
				else
				{
					if (n == "#")
					{
						//暴击
						num_sp_x+=(numberSp.width);
					}
					else
					{
						num_sp_x+=16;
					}
				}

				if (type.indexOf("mp_add") == 0)
				{
					numberSp.y=-20; //17

				}
				else if (type.indexOf("hp_add") == 0)
				{
					numberSp.y=17;

				}
				else if (type.indexOf("hp_sub") == 0 && isBaoJi)
				{
					numberSp.y=-10;

				}
				else if (type.indexOf("hp_sub") == 0 && isBaoJi)
				{
					numberSp.y=-10;
				}
				else
				{
					numberSp.y=-2;
				}

				this.addChild(numberSp);
			}
		}

		public function get zoomIn():Number
		{
			return _zoomIn;
		}

		public function set zoomIn(value:Number):void
		{
			_zoomIn=value;

			//
			this.width=oriW * _zoomIn;
			this.height=oriH * _zoomIn;
			//this.x = 0 - (oriW * _zoomIn - oriW)/2;	
			this.x=this.oriX - (oriW * _zoomIn - oriW) / 2;
		}

		public function set depthPri(value:int):void
		{

		}

		/**
		 * MAP_BODY层深度优先级
		 */
		public function get depthPri():int
		{
			return DepthDef.NORMAL;
		}

		/**
		 * 生物类型标识 + objid
		 *
		 * 本类不需要objid，返回类名即可
		 */
		public function get name2():String
		{
			return "WaftNumber";
		}

		/**
		 * @private
		 */
		public function set name2(value:String):void
		{

		}

		public function get mapy():Number
		{
			return 0;
		}

		public function get mapx():Number
		{
			return 0;
		}
	}
}
