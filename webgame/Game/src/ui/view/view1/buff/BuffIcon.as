package ui.view.view1.buff{
	import common.config.GameIni;
	
	import engine.load.GamelibS;
	
	import fl.containers.UILoader;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	import ui.frame.ImageUtils;
	
	import world.FileManager;

	/**
	 * @author suhang
	 * @create 2012-2-10
	 * buff实例
	 */
	public class BuffIcon extends Sprite{
		//private var uisp:UILoader;
		private var _data:Object =null;
		private var instance:MovieClip =null;
		public var tipParam:Array;
		
		//private var url:String = "";
		
		public function BuffIcon():void{
			instance=GamelibS.getswflink("game_utils","mBuffIcon") as MovieClip;
			this.addChild(instance);
			//uisp=instance["sp"] as UILoader;
			//uisp.width=16;
			//uisp.height=16;
			
			instance["sp"].width=16;
			instance["sp"].height=16;
		}
		
		public function set icon(id:int):void{
			//uisp.source = FileManager.instance.getBuffIconById(id);
//			instance["sp"].source = FileManager.instance.getBuffIconById(id);
			ImageUtils.replaceImage(instance,instance["sp"],FileManager.instance.getBuffIconById(id));
		}
		
		public function set data(objdata:Object):void{
			_data=objdata;
		}

		public function get data():Object{
			return _data;
		}


									   
	}
}
