package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructServerList2
    /** 
    *返回的服务器列表
    */
    public class PacketGCServerList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 102;
        /** 
        *列表
        */
        public var arrItemlist:Vector.<StructServerList2> = new Vector.<StructServerList2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemlist.length);
            for each (var listitem:Object in arrItemlist)
            {
                var objlist:ISerializable = listitem as ISerializable;
                if (null!=objlist)
                {
                    objlist.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemlist= new  Vector.<StructServerList2>();
            var listLength:int = ar.readInt();
            for (var ilist:int=0;ilist<listLength; ++ilist)
            {
                var objServerList:StructServerList2 = new StructServerList2();
                objServerList.Deserialize(ar);
                arrItemlist.push(objServerList);
            }
        }
    }
}
