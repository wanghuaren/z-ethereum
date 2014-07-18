package boomiui.utils
{
	import flash.text.TextFormat;
	import flash.utils.describeType;

	public class Tools
	{
		private static function getProperties(value:Object):Array
		{
			var m_array:Array=[];
			var xml:XML=describeType(value);
			for (var i:int=0; i < xml.accessor.length(); i++)
			{
				m_array.push(xml.accessor[i].@name);
			}
			return m_array;
		}

		public static function copyTextFormat(value:TextFormat):TextFormat
		{
			var m_textFormat:TextFormat=new TextFormat();
			var m_properties_array:Array=Tools.getProperties(value);
			for each (var m_proper:String in m_properties_array)
			{
				m_textFormat[m_proper]=value[m_proper];
			}
			return m_textFormat;
		}
	}
}