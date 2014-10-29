package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructGuildLog2
    /** 
    *家族动态
    */
    public class PacketWCGuildLog implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39237;
        /** 
        *家族动态
        */
        public var arrItemguildlog:Vector.<StructGuildLog2> = new Vector.<StructGuildLog2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemguildlog.length);
            for each (var guildlogitem:Object in arrItemguildlog)
            {
                var objguildlog:ISerializable = guildlogitem as ISerializable;
                if (null!=objguildlog)
                {
                    objguildlog.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemguildlog= new  Vector.<StructGuildLog2>();
            var guildlogLength:int = ar.readInt();
            for (var iguildlog:int=0;iguildlog<guildlogLength; ++iguildlog)
            {
                var objGuildLog:StructGuildLog2 = new StructGuildLog2();
                objGuildLog.Deserialize(ar);
                arrItemguildlog.push(objGuildLog);
            }
        }
    }
}
