package common.config
{
	import netc.packets2.StructItemAttr2;

	public class AttModel
	{
		/**
		 *	属性
		 *  2013-03-28 andy 
		 */
		public function AttModel()
		{
		}
		/**
		 *	属性ID
		 */
		public var attId:int=0;
		/**
		 *	基础属性
		 */
		public var minAtt:StructItemAttr2;
		public var maxAtt:StructItemAttr2;
	}
}