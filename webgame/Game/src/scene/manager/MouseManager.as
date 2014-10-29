package scene.manager
{
	import common.config.PubData;
	
	import engine.load.GamelibS;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;
	import flash.utils.Timer;
	
	import scene.mouse.MouseSkinType;

	/**
	 * @author wanghuaren
	 * @create 2012-10-22
	 * 场景鼠标变化控制
	 */
	public class MouseManager
	{
		/**
		 *
		 */
		private static var _instance:MouseManager;

		public static function get instance():MouseManager
		{
			if (!_instance)
			{
				_instance=new MouseManager();
			}

			return _instance;
		}
public function MouseManager(){
	MouseSkin;
}
		private var _mouseSkin:MovieClip;
		private var _lock:Boolean=false;
		public var mouseSkinType:int=0;

		//----whr--------
		private var timer:Timer;

		//---------------
		private function get MouseSkin():MovieClip
		{
			if (null == _mouseSkin)
			{
				_mouseSkin=GamelibS.getswflink("game_utils", "mouse_zhi_zhen") as MovieClip;
				_mouseSkin.MouseChildren=_mouseSkin.MouseEnabled=false;

				init();
				//	-----whr-----
				timer=new Timer(10);
					//	---------
			}

			return _mouseSkin;
		}

		/**
		 * 初始化鼠标样式
		 * 1.2-空 3-对话 4-采集 5-空 6-攻击 7-拆分 8-购买 9-批量使用 10-金镖
		 */
		public function init():void
		{
			//dialog对话
			var len:int=4;
			var dialogMCD:MouseCursorData=new MouseCursorData();
			var dialogV:Vector.<BitmapData>=new Vector.<BitmapData>();
			var index:int=0;
			var bmd:BitmapData=null;
			while (index < len)
			{
				bmd=GamelibS.getbmdlink("game_utils", MouseSkinType.NPCTalk_CURSOR + index);
				dialogV.push(bmd);
				index++;
			}
			dialogMCD.data=dialogV;
			dialogMCD.frameRate=len;
			Mouse.registerCursor(MouseSkinType.NPCTalk_CURSOR, dialogMCD);

			//gather采集
			index=0;
			len=2;
			var gatherMCD:MouseCursorData=new MouseCursorData();
			var gatherV:Vector.<BitmapData>=new Vector.<BitmapData>();
			while (index < len)
			{
				bmd=GamelibS.getbmdlink("game_utils", MouseSkinType.TAKE_CURSOR + index);
				gatherV.push(bmd);
				index++;
			}
			gatherMCD.data=gatherV;
			gatherMCD.frameRate=len;
			Mouse.registerCursor(MouseSkinType.TAKE_CURSOR, gatherMCD);

			//juan捐
			var payMCD:MouseCursorData=new MouseCursorData();
			var payV:Vector.<BitmapData>=new Vector.<BitmapData>();
			bmd=GamelibS.getbmdlink("game_utils", MouseSkinType.PAY_CURSOR);
			payV.push(bmd);
			payMCD.data=payV;
			Mouse.registerCursor(MouseSkinType.PAY_CURSOR, payMCD);

			//destory毁掉
			var destoryMCD:MouseCursorData=new MouseCursorData();
			var destoryV:Vector.<BitmapData>=new Vector.<BitmapData>();
			bmd=GamelibS.getbmdlink("game_utils", MouseSkinType.DESTORY_CURSOR);
			destoryV.push(bmd);
			destoryMCD.data=destoryV;
			Mouse.registerCursor(MouseSkinType.DESTORY_CURSOR, destoryMCD);

			//split 拆分
			var splitMCD:MouseCursorData=new MouseCursorData();
			var splitV:Vector.<BitmapData>=new Vector.<BitmapData>();
			bmd=GamelibS.getbmdlink("game_utils", MouseSkinType.SPLIT_CURSOR);
			splitV.push(bmd);
			splitMCD.data=splitV;
			Mouse.registerCursor(MouseSkinType.SPLIT_CURSOR, splitMCD);

			//buy 购买
			var buyMCD:MouseCursorData=new MouseCursorData();
			var buyV:Vector.<BitmapData>=new Vector.<BitmapData>();
			bmd=GamelibS.getbmdlink("game_utils", MouseSkinType.BUY_CURSOR);
			buyV.push(bmd);
			buyMCD.data=buyV;
			Mouse.registerCursor(MouseSkinType.BUY_CURSOR, buyMCD);

			//attack 攻击
			index=0;
			len=1;
			var attackMCD:MouseCursorData=new MouseCursorData();
			var attackV:Vector.<BitmapData>=new Vector.<BitmapData>();
			bmd=GamelibS.getbmdlink("game_utils", MouseSkinType.ATTACK_CURSOR);
			attackV.push(bmd);
			attackMCD.data=attackV;
			Mouse.registerCursor(MouseSkinType.ATTACK_CURSOR, attackMCD);

			//batch 批量使用
			var piliangMCD:MouseCursorData=new MouseCursorData();
			var piliangV:Vector.<BitmapData>=new Vector.<BitmapData>();
			bmd=GamelibS.getbmdlink("game_utils", MouseSkinType.PILIANG_CURSOR);
			piliangV.push(bmd);
			piliangMCD.data=piliangV;
			Mouse.registerCursor(MouseSkinType.PILIANG_CURSOR, piliangMCD);

			//sel 出售
			var selMCD:MouseCursorData=new MouseCursorData();
			var selV:Vector.<BitmapData>=new Vector.<BitmapData>();
			bmd=GamelibS.getbmdlink("game_utils", MouseSkinType.SEL_CURSOR);
			selV.push(bmd);
			selMCD.data=selV;
			Mouse.registerCursor(MouseSkinType.SEL_CURSOR, selMCD);

			//hand 手形
			var handMCD:MouseCursorData=new MouseCursorData();
			var handV:Vector.<BitmapData>=new Vector.<BitmapData>();
			bmd=GamelibS.getbmdlink("game_utils", MouseSkinType.SEL_CURSOR);
			handV.push(bmd);
			handMCD.data=handV;
			Mouse.registerCursor(MouseCursor.HAND, handMCD);
		}

		public function get Lock():Boolean
		{
			return _lock;
		}

		public function set Lock(value:Boolean):void
		{
			this._lock=value;
		}

		private function AddEnterFrame(tag:Boolean):void
		{

			if (null == MouseSkin)
			{
				return;
			}

			if (tag)
			{

				timer.removeEventListener(TimerEvent.TIMER, timerHandler);
				timer.addEventListener(TimerEvent.TIMER, timerHandler);
				timer.start();
			}
			else
			{
				timer.removeEventListener(TimerEvent.TIMER, timerHandler);
				timer.stop();
			}

		}

		private function timerHandler(e:TimerEvent=null):void
		{
			if (null == MouseSkin)
			{
				return;
			}

			MouseSkin.x=PubData.mainUI.mouseX;
			MouseSkin.y=PubData.mainUI.mouseY;
//----------whr---------------
			if (e != null)
			{
				e.updateAfterEvent();
			}
			//---------------
		}

		//1.空2.剑3.背包卖东西4.捡东西5.技能方阵光圈6.单击攻击10.大锅盖技能覆盖攻击
		public function show(skinType:int):void
		{
			if (null == MouseSkin)
			{
				return;
			}
			
			this.mouseSkinType = skinType;
			
			if (Mouse.supportsNativeCursor)
			{
				var isSupport:Boolean=true;
				timer.stop();
				switch (skinType)
				{
					case 3:
						this.currentCursor=MouseSkinType.NPCTalk_CURSOR;
						break;
					case 4:
						this.currentCursor=MouseSkinType.TAKE_CURSOR;
						break;
					case 6:
						this.currentCursor=MouseSkinType.ATTACK_CURSOR;
						break;
					case 7:
						this.currentCursor=MouseSkinType.SPLIT_CURSOR;
						break;
					case 8:
						this.currentCursor=MouseSkinType.BUY_CURSOR;
						break;
					case 9:
						this.currentCursor=MouseSkinType.PILIANG_CURSOR;
						break;
					case 12:
						this.currentCursor=MouseSkinType.SEL_CURSOR;
						break;
					case 13:
						this.currentCursor=MouseSkinType.PAY_CURSOR;
						break;
					case 14:
						this.currentCursor=MouseSkinType.DESTORY_CURSOR;
						break;
					default:
						this.currentCursor=MouseCursor.AUTO;
						isSupport=false;
						break;
				}
				if (isSupport)
				{
					return;
				} //end
			}
			if (!Lock)
			{
				timerHandler();
				if (skinType <= 1)
				{

					//Mouse.hide();
					Mouse.show();
					MouseSkin.visible=false;
					//MouseSkin.gotoAndStop(MouseSkinType);
					AddEnterFrame(false);
						//AddEnterFrame(true);

				}
				else
				{
					Mouse.hide();
					MouseSkin.visible=true;
					MouseSkin.gotoAndStop(skinType);
					//PubData.mainUI.stage.addChild(MouseSkin);

					PubData.mainUI.Layer5.addChild(MouseSkin);

					AddEnterFrame(true);
				}
				if (skinType == 5)
					_lock=true;
				mouseSkinType=skinType;
			}
		}

		public function hide():void
		{

			if (null == MouseSkin)
			{
				return;
			}

			if (Lock)
			{

				Mouse.show();
				MouseSkin.visible=false;
				//MouseSkin.visible = true;
				//MouseSkin.gotoAndStop(2);
				AddEnterFrame(false);
				//AddEnterFrame(true);

				Lock=false;
			}
		}
		private var _currentCursor:String=MouseCursor.ARROW;

		/**
		 * 设置当前鼠标样式
		 * @param value
		 *
		 */
		public function set currentCursor(value:String):void
		{
			if (this._currentCursor == value)
				return;
			this._currentCursor=value;
			Mouse.cursor=value;
		}

	}
}
