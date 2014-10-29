package scene.utils
{
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import netc.Data;
	import netc.MsgPrint;
	import netc.MsgPrintType;
	
	import scene.action.PathAction;
	import scene.action.hangup.GamePlugIns;
	import scene.king.IGameKing;

	public class MyWay
	{
		
		/**
		 * 主人公的路结点
		 */
		private static var _way:Array = [];
		private static var _wayFull:Array = [];
		
		public static var isJump_:int;

		public static function get pbOrzl():String
		{
			return _pbOrzl;
		}

		public static function set pbOrzl(value:String):void
		{
			if(_pbOrzl == value)
				return;
			_pbOrzl = value;
		}

		public static function get way():Array
		{
			return _way;
		}
		
		//
		private static var _time1:int;
		
		/**
		 * @private
		 */
		public static function set way(value:Array):void
		{
			T;
			
			var _way_len:int = null == _way?0:_way.length;
			
			//如果数据完全相同的话，则不重复设置
			if(isSamePath(_way,value) ||				
			  (isSamePath(_wayFull,value) && _way_len > 0)
			)
			{
				return;
			}
			
			//路径被更改了
			if(null == value){
				_wayFull = value;
			}else{
				_wayFull = new Array().concat(value);
			}
			_way = value;
			wayIndex = 0;
			
			//
			_time1 = getTimer();// / 1000;
			
			//
			THandler();
			
		}
		
		private static var _wayIndex:int = 0;
				
		public static function get wayIndex():int
		{
			return _wayIndex;
		}

		public static function set wayIndex(value:int):void
		{
			_wayIndex = value;
		}
		
		
		/**
		 * 模拟服务端的驱动器
		 */ 
		private static var _t:Timer;
		
		public static function get T():Timer
		{
			if(null == _t)
			{
				_t = new Timer(100);
				_t.addEventListener(TimerEvent.TIMER,THandler);
				
			}
			
			if(!_t.running)
			{
				_t.start();
			}
			
			return _t;
		}
		public static var heroIsMoving:Boolean
		private static var _pbOrzl:String
		public static function THandler(event:TimerEvent=null):void
		{
				
			if(null == way || 0 == way.length)
			{
				
				
				//
				T.stop();
				var _time2:int = getTimer();///1000;
								
				if(null != _wayFull && _wayFull.length >= 2 && MsgPrint.printOpen){
										
				var pA:Point = new Point(_wayFull[0][0],_wayFull[0][1]);
				var pB:Point = new Point(_wayFull[_wayFull.length-1][0],_wayFull[_wayFull.length-1][1]);
					
				MsgPrint.printTrace("从(" + pA.x + "," + pA.y + ")移动到(" 
										  + pB.x + ","  + pB.y + ")长" 
										  + Point.distance(pA,pB).toFixed(0) + "像素",
										  MsgPrintType.WINDOW_REFRESH);
				
				MsgPrint.printTrace("用时" + (_time2 - _time1)/1000 + "秒",MsgPrintType.WINDOW_REFRESH);				
				}
				return;
			}
			
			var k:IGameKing = Data.myKing.king;			
		
			//计算wayIndex
			var k_x:int = k.x;
			var k_y:int = k.y;
			
			//
			var wayPo:Point;
			var curPo:Point = new Point(k.x,k.y);
			
			//用于容错处理
			var isMatch:Boolean = false;
						
			//
			for(var i:int=0;i<way.length;i++)
			{				
				curPo.x = k_x = k.x;
				curPo.y = k_y = k.y;
				
				//
				if(-1 == wayIndex ||
					0 == wayIndex || 
				(k_x == way[i][0] && k_y == way[i][1])
				)
				{					
					//
					isMatch = true;
					
					if(-1 == wayIndex)
					{
						wayIndex = 0;
					}else{
						wayIndex=i+1;
					}
					
					if(wayIndex < way.length){						
						wayPo = new Point(way[wayIndex][0],way[wayIndex][1]);
						
						//
						way.splice(i,1);
						
						//
						ScMove(wayPo,curPo,isJump_,k.objid,k,pbOrzl);
					}else{
					
						wayPo = new Point(way[way.length-1][0],way[way.length-1][1]);
						
						//
						way.splice(i,1);
						
						//
						ScMove(wayPo,curPo,isJump_,k.objid,k,pbOrzl);
					}
					
					
					
							
					
					break;
				}
			
			}
			
			
			//容错检测
			if(!isMatch)
			{
				var hasPower:Boolean = Data.myKing.king.hasPower;
				var idleSec:int = Data.idleTime.idleSecByXiuLian;
				
												
				if(!hasPower && GamePlugIns.getInstance().running &&
					PathAction.isCanPutIn)
				{
					RESET_WARN();
				}
				
				if(!hasPower && idleSec >= 2)//3)
				{
					RESET_WARN();
				}
			
			}
			
		
			
		
		}

		private static function RESET_WARN():void
		{
			if(null != way && way.length > 0){
				wayIndex =-1;
			}
		}
		
		
		/**
		 * 
		 * 接收移动指令
		 * 		
		 * 
		 * curPo 起点
		 * wayPo 终点
		 */  
		 private static function ScMove(wayPo:Point,curPo:Point,isjump:int,aid:uint,k:IGameKing=null,zt:String=null):void
		 {			
		 	
			k.setKingMoveTarget(wayPo,curPo,isjump,zt);			
		 
		 
		 }
		
//		
//		
//		
//		
//		
//		 /**
//		  * 接收停止指令
//		  * 
//		  */ 
//		 public static function ScStop(k:IGameKing=null):void
//		 {
//			 if(k.isMe)
//			 {
//				 //马上停
//				 
//			 }else
//			 {
//				 
//				 
//				 
//			 }
//			 
//		 }
		
		
		
		
		
		private static function isSamePath(a:Array,b:Array):Boolean
		{
			
			//
			if(null == a && null == b)
			{
				return false;
			}
			
			//
			if(null == a && null != b)
			{
				return false;
			}
			
			//
			if(null != a && null == b)
			{
				return false;
			}
			
			//
			if(null != a && null != b)
			{
				if(a.length != b.length)
				{
					return false;
					
				}
				
				var len:int = b.length;
				for(var i:int=0;i<len;i++)
				{
					if(a[i][0] != b[i][0] || 
						a[i][1] != b[i][1])
					{
						
						return false;
						
					}				
				}				
				
			}
			
			return true;
			
		}
		
		
		
		
		
	}
}