
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_KingnameResModel  implements IResModel
	{
		private var _id:int=0;//序号
		private var _sort:int=0;//类型：1姓2男名3女名-4姓5男名6女命-7单独名字-三种配合随机名称各占三分之一几率
		private var _para:String="";//内容
		
	
		public function Pub_KingnameResModel(
args:Array
		)
		{
			_id = args[0];
			_sort = args[1];
			_para = args[2];
			
		}
											
                public function get id():int
                {
	                return _id;
                }

                public function get sort():int
                {
	                return _sort;
                }

                public function get para():String
                {
	                return _para;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				sort:this.sort.toString(),
				para:this.para.toString()
	            };			
	            return o;
			
            }
	}
 }