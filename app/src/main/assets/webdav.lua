require "import"
import "mod"
import "color"

layout2={
  LinearLayout;
  layout_height="fill";
  layout_width="fill";
  orientation="vertical";
  {
    FrameLayout;
    layout_width="fill";
    layout_height="56dp";
    elevation=4;
    id="mainActionBar";
    {
      LinearLayout;
      layout_height="fill";
      layout_gravity="center|left";
      paddingLeft="16dp";
      {
        ImageView;
        id="back";
        src=ICON_BACK;
        layout_width="24dp";
        layout_height="24dp";
        layout_gravity="center";
        layout_marginRight="12dp";
      };
      {
        TextView;
        gravity="center";
        id="mainTitle";
        text="WebDAV";
        textSize="20sp";
        layout_height="fill";
      };
    };
    {
      LinearLayout;
      layout_height="fill";
      layout_gravity="center|right";
      paddingRight="12dp";
      {
        ImageView;
        id="popmenu";
        src=ICON_MENU;
        layout_width="24dp";
        layout_height="24dp";
        layout_gravity="center";
      };
    };
  };
  {
    ScrollView;
    layout_width="fill";
    layout_height="fill";
    VerticalScrollBarEnabled=false;
    id="mainBackground";
    {
      LinearLayout;
      orientation="vertical";
      id="background1";
      layout_width="fill";
      layout_height="fill";
      layout_margin="16dp";
      {
        LinearLayout;
        orientation="vertical";
        layout_width="fill";
        layout_height="wrap";
        {
          TextView;
          id="rootTitle";
          text="服务器";
        };
        {
          EditText;
          id="rootText";
          layout_width="fill";
          layout_height="wrap";
          hint="服务器根地址";
          singleLine=true;
          imeOptions="actionNext";
        };
        {
          LinearLayout;
          layout_width="fill";
          layout_height="8dp";
        };
        {
          TextView;
          id="accTitle";
          text="账号";
        };
        {
          EditText;
          id="accText";
          layout_width="fill";
          layout_height="wrap";
          hint="账号";
          singleLine=true;
          imeOptions="actionNext";
        };
        {
          LinearLayout;
          layout_width="fill";
          layout_height="8dp";
        };
        {
          TextView;
          id="pwdTitle";
          text="密码";
        };
        {
          LinearLayout;
          layout_width="fill";
          layout_height="wrap";
          {
            EditText;
            id="pwdText";
            layout_width="fill";
            layout_height="wrap";
            layout_weight=1;
            hint="应用密码";
            singleLine=true;
            --password=true;
          };
          {
            ImageView;
            id="showPwd";
            layout_width="fill";
            layout_height="24dp";
            layout_weight=15;
            layout_gravity="center";
            src=ICON_VISIBILITY_ON;
          };
        };
        {
          LinearLayout;
          layout_width="fill";
          layout_height="8dp";
        };
      };
      {
        LinearLayout;
        layout_width="fill";
        layout_height="wrap";
        padding="4dp";
        {
          CardView;
          id="testBtn";
          layout_width="fill";
          layout_height="40dp";
          layout_weight=1;
          radius="24dp";
          elevation="0";
          {
            TextView;
            id="testText";
            layout_width="fill";
            layout_height="fill";
            padding="8dp";
            gravity="center";
            text="测试";
            textSize="16sp";
          };
        };
        {
          LinearLayout;
          layout_width="8dp";
          layout_height="fill";
        };
        {
          CardView;
          id="statuBtn";
          layout_width="fill";
          layout_height="40dp";
          layout_weight=1;
          radius="24dp";
          elevation="0";
          {
            TextView;
            id="statuText";
            layout_width="fill";
            layout_height="fill";
            padding="8dp";
            gravity="center";
            text="加载中";
            textSize="16sp";
          };
        };
      };
      {
        LinearLayout;
        layout_width="fill";
        layout_height="wrap";
        padding="4dp";
        {
          ImageView;
          id="infoImage";
          src=ICON_INFO;
          layout_width="24dp";
          layout_height="24dp";
          layout_gravity="center";
        };
        {
          TextView;
          id="infoText";
          layout_width="wrap";
          layout_height="wrap";
          padding="8dp";
          text="⚠️请自行备份好便签，以防数据丢失⚠️\n坚果云服务器：https://dav.jianguoyun.com/dav/\n开启后主页下拉同步";
          textSize="14sp";
          textIsSelectable=true;
        };
      };
      {
        LinearLayout;
        layout_width="fill";
        layout_height="1dp";
        background="#80A0A0A0";
      };
      {
        LinearLayout;
        layout_width="fill";
        layout_height="wrap";
        padding="4dp";
        {
          TextView;
          id="lastText";
          layout_width="fill";
          layout_height="wrap";
          padding="8dp";
          text="无上次同步信息";
          textSize="14sp";
          textIsSelectable=true;
        };
      };
      {
        LinearLayout;
        layout_width="fill";
        layout_height="1dp";
        background="#80A0A0A0";
      };
      {
        LinearLayout;
        layout_height="wrap";
        layout_width="fill";
        backgroundColor=COLOR_MAIN_BACKGROUND;
        {
          FrameLayout;
          id="autoSyncBg";
          layout_height="fill";
          layout_width="fill";
          padding="12dp";
          {
            LinearLayout;
            layout_width="wrap";
            layout_height="fill";
            Orientation="vertical";
            {
              TextView;
              id="autoSyncName";
              maxLines="2";
              text="自动同步";
              textSize="16sp";
              textColor=COLOR_ON_BACKGROUND;
            };
            {
              TextView;
              id="autoSyncDesc";
              maxLines="3";
              text="开启后，打开和退出软件时将会同步便签\n请使用返回退出且不要划掉后台任务";
              textSize="14sp";
            };
          };
          {
            LinearLayout;
            layout_height="fill";
            layout_width="wrap";
            layout_gravity="center|right";
            {
              Switch;
              id="autoSyncSwitch";
              layout_height="fill";
              gravity="center";
              clickable=false
            };
          };
        };
      };
    };
  };
}

设置视图(layout2)

水波纹(back)
水波纹(popmenu)

水波纹(testText)
水波纹(showPwd)

mainActionBar.setBackgroundColor(COLOR_MAIN)
mainBackground.setBackgroundColor(COLOR_MAIN_BACKGROUND)
mainTitle.setTextColor(COLOR_ON_MAIN)
mainTitle.getPaint().setFakeBoldText(true)
设置字体(mainTitle)

testBtn.setBackgroundColor(COLOR_CARD_BACKGROUND)
testText.setTextColor(COLOR_ON_BACKGROUND)

设置字体(rootTitle)
设置字体(accTitle)
设置字体(pwdTitle)
设置字体(rootText)
设置字体(accText)
设置字体(pwdText)
设置字体(testText)
设置字体(statuText)
设置字体(infoText)
设置字体(lastText)

cfpath=pathc.."WebdavConfig.json"
if File(cfpath).isFile() then
  conf=cjson.decode(读取文件(cfpath))
  rootText.setText(conf.root)
  accText.setText(conf.account)
  pwdText.setText(conf.password)
 else
  conf={}
end

pwdText.setInputType(InputType.TYPE_CLASS_TEXT|InputType.TYPE_TEXT_VARIATION_PASSWORD)

rootText.addTextChangedListener{
  onTextChanged=function(s)
    conf.root=tostring(s)
end}

accText.addTextChangedListener{
  onTextChanged=function(s)
    conf.account=tostring(s)
end}

pwdText.addTextChangedListener{
  onTextChanged=function(s)
    conf.password=tostring(s)
end}

showPwd.onClick=function(v)
  if vis~=true then
    showPwd.setImageBitmap(loadbitmap(ICON_VISIBILITY_OFF))
    local lastSelection=pwdText.getSelectionStart()
    pwdText.setInputType(InputType.TYPE_CLASS_TEXT|InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD)
    pwdText.setSelection(lastSelection)
    vis=true
   else
    showPwd.setImageBitmap(loadbitmap(ICON_VISIBILITY_ON))
    local lastSelection=pwdText.getSelectionStart()
    pwdText.setInputType(InputType.TYPE_CLASS_TEXT|InputType.TYPE_TEXT_VARIATION_PASSWORD)
    pwdText.setSelection(lastSelection)
    vis=false
  end
end

if activity.getSharedData("webdavStatu")~=true then
  statuText.setText("已关闭")
  statuBtn.setBackgroundColor(COLOR_CARD_BACKGROUND)
  statuText.setTextColor(COLOR_ON_BACKGROUND)
  波纹(statuText,COLOR_MAIN)
 else
  statuText.setText("已开启")
  statuBtn.setBackgroundColor(COLOR_MAIN)
  statuText.setTextColor(COLOR_ON_MAIN)
  波纹(statuText,COLOR_CARD_BACKGROUND)
end

statuText.onClick=function(view)
  写入文件(cfpath,cjson.encode(conf))
  if activity.getSharedData("webdavStatu")~=true then
    if pass==true then
      statuText.setText("已开启")
      statuText.setTextColor(COLOR_ON_MAIN)
      task(256,function()
        statuBtn.setBackgroundColor(COLOR_MAIN)
        activity.setSharedData("webdavStatu",true)
        波纹(statuText,COLOR_CARD_BACKGROUND)
      end)
      activity.setSharedData("change",true)
     else
      print("请先测试成功后再开启")
    end
   else
    statuText.setText("已关闭")
    statuText.setTextColor(COLOR_ON_BACKGROUND)
    task(256,function()
      statuBtn.setBackgroundColor(COLOR_CARD_BACKGROUND)
      activity.setSharedData("webdavStatu",false)
      波纹(statuText,COLOR_MAIN)
    end)
    activity.setSharedData("change",true)
  end
end

testText.onClick=function(v)
  testText.setText("……")
  testText.setTextColor(COLOR_ON_BACKGROUND)
  if getNetworkInfo() then
    task(function(conf)
      import "libs/util"
      if Webdav.new(conf).list() then
        return true
      end
      end,conf,function(success)
      if success then
        testText.setText("成功")
        testText.setTextColor(0xFF388E3C)
        pass=true
       else
        testText.setText("错误")
        testText.setTextColor(0xFFF44336)
      end
    end)
   else
    testText.setText("无网络连接")
    testText.setTextColor(0xFFF44336)
  end
end

back.onClick=function(view)
  写入文件(cfpath, cjson.encode(conf))
  activity.finish()
end

lastInfo = {}
if File(pathc.."LastWebdavInfo.json").isFile() and File(pathc.."LastSyncResult.log").isFile() then
  lastInfo = cjson.decode(读取文件(pathc.."LastWebdavInfo.json"))
  lastResult = 读取文件(pathc.."LastSyncResult.log")
  switch(lastResult)
   case "nil"
    lastResult = "错误：未知错误"
   case "0"
    lastResult = "错误0：未执行任何操作"
   case "1"
    lastResult = "成功1：全部上传"
   case "2"
    lastResult = "成功2：全部下载"
   case "3"
    lastResult = "成功3：无需操作"
   case "4"
    lastResult = "错误4：配置文件不存在"
   case "5"
    lastResult = "成功5：本地较新，更新远程"
   case "6"
    lastResult = "成功6：远程较新，更新本地"
  end
  if lastInfo.version >= 3 then
    lastText.setText(
    "上次同步时间："..convertToLocaleTime(lastInfo.time)..
    "\n上次同步结果：\""..lastResult.."\""..
    "\n上次同步设备信息："..
    "\n   品牌："..lastInfo.deviceInfo.brand..
    "\n   设备名："..lastInfo.deviceInfo.device..
    "\n   型号："..lastInfo.deviceInfo.model..
    "\n   AOSP版本："..lastInfo.deviceInfo.os_version..
--    "\n   IP归属地："..(lastInfo.ipInfo.country or "").." "..(lastInfo.ipInfo.province or "")..
    "\n同步版本号："..tostring(lastInfo.version))
  end
end

popmenu.onClick=function(view)
  local pop=PopupMenu(activity, popmenu)
  local menu=pop.Menu
  --[[menu.add("查看上次同步详细IP信息").onMenuItemClick=function()
    local dialog=AlertDialog.Builder(this)
    dialog.setTitle("提示")
    dialog.setMessage("请提防信息泄露，点击确定显示")
    dialog.setPositiveButton("确定", {onClick=function(v)
        local dialog=AlertDialog.Builder(this)
        dialog.setMessage(dump(lastInfo.ipInfo))
        dialog.setPositiveButton("关闭", nil)
        dialog.show()
    end})
    dialog.setNegativeButton("取消", nil)
    dialog.show()
  end]]

  menu.add("删除本地同步信息文件").onMenuItemClick=function()
    local dialog=AlertDialog.Builder(this)
    dialog.setTitle("你最好知道你在做什么")
    dialog.setMessage("确认删除本地端的 WebdavInfo.json ？\n将会使本端恢复到从未同步状态")
    dialog.setPositiveButton("确定",{onClick=function(v)
        os.remove(pathc.."WebdavInfo.json")
        print("已删除")
    end})
    dialog.setNegativeButton("取消", nil)
    dialog.show()
  end
  pop.show()
end

function onKeyDown(keycode,event)
  if keycode == 4 then
    写入文件(cfpath, cjson.encode(conf))
  end
end

设置字体(autoSyncName)
设置字体(autoSyncDesc)

水波纹(autoSyncBg)

if activity.getSharedData("autoSync")==nil then
  autoSyncSwitch.setChecked(false)
 else
  autoSyncSwitch.setChecked(activity.getSharedData("autoSync"))
end
autoSyncBg.onClick=function(view)
  if autoSyncSwitch.isChecked() then
    autoSyncSwitch.setChecked(false)
    activity.setSharedData("autoSync",false)
   else
    autoSyncSwitch.setChecked(true)
    activity.setSharedData("autoSync",true)
  end
end
