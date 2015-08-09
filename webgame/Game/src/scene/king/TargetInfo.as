package scene.king
{
	import scene.manager.SceneManager;

	public class TargetInfo
	{
		/**
		 *
		 */
		public var srcid:int;
		public var src_mapx:int;
		public var src_mapy:int;

		/**
		 * 加载技能元件路径需要src_sex
		 */
		public var src_sex:int;

		/**
		 * 元件的宽高，以便调整技能元件出生位置
		 */
		public var src_width:int;
		public var src_height:int;

		/**
		 * 主显示的数据
		 */
		public var src_originX:Number;
		public var src_originY:Number;


		/**
		 *
		 */
		public var targetid:int;
		public var target_mapx:int;
		public var target_mapy:int;

		/**
		 * 元件的宽高，以便调整技能元件出生位置
		 */
		public var target_width:int;
		public var target_height:int;

		/**
		 * 主显示的数据
		 */
		public var target_originX:Number;
		public var target_originY:Number;

		/**
		 *
		 */
		public var logiccount:int;
		private static var _instance:TargetInfo;

		public static function getInstance():TargetInfo
		{
			if (_instance == null)
			{
				_instance=new TargetInfo(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
			}
			return _instance;
		}
		public static var vectorPoolItems:Vector.<TargetInfo>=new Vector.<TargetInfo>();

		public function getItem(srcid_:int, src_sex_:int, src_mapx_:int, src_mapy_:int, src_width_:int, src_height_:int, src_originX_:int, src_originY_:int, targetid_:int, target_mapx_:int, target_mapy_:int, target_width_:int, target_height_:int, target_originX_:Number, target_originY_:Number, logiccount_:int):TargetInfo
		{
			var reTargetInfo:TargetInfo;
			if (vectorPoolItems.length<1)
			{
				for (var i:int=0; i < 200; i++)
				{
					vectorPoolItems.push(new TargetInfo(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
				}
			}
			reTargetInfo=vectorPoolItems.pop();
			if (reTargetInfo == null)
			{
				reTargetInfo=new TargetInfo(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
			}
			//
			reTargetInfo.srcid=srcid_;

			reTargetInfo.src_sex=src_sex_;

			reTargetInfo.src_mapx=src_mapx_;
			reTargetInfo.src_mapy=src_mapy_;

			reTargetInfo.src_width=src_width_;
			reTargetInfo.src_height=src_height_;

			reTargetInfo.src_originX=src_originX_;
			reTargetInfo.src_originY=src_originY_;

			//
			reTargetInfo.targetid=targetid_;

			reTargetInfo.target_mapx=target_mapx_;
			reTargetInfo.target_mapy=target_mapy_;

			reTargetInfo.target_width=target_width_;
			reTargetInfo.target_height=target_height_;

			reTargetInfo.target_originX=target_originX_;
			reTargetInfo.target_originY=target_originY_;

			//
			reTargetInfo.logiccount=logiccount_;

			return reTargetInfo;
		}

		public function TargetInfo(srcid_:int, src_sex_:int, src_mapx_:int, src_mapy_:int, src_width_:int, src_height_:int, src_originX_:int, src_originY_:int, targetid_:int, target_mapx_:int, target_mapy_:int, target_width_:int, target_height_:int, target_originX_:Number, target_originY_:Number, logiccount_:int)
		{
			//
			this.srcid=srcid_;

			this.src_sex=src_sex_;

			this.src_mapx=src_mapx_;
			this.src_mapy=src_mapy_;

			this.src_width=src_width_;
			this.src_height=src_height_;

			this.src_originX=src_originX_;
			this.src_originY=src_originY_;

			//
			this.targetid=targetid_;

			this.target_mapx=target_mapx_;
			this.target_mapy=target_mapy_;

			this.target_width=target_width_;
			this.target_height=target_height_;

			this.target_originX=target_originX_;
			this.target_originY=target_originY_;

			//
			this.logiccount=logiccount_;
		}


		public function clone():TargetInfo
		{
			return TargetInfo.getInstance().getItem(this.srcid, this.src_sex, this.src_mapx, this.src_mapy, this.src_width, this.src_height, this.src_originX, this.src_originY, this.targetid, this.target_mapx, this.target_mapy, this.target_width, this.target_height, this.target_originX, this.target_originY, this.logiccount);
		}



	}
}
