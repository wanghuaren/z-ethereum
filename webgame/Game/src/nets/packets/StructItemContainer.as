package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructEquipData2
    import netc.packets2.StructCommonItemData2
    import netc.packets2.StructStarItemData2
    import netc.packets2.StructTimesItemData2
    import netc.packets2.StructWingData2
    import netc.packets2.StructPetEggData2
    import netc.packets2.StructHorseItemData2
    /** 
    *物品容器
    */
    public class StructItemContainer implements ISerializable
    {
        /** 
        *装备数组
        */
        public var arrItemequipArray:Vector.<StructEquipData2> = new Vector.<StructEquipData2>();
        /** 
        *非装备数组
        */
        public var arrItemcommonItemArray:Vector.<StructCommonItemData2> = new Vector.<StructCommonItemData2>();
        /** 
        *星魂数组
        */
        public var arrItemstarItemArray:Vector.<StructStarItemData2> = new Vector.<StructStarItemData2>();
        /** 
        *背包总容量
        */
        public var containerSize:int;
        /** 
        *不能使用格开始索引位置
        */
        public var disableStartIdx:int;
        /** 
        *不能使用格结束索引位置
        */
        public var disableEndIdx:int;
        /** 
        *有使用次数的物品数组
        */
        public var arrItemtimesItemArray:Vector.<StructTimesItemData2> = new Vector.<StructTimesItemData2>();
        /** 
        *翅膀数组
        */
        public var arrItemwingItemArray:Vector.<StructWingData2> = new Vector.<StructWingData2>();
        /** 
        *宠物蛋数组
        */
        public var arrItemeggItemArray:Vector.<StructPetEggData2> = new Vector.<StructPetEggData2>();
        /** 
        *坐骑数组
        */
        public var arrItemhorseItemArray:Vector.<StructHorseItemData2> = new Vector.<StructHorseItemData2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(arrItemequipArray.length);
            for each (var equipArrayitem:Object in arrItemequipArray)
            {
                var objequipArray:ISerializable = equipArrayitem as ISerializable;
                if (null!=objequipArray)
                {
                    objequipArray.Serialize(ar);
                }
            }
            ar.writeInt(arrItemcommonItemArray.length);
            for each (var commonItemArrayitem:Object in arrItemcommonItemArray)
            {
                var objcommonItemArray:ISerializable = commonItemArrayitem as ISerializable;
                if (null!=objcommonItemArray)
                {
                    objcommonItemArray.Serialize(ar);
                }
            }
            ar.writeInt(arrItemstarItemArray.length);
            for each (var starItemArrayitem:Object in arrItemstarItemArray)
            {
                var objstarItemArray:ISerializable = starItemArrayitem as ISerializable;
                if (null!=objstarItemArray)
                {
                    objstarItemArray.Serialize(ar);
                }
            }
            ar.writeInt(containerSize);
            ar.writeInt(disableStartIdx);
            ar.writeInt(disableEndIdx);
            ar.writeInt(arrItemtimesItemArray.length);
            for each (var timesItemArrayitem:Object in arrItemtimesItemArray)
            {
                var objtimesItemArray:ISerializable = timesItemArrayitem as ISerializable;
                if (null!=objtimesItemArray)
                {
                    objtimesItemArray.Serialize(ar);
                }
            }
            ar.writeInt(arrItemwingItemArray.length);
            for each (var wingItemArrayitem:Object in arrItemwingItemArray)
            {
                var objwingItemArray:ISerializable = wingItemArrayitem as ISerializable;
                if (null!=objwingItemArray)
                {
                    objwingItemArray.Serialize(ar);
                }
            }
            ar.writeInt(arrItemeggItemArray.length);
            for each (var eggItemArrayitem:Object in arrItemeggItemArray)
            {
                var objeggItemArray:ISerializable = eggItemArrayitem as ISerializable;
                if (null!=objeggItemArray)
                {
                    objeggItemArray.Serialize(ar);
                }
            }
            ar.writeInt(arrItemhorseItemArray.length);
            for each (var horseItemArrayitem:Object in arrItemhorseItemArray)
            {
                var objhorseItemArray:ISerializable = horseItemArrayitem as ISerializable;
                if (null!=objhorseItemArray)
                {
                    objhorseItemArray.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemequipArray= new  Vector.<StructEquipData2>();
            var equipArrayLength:int = ar.readInt();
            for (var iequipArray:int=0;iequipArray<equipArrayLength; ++iequipArray)
            {
                var objEquipData:StructEquipData2 = new StructEquipData2();
                objEquipData.Deserialize(ar);
                arrItemequipArray.push(objEquipData);
            }
            arrItemcommonItemArray= new  Vector.<StructCommonItemData2>();
            var commonItemArrayLength:int = ar.readInt();
            for (var icommonItemArray:int=0;icommonItemArray<commonItemArrayLength; ++icommonItemArray)
            {
                var objCommonItemData:StructCommonItemData2 = new StructCommonItemData2();
                objCommonItemData.Deserialize(ar);
                arrItemcommonItemArray.push(objCommonItemData);
            }
            arrItemstarItemArray= new  Vector.<StructStarItemData2>();
            var starItemArrayLength:int = ar.readInt();
            for (var istarItemArray:int=0;istarItemArray<starItemArrayLength; ++istarItemArray)
            {
                var objStarItemData:StructStarItemData2 = new StructStarItemData2();
                objStarItemData.Deserialize(ar);
                arrItemstarItemArray.push(objStarItemData);
            }
            containerSize = ar.readInt();
            disableStartIdx = ar.readInt();
            disableEndIdx = ar.readInt();
            arrItemtimesItemArray= new  Vector.<StructTimesItemData2>();
            var timesItemArrayLength:int = ar.readInt();
            for (var itimesItemArray:int=0;itimesItemArray<timesItemArrayLength; ++itimesItemArray)
            {
                var objTimesItemData:StructTimesItemData2 = new StructTimesItemData2();
                objTimesItemData.Deserialize(ar);
                arrItemtimesItemArray.push(objTimesItemData);
            }
            arrItemwingItemArray= new  Vector.<StructWingData2>();
            var wingItemArrayLength:int = ar.readInt();
            for (var iwingItemArray:int=0;iwingItemArray<wingItemArrayLength; ++iwingItemArray)
            {
                var objWingData:StructWingData2 = new StructWingData2();
                objWingData.Deserialize(ar);
                arrItemwingItemArray.push(objWingData);
            }
            arrItemeggItemArray= new  Vector.<StructPetEggData2>();
            var eggItemArrayLength:int = ar.readInt();
            for (var ieggItemArray:int=0;ieggItemArray<eggItemArrayLength; ++ieggItemArray)
            {
                var objPetEggData:StructPetEggData2 = new StructPetEggData2();
                objPetEggData.Deserialize(ar);
                arrItemeggItemArray.push(objPetEggData);
            }
            arrItemhorseItemArray= new  Vector.<StructHorseItemData2>();
            var horseItemArrayLength:int = ar.readInt();
            for (var ihorseItemArray:int=0;ihorseItemArray<horseItemArrayLength; ++ihorseItemArray)
            {
                var objHorseItemData:StructHorseItemData2 = new StructHorseItemData2();
                objHorseItemData.Deserialize(ar);
                arrItemhorseItemArray.push(objHorseItemData);
            }
        }
    }
}
