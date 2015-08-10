<GameProjectFile>
  <PropertyGroup Type="Scene" Name="MainScene" ID="a2ee0952-26b5-49ae-8bf9-4f1d6279b798" Version="2.3.1.2" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Scene" ctype="GameNodeObjectData">
        <Size X="640.0000" Y="960.0000" />
        <Children>
          <AbstractNodeData Name="Image_4" ActionTag="914819739" Tag="17" IconVisible="False" RightEage="200" TopEage="300" ctype="ImageViewObjectData">
            <Size X="640.0000" Y="960.0000" />
            <ScriptData FileType="Lua" RelativeScriptFile="image.lua" />
            <AnchorPoint />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="1.0000" Y="1.0000" />
            <FileData Type="Addin" Path="image/scenebg.png" Plist="" />
          </AbstractNodeData>
          <AbstractNodeData Name="TextField_user" ActionTag="-818751370" Tag="33" IconVisible="False" LeftMargin="74.1243" RightMargin="65.8757" TopMargin="412.6063" BottomMargin="477.3937" TouchEnable="True" FontSize="70" IsCustomSize="True" LabelText="" PlaceHolderText="点我输入用户名" PasswordStyleText="" ctype="TextFieldObjectData">
            <Size X="500.0000" Y="70.0000" />
            <ScriptData FileType="Lua" RelativeScriptFile="txtInput.lua" />
            <AnchorPoint ScaleY="1.0000" />
            <Position X="74.1243" Y="547.3937" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.1158" Y="0.5702" />
            <PreSize X="0.7813" Y="0.0729" />
          </AbstractNodeData>
          <AbstractNodeData Name="TextField_pass" ActionTag="-77140129" Tag="34" IconVisible="False" LeftMargin="74.1243" RightMargin="65.8757" TopMargin="574.1391" BottomMargin="315.8609" TouchEnable="True" FontSize="70" IsCustomSize="True" LabelText="" PlaceHolderText="点我输入密码" PasswordEnable="True" ctype="TextFieldObjectData">
            <Size X="500.0000" Y="70.0000" />
            <ScriptData FileType="Lua" RelativeScriptFile="txtInput.lua" />
            <AnchorPoint ScaleY="1.0000" />
            <Position X="74.1243" Y="385.8609" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.1158" Y="0.4019" />
            <PreSize X="0.7813" Y="0.0729" />
          </AbstractNodeData>
          <AbstractNodeData Name="btnLogin" ActionTag="1798011355" Tag="5" IconVisible="False" LeftMargin="220.3637" RightMargin="269.6363" TopMargin="776.7005" BottomMargin="123.2995" TouchEnable="True" FontSize="40" ButtonText="登录" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="150.0000" Y="60.0000" />
            <ScriptData FileType="Lua" RelativeScriptFile="button.lua" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="295.3637" Y="153.2995" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.4615" Y="0.1597" />
            <PreSize X="0.0000" Y="0.0000" />
            <TextColor A="255" R="255" G="255" B="255" />
            <DisabledFileData Type="Addin" Path="button/btn2.png" Plist="" />
            <PressedFileData Type="Addin" Path="button/btn2.png" Plist="" />
            <NormalFileData Type="Addin" Path="button/btn.png" Plist="" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameProjectFile>