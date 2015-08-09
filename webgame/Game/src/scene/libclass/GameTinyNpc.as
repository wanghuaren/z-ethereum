package scene.libclass{
	import com.bellaxu.res.ResTool;
	
	import display.components2.UILd;
	
	import engine.load.GamelibS;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;


	public class GameTinyNpc extends Sprite{
		private var _npcId:int=0;
		private var _sort:int=0;
		private var _hasTask:Boolean=false;
		private var mc:MovieClip =null;		
		private var _ld:UILd;
		
		public function GameTinyNpc():void{
//项目转换		mc=ResTool.getAppMc("mGameTinyNpc") as MovieClip;
			mc=GamelibS.getswflink("game_index","mGameTinyNpc") as MovieClip;
			this.addChild(mc);
			this.tabChildren = false;
			this.mouseChildren=false;
			this.buttonMode=true;
			mc["npc_name"].mouseEnabled=false;
			mc["npc_name"].text="";
			mc["npc_name"].visible=false;
		}
		
		public function get Ld():UILd
		{
			if(null == _ld)
			{
				_ld = new UILd();
			}
			
			return _ld;
		}
		
		public function setIcon(icon:int):void{
			this.mouseEnabled=true;
			//怪物图片
			if(sort==3){
				
//				var p:String = FileManager.instance.getMapMonsterIconById(icon);
//				
//				//暂时用不到，如加载没有的图，会报错
//				p = null;
//				
//				if(Ld.source == null ||
//					Ld.source != p)				
//				{
//					Ld.source= p ;
//				}
//				
//				this.addChild(Ld);
//				Ld.width=Ld.height=50;
//				Ld.x=-_ld.width/2;
//				Ld.y=-_ld.height;
//				Ld.buttonMode=true;				
//				Ld.mouseEnabled=_ld.mouseChildren=false;
//				
//				this.swapChildren(Ld,mc);
				
				//2013-08-22 andy 策划说怪物直接显示名字
				showName(true);
				this.mouseEnabled=false;
				return;
			}
			//2014-01-07 andy 策划说地图直接显示名字
			if(sort==4){
				showName(true);
			}
			//功能npc图片
			if(this.getChildByName("btnGameTinyNpc_"+npcId)!=null){
				this.removeChild(this.getChildByName("btnGameTinyNpc_"+npcId));
			}
			if(icon==0)return;
			var btn:SimpleButton= ResTool.getAppMc( "btn_"+icon) as SimpleButton;
			if(btn!=null){
				btn.name="btnGameTinyNpc_"+npcId;
//				btn.y=icon==1111?0:0;
				this.addChild(btn);
				this.setChildIndex(btn,0);
			}
		}
		
		public function setName(names:String):void{
			this.name="GameTinyNpc_"+npcId;
			mc["npc_name"].text=names;
			
			setNameColor();
			setNamePos();
		}
		public function setNamePos():void{
			var w:int=mc["npc_name"].textWidth/2;
			var h:int=mc["npc_name"].textHeight;
			if(sort==1){
				//npc
				mc["npc_name"].y=-30;
			}else if(sort==2&&this.hasTask==false){
				mc["npc_name"].y=-30;
			}else if(sort==3){
				//怪物
				mc["npc_name"].y=-12;
			}else{
			
			}	
				
			//andy npc名字超出边框
//			if(this.x+w>wt)
//				mc["npc_name"].x=mc["npc_name"].x-(this.x+w-wt);
//			if(this.x-w<0)
//				mc["npc_name"].x=mc["npc_name"].x-(this.x-w);
//			if(this.y+h>ht)
//				mc["npc_name"].y=mc["npc_name"].y-(this.y+h-ht)-3;

		}
		
		public function setNameColor():void{	
			if(sort==1||sort==2)
				mc["npc_name"].textColor=0xFF942B;
			else if(sort==3)
				mc["npc_name"].textColor=0xff0000;
			else if(sort==4)
				mc["npc_name"].textColor=0x4a9afe;
			else
				mc["npc_name"].textColor=0xFF942B;
		}
		
		public function showName(v:Boolean=true):void{
		
			mc["npc_name"].visible=v;
			if(sort==4)mc["npc_name"].visible=true;
		}
		
		public function showNpcIcon(v:Boolean=true):void{
			mc.gotoAndStop(v?1:2);
		}
		
		public function set npcId(v:int):void{
			_npcId=v;
		}
		public function get npcId():int{
			return _npcId;
		}
		
		public function set sort(v:int):void{
			_sort=v;
		}
		public function get sort():int{
			return _sort;
		}
		
		public function set hasTask(v:Boolean):void{
			_hasTask=v;
		}
		public function get hasTask():Boolean{
			return _hasTask;
		}
		
		public function get npcName():TextField{
			return mc["npc_name"];
		}
	}
}
