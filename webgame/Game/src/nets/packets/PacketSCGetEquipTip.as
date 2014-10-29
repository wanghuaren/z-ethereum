package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructSCEquipTip2
    /** 
    *装备悬浮信息
    */
    public class PacketSCGetEquipTip implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8018;
        /** 
        *装备属性信息
        */
        public var arrItemattrs:Vector.<StructSCEquipTip2> = new Vector.<StructSCEquipTip2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemattrs.length);
            for each (var attrsitem:Object in arrItemattrs)
            {
                var objattrs:ISerializable = attrsitem as ISerializable;
                if (null!=objattrs)
                {
                    objattrs.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemattrs= new  Vector.<StructSCEquipTip2>();
            var attrsLength:int = ar.readInt();
            for (var iattrs:int=0;iattrs<attrsLength; ++iattrs)
            {
                var objSCEquipTip:StructSCEquipTip2 = new StructSCEquipTip2();
                objSCEquipTip.Deserialize(ar);
                arrItemattrs.push(objSCEquipTip);
            }
        }
    }
}
