package scene.winWeather
{
	import com.bellaxu.res.ResMc;
	import com.bellaxu.util.StageUtil;
	
	import com.bellaxu.data.GameData;
	import common.utils.clock.GameClock;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.Event;
	
	import netc.Data;
	
	import scene.event.KingActionEnum;
	import scene.king.SkinBySkill;
	import scene.utils.MapCl;
	import scene.weather.WeaterEffectManager;
	
	import ui.frame.UIWindow;
	
	import world.FileManager;
	import world.WorldEvent;
	import world.model.file.SkillFilePath;
	
	public class WinWeaterEffectByFog extends UIWindow
	{
		
		private static var _instance:WinWeaterEffectByFog;
		
		public static function getInstance():WinWeaterEffectByFog
		{
			if (null == _instance)
			{
				_instance=new WinWeaterEffectByFog();
			}
			
			return _instance;
		}
		
		/**
		 * 锯齿形数组
		 */ 
		public var cloudList:Array;
		
		
		public const MIN_NEED_CLOUD_LIST_COL:int = 4;//4;
		public const MIN_NEED_CLOUD_LIST_ROW:int = 3;//3;
		
		/**
		 * 
		 */ 
		public var fc:int;
		public const CREATE_CLOUD_TIMEOUT_FRAME:int = 15;//5;
		
		/**
		 * 美术元件 云 宽高
		 */ 
		public const CLOUD_WIDTH:int = 1000;//522;//1024;
		public const CLOUD_HEIGHT:int = 320;//401;
		
		/**
		 * 
		 */
		public function get DZ():String
		{
			return KingActionEnum.DJ;
		}
		
		public function get FX():String
		{
			//return "F1";
			return "F2";
		}
		
		public function WinWeaterEffectByFog()
		{
			var DO:DisplayObject = new McWeaterEffectByCloud();
			
			super(DO, null, 1, false);
		}
		
		override protected function init():void
		{
			var _g:Graphics = this.graphics;
			
			_g.clear();
			
			_g.beginFill(0x000000,0.0);
			_g.drawRect(0, 0, 50, 50);
			_g.endFill();
			
			//
			this.x = 0;
			
			//不可点击，以免引起child变化,uiwindow基本规则：点了后调到最上层
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
			//
			count = 0;
			
			//
			cloudList = [];			
			//
			GameClock.instance.addEventListener(WorldEvent.CLOCK__,frameHandler);
			
		}
		
		
		
		public function frameHandler(e:Event):void
		{
			fc++;
			
			var w:int = StageUtil.stageWidth;
			var h:int = StageUtil.stageHeight;
			var d:DisplayObject;
			
			//美术元件 云 宽高
			var testCloudListCol:int = w / CLOUD_WIDTH;
			var testCloudListRow:int = h / CLOUD_HEIGHT;
			
			if(testCloudListCol < MIN_NEED_CLOUD_LIST_COL){testCloudListCol = MIN_NEED_CLOUD_LIST_COL;}			
			if(testCloudListRow < MIN_NEED_CLOUD_LIST_ROW){testCloudListRow = MIN_NEED_CLOUD_LIST_ROW;}
			
			
			
			//加载第一个
			if(CREATE_CLOUD_TIMEOUT_FRAME == fc)
			{
				if(0  == cloudList.length)
				{
					One_CreateEffect(testCloudListCol);
					
				}
			}
			
			//加载后续
			if(fc > CREATE_CLOUD_TIMEOUT_FRAME*3)
			{
				//多弄一行，以便下面随机的y
				if(cloudList.length < (testCloudListRow+1))
				{
					One_CreateEffect(testCloudListCol);		
				}
			}
			
			
			//
			Three_Move();
		}
		
		/**
		 * 创建效果文件
		 */ 
		public function One_CreateEffect(testCloudListCol:int):void
		{
			//
			var k:int;
			var cloudRow:Array = [];
			var d:DisplayObject;
			
			var w:int = StageUtil.stageWidth;
			var h:int = StageUtil.stageHeight;
			
			var d_y:int;
			
			d_y = cloudList.length * CLOUD_HEIGHT;
			
			//整体往上提一点
			//距离20
			//d_y -= CLOUD_HEIGHT/10;//3;
			
			
			//随机一下Y值
			if(cloudList.length > 0)
			{
				//d_y -= Math.random() * (CLOUD_HEIGHT/10);//3);	
				d_y -= 200;//100;
				
				d_y -= cloudList.length * 60;
				
								
			}else
			{
				d_y -= 200;//100;				
			}
			
			for(k=0;k<testCloudListCol;k++)
			{
				d = getDisplayContent();		
				
				//靠屏幕右边，靠近
				//d.x = k * (w/2) * -1;
				d.x = (w - CLOUD_WIDTH) - k*CLOUD_WIDTH;
				
				//movie居中对齐?
				d.x += CLOUD_WIDTH/2;
				
				//
				d.y = d_y;
				
				Two_AddChild(d);
				cloudRow.push(d);
			}
			
			cloudList.push(cloudRow);
			
		}
		
		/**
		 * 增加到屏幕
		 */ 
		public function Two_AddChild(d:DisplayObject):void
		{								
			
			this.addChild(d);
			
			Two_Sub_RefreshFx(d);
		}
		
		
		public function Two_Sub_RefreshFx(d:DisplayObject):void
		{	
			//loop use
			var i:int;
			
			//调整方向
			//var d:DisplayObject;	
			
			//for(i=0;i<this.numChildren;i++)
			//{
			//d = this.getChildAt(i);
			
			if(d as ResMc)
			{
				MapCl.setFangXiang(d as ResMc,this.DZ,this.FX);
				
			}else if(d as SkinBySkill)
			{
				//
				(d as SkinBySkill).setAction(this.DZ,this.FX,0,null);
				
			}
			
			//}//end for	
			
		}
		
		public function Three_Move():void
		{
			var jLen:int = this.cloudList.length;
			
			for(var j:int=0;j<jLen;j++)
			{	
				var kLen:int = cloudList[j].length;
				
				for(var k:int = 0;k<kLen;k++)
				{
					Three_Move_Cloud(cloudList[j][k]);
				}
			}
		}
		
		
		/**
		 * 移动
		 */ 
		public function Three_Move_Cloud(d:DisplayObject):void
		{
			var w:int = StageUtil.stageWidth;
			var h:int = StageUtil.stageHeight;
			
			var roleZT:String = Data.myKing.king.roleZT;
			var roleFX:String = Data.myKing.king.roleFX;
			
			//if(fc % 2 == 0)
			//{
			//	d.x += 1;
			
			d.x += 4;
			//}
			
			
			//if(fc % 3 == 0)
			//{
			//当人物停止时,y轴不下降
			//现在y轴不动
			if(roleZT == KingActionEnum.PB)
			{
				//d.y+= 4;
			}
			//}
			
			//reset point ----------------------------------------------
			//if(d.x > (w/2 + CLOUD_WIDTH/3))
			if(d.x > (w + CLOUD_WIDTH/2))
			{
				//d.x = 0 - w/2;
				d.x = 0 - CLOUD_WIDTH/2;
			}
			
			//if(d.y > (h + CLOUD_HEIGHT/3))
			//{
			//	d.y = 0 - h/2;
			//}
		}
		
		/**
		 * 
		 */ 
		public function Four_MoveComplete():void
		{
			//
			clear();
			
			
		}
		
		public function clear():void
		{
			var len:int = this.numChildren;
			
			var d:DisplayObject;
			for(var i:int=0;i<len;i++)
			{
				d = this.removeChildAt(0);
				
				if(d as SkinBySkill)
				{
					(d as SkinBySkill).removeAll();
					
				}else if(d as ResMc)
				{
					//(d as Movie).stop();
					(d as ResMc).close();
				}				
			}			
			
		}
		
		
		public function getDisplayContent():DisplayObject
		{
			var d:DisplayObject; 
			var bfp:SkillFilePath;
			
			//bfp = FileManager.instance.getSkillSoulFileByFileName("yjf_cloud");	
			bfp = FileManager.instance.getSkill12FileByFileName("xueWu");
			d =  WeaterEffectManager.instance.getPoolByCloud(bfp);
			
			return d;
		}
		
		
		
		
		// 窗口关闭事件
		override protected function windowClose():void
		{
			GameClock.instance.removeEventListener(WorldEvent.CLOCK__,frameHandler);
			
			if(null != this.cloudList)
			{
				var jLen:int = this.cloudList.length;
				
				var d:DisplayObject;
				
				for(var j:int =0;j<jLen;j++)
				{
					var kLen:int = this.cloudList[j];
					
					for(var k:int =0;k<kLen;k++)
					{
						d = this.cloudList[j][k];
						
						if(d as SkinBySkill)
						{
							(d as SkinBySkill).removeAll();
							
						}else if(d as ResMc)
						{
							//(d as Movie).stop();
							(d as ResMc).close();
						}		
						
					}//end for				
				}//end for	
				
				cloudList = [];
				
			}
			
			//
			Four_MoveComplete();
			
			super.windowClose();
			
		}
		
		
		override public function closeByESC():Boolean
		{
			return false;
		}
		
		
		
	}
}