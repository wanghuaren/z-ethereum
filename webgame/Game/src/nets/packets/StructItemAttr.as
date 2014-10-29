package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *属性信息
    */
    public class StructItemAttr implements ISerializable
    {
        /** 
        *是否有效
        */
        public var attrValid:int;
        /** 
        *属性索引
        */
        public var attrIndex:int;
        /** 
        *属性颜色
        */
        public var attrColor:int;
        /** 
        *属性值
        */
        public var attrValue:int;

        public function Serialize(ar:ByteArray):void
        {
            var agc_dummy_1:int = attrValid&((1<<1)-1);
            agc_dummy_1 |= (attrIndex&((1<<8)-1))<<1;
            agc_dummy_1 |= (attrColor&((1<<8)-1))<<9;
            ar.writeInt(agc_dummy_1);

            ar.writeInt(attrValue);
        }
        public function Deserialize(ar:ByteArray):void
        {
            var agc_dummy_1:int = ar.readInt();
            attrValid=agc_dummy_1&((1<<1)-1);
            attrIndex=(agc_dummy_1>>1)&((1<<8)-1);
            attrColor=(agc_dummy_1>>9)&((1<<8)-1);
            attrValue = ar.readInt();
        }
    }
}
