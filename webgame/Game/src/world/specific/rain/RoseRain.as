package world.specific.rain
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	public class RoseRain extends Bitmap
	{
		private static var _instance:RoseRain;

		public static function getInstance():RoseRain
		{
			if (_instance == null)
				_instance=new RoseRain();
			return _instance;
		}

		public var resClass:Array;
		private var instanceRes:Array=[];
		private var num:int;
		private var speed:int;
		private var rect:Rectangle;
		private var mainStage:BitmapData;
		private var canRotation:Boolean;
		/**
		 *	播放时间 【单位：秒】
		 */
		public var playTime:int=10;

		public function RoseRain():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedHandler);
			timer=new Timer(20);

		}

		/**
		 *
		 * @param arrayRoseClass 要落下的素材类
		 * @param dropMaxSpeed 最大下落速度
		 * @param MAX 同时出现最大数量
		 * @param moveWidth 屏幕宽
		 * @param moveHeight 屏幕高
		 *
		 */
		public function setData(arrayRoseClass:Array, moveWidth:int=1440, moveHeight:int=900, dropMaxSpeed:int=5, MAX:int=200, rota:Boolean=true):void
		{
			canRotation=rota;
			resClass=arrayRoseClass
			speed=dropMaxSpeed + 2;
			num=MAX;
			rect=new Rectangle(0, 0, moveWidth, moveHeight);
			var len:int=resClass.length;
			while (instanceRes.length > 0)
				instanceRes.shift();
			for (var i:int=0; i < num; i++)
			{
				var m_instance:RoseItem=new RoseItem();
				m_instance.bitmapData=new resClass[int(Math.random() * len)]();
				initRose(m_instance);
				instanceRes.push(m_instance);
			}
			mainStage=new BitmapData(rect.width, rect.height, true, 0);
			this.bitmapData=mainStage;
			timer.repeatCount=playTime * 1000 / 20;
		}

		private function addedHandler(e:Event):void
		{
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			timer.start();

		}

		private function removedHandler(e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
			timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			mainStage.dispose();
			timer.reset();
		}
		private var timer:Timer;

		private function timerHandler(e:TimerEvent):void
		{

			mainStage.fillRect(rect, 0);
			var rose:RoseItem;
			for each (rose in instanceRes)
			{
				rose.y+=rose.speed;
				if (canRotation)
					rose.rotation+=2;
				if (rose.y < rect.height)
				{
					mainStage.draw(rose.bitmapData, rose.matrix);
					e.updateAfterEvent();
				}
				else
				{
					initRose(rose);
				}
			}
		}

		private function timerCompleteHandler(e:TimerEvent):void
		{
			if (this.parent != null)
				this.parent.removeChild(this);
			var rose:RoseItem;
			for each (rose in instanceRes)
			{
				rose.bitmapData.dispose();
				rose.bitmapData=null;
				rose=null;
			}
			mainStage.dispose();
			mainStage=null;
			this.bitmapData.dispose();
		}

		private function initRose(m_rose:RoseItem):RoseItem
		{
			m_rose.x=rect.width * Math.random();
			m_rose.y=-rect.height * Math.random();
			m_rose.speed=speed;
			if (canRotation)
			{
				m_rose.rotation=360 * Math.random();
				m_rose.speed=speed * Math.random();
			}
//			m_rose.alpha=1;
//			m_rose.visible=false;
			return m_rose;
		}
	}
}
