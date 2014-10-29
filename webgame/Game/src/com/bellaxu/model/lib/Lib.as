package com.bellaxu.model.lib
{
	import com.bellaxu.def.LibDef;
	import com.bellaxu.model.lib.ext.IN;
	import com.bellaxu.model.lib.ext.IS;
	import com.bellaxu.model.lib.ext.IS_IN;
	import com.bellaxu.model.lib.ext.NO;
	import com.bellaxu.res.ResTool;
	
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * XMl数据变成了二进制，从这里拿
	 * @author BellaXu
	 */
	public class Lib
	{
		private static const LIB_PATH:String = "com.bellaxu.model.lib.";
		private static const MOD_NAME:String = "ResModel";
		private static var _libDic:Dictionary = new Dictionary();
		private static var _cacheDic:Dictionary = new Dictionary(); //二级缓存，提高性能
		
		public static function save(bytes:ByteArray):void
		{
			bytes.uncompress();
			bytes.position = 0;
			var attrNum:int;
			var libName:String;
			var attrArr:Array;
			var i:int, j:int, len:int;
			var cls:Class;
			var selfKey:Boolean;
			var obj:*;
			var key:String;
			var tmp:String;
			var si:int;
			var dic:Dictionary;
			while (bytes.bytesAvailable > 0)
			{
				libName = bytes.readUTF();
				//修正 
				if(libName=="0"){
					return;
				}
				attrNum = int(bytes.readUTF());//有多少个属性
				attrArr = [];//属性名数组
				i = 0;
				while(i++ < attrNum)
				{
					attrArr.push(bytes.readUTF());
				}
				len = int(bytes.readUTF());
				cls = ResTool.getAppCls(LIB_PATH + libName + MOD_NAME);
				
				//具有多个key的表，客户端给它生成一个唯一key，即行号
				selfKey = false;
				if(LibDef.SPECIAL_LIST.indexOf(libName) > -1)
					selfKey = true;
				i = si = 0;
				
				dic = new Dictionary();
				while (i++ < len)
				{
					//修正 
					if(cls==null)
						continue;
					obj = new cls();
					j = 0;
					while (j < attrNum)
					{
						tmp = bytes.readUTF();
						if (j == 0)
							key = tmp;
						obj[attrArr[j++]] = tmp;
					}
					dic[selfKey ? si++ : key] = obj;
				}
				_libDic[libName] = dic;
			}
		}
		
		/**
		 * 使用方法：
		 * <br/>1.通过Lib.getObj获得一个model
		 * <br/>2.将model载入特定的ResModel中(构造函数载入)
		 * <br/>3.key为xml中关键字的值
		 */
		public static function getObj(libName:String, key:String):*
		{
			if(!_libDic[libName])
				return null;
			return _libDic[libName][key];
		}
		
		public static function getDifNum(libName:String, attr:String):int
		{
			var dic:Dictionary = _libDic[libName];
			if(!dic)
				return 0;
			var count:int = 0;
			var tmp:uint = 0;
			var obj:Object;
			for each(obj in dic)
			{
				if(obj[attr] != tmp)
				{
					tmp = obj[attr];
					count++;
				}
			}
			return count;
		}
		
		/**
		 * 索引机制的统一
		 * <br/>使用方法：
		 * <br/>1.通过Lib.getArr获得一个Vec
		 * <br/>2.将Vec中的Object载入特定的ResModel中(构造函数载入)
		 * <br/>3.args是参数格式如：[attname, IS, attvalue] 或者[attname, IN, value1, value2]
		 */
		public static function getVec(libName:String, ...args):*
		{
			if(!_libDic[libName])
				return null;
			//计算cache_key
			var cache_key:String = libName + "_";
			var ary:Array;
			var i:int, j:int;
			while(i < args.length)
			{
				ary = args[i];
				j = 0;
				while(j < ary.length)
				{
					cache_key += ary[j];
					j++;
				}
				if (i != args.length - 1)
					cache_key += "_";
				i++;
			}
			if(_cacheDic[cache_key])
				return _cacheDic[cache_key];
			//动态构建Vector
			var vecCls:Class = ResTool.getAppCls("__AS3__.vec.Vector.<" + LIB_PATH + libName + MOD_NAME + ">") as Class;
			var vec:* = new vecCls();
			var cls:Class = ResTool.getAppCls(LIB_PATH + libName + MOD_NAME);
			if(!cls)
				return;
			var dic:Dictionary = _libDic[libName];
			var attname:String;
			var flag:String;
			var attvalue:int;
			var value1:int;
			var value2:int;
			var obj:Object;
			for each(obj in dic)
			{
				i = 0;
				while(i < args.length)
				{
					ary = args[i];
					attname = ary[0];
					flag = ary[1];
					if(flag == IS)
					{
						attvalue = ary[2];
						if(obj[attname] != attvalue)
							break;
					}
					else if(flag == NO)
					{
						attvalue = ary[2];
						if(obj[attname] == attvalue)
							break;
					}
					else if(flag == IN)
					{
						value1 = ary[2];
						value2 = ary[3];
						if(obj[attname] < value1 || obj[attname] > value2)
							break;
					}
					else if(flag == IS_IN)
					{
						for(j = 2;j < ary.length;j++)
						{
							if(obj[attname] == ary[j])
								break;
						}
						if(j >= ary.length)
							break;
					}
					i++;
				}
				if(i >= args.length)
					vec.push(obj);
			}
			_cacheDic[cache_key] = vec;
			return vec;
		}
	}
}