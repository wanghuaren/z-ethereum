package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructPrizeMsgInfo2
    /** 
    *消息奖励列表
    */
    public class PacketSCPrizeMsgList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 24601;
        /** 
        *消息奖励列表
        */
        public var arrItemlist:Vector.<StructPrizeMsgInfo2> = new Vector.<StructPrizeMsgInfo2>();

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
            arrItemlist= new  Vector.<StructPrizeMsgInfo2>();
            var listLength:int = ar.readInt();
            for (var ilist:int=0;ilist<listLength; ++ilist)
            {
                var objPrizeMsgInfo:StructPrizeMsgInfo2 = new StructPrizeMsgInfo2();
                objPrizeMsgInfo.Deserialize(ar);
                arrItemlist.push(objPrizeMsgInfo);
            }
        }
    }
}
