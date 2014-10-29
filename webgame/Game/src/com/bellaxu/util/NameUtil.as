package com.bellaxu.util
{
	import com.bellaxu.def.AttrDef;
	import com.bellaxu.def.LibDef;
	import com.bellaxu.model.lib.Lib;
	import com.bellaxu.model.lib.Pub_KingnameResModel;
	import com.bellaxu.model.lib.ext.IS;
	import com.bellaxu.model.lib.ext.IS_IN;

	/**
	 * 取名工具
	 * @author BellaXu
	 */
	public class NameUtil 
	{
		/**
		 *随机产生姓名 
		 */
		public static function getRandomNameBySex(sex:int):String
		{
			var r:int = MathUtil.getRandomInt(1, 2);
			var pv:Vector.<Pub_KingnameResModel>;
			var lv:Vector.<Pub_KingnameResModel>;
			var pname:String;
			var lname:String;
			var aname:String;
			switch(r)
			{
				case 1:
					pv = Lib.getVec(LibDef.PUB_KINGNAME, [AttrDef.sort, IS, 1]);
					lv = Lib.getVec(LibDef.PUB_KINGNAME, [AttrDef.sort, IS, sex + 1]);
					
					pname = pv[MathUtil.getRandomInt(0, pv.length - 1)].para;
					lname = lv[MathUtil.getRandomInt(0, lv.length - 1)].para;
					aname = pname + lname;
					break;
				case 2:
					pv = Lib.getVec(LibDef.PUB_KINGNAME, [AttrDef.sort, IS, 4]);
					lv = Lib.getVec(LibDef.PUB_KINGNAME, [AttrDef.sort, IS, sex + 4]);
					
					pname = pv[MathUtil.getRandomInt(0, pv.length - 1)].para;
					lname = lv[MathUtil.getRandomInt(0, lv.length - 1)].para;
					aname = pname + lname;
					break;
				case 3:
					pv = Lib.getVec(LibDef.PUB_KINGNAME, [AttrDef.sort, IS, 7]);
					
					aname = pv[MathUtil.getRandomInt(0, pv.length - 1)].para;
					break;
			}
			//新建用于起名的数组
			return aname;
		}
		
		/**
		 * 随机游客用户名
		 * @return
		 */
		public static function GetRandomNameByDate():String
		{
			var date:Date = new Date();
			var nameLen:int = 10;
			var name:String = date.time + "";
			var code:int;
			for (var i:int = 0; i < nameLen ; i++ )
			{
				code = MathUtil.getRandomInt(122, 97);
				name += String.fromCharCode(code);
			}
			return name;
		}
	}
}