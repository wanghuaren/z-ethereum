package ui.view.view2.liandanlu
{
	
	import flash.display.MovieClip;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;

	/**
	 *	装备合成
	 *  andy 2014-02-11 
	 */
	public class HC extends UIWindow{
		//当前选中数据
		private var curData:StructBagCell2=null;
		//当前选中数据
		private var mc_list:MovieClip=null;
		
		private static const PAGE_SIZE:int=6;
		//职业
		private var metier:int=0;
		//等级
		private var level:int=0;
		
		private static var _instance:HC;

		public static function instance():HC{
			if(_instance==null){
				_instance=new HC();
			}
			return _instance;
		}
		
		public function HC(){
			super(this.getLink(WindowName.win_hc));
		}
		
//		override public function get width():Number{
//			return 330;
//		}

		public function setType(v:int,must:Boolean=false):void{			
			type=v;
			super.open(must);
		}
		override protected function openFunction():void{
			init();
		}
		override protected function init():void{
			super.init();
			super.blmBtn=0;
			
			metier=Data.myKing.metier;
			for(i=1;i<=6;i++){
				if(mc["rad_metier"+i]!=null)
				mc["rad_metier"+i].selected=false;
			}
			if(mc["rad_metier"+Data.myKing.metier]!=null)
			mc["rad_metier"+Data.myKing.metier].selected=true;
		}	
		override public function mcHandler(target:Object):void
		{
			var name:String=target.name;
			if(name.indexOf("rad_metier")==0){
				metier=int(name.replace("rad_metier",""));
				show();
				return;
			}
			if(name.indexOf("btnLevel")==0){
				level=int(name.replace("btnLevel",""));
				show();
				return;
			}

			
			switch(name){
				case "":
					//合成
					
					break;	
				default :
					break;
			}
			
		}
		
		/**
		 *	 
		 */
		private function show():void{
	
			if(metier>0&&level>0){
				var tupuId:int=int(metier+""+level);
				HCTuPu.instance().setType(tupuId,level,true);
			}
		}

		
		override protected function windowClose():void{
			super.windowClose();
			
		}

		override public function getID():int
		{
			return 1081;
		}

	}
}