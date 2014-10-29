package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructDCRoleList2
    /** 
    *角色列表
    */
    public class PacketDCRoleList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 2001;
        /** 
        *角色列表
        */
        public var arrItemroleList:Vector.<StructDCRoleList2> = new Vector.<StructDCRoleList2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemroleList.length);
            for each (var roleListitem:Object in arrItemroleList)
            {
                var objroleList:ISerializable = roleListitem as ISerializable;
                if (null!=objroleList)
                {
                    objroleList.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemroleList= new  Vector.<StructDCRoleList2>();
            var roleListLength:int = ar.readInt();
            for (var iroleList:int=0;iroleList<roleListLength; ++iroleList)
            {
                var objDCRoleList:StructDCRoleList2 = new StructDCRoleList2();
                objDCRoleList.Deserialize(ar);
                arrItemroleList.push(objDCRoleList);
            }
        }
    }
}
