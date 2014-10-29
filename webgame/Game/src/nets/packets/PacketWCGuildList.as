package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructGuildSimpleInfo2
    /** 
    *公会列表
    */
    public class PacketWCGuildList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39205;
        /** 
        *公会列表
        */
        public var arrItemguildlist:Vector.<StructGuildSimpleInfo2> = new Vector.<StructGuildSimpleInfo2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemguildlist.length);
            for each (var guildlistitem:Object in arrItemguildlist)
            {
                var objguildlist:ISerializable = guildlistitem as ISerializable;
                if (null!=objguildlist)
                {
                    objguildlist.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemguildlist= new  Vector.<StructGuildSimpleInfo2>();
            var guildlistLength:int = ar.readInt();
            for (var iguildlist:int=0;iguildlist<guildlistLength; ++iguildlist)
            {
                var objGuildSimpleInfo:StructGuildSimpleInfo2 = new StructGuildSimpleInfo2();
                objGuildSimpleInfo.Deserialize(ar);
                arrItemguildlist.push(objGuildSimpleInfo);
            }
        }
    }
}
