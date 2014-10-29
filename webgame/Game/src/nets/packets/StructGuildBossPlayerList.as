package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructGuildBossPlayerInfo2
    /** 
    *家族boss玩家信息
    */
    public class StructGuildBossPlayerList implements ISerializable
    {
        /** 
        *家族等级
        */
        public var guildlvl:int;
        /** 
        *玩家信息
        */
        public var arrItemplayers:Vector.<StructGuildBossPlayerInfo2> = new Vector.<StructGuildBossPlayerInfo2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(guildlvl);
            ar.writeInt(arrItemplayers.length);
            for each (var playersitem:Object in arrItemplayers)
            {
                var objplayers:ISerializable = playersitem as ISerializable;
                if (null!=objplayers)
                {
                    objplayers.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            guildlvl = ar.readInt();
            arrItemplayers= new  Vector.<StructGuildBossPlayerInfo2>();
            var playersLength:int = ar.readInt();
            for (var iplayers:int=0;iplayers<playersLength; ++iplayers)
            {
                var objGuildBossPlayerInfo:StructGuildBossPlayerInfo2 = new StructGuildBossPlayerInfo2();
                objGuildBossPlayerInfo.Deserialize(ar);
                arrItemplayers.push(objGuildBossPlayerInfo);
            }
        }
    }
}
