package scene.action
{
	import flash.display.DisplayObject;
	
	import scene.king.IGameKing;
	import scene.manager.SceneManager;
	import scene.skill2.SkillEffect12;
	import scene.skill2.SkillEffectManager;
	
	import world.FileManager;
	
	public class QiangHuaAction
	{
		public function QiangHuaAction()
		{
		}
		
		/**
		 * 全身装备(包括神器)完美强化到8星，人物显示绿色发光特效；
		           全身装备(包括神器)完美强化到12星，人物显示蓝色发光特效；
		           全身装备(包括神器)完美强化到16星，人物显示紫色发光特效；
		           全身装备(包括神器)完美强化到20星，人物显示橙色发光特效；
			
		   "qianghua_green"
		   "qianghua_blue"	
		   "qianghua_purp"		
		   "qianghua_orange"
		   
		 * 
		 */ 
		public function StarUpdate(objid:uint,starPrimetive:int,k:IGameKing = null):void
		{
			
			if(null == k)
			{
				k = SceneManager.instance.GetKing_Core(objid);
			}			
			
			if(null == k)
			{
				return;
			}
			
			//starPrimetive原始数据，来自r1，高16位	
			//var dataList:Array = BitUtil.convertToBinaryArr(starPrimetive);
			var star:int = starPrimetive >> 16;
			
			//test
			//star = 1;
			
			//
			ColorUpdate(k,1 == star?true:false,"qianghua_green");
			ColorUpdate(k,2 == star?true:false,"qianghua_blue");
			ColorUpdate(k,3 == star?true:false,"qianghua_purp");
			ColorUpdate(k,4 == star?true:false,"qianghua_orange");
		}
		
		
		public function getColor(objid:uint):String
		{
			var k:IGameKing = SceneManager.instance.GetKing_Core(objid);
		
			if(null == k)
			{
				return "";
			}
			
			if("" == k.qiangHuaColor)
			{
				return "";
			}
			
			return FileManager.instance.getSkill12FileByFileName(k.qiangHuaColor).swf_path0;
			
		}
		
		private function ColorUpdate(k:IGameKing,
									 hasColor:Boolean,
									 color:String):void
		{
			var hasEffect:Boolean = ChkEffect(k,color);
			
			if(hasColor)
			{
				if(!hasEffect)
				{				
					AddEffect(k,color);
				}
				
				//
				//GameMusic.playWave(WaveURL.ui_hun_release);
				
			}
			
			if(!hasColor)
			{
				if(hasEffect)
				{
					DelEffect(k,color);
				}
			}
		
		}
		
		
		
		private function AddEffect(k:IGameKing,color:String):void
		{
			var se_color:SkillEffect12 = new SkillEffect12();
			se_color.setData(k.objid,color);
			SkillEffectManager.instance.send(se_color);
		
		}
		
		private function ChkEffect(k:IGameKing,color:String):Boolean
		{
			var i:int;
			var d:DisplayObject;
			var hasEffect:Boolean = false;
			
			for(i =0;i<k.getSkin().effectUp.numChildren;i++)
			{
				d = k.getSkin().effectUp.getChildAt(i);	
				
				if(d as SkillEffect12)
				{
					if(color == (d as SkillEffect12).path)
					{
						hasEffect = true;
						break;
					}
				}
			}
			
			for(i =0;i<k.getSkin().effectDown.numChildren;i++)
			{
				d = k.getSkin().effectDown.getChildAt(i);	
				
				if(d as SkillEffect12)
				{
					if(color == (d as SkillEffect12).path)
					{
						hasEffect = true;
						break;
					}
				}
			}
			
			//
			for(i =0;i<k.getSkin().foot.numChildren;i++)
			{
				d = k.getSkin().foot.getChildAt(i);	
				
				if(d as SkillEffect12)
				{
					if(color == (d as SkillEffect12).path)
					{
						hasEffect = true;
						break;
					}
				}
			}
			
			return hasEffect;
			
		}
		
		
		private function DelEffect(k:IGameKing,color:String):void
		{
			var i:int;
			var d:DisplayObject;
			
			for(i =0;i<k.getSkin().effectUp.numChildren;i++)
			{
				d = k.getSkin().effectUp.getChildAt(i);	
				
				if(d as SkillEffect12)
				{
					if(color == (d as SkillEffect12).path)
					{
						(d as SkillEffect12).Four_MoveComplete();
						//break;
					}
				}
			}
			
			for(i =0;i<k.getSkin().effectDown.numChildren;i++)
			{
				d = k.getSkin().effectDown.getChildAt(i);	
				
				if(d as SkillEffect12)
				{
					if(color == (d as SkillEffect12).path)
					{
						(d as SkillEffect12).Four_MoveComplete();
						//break;
					}
				}
			}
			
			//
			for(i =0;i<k.getSkin().foot.numChildren;i++)
			{
				d = k.getSkin().foot.getChildAt(i);	
				
				if(d as SkillEffect12)
				{
					if(color == (d as SkillEffect12).path)
					{
						(d as SkillEffect12).Four_MoveComplete();
						//break;
					}
				}
			}
			
			
		}
		
		
		
	}
}