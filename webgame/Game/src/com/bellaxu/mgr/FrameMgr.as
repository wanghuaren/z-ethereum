package com.bellaxu.mgr
{
    import com.bellaxu.def.RenderGroupDef;
    import com.bellaxu.def.RenderGroupSpeedDef;
    
    import flash.display.Stage;
    import flash.events.Event;
    import flash.utils.Dictionary;
    import flash.utils.getTimer;
    
    /**
	 * 游戏帧的管理
     * @author BellaXu
     */
    public class FrameMgr
    {
        private static var groupDic:Dictionary = new Dictionary(); //组别字典, 存放数据[curSpeed, funcVec]
        private static var pauseDic:Dictionary = new Dictionary(); //暂停字典, 存放数据[groups];
		private static var funcParamsDic:Dictionary = new Dictionary(); //方法被Enter的次数字典, 存放数据[enterCount, runCount, runCount, ...args]
        private static var interval:uint;//时间片长度
        private static var lastTime:uint;//上次帧时间
		private static var lostTime:uint;//丢失的时间
		private static var lostCount:uint;//连续丢帧的次数
		private static var lostFlag:Boolean = false; //连续丢帧的标志

        public static function regist(stage:Stage) : void
        {
			//算每帧时间
			interval = 1000 / stage.frameRate;
			//监听舞台帧，全局只有这个帧监听，其他地方不要添加了
            stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			groupDic[RenderGroupDef.NO_DELAY] = [RenderGroupSpeedDef[RenderGroupDef.NO_DELAY][RenderGroupSpeedDef.NORMAL], new <Function>[]];
        }
		
		/**
		 * 假如连续100帧丢帧，则认定为当前不适合跑高帧频
		 */
		public static function get isBad():Boolean
		{
			return lostCount > 100;
		}
		
		private static function onEnterFrame(e:Event) : void
		{
			var curTime:uint = getTimer();
			var timeGap:uint = curTime - lastTime;
			if(timeGap > interval)
			{
				lostTime += timeGap - interval;
				if(timeGap >= interval << 1)
				{
					lostFlag = true;
					lostCount++;
				}
				else
				{
					lostFlag = false;
					lostCount = 0;
				}
			}
			else
			{
				lostFlag = false;
				lostCount = 0;
			}
			var renderTimes:uint = 1;
			if(lostTime >= interval)
			{
				renderTimes += int(lostTime / interval);
				lostTime = lostTime % interval;
				
				if(renderTimes >= 5)
				{
					//新增规则，最多渲染5次，避免单个时间片因为补帧太卡
					renderTimes = 5;
				}
			}
			var i:int = 0;
			var group:String = null;
			var tmp:Array = null;
			var speed:uint = 0;
			var funcVec:Vector.<Function> = null;
			var func:Function = null;
			var funcParams:Array = null;
			var delFuncs:Vector.<Function> = null;
			for(i = 0; i < renderTimes; i++)
			{
				for(group in groupDic)
				{
					if(pauseDic[group] == true)
						continue;
					tmp = groupDic[group];
					speed = tmp[0];
					funcVec = tmp[1];
					delFuncs = new <Function>[];
					for each(func in funcVec)
					{
						funcParams = funcParamsDic[func];
						if(funcParams[2] == 0)
						{
							delFuncs.push(func);
						}
						else if(++funcParams[0] % speed == 0)
						{
							func.apply(null, funcParams[3]);
							funcParams[0] = 0; //进入次数清0
							//若达到规定运行的次数则删除该方法
							if(++funcParams[1] >= funcParams[2] && funcParams[2] >= 0)
								delFuncs.push(func);
						}
					}
					for each(func in delFuncs)
					{
						delFunction(func, group);
					}
				}
			}
			lastTime = getTimer();
		}
		
		/**
		 * 判断组别中是否有某个方法
		 */
		public static function hasEnterFramefunc(func:Function, group:String) : Boolean
		{
			return groupDic[group] && groupDic[group][1].indexOf(func) > -1;
		}
		
		/**
		 * 指定组别中添加方法，并设定速度speed，执行次数count(-1为无限执行)，参数列表args
		 */
		public static function addFunction(func:Function, group:String, count:int = -1, ...args) : void
		{
			if(func == null || !groupDic[group] || groupDic[group][1].indexOf(func) > -1)
				return;
			delFunction(func, group);
			funcParamsDic[func] = [0, 0, count, args];
			groupDic[group][1].push(func);
		}
		
		public static function delFunction(func:Function, group:String) : void
		{
			if (!hasEnterFramefunc(func, group))
				return;
			//从字典中也删除
			var funcVec:Vector.<Function> = groupDic[group][1];
			if(funcVec.indexOf(func) > -1)
			{
				funcVec.splice(funcVec.indexOf(func), 1);
				delete funcParamsDic[func];
			}
		}
		
		/**
		 * 播放一个组别
		 */
		public static function playGroup(group:String) : void
		{
			if(pauseDic[group])
				delete pauseDic[group];
		}
		
        /**
		 * 暂停一个组别
		 */
        public static function pauseGroup(group:String) : void
        {
            pauseDic[group] = true;
        }
    }
}
