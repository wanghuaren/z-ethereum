package ui.view.view1.chat
{
	public class ChatVO
	{
		private var _type:int;
		private var _content:Object;
		public function ChatVO(type_:int,content_:Object)
		{
			_type = type_;
			_content = content_;
		}

		public function get content():Object
		{
			return _content;
		}

		public function set content(value:Object):void
		{
			_content = value;
		}

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}

	}
}