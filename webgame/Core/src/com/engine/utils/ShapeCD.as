package com.engine.utils
{
	import com.engine.core.view.BaseSprite;
	
	import core.HeartbeatFactory;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 * ＣＤ播放动画对象 
	 * @author saiman
	 * 
	 */
	public class ShapeCD extends BaseSprite
	{
//		private static var timer:Timer
		private static var isReady:Boolean
		private static var hash:Hash=new Hash
		public static const CD_FINISH:String='CD_FINISH'
		public var isRuning:Boolean
		private var _startTime:Number
		private var _totalTime:Number
		private var _passTime:Number
		private var _size:Number
		private var _angle:Number=360
		private var _pos:Number;
		public var isFinish:Boolean=false;
		public var visibleEnabled:Boolean=true
		public var dur:int
		private var _t:int
		/**
		 *  
		 * @param size cd大小 
		 *  
		 * @param ellipes 圆角大小
		 * 
		 */		
		public function ShapeCD(size:int=50,ellipes:int=2,run:Boolean=false)
		{
			_size=size;
			var _mask:Shape=new Shape;
			_mask.graphics.beginFill(0);
			_mask.graphics.drawRoundRect(0,0,this._size*2+1,this._size*2+1,ellipes,ellipes)
			this.mask=_mask
			this.addChild(_mask)
			_pos=this._size*1.414
			isRuning=false
			this.mouseChildren=this.mouseEnabled=false;
			if(run)hash.put(this.id,this);
			liangdu(120)
		}
		
		private static function timerFunc():void
		{
			var dic:Dictionary=hash.hash
			for each (var cd:ShapeCD in dic) 
			{
				cd.onRender()
			}
			
		}
		public function liangdu(N:Number):Array
		{
			return [1,0,0,0,N,
				0,1,0,0,N,
				0,0,1,0,N,
				0,0,0,1,0]
		}
		/**
		 * 播放 
		 * @param totalTime
		 * 
		 */		
		public function play(totalTime:int,startTime:int=0,dur:int=60):void
		{
			this.dur=dur+(Math.random()*95>>0);
//			if(timer==null)
//			{
//				timer=new Timer(0);
//				timer.addEventListener(TimerEvent.TIMER,timerFunc)
//				timer.start()
//					
//					
//			}
			
			if(!isReady)
			{
				isReady=true
				HeartbeatFactory.getInstance().addFrameOrder(timerFunc)
			}
				
			_startTime=getTimer()-startTime;
			_totalTime=totalTime
			_angle=360;
			isFinish=false
			isRuning=true;
		}
		/**
		 * 心跳 
		 * @param e
		 * 
		 */			
		public function onRender():void
		{
			if(isFinish)return;
			this._passTime=getTimer()-this._startTime
			if(_passTime>=this._totalTime)
			{
			
				this.graphics.clear();
				this._angle=0
				isRuning=false
				this.dispatchEvent(new Event(CD_FINISH))
				isFinish=true
					
			}else {
			
				_angle=360-360*_passTime/this._totalTime
				//计算剩余角度
				if(getTimer()-_t>dur)
				{
					_t=getTimer()
					if(visibleEnabled&&this.stage)
					drawSector(graphics,_size,_size,_pos,_angle,-(_angle+90));
				}
				
			};
			
			
		}
		
		
		
		/**
		 * 绘制扇形 
		 * @param graphics 绘图对象
		 * @param x 圆心x轴
		 * @param y 圆心vy轴
		 * @param radius 半径
		 * @param size 绘制的扇形大小（角度制，0<=size<=360)
		 * @param startRotation 开始的角度(角度制，默认为270度即12点方向)
		 * 
		 */		
		private function drawSector(graphics:Graphics,x:int,y:int,radius:int,size:Number,startRotation:Number=270):void
		{
			if(size<=0) return;
			if(size > 360) size = 360;
			
			var n:int=8
			size = Math.PI/180 * size;
			var angleN:Number = size/n;
			 //绘制二次贝塞尔曲线的外切半径
			var tangentRadius:Number = radius/Math.cos(angleN/2);
			//转换为弧度
			var angle:Number=startRotation* Math.PI / 180;
			
			var cx:Number;
			var cy:Number;
			var ax:Number;
			var ay:Number;
			
			//开始角度再圆上的位置
			var startX:Number = x + Math.cos(angle) * radius;
			var startY:Number = y + Math.sin(angle) * radius;
			
			graphics.clear();
//			graphics.lineStyle(0,0,0)
			graphics.beginFill(0x666666,.6)
			graphics.moveTo(x, y);
			graphics.lineTo(startX, startY);
			
			
			for (var i:Number = 0; i < n; i++) {
				
				//绘制2次贝塞尔曲线，
				angle += angleN;
				//求出开始点与将要绘制点的角平分线与将要绘制点的交点
				cx = x + Math.cos(angle-(angleN/2))*(tangentRadius);
				cy = y + Math.sin(angle-(angleN/2))*(tangentRadius);
				//僬侥绘制点在圆上的位置
				ax = x + Math.cos(angle) * radius;
				ay = y + Math.sin(angle) * radius;
				
				graphics.curveTo(cx, cy, ax, ay);
			}
			graphics.lineTo(x, y);
			
		}

		public function get size():Number
		{
			return _size;
		}

		public function set size(value:Number):void
		{
			_size = value;
		}
		
		override public function dispose():void
		{
			hash.remove(this.id)
			super.dispose()
			
		}
	}
}