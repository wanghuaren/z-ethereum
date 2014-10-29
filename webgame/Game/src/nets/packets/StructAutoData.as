package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *自动挂机数据
    */
    public class StructAutoData implements ISerializable
    {
        /** 
        *配置
        */
        public var config:int;
        /** 
        *配置
        */
        public var config1:int;
        /** 
        *赠送所剩挂机时间
        */
        public var autominute:int;
        /** 
        *买的挂机时间
        */
        public var rmbautominute:int;
        /** 
        *购买挂机时间的次数
        */
        public var buycount:int;
        /** 
        *技能栏设置标志
        */
        public var shortcutflag:int;
        /** 
        *配置
        */
        public var config2:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(config);
            ar.writeInt(config1);
            ar.writeInt(autominute);
            ar.writeInt(rmbautominute);
            ar.writeInt(buycount);
            ar.writeInt(shortcutflag);
            ar.writeInt(config2);
        }
        public function Deserialize(ar:ByteArray):void
        {
            config = ar.readInt();
            config1 = ar.readInt();
            autominute = ar.readInt();
            rmbautominute = ar.readInt();
            buycount = ar.readInt();
            shortcutflag = ar.readInt();
            config2 = ar.readInt();
        }
    }
}
