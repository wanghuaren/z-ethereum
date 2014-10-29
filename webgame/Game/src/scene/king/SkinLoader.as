package scene.king
{
	import com.bellaxu.def.ResPriorityDef;
	import com.bellaxu.res.ResMc;
	import com.bellaxu.res.ResTool;
	import com.bellaxu.util.MathUtil;
	import com.bellaxu.util.PathUtil;
	
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import world.WorldEvent;

	public class SkinLoader extends EventDispatcher
	{
		/** 层级 **/
		public var layer:int;
		public var xmlUrl:String;
		
		public function SkinLoader(layer:int)
		{
			this.layer = layer;
		}

		public function destory():void
		{
			xmlUrl = null;
		}

		public function loading(king_name2:String, king_isMe:Boolean, king_isMePet:Boolean, path:String):void
		{
			if(!path || path == "")
				return;
			this.xmlUrl = PathUtil.getTrimPath(path);
			if (ResTool.isLoaded(xmlUrl))
			{
				this.onLoadedXml(xmlUrl);
				return;
			}
			ResTool.load(xmlUrl, onLoadedXml, loadProgress, null, new ApplicationDomain(), king_isMe ? ResPriorityDef.SHIGH : ResPriorityDef.NORMAL);
		}
		
		private function onLoadedXml(url:String):void
		{
			if(!xmlUrl)
				return;
			this.dispatchEvent(new WorldEvent(WorldEvent.PROGRESS_HAND, {layer: this.layer, data: [100, 100]}));
			this.dispatchEvent(new WorldEvent(WorldEvent.COMPLETE_HAND, {layer: this.layer, movie: ResTool.getResMc(PathUtil.getTrimPath(xmlUrl))}));
		}
		
		public function clearCallback():void
		{
			if(!xmlUrl)
				return;
			ResTool.clearNotify(xmlUrl, onLoadedXml);
			ResTool.clearNotify(xmlUrl, loadProgress);
		}

		public function loadProgress(bytesLoaded:uint, bytesTotal:uint):void
		{
			if(!xmlUrl)
				return;
			this.dispatchEvent(new WorldEvent(WorldEvent.PROGRESS_HAND, {layer: this.layer, data: [int(bytesLoaded * 100 / bytesTotal), 100]}));
		}
	}
}
