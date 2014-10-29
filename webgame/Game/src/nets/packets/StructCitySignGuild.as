package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *皇城至尊战报名
    */
    public class StructCitySignGuild implements ISerializable
    {
        /** 
        *
        */
        public var arrItemguild:Vector.<int> = new Vector.<int>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(arrItemguild.length);
            for each (var guilditem:int in arrItemguild)
            {
                ar.writeInt(guilditem);
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemguild= new  Vector.<int>();
            var guildLength:int = ar.readInt();
            for (var iguild:int=0;iguild<guildLength; ++iguild)
            {
                arrItemguild.push(ar.readInt());
            }
        }
    }
}
