package world.model.file
{
	import common.config.GameIni;

	/**
	 * Author:fux
	 * Date: 2012/1/1
	 */
	public class BeingFilePath
	{
		/**
		 * s0 待定
		 * .swf相对路径
		 * .xml相对路径
		 */
		private var _s0:int;
		public var swf_path0:String;
		public var xml_path0:String;

		/**
		 * s1 坐骑
		 * .swf相对路径
		 * .xml相对路径
		 */
		private var _s1:int;
		public var swf_path1:String;
		public var xml_path1:String;

		/**
		 * s2 人物
		 * .swf相对路径
		 * .xml相对路径
		 */
		private var _s2:int;
		public var swf_path2:String;
		public var xml_path2:String;

		/**
		 * s3 武器
		 * .swf相对路径
		 * .xml相对路径
		 */
		private var _s3:int;
		public var swf_path3:String;
		public var xml_path3:String;

		/**
		 * 是否右手拿武器
		 *
		 * 武器和人物的层级关系
		 */
		public var rightHand:int;


		private var _pList:Array;		
		private var _xList:Array;
		
		public function BeingFilePath(s0_:int=0, 
									  s1_:int=0, 
									  s2_:int=0, 
									  s3_:int=0, 
									  pList_:Array = null,
									  xList_:Array = null, 
									  rh:int=1):void
		{
			//
			_pList = pList_;
			_xList = xList_;

			//
			this._s0=s0_;			
			
			this.swf_path0=_pList[0];
			this.xml_path0=_xList[0];

			this._s1=s1_;
			this.swf_path1=_pList[1];
			this.xml_path1=_xList[1];


			this._s2=s2_;
			this.swf_path2=_pList[2];
			this.xml_path2=_xList[2];

			this._s3=s3_;
			this.swf_path3=_pList[3];
			this.xml_path3=_xList[3];

			this.rightHand=rh;
		}



		/**
		 * 比较差异，决定是否重新加载
		 */
		public function compare(fresh:BeingFilePath):Array
		{
			var path_0_changed:Boolean=false;
			var path_1_changed:Boolean=false;
			var path_2_changed:Boolean=false;
			var path_3_changed:Boolean=false;

			if(null != fresh)
			{
				
				
				if (this.swf_path0 != fresh.swf_path0 || this.xml_path0 != fresh.xml_path0)
				{
					path_0_changed=true;
					
					this._s0=fresh.s0;
					this.swf_path0=fresh.swf_path0;
					this.xml_path0=fresh.xml_path0;
				}
				
				if (this.swf_path1 != fresh.swf_path1 || this.xml_path1 != fresh.xml_path1)
				{
					path_1_changed=true;
					
					this._s1=fresh.s1;
					this.swf_path1=fresh.swf_path1;
					this.xml_path1=fresh.xml_path1;
					
				}
				
				if (this.swf_path2 != fresh.swf_path2 || this.xml_path2 != fresh.xml_path2)
				{
					path_2_changed=true;
					
					this._s2=fresh.s2;
					this.swf_path2=fresh.swf_path2;
					this.xml_path2=fresh.xml_path2;
					
				}
				
				if (this.swf_path3 != fresh.swf_path3 || this.xml_path3 != fresh.xml_path3)
				{
					path_3_changed=true;
					
					this._s3=fresh.s3;
					this.swf_path3=fresh.swf_path3;
					this.xml_path3=fresh.xml_path3;
					
				}
				
				
				
				
			
			}
			
			

			return [path_0_changed, path_1_changed, path_2_changed, path_3_changed];

		}

		public function clone():BeingFilePath
		{
			return new BeingFilePath(s0, s1, s2, s3, new Array().concat(_pList),new Array().concat(_xList),this.rightHand);
		}

		//get

		public function get s0():int
		{
			return _s0;
		}

		public function get s1():int
		{
			return _s1;
		}

		public function get s2():int
		{
			return _s2;
			
			
		}
		
		public function setS2(value:int):void
		{
			_s2 = value;
		
		}
		
		public function setS1(value:int):void
		{
			_s1 = value;
			
		}
		
		
		

		public function get s3():int
		{
			return _s3;
		}

		public function get hasHorse():Boolean
		{
			if ("" != swf_path1 && "" != xml_path1)
			{
				return true;
			}

			return false;
		}

	}
}