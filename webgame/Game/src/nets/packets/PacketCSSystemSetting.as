package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *系统设置
    */
    public class PacketCSSystemSetting implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 19001;
        /** 
        *系统设置信息，如果为0就是请求信息，非0就是设置0x01:始终显示玩家信息0x02:始终显示怪物信息0x04:隐藏其他玩家及伙伴0x08:始终显示掉落物品名称0x10:全屏游戏0x20:消费提醒0x40:自动同意组队0x80:自动同意交友0x100:音乐0x200:音效
        */
        public var setting:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(setting);
        }
        public function Deserialize(ar:ByteArray):void
        {
            setting = ar.readInt();
        }
    }
}
