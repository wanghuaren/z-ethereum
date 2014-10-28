
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_BookResModel  implements IResModel
	{
		private var _id:int=0;//序号
		private var _booksort:int=0;//类型
		private var _bookname:String="";//类型名称
		private var _action_group:int=0;//活动组id
		private var _action_name:String="";//活动名称
		private var _icon:int=0;//icon
		private var _min_level:int=0;//最小等级
		private var _needlevel:int=0;//需大等级
		private var _sort:int=0;//奖励类型
		private var _bookval:String="";//奖励数值
		private var _grade_type:int=0;//类型
		
	
		public function Pub_BookResModel(
args:Array
		)
		{
			_id = args[0];
			_booksort = args[1];
			_bookname = args[2];
			_action_group = args[3];
			_action_name = args[4];
			_icon = args[5];
			_min_level = args[6];
			_needlevel = args[7];
			_sort = args[8];
			_bookval = args[9];
			_grade_type = args[10];
			
		}
																																			
                public function get id():int
                {
	                return _id;
                }

                public function get booksort():int
                {
	                return _booksort;
                }

                public function get bookname():String
                {
	                return _bookname;
                }

                public function get action_group():int
                {
	                return _action_group;
                }

                public function get action_name():String
                {
	                return _action_name;
                }

                public function get icon():int
                {
	                return _icon;
                }

                public function get min_level():int
                {
	                return _min_level;
                }

                public function get needlevel():int
                {
	                return _needlevel;
                }

                public function get sort():int
                {
	                return _sort;
                }

                public function get bookval():String
                {
	                return _bookval;
                }

                public function get grade_type():int
                {
	                return _grade_type;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				booksort:this.booksort.toString(),
				bookname:this.bookname.toString(),
				action_group:this.action_group.toString(),
				action_name:this.action_name.toString(),
				icon:this.icon.toString(),
				min_level:this.min_level.toString(),
				needlevel:this.needlevel.toString(),
				sort:this.sort.toString(),
				bookval:this.bookval.toString(),
				grade_type:this.grade_type.toString()
	            };			
	            return o;
			
            }
	}
 }