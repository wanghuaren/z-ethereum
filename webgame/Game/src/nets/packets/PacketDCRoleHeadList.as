package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructRoleHead2
    /** 
    *返回角色头像编号
    */
    public class PacketDCRoleHeadList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 2002;
        /** 
        *头像列表
        */
        public var arrItemheads:Vector.<StructRoleHead2> = new Vector.<StructRoleHead2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemheads.length);
            for each (var headsitem:Object in arrItemheads)
            {
                var objheads:ISerializable = headsitem as ISerializable;
                if (null!=objheads)
                {
                    objheads.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemheads= new  Vector.<StructRoleHead2>();
            var headsLength:int = ar.readInt();
            for (var iheads:int=0;iheads<headsLength; ++iheads)
            {
                var objRoleHead:StructRoleHead2 = new StructRoleHead2();
                objRoleHead.Deserialize(ar);
                arrItemheads.push(objRoleHead);
            }
        }
    }
}
