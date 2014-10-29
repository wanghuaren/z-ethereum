package scene.action
{
	import com.bellaxu.def.LayerDef;
	import com.bellaxu.map.MapBlockContainer;
	import com.bellaxu.mgr.LayerMgr;
	import com.bellaxu.util.StageUtil;
	import com.engine.core.tile.TileConstant;
	
	import common.config.PubData;
	import common.managers.GameKeyBoard;
	import common.utils.clock.GameClock;
	
	import engine.event.KeyEvent;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import main.Game_main;
	
	import netc.Data;
	import netc.MsgPrint;
	
	import scene.body.Body;
	import scene.king.FightSource;
	import scene.manager.SceneManager;
	import scene.utils.MapCl;
	import scene.utils.MapData;
	
	import ui.base.mainStage.UI_index;
	
	import world.WorldEvent;
	import world.WorldPoint;

	public class Action
	{
		private static var _instance:Action;

		public static function get instance():Action
		{
			if (!_instance)
			{
				_instance=new Action();
			}
			return _instance;
		}
		/**
		 * 走路
		 */
		private var _pathAction:PathAction;
		/**
		 * 战斗
		 */
		private var _fightAction:FightAction;

		public function get fight():FightAction
		{
			return _fightAction;
		}
		private var _sysConfigAction:SysConfigAction;

		public function get sysConfig():SysConfigAction
		{
			return _sysConfigAction;
		}
		/**
		 * 新手指引
		 */
		private var _guestAction:NewGuestAction;

		public function get guest():NewGuestAction
		{
			return _guestAction;
		}
		/**
		 * 魂效果
		 */
		private var _soulAction:SoulAction;

		public function get soul():SoulAction
		{
			return _soulAction;
		}
		/**
		 * 万荆缠身符效果
		 */
		private var _virusAction:VirusAction;

		public function get virus():VirusAction
		{
			return _virusAction;
		}
		/**
		 * 剑效果
		 */
		private var _swordAction:SwordAction;

		public function get sword():SwordAction
		{
			return _swordAction;
		}
		/**
		 * 神器效果
		 */
		private var _godArmAction:GodArmAction

		public function get godArm():GodArmAction
		{
			return _godArmAction;
		}
		/**
		 *
		 */
		private var _cgAction:CGAction;

		public function get cg():CGAction
		{
			return _cgAction;
		}
		/**
		 *
		 */
		private var _storyAction:StoryAction;

		public function get story():StoryAction
		{
			return _storyAction;
		}
		/**
		 *
		 */
		private var _yuJianFlyAction:YuJianFlyAction;

		public function get yuJianFly():YuJianFlyAction
		{
			return _yuJianFlyAction;
		}
		/**
		 *
		 */
		private var _yuBoatAction:YuBoatAction;

		public function get yuBoat():YuBoatAction
		{
			return _yuBoatAction;
		}
		/**
		 *
		 */
		private var _suduAction:SuduAction;

		public function get sudu():SuduAction
		{
			return _suduAction;
		}
		/**
		 *
		 */
		private var _qianghuaAction:QiangHuaAction;

		public function get qiangHua():QiangHuaAction
		{
			return _qianghuaAction;
		}
		/**
		 *
		 */
		private var _boothAction:BoothAction;

		public function get booth():BoothAction
		{
			return _boothAction;
		}
		/**
		 *
		 */
		private var _boss2Effect:Boss2EffectAction;

		public function get boss2Effect():Boss2EffectAction
		{
			return _boss2Effect;
		}
		private var _boss3Effect:Boss3EffectAction;

		public function get boss3Effect():Boss3EffectAction
		{
			return _boss3Effect;
		}
		private var _boss4Effect:Boss4EffectAction;

		public function get boss4Effect():Boss4EffectAction
		{
			return _boss4Effect;
		}
		private var _boss41Effect:Boss41EffectAction;

		public function get boss41Effect():Boss41EffectAction
		{
			return _boss41Effect;
		}
		//
		private var _wudi:WudiAction;

		/**
		 * 无敌护盾
		 */
		public function get wudi():WudiAction
		{
			return _wudi;
		}
		private var m_defense_attr:DefenseAttrAction;

		/**
		 * 防御增强效果(魔龙战甲)
		 */
		public function get defense_attr():DefenseAttrAction
		{
			return m_defense_attr;
		}
		private var m_nPoison:PoisonAction;

		/**
		 * 施毒术，持续掉血
		 */
		public function get poison():PoisonAction
		{
			return m_nPoison;
		}
		private var m_nVertigo:VertigoAction;

		/**
		 * 施毒术，持续掉血
		 */
		public function get vertigo():VertigoAction
		{
			return m_nVertigo;
		}
		private var _pk_ranshao:PkRanShaoAction;

		public function get pk_ranshao():PkRanShaoAction
		{
			return _pk_ranshao;
		}
		private var _sneak:SneakAction;

		/**
		 * 潜行
		 */
		public function get sneak():SneakAction
		{
			return _sneak;
		}
		private var _biShaJi:BiShaJiAction;

		public function get biShaJi():BiShaJiAction
		{
			return _biShaJi;
		}

		/**
		 * 负责动作
		 * 显示出来由Body负责
		 */
		public function Action():void
		{
			//走路
			if (null == _pathAction)
			{
				_pathAction=new PathAction();
			}
			//战斗
			if (null == _fightAction)
			{
				_fightAction=new FightAction();
			}
			//			if(null == _chatAction)
			//			{
			//				_chatAction = new ChatAction();
			//			}
			if (null == _guestAction)
			{
				_guestAction=new NewGuestAction();
			}
			if (null == _sysConfigAction)
			{
				_sysConfigAction=new SysConfigAction();
			}
			if (null == _soulAction)
			{
				_soulAction=new SoulAction();
			}
			if (null == _virusAction)
			{
				_virusAction=new VirusAction();
			}
			if (null == _swordAction)
			{
				_swordAction=new SwordAction();
			}
			if (null == _godArmAction)
			{
				_godArmAction=new GodArmAction();
			}
			if (null == _cgAction)
			{
				_cgAction=new CGAction();
			}
			if (null == _storyAction)
			{
				_storyAction=new StoryAction();
			}
			if (null == _yuJianFlyAction)
			{
				_yuJianFlyAction=new YuJianFlyAction();
			}
			if (null == _yuBoatAction)
			{
				_yuBoatAction=new YuBoatAction();
			}
			if (null == _suduAction)
			{
				_suduAction=new SuduAction();
			}
			if (null == _qianghuaAction)
			{
				_qianghuaAction=new QiangHuaAction();
			}
			if (null == _boothAction)
			{
				_boothAction=new BoothAction();
			}
			if (null == this._boss2Effect)
			{
				_boss2Effect=new Boss2EffectAction();
			}
			if (null == this._boss3Effect)
			{
				_boss3Effect=new Boss3EffectAction();
			}
			if (null == this._boss4Effect)
			{
				_boss4Effect=new Boss4EffectAction();
			}
			if (null == this._boss41Effect)
			{
				_boss41Effect=new Boss41EffectAction();
			}
			if (null == this._wudi)
			{
				_wudi=new WudiAction();
			}
			if (null == this._pk_ranshao)
			{
				_pk_ranshao=new PkRanShaoAction();
			}
			if (null == this._sneak)
			{
				_sneak=new SneakAction();
			}
			if (null == this._biShaJi)
			{
				_biShaJi=new BiShaJiAction();
			}
			if (this.m_defense_attr == null)
			{
				this.m_defense_attr=new DefenseAttrAction();
			}
			if (this.m_nPoison == null)
			{
				this.m_nPoison=new PoisonAction();
			}
			if (this.m_nVertigo == null)
			{
				this.m_nVertigo=new VertigoAction();
			}
			LayerDef.mapLayer.addEventListener(Event.ADDED_TO_STAGE, addToStageFunc);
			if (LayerDef.mapLayer.stage != null)
			{
				addToStageFunc(null);
			}
			MapData.AddEventListener(MouseEvent.MOUSE_OUT, MAP_MOUSE_OUT);
			MapData.AddEventListener(MouseEvent.MOUSE_OVER, MAP_MOUSE_OVER);
			StageUtil.addEventListener(KeyEvent.KEY_DOWN, ACTION_KEY_DOWN);
		}

		protected function addToStageFunc(event:Event):void
		{
			LayerDef.mapLayer.removeEventListener(Event.ADDED_TO_STAGE, addToStageFunc);
			LayerDef.mapLayer.stage.addEventListener(MouseEvent.MOUSE_DOWN, MAP_MOUSE_DOWN2);
			//测试
			LayerDef.mapLayer.stage.addEventListener(MouseEvent.MOUSE_MOVE, showMapGrid);
		}
		private var m_nTFPos:TextField=new TextField();

		private function showMapGrid(e:MouseEvent):void
		{
			return;
			if (MsgPrint.showStopPoint)
			{
				m_nTFPos.mouseEnabled=false;
				var po:WorldPoint=SceneManager.instance.getIndexUI_GameMap_MouseGridPoint();
				var p:Point=new Point(po.mapx, po.mapy);
				MapCl.gridToMap(p);
				m_nTFPos.text=po.mapx + "," + po.mapy;
				LayerDef.dropLayer.addChild(m_nTFPos);
				m_nTFPos.x=p.x - m_nTFPos.textWidth * 0.5;
				m_nTFPos.y=p.y - m_nTFPos.textHeight * 0.5;
				LayerDef.dropLayer.graphics.clear();
				LayerDef.dropLayer.graphics.beginFill(0xff0000, 0.5);
				LayerDef.dropLayer.graphics.drawRect(p.x - TileConstant.TILE_Width * 0.5, p.y - TileConstant.TILE_Height * 0.5, TileConstant.TILE_Width, TileConstant.TILE_Height);
				LayerDef.dropLayer.graphics.endFill();
			}
		}

		private function ACTION_KEY_DOWN(e:engine.event.KeyEvent):void
		{
			switch (e.KeyCode)
			{
				case KeyEvent.KEY_ESC:
					Body.instance.sceneKing.DelMeFightInfo(FightSource.Kb_Esc, 0);
					Body.instance.sceneKing.DelMeTalkInfo(FightSource.Kb_Esc, 0);
					GameKeyBoard.RestTime();
					break;
			}
		}
		//UI层是透明的时候  穿透到地图层
		private static var UIBMD:BitmapData=new BitmapData(1, 1, true, 0);
		private static var UIMatrix:Matrix=new Matrix();
		private static var UIAlpha:uint=100;
		private static var currMC:DisplayObject;

		public static function MAP_MOUSE_DOWN2(e:MouseEvent):void
		{
			//会有卡顿
//			currMC=e.target.root;
//
//			UIMatrix.tx=-currMC.mouseX;
//			UIMatrix.ty=-currMC.mouseY;
//			UIBMD.fillRect(UIBMD.rect, 0);
//			UIBMD.draw(currMC, UIMatrix);
//			UIAlpha=UIBMD.getPixel32(0, 0) >> 24;
			if (PubData.canRightKey||e.target.hasOwnProperty("mc") && e.target["mc"].name == "messagePanel2")
			{
				LayerMgr.onMouseDown(e);
			}
			else if (!SceneManager.MapInLoading)
			{
				BodyAction.indexUI_GameMap_Mouse_Down(e);
			}
		}

		// 地图鼠标点击事件
		public function MAP_MOUSE_DOWN(e:MouseEvent):void
		{
//			e.stopImmediatePropagation();
			BodyAction.indexUI_GameMap_Mouse_Down(e);
		}

		public function MAP_MOUSE_OUT(e:MouseEvent):void
		{
			ColorAction.KingMouseOut(e);
		}

		public function MAP_MOUSE_OVER(e:MouseEvent):void
		{
						ColorAction.KingMouseOver(e);
		}
	}
}
