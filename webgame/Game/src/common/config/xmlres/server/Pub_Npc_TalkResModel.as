
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Npc_TalkResModel  implements IResModel
	{
		private var _func_index:int=0;//总顺序
		private var _talk_id:int=0;//对话id
		private var _page:int=0;//页数
		private var _npc_id:int=0;//NPC编号
		private var _talking:String="";//谈话内容
		private var _func_icon:int=0;//功能图标
		private var _prize:int=0;//任务奖励
		private var _func_id:int=0;//功能id
		private var _show_button:int=0;//按钮
		private var _completeclose:int=0;//任务完成关闭对话（0为关闭、1为不关闭。）
		private var _exp_double:int=0;//是否显示双倍经验
		private var _not_open:int=0;//是否打开NPC对话界面（用于打开功能界面）
		
	
		public function Pub_Npc_TalkResModel(
args:Array
		)
		{
			_func_index = args[0];
			_talk_id = args[1];
			_page = args[2];
			_npc_id = args[3];
			_talking = args[4];
			_func_icon = args[5];
			_prize = args[6];
			_func_id = args[7];
			_show_button = args[8];
			_completeclose = args[9];
			_exp_double = args[10];
			_not_open = args[11];
			
		}
																																						
                public function get func_index():int
                {
	                return _func_index;
                }

                public function get talk_id():int
                {
	                return _talk_id;
                }

                public function get page():int
                {
	                return _page;
                }

                public function get npc_id():int
                {
	                return _npc_id;
                }

                public function get talking():String
                {
	                return _talking;
                }

                public function get func_icon():int
                {
	                return _func_icon;
                }

                public function get prize():int
                {
	                return _prize;
                }

                public function get func_id():int
                {
	                return _func_id;
                }

                public function get show_button():int
                {
	                return _show_button;
                }

                public function get completeclose():int
                {
	                return _completeclose;
                }

                public function get exp_double():int
                {
	                return _exp_double;
                }

                public function get not_open():int
                {
	                return _not_open;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            func_index:this.func_index.toString(),
				talk_id:this.talk_id.toString(),
				page:this.page.toString(),
				npc_id:this.npc_id.toString(),
				talking:this.talking.toString(),
				func_icon:this.func_icon.toString(),
				prize:this.prize.toString(),
				func_id:this.func_id.toString(),
				show_button:this.show_button.toString(),
				completeclose:this.completeclose.toString(),
				exp_double:this.exp_double.toString(),
				not_open:this.not_open.toString()
	            };			
	            return o;
			
            }
	}
 }