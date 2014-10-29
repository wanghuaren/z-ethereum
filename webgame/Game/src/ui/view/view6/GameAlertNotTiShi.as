package ui.view.view6
{
	import common.config.GameIni;
	import common.config.PubData;
	import common.managers.Lang;
	import common.utils.bit.BitUtil;
	
	import engine.load.GamelibS;
	import engine.utils.HashMap;
	
	import flash.display.*;
	import flash.events.*;
	
	import ui.view.view4.yunying.ZhiZunVIP;
	import ui.view.view4.yunying.ZhiZunVIPMain;

	/**
	 *	不再提示 统一处理
	 *  @andy 2012-05-20
	 */
	public class GameAlertNotTiShi extends MovieClip
	{
		private var _UI:DisplayObject;
		private var doAct:Function=null;
		private var param:Object=null;
		private var curType:int=0;
		public var map:HashMap=null;

		/**********自己定义编号 不再提示**************/
		/**
		 *	 神秘商店
		 */
		public static const RMBSHOP:int=1;
		/**
		 *	 炼骨
		 */
		public static const BONE:int=2;

		/**
		 * 挂机
		 */
		public static const GUAJI:int=3;

		/**
		 * 境界
		 */
		public static const JINGJIE:int=4;

		/**
		 * 元宝鼓舞
		 */
		public static const GUWU:int=5;

		/**
		 * 魔天万界
		 */
		public static const MOTIAN:int=6;
		/**
		 * 重铸极致属性
		 */
		public static const CHONGZHU:int=7;
		/**
		 * 传送
		 */
		public static const CHUANSONG:int=8;
		/**
		 * 抽奖
		 */
		public static const CHOUJIANG:int=9;
		/**
		 * 强化普通退星 
		 */
		public static const STRONG_DOWN_STAR:int=10;
		/**
		 * 护送美女刷新次数 
		 */
		public static const HU_SONG_REFRESH:int=11;
		/**
		 * 摆摊发广告消耗银两 
		 */
		public static const BOOTH_AD:int=12;
		/**
		 * 悬赏任务元宝刷新提示
		 */
		public static const XUAN_SHANG:int=13;
		
		
		public static const BANGPAI:int =14;
		
		
		/***********新项目从100开始，免得和老项目重复，给平移带来麻烦*****/
		/**
		 * 帮派拜关公召唤神将提示
		 */
		public static const SHEN_JIANG:int=100;
		/**
		 * 分解装备
		 */
		public static const FENJIE_ZHUANGBEI:int=101;

		/**
		 * 配置信息 (需要与服务器保持同步)
		 */
		private var m_config:int;

		/**
		 * 用于判断是否为模态的
		 */
		public var m_isModal:Boolean=false;

		public function GameAlertNotTiShi():void
		{
			
		}

		private static var _instance:GameAlertNotTiShi;

		public static function get instance():GameAlertNotTiShi
		{
			if (_instance == null)
			{
				_instance=new GameAlertNotTiShi();
			}


			return _instance;
		}
		
		public function get UI():DisplayObject
		{
			if(null == _UI)
			{
				_UI = GamelibS.getswflink("game_utils", "pop_not_open");
			}
			
			return _UI;
		}
		
		public function init():void{
			//map=new HashMap();
	
			if(null != UI){

			UI.name="SUBMIT_CANCEL_NOT_OPEN";
			if(UI["txt_msg"])
			UI["txt_msg"].addEventListener(TextEvent.LINK, textLinkHandle);
			}
		}

		private function _onAddToStageListener(e:Event):void
		{
			this._setModal(m_isModal);

			m_isModal=false;

		}


		public function setModal(b:Boolean):void
		{
			m_isModal=b;
		}

		/**

		 * @param type    不再提示编号
		 * @param sprite  确定按钮上的文字 如：刷新，立即充值...
		 */
		public function ShowMsg(msg:Object=null, type:uint=1, sprite:Object=null, doFunction:Function=null, ... Param):MovieClip
		{

			if (null != map && map.get(type) != null && map.get(type) == 1)
			{
				(doFunction is Function) ? Param.length == 0 ? doFunction() : doFunction(Param[0] == null ? UI["txt_msg"].text : Param[0]) : "";
				return null;
			}
			curType=type;
			doAct=doFunction;
			param=Param;

			if(null != UI){
			UI.addEventListener(Event.ADDED_TO_STAGE, _onAddToStageListener);

			UI["txt_msg"].htmlText=msg;
			}
			
			if (null == sprite)
			{
				UI["ok"]["label"]=Lang.getLabel("pub_que_ding");
			}
			else
			{
				UI["ok"]["label"]=sprite;
			}

			UI.addEventListener(MouseEvent.MOUSE_UP, alertPaneHandler);
			UI["check"].selected=false;

			UI.visible=true;
			UI.x=(GameIni.MAP_SIZE_W - UI.width) / 2;
			if (type == 2)
			{
				UI.y=(GameIni.MAP_SIZE_H - UI.height) / 2 + 50;
			}
			else
			{
				UI.y=(GameIni.MAP_SIZE_H - UI.height) / 2;
			}
			PubData.AlertUI2.addChild(UI as DisplayObject);
			if (UI == null)
			{
				return null;
			}
			return UI as MovieClip;
		}

		private function alertPaneHandler(e:MouseEvent):void
		{
			switch (e.target.name)
			{
				case "ok":
					(doAct is Function) ? param.length == 0 ? doAct() : doAct(param[0] == null ? UI["txt_msg"].text : param[0]) : "";
					// TweenMax.to(UI,UIControl.tweenDelay,{alpha:UIControl.tweenAlpha,x:UI.x+UI.width/2,y:UI.y+UI.height/2,width:UIControl.tweenWidth,height:UIControl.tweenHeight,onComplete:willClose});
					willClose();
					break;
				case "cancel":
					(doAct is Function) ? param.length == 2 && param != null ? doAct(param[1]) : "" : "";
					// TweenMax.to(UI,UIControl.tweenDelay,{alpha:UIControl.tweenAlpha,x:UI.x+UI.width/2,y:UI.y+UI.height/2,width:UIControl.tweenWidth,height:UIControl.tweenHeight,onComplete:willClose});
					willClose();
					break;
				case "check":
					UI["check"].selected=!UI["check"].selected;
					if (null != map)
					{
						map.put(curType, UI["check"].selected ? 1 : 0);
						m_config=this._changeMapToInt(map);
						saveConfig();
					}

					break;

			}

		}

		private function textLinkHandle(e:TextEvent):void
		{
			var type:int=int(e.text);
			if (type == CHUANSONG)
			{
				ZhiZunVIPMain.getInstance().open();
				willClose();
			}
		}

		public function willClose():void
		{

			_setModal(false);

			if (UI == null)
			{
				return;
			}

			UI.removeEventListener(MouseEvent.MOUSE_UP, alertPaneHandler);
			if (null != UI.parent)
			{
				UI.parent.removeChild(UI);
			}
			doAct=null;
			param=null;

		}

		/**
		 *	不再提示恢复
		 */
		public function reset():void
		{
			map=new HashMap();
			m_config=0;
			saveConfig();
		}


		//模态蒙板
		private var m_modelSprite:Sprite;

		private function _setModal(b:Boolean):void
		{
			m_isModal=b;

			if (b)
			{
				if (null == m_modelSprite)
				{
					m_modelSprite=new Sprite();
					m_modelSprite.alpha=0.1;
					m_modelSprite.graphics.beginFill(0x000000);
					m_modelSprite.graphics.drawRect(0, 0, 10, 10);
				}

				var _ui:MovieClip=UI as MovieClip;


				if (null != _ui && _ui.stage && _ui.parent)
				{
					m_modelSprite.width=_ui.stage.stageWidth;
					m_modelSprite.height=_ui.stage.stageHeight;
					m_modelSprite.x=0;
					m_modelSprite.y=0;

					_ui.parent.addChild(m_modelSprite);
					_ui.parent.setChildIndex(_ui, _ui.parent.numChildren - 1);
						//this.addChild(this);
				}
			}
			else
			{
				if (null != m_modelSprite && null != m_modelSprite.parent)
				{
					m_modelSprite.parent.removeChild(m_modelSprite);
				}
			}


		}

		private function _changeMapToInt(map:HashMap):int
		{
			var _config:int=0;
			_config=BitUtil.setIntToInt(map.get(RMBSHOP), _config, RMBSHOP, RMBSHOP);
			_config=BitUtil.setIntToInt(map.get(BONE), _config, BONE, BONE);
			_config=BitUtil.setIntToInt(map.get(GUAJI), _config, GUAJI, GUAJI);
			_config=BitUtil.setIntToInt(map.get(JINGJIE), _config, JINGJIE, JINGJIE);
			_config=BitUtil.setIntToInt(map.get(GUWU), _config, GUWU, GUWU);
			_config=BitUtil.setIntToInt(map.get(MOTIAN), _config, MOTIAN, MOTIAN);
			_config=BitUtil.setIntToInt(map.get(CHONGZHU), _config, CHONGZHU, CHONGZHU);
			_config=BitUtil.setIntToInt(map.get(CHUANSONG), _config, CHUANSONG, CHUANSONG);

			return _config;
		}

		private function _changeIntToMap(i:int):HashMap
		{
			var _map:HashMap=new HashMap();
			_map.put(RMBSHOP, BitUtil.getOneToOne(i, RMBSHOP, RMBSHOP));
			_map.put(BONE, BitUtil.getOneToOne(i, BONE, BONE));
			_map.put(GUAJI, BitUtil.getOneToOne(i, GUAJI, GUAJI));
			_map.put(JINGJIE, BitUtil.getOneToOne(i, JINGJIE, JINGJIE));
			_map.put(GUWU, BitUtil.getOneToOne(i, GUWU, GUWU));
			_map.put(MOTIAN, BitUtil.getOneToOne(i, MOTIAN, MOTIAN));
			_map.put(CHONGZHU, BitUtil.getOneToOne(i, CHONGZHU, CHONGZHU));
			_map.put(CHUANSONG, BitUtil.getOneToOne(i, CHUANSONG, CHUANSONG));

			return _map;
		}

		//从服务器读取的配置信息，保存到客户端
		public function setConfig(pare:int):void
		{
			m_config=pare;
			this.map=_changeIntToMap(m_config);
		}

		//把配置信息保存到后台数据库
		private function saveConfig():void
		{
			PubData.save(2,m_config);
//			var _p:=new ();
//			_p.data.para1=-1;
//			_p.data.para2=-1;
//			_p.data.para3=-1;
//			_p.data.para4=-1;
//
//			_p.data.para2=m_config;
//
//			DataKey.instance.send(_p);
		}

	}
}



