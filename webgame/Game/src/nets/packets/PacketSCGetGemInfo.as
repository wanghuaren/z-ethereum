package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructGemInfoPos2
    /** 
    *获取宝石信息
    */
    public class PacketSCGetGemInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 54202;
        /** 
        *错误码
        */
        public var tag:int;
        /** 
        *宝石信息
        */
        public var arrItemgems:Vector.<StructGemInfoPos2> = new Vector.<StructGemInfoPos2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
            ar.writeInt(arrItemgems.length);
            for each (var gemsitem:Object in arrItemgems)
            {
                var objgems:ISerializable = gemsitem as ISerializable;
                if (null!=objgems)
                {
                    objgems.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            arrItemgems= new  Vector.<StructGemInfoPos2>();
            var gemsLength:int = ar.readInt();
            for (var igems:int=0;igems<gemsLength; ++igems)
            {
                var objGemInfoPos:StructGemInfoPos2 = new StructGemInfoPos2();
                objGemInfoPos.Deserialize(ar);
                arrItemgems.push(objGemInfoPos);
            }
        }
    }
}
