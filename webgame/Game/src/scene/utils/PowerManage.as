package scene.utils 
{
	import com.engine.utils.HashMap;
	
	import flash.events.Event;
	import flash.events.TimerEvent;

	/**
	 * @author shuiyue
	 */
	public class PowerManage 
	{
		//--------------------------- begin -------------------------
		public static var way:HashMap = new HashMap();
		
		
		
		//--------------------------- end ---------------------------
		
		
		
		public static var isRunStart : Boolean = false;
		private static var FuncList : Vector.<Function> = new Vector.<Function>();
		
		//newcodes
		//public static var clock:Timer = new Timer(10);

		private static function InitAndRunStart() : void {
			if(!isRunStart) {
				isRunStart = true;
				//移至game_main的Frame事件中
				//clock.addEventListener(TimerEvent.TIMER,onTick);
//				clock.start();
			}
		}
		
		private static function onTick(e:TimerEvent):void{
			for each(var F:Function in FuncList)
			{ 
				F.call(null,false);
			}
		}
		
		public static function HasFunc(runFunc : Function) :Boolean {
			var DelIndex : int = FuncList.indexOf(runFunc);
			if (DelIndex == -1) {
				return false;
			}
			
			return true;
		}

		public static function AddFunc(runFunc : Function) : Boolean {
			var DelIndex : int = FuncList.indexOf(runFunc);
			if (DelIndex == -1) {
				FuncList.push(runFunc);
				//InitAndRunStart();
				isRunStart = true;
				
				return true;
			}
			return false;
		}

		public static function DelFunc(runFunc : Function) : void {
			var DelIndex : int = FuncList.indexOf(runFunc);
			if (DelIndex >= 0) {
				FuncList.splice(DelIndex, 1);
				if(FuncList.length == 0 && isRunStart)StopAndDelAllRunFunc();
			}
		}

		public static var delayStartIndex:int = 0;
		
		public static function frameHandler(event:Event=null) : void
		{
//			return;
//			var index:int = 0;
//			var len:int = FuncList.length;
//			if (delayStartIndex>=len){
//				delayStartIndex = 0;
//			}
//			var tempList:Array = [];
			for each(var F:Function in FuncList)
			{ 
				F.call(null,false);
//				if (getTimer()-PreTimer<=40)//正常执行
//				{
//					if (index>=delayStartIndex){//正常执行
//						F.call(null,false);
//						delayStartIndex++;
//						if (delayStartIndex>=len){
//							delayStartIndex = 0;
//						}
//					}else{
////						F.call(null,true);//延迟
//						tempList.push(F);
//					}
//				}else{
//					F.call(null,true);//延迟
//				}
//				index++;
			}
//			return;
//			index = 0;
//			var func:Function;
//			while (getTimer()-PreTimer<=40){
//				if (tempList.length>0){
//					func = tempList.shift();
//					func.call(null,false);
//				}else{
//					break;
//				}
//				index++;
//			}
//			PreTimer = getTimer();
		}

		
		public static function StopAndDelAllRunFunc() : void {
			isRunStart = false;
			//FuncList = new Vector.<Function>();
			
			if(null == FuncList){FuncList = new Vector.<Function>();}
			
//			var len:int = FuncList.length;
//			for(var i:int=0;i<len;i++)
//			{
//				FuncList.pop();
//			}
			
			if(FuncList.length > 0){FuncList.splice(0,FuncList.length);}
			
			//移至game_main的Frame事件中
		}
	}
}
