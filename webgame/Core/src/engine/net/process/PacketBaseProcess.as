package engine.net.process
{
	import engine.event.DispatchEvent;
	
	import flash.utils.describeType;
	
	import engine.support.IPacket;
	import engine.support.ISerializable;
	import engine.support.IProcess;

	/**
	 * 本类不可以有成员变量
	 * 继承此类并覆写process方法
	 */ 
	public class PacketBaseProcess implements IProcess
	{
		public function PacketBaseProcess()
		{
		}
		
		/**
		 * need override
		 */ 
		//public function process(pack:IPacket):DispatchEvent
		//public function process(pack:IPacket):Array
		public function process(pack:IPacket):IPacket
		{
			//
			throw new Error("this function need override , Func:process Class:PacketBaseProcess");
			
			return null;
		}
		
		private function helpByPureO(o:Object):String
		{
			var s:String = "";
			var line:String = "";
			
			for (var c:String in o) 
			{
				line = c + ":" + o[c] + "," + "\n";
				s += line;				
			}
			
			return s;
		}
		
		public function helpByO(o:Object,beginStr:String="",endString:String=""):String
		{
			var s:String = "";
			var line:String = "";
			var len:int;
						
			s+=beginStr;
			
			for (var c:String in o) 
			{
				
				if(o[c] as Array)
				{
					//--------------------------------------------------------
					
					line = c + ":\n";
					
					len  = (o[c] as Array).length;
					
					for(var i:int =0;i<len;i++)
					{												
						line += "[" + i.toString() + "]\n";
						
						line += helpByPureO(o[c][i]);
					}
					
					line += "\n";
				
					//--------------------------------------------------------
				}				
				else
				{
					//--------------------------------------------------------
					line = c + ":" + o[c] + "," + "\n";
					
					//--------------------------------------------------------			
					
				}
				
				//end if
				
				s += line;
				
			}
			
			s += endString;
		
			return s;
		
		}
		
		public function helpByPureReflect(pack:*):Object
		{
			//
			var packXml:XML = describeType(pack);
			
			var packVariList:XMLList = packXml.variable;
			
			//
			var o:Object = {};
			
			var len:int = packVariList.length();
			
			//
			for(var i:int=0;i<len;i++)
			{
				var n:String = packVariList[i].@name;
				
				o[n] = pack[n];
			
			}	
			
			return o;
		}
		
		public function helpByReflext_PackName(pack:*):String
		{
			var packXml:XML = describeType(pack);
		
			var type_name:String = packXml.@name;
			
			var split_name:Array;
			
			//
			if(type_name.indexOf("::") > 0)
			{
				split_name = type_name.split("::");
				
			}
			
			if(split_name.length == 2)
			{
				return split_name[1];
			}
			
			return "";
			
		}
				
		/**
		 * pack可能是 IPack，也可能是ISerializable
		 */ 
		public function helpByReflect(pack:*):Object
		{
			//
			var packXml:XML = describeType(pack);
			
			var packVariList:XMLList = packXml.variable;
			
			//
			var o:Object = {};
			
			
			var len:int = packVariList.length();
			
			var lenJ:int;
				
			//
			var j:int;
			for(var i:int=0;i<len;i++)
			{
				var n:String = packVariList[i].@name;
			
				var t:String = packVariList[i].@type;
				
				if("int" == t || 
					"uint" == t || 
					"String" == t ||
					"Number" == t ||					 
					"Boolean" == t)
				{
					o[n] = pack[n];
				
				}else if("Array" == t)
				{					
					var pack_n_array:Array = pack[n] as Array;
					
					lenJ  = pack_n_array.length;
					
					o[n] = new Array();
					
					for(j =0;j<lenJ;j++)
					{	
						o[n].push(helpByPureReflect(pack_n_array[j]));
					}
				
				}else if(t.indexOf("__AS3__.vec::Vector.") == 0)
				{
					
					//__AS3__.vec::Vector.<netc.packets2::StructSCEquipTip2>
					var pack_n_vec:Vector.<*> = pack[n] as Vector.<*>;
										
					var pack_n_vec_int:Vector.<int>;
					var pack_n_vec_uint:Vector.<uint>;
					var pack_n_vec_String:Vector.<String>;
					var pack_n_vec_Number:Vector.<Number>;
					var pack_n_vec_Boolean:Vector.<Boolean>;
					
					if(null == pack_n_vec)
					{
						pack_n_vec_int = pack[n] as Vector.<int>;
					}
					
					if(null == pack_n_vec_int)
					{
						pack_n_vec_uint = pack[n] as Vector.<uint>;
					}
					
					if(null == pack_n_vec_uint)
					{
						pack_n_vec_String = pack[n] as Vector.<String>;
					}
					
					if(null == pack_n_vec_String)
					{
						pack_n_vec_Number = pack[n] as Vector.<Number>;
					}
					
					if(null == pack_n_vec_Number)
					{
						pack_n_vec_Boolean = pack[n] as Vector.<Boolean>;
					}
					
					if(null == pack_n_vec &&
						null == pack_n_vec_int &&
						null == pack_n_vec_uint &&
						null == pack_n_vec_String &&
						null == pack_n_vec_Number &&
						null == pack_n_vec_Boolean)
					{
						continue;
					}
					
					if(null != pack_n_vec)
					{
						lenJ  = pack_n_vec.length;
					
					}else if(null != pack_n_vec_int)
					{
						lenJ  = pack_n_vec_int.length;
					}
					else if(null != pack_n_vec_uint)
					{
						lenJ  = pack_n_vec_uint.length;
					}
					else if(null != pack_n_vec_String)
					{
						lenJ  = pack_n_vec_String.length;
					}
					else if(null != pack_n_vec_Number)
					{
						lenJ  = pack_n_vec_Number.length;
					}
					else if(null != pack_n_vec_Boolean)
					{
						lenJ  = pack_n_vec_Boolean.length;
					}
					
							
					o[n] = new Array();
							
					for(j =0;j<lenJ;j++)
					{	
						if(null != pack_n_vec)
						{
							o[n].push(helpByPureReflect(pack_n_vec[j]));
								
						}else if(null != pack_n_vec_int)
						{
							o[n].push(helpByPureReflect(pack_n_vec_int[j]));
						}
						else if(null != pack_n_vec_uint)
						{
							o[n].push(helpByPureReflect(pack_n_vec_uint[j]));
						}
						else if(null != pack_n_vec_String)
						{
							o[n].push(helpByPureReflect(pack_n_vec_String[j]));
						}
						else if(null != pack_n_vec_Number)
						{
							o[n].push(helpByPureReflect(pack_n_vec_Number[j]));
						}
						else if(null != pack_n_vec_Boolean)
						{
							o[n].push(helpByPureReflect(pack_n_vec_Boolean[j]));
						}
							
								//o[n].push(helpByPureReflect(pack_n_vec[j]));
					}
					
					
					
				
				}
				else
				{
					o[n] = new Array(helpByPureReflect(pack[n]));
				}
			}	
				
			return o;
		}
	}
}