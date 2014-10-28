package com.engine.core.tile
{
	

	import flash.utils.Dictionary;
	/**
	 * 45度地图数据9宫格对象 
	 * @author saiman
	 * 
	 */
	public class ScaleGrid
	{
		private var _tc:Cell
		private var _ct:Cell
		private var _cr:Cell
		private var _bc:Cell

		private var _tl:Cell
		private var _tr:Cell
		private var _bl:Cell
		private var _br:Cell
		private var _cc:Cell
		private var _value:Pt

		public function ScaleGrid()
		{
		}

		public function get cc():Cell
		{
			return _cc
		}

		/**
		 * 非单例模式设值 
		 * @param value
		 * @param dic
		 * 
		 */		
		public function setValue(value:Pt,dic:Dictionary):void
		{
			if (!value)
				return;
			_value=value
			var source:Dictionary=dic
			if (source)
			{
				var x:int=value.x
				var y:int=value.z;
				_cc=source[x + '|0|' + y];
				_tc=source[x + '|0|' + (y - 1)];
				_ct=source[(x - 1) + '|0|' + y]
				_cr=source[(x + 1) + '|0|' + y]
				_bc=source[x + '|0|' + (y + 1)]
				
				_tl=source[(x - 1) + '|0|' + (y - 1)];
				_tr=source[(x + 1) + '|0|' + (y - 1)];
				_bl=source[(x - 1) + '|0|' + (y + 1)]
				_br=source[(x + 1) + '|0|' + (y + 1)]
			}
		}
		public function get value():Pt
		{
			return _value
		}

		public function get br():Cell
		{
			return _br;
		}

		public function get bl():Cell
		{
			return _bl;
		}

		public function get tr():Cell
		{
			return _tr;
		}

		public function get tl():Cell
		{
			return _tl;
		}

		public function get bc():Cell
		{
			return _bc;
		}

		public function get cr():Cell
		{
			return _cr;
		}

		public function get ct():Cell
		{
			return _ct;
		}

		public function get tc():Cell
		{
			return _tc;
		}

		public function passCell():Array
		{

			var array:Array=[]
			if (this.tc)
				array.push(this.tc);
			if (this.tl )
				array.push(this.tl);
			if (this.tr  )
				array.push(this.tr);
			if (this.cr)
				array.push(this.cr);
			if (this.ct )
				array.push(this.ct);
			if (this.bc)
				array.push(this.bc);
			if (this.bl)
				array.push(this.bl);
			if (this.br)
				array.push(this.br);

			return array
		}

	}
}