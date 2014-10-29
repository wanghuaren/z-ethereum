package ui.frame
{
	import com.greensock.TweenLite;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	public class FlyIcon extends Sprite
	{
		private var m_loader:Loader = null;
		private var m_urlReq:URLRequest = null;
		
		public function FlyIcon()
		{
			//TODO: implement function
			super();
		}
		
		private var m_sx:int;
		private var m_sy:int;
		private var m_ex:int;
		private var m_ey:int;
		private var m_delay:int;
		
		/**
		 * 设置 
		 * @param sx
		 * @param sy
		 * @param ex
		 * @param ey
		 * @param delay 延时：秒
		 */		
		public function setPath(sx:int,sy:int,ex:int,ey:int,delay:int=0):void
		{
			m_sx = sx;
			m_sy = sy;
			m_ex = ex;
			m_ey = ey;
			m_delay=delay;
		}
		
		private var m_url:String = null;
		public function setIconURL(url:String):void
		{
			m_url = url;
		}
		
		public function doFly():void
		{
			if(null == m_url)
			{
				return ;
			}
			
			if(null == m_loader)
			{
				m_loader = new Loader();
				m_urlReq = new URLRequest();
				this.addChild(m_loader);
			}
			
			m_urlReq.url = m_url;
			m_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,_completeHandler);
			m_loader.addEventListener(IOErrorEvent.IO_ERROR, loadErr);
			m_loader.load(m_urlReq);
			
			
			//TweenMax.to(loader, 1.5, {scaleX: 1, scaleY: 1, x: bagPoint.x, y: bagPoint.y, bezier: [{x: UI_index.indexMC.stage.stageWidth / 2, y: UI_index.indexMC.stage.stageHeight * 2 / 3}, {x: UI_index.indexMC.stage.stageWidth / 2, y: UI_index.indexMC.stage.stageHeight * 2 / 3}], onComplete: fllowBag});
			//TweenLite.to(loader, 0.5, {y: bagPoint.y, onComplete: fllowBag});
		}
		private function loadErr(e:IOErrorEvent):void{
			trace("flyicon 错误")
		}
		private function _completeHandler(event:Event):void 
		{

			m_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,_completeHandler);
			

			this.x = m_sx;
			this.y = m_sy;
			this.scaleX = 1;
			this.scaleY = 1;
			
			TweenLite.to(this, 2, {delay:m_delay,x:m_ex,y:m_ey,scaleX:1.0,scaleY:1.0, onComplete: _endPly});
			
		}

		
		private function _endPly():void
		{
			if(null != this.parent)
			{
				this.parent.removeChild(this);
			}
		}
	}
	
	
}

