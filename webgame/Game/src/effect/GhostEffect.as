package effect
{
	import com.bellaxu.mgr.TimeMgr;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import scene.king.King;
	import scene.utils.PowerManage;
	
	import world.IWorld;
	
	public class GhostEffect extends Sprite implements IWorld
	{
		private var ghostList:Vector.<GhostFrame> = new Vector.<GhostFrame>();
		private var target:King;
		private var startTime:int = 0;
		private var endTime:int = 0;
		private var playTime:int = 0;
		public var playing:Boolean = false;
		private var m_nTick:int;
		private var step:int = 4;
		
		public function GhostEffect(k:King,playTime:int)
		{
			this.mouseChildren = this.mouseEnabled = false;
			this.target = k;
			this.playTime = playTime;
		}
		
		public function start():void
		{
			if (playing) return;
			playing = true;
			var container:DisplayObjectContainer = target.parent;
			if (target.roleFX == "F4" || target.roleFX == "F6")
			{
//				target.depthPri = DepthPri.BOTTOM;
//				depthPri = DepthPri.NORMAL;
//				step = 2;
				container.addChildAt(this,container.getChildIndex(target));
			}
			else
			{
				container.addChildAt(this,container.getChildIndex(target));
			}
			this.x = this.target.x;
			this.y = this.target.y;
			startTime = TimeMgr.cacheTime;
			endTime = startTime + playTime;
			PowerManage.AddFunc(play);
		}
		
		public function play(flag:Boolean=false):void
		{
			m_nTick++;
			if (m_nTick%step==0)
			{
				updateData();
			}
			updateDisplay();
			updateTime();
		}
		
		private function updateData():void
		{
			if (target == null || target.getSkin() == null || target.getSkin().getRole()==null)
				return;
			var len:int = ghostList.length;
			var bmp:Bitmap = target.getSkin().getRole().curBitmap;
			var bmd:BitmapData = bmp.bitmapData;
			var scaleX:int = bmp.scaleX;
			var frame:GhostFrame;
			var p:Point = new Point(bmp.x,bmp.y);
			p = target.getSkin().getRole().localToGlobal(p);
			p = this.globalToLocal(p);
			frame = new GhostFrame(p.x,p.y,bmd,scaleX);
			frame.totalTime = endTime - startTime;
			ghostList.push(frame);
		}
		
		private function updateDisplay():void
		{
			var currentX:int = target.x;
			var currentY:int = target.y;
			
			for each (var f:GhostFrame in ghostList)
			{
				if (f.x != currentX || f.y != currentY)
				{
					f.bmp.alpha = (f.totalTime-f.currentTime)/f.totalTime * 0.8;
					if (f.bmp.parent==null)
					{
						this.addChild(f.bmp);
					}
				}
			}
		}
		
		private function updateTime():void
		{
			for each (var f:GhostFrame in ghostList)
			{
				f.currentTime += TimeMgr.cacheTime - startTime; 
			}
			startTime = TimeMgr.cacheTime;
			if (endTime <= startTime)
			{
				PowerManage.DelFunc(play);
				destroy();
			}
		}
		
		public function destroy():void
		{
			playing = false;
			while (this.numChildren>0)
			{
				var bmd:Bitmap = this.removeChildAt(0) as Bitmap;
				bmd.bitmapData = null;
			}
			for each (var f:GhostFrame in ghostList)
			{
				f.bmp = null;
				f.bmd = null;
			}
			ghostList.length = 0;
			if (parent)
			{
				parent.removeChild(this);
			}
		}
		
		public function init():void
		{
			
		}
		
		/**
		 * 全局从标
		 */ 
		public function get mapx():Number
		{
			return 0;
		}
		
		public function get mapy():Number
		{
			return 0;
		}
		
		public function get svr_stop_mapx():Number
		{
			return 0;
		}
		
		public function get svr_stop_mapy():Number
		{
			return 0;
		}
		
		private var m_nDepthPri:int = 0;
		
		public function get depthPri():int
		{
			return m_nDepthPri;
		}
		
		public function set depthPri(value:int):void
		{
			this.m_nDepthPri = value;
		}
		
		public function DelHitArea():void
		{
			
		}
		
		public function UpdHitArea():void
		{
			
		}
		
//		/**
//		 * 
//		 */
//		public function set name(names : String) : void
//		{
//			
//		}
//		
//		public function get name() : String
//		{
//			return "";
//		}
		
		public function set name2(names : String) : void
		{
			
		}
		
		public function get name2() : String
		{
			return "";
		}
	}
}