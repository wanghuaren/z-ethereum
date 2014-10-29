package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructFriendData2
    /** 
    *返回好友列表
    */
    public class PacketWCFriendList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 3001;
        /** 
        *好友列表
        */
        public var arrItemfriend_list:Vector.<StructFriendData2> = new Vector.<StructFriendData2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemfriend_list.length);
            for each (var friend_listitem:Object in arrItemfriend_list)
            {
                var objfriend_list:ISerializable = friend_listitem as ISerializable;
                if (null!=objfriend_list)
                {
                    objfriend_list.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemfriend_list= new  Vector.<StructFriendData2>();
            var friend_listLength:int = ar.readInt();
            for (var ifriend_list:int=0;ifriend_list<friend_listLength; ++ifriend_list)
            {
                var objFriendData:StructFriendData2 = new StructFriendData2();
                objFriendData.Deserialize(ar);
                arrItemfriend_list.push(objFriendData);
            }
        }
    }
}
