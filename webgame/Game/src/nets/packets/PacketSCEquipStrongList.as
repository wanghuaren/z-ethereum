package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructEquipStrongItem2
    /** 
    *强化列表
    */
    public class PacketSCEquipStrongList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 15004;
        /** 
        *4个槽的信息
        */
        public var arrItemStrongItemList:Vector.<StructEquipStrongItem2> = new Vector.<StructEquipStrongItem2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemStrongItemList.length);
            for each (var StrongItemListitem:Object in arrItemStrongItemList)
            {
                var objStrongItemList:ISerializable = StrongItemListitem as ISerializable;
                if (null!=objStrongItemList)
                {
                    objStrongItemList.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemStrongItemList= new  Vector.<StructEquipStrongItem2>();
            var StrongItemListLength:int = ar.readInt();
            for (var iStrongItemList:int=0;iStrongItemList<StrongItemListLength; ++iStrongItemList)
            {
                var objEquipStrongItem:StructEquipStrongItem2 = new StructEquipStrongItem2();
                objEquipStrongItem.Deserialize(ar);
                arrItemStrongItemList.push(objEquipStrongItem);
            }
        }
    }
}
