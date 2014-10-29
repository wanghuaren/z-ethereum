package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructEquipStrongItemData2
    /** 
    *强化槽列表
    */
    public class StructEquipStrongItems implements ISerializable
    {
        /** 
        *强化槽列表
        */
        public var arrItemitems:Vector.<StructEquipStrongItemData2> = new Vector.<StructEquipStrongItemData2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(arrItemitems.length);
            for each (var itemsitem:Object in arrItemitems)
            {
                var objitems:ISerializable = itemsitem as ISerializable;
                if (null!=objitems)
                {
                    objitems.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemitems= new  Vector.<StructEquipStrongItemData2>();
            var itemsLength:int = ar.readInt();
            for (var iitems:int=0;iitems<itemsLength; ++iitems)
            {
                var objEquipStrongItemData:StructEquipStrongItemData2 = new StructEquipStrongItemData2();
                objEquipStrongItemData.Deserialize(ar);
                arrItemitems.push(objEquipStrongItemData);
            }
        }
    }
}
