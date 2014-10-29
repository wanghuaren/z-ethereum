package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructExpBack2
    /** 
    *活动经验找回数据列表
    */
    public class PacketSCActExpList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 33003;
        /** 
        *活动经验数组
        */
        public var arrItemexpbackarray:Vector.<StructExpBack2> = new Vector.<StructExpBack2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemexpbackarray.length);
            for each (var expbackarrayitem:Object in arrItemexpbackarray)
            {
                var objexpbackarray:ISerializable = expbackarrayitem as ISerializable;
                if (null!=objexpbackarray)
                {
                    objexpbackarray.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemexpbackarray= new  Vector.<StructExpBack2>();
            var expbackarrayLength:int = ar.readInt();
            for (var iexpbackarray:int=0;iexpbackarray<expbackarrayLength; ++iexpbackarray)
            {
                var objExpBack:StructExpBack2 = new StructExpBack2();
                objExpBack.Deserialize(ar);
                arrItemexpbackarray.push(objExpBack);
            }
        }
    }
}
